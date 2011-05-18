Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1ERXGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:06:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55714 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab1ERXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:06:16 -0400
Date: Thu, 19 May 2011 00:06:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tim Gardner <timg@tpi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] 2.6.39-rc7+ fs: Fix spinlock recursion in
 get_active_super()
Message-ID: <20110518230614.GG19987@ZenIV.linux.org.uk>
References: <20110518163500.5CA99F912D@sepang.rtg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518163500.5CA99F912D@sepang.rtg.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:35:00AM -0600, Tim Gardner wrote:
> >From c7d9161350188c8132210eea5c7f6edff94e6c9c Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Wed, 18 May 2011 10:30:02 -0600
> Subject: [PATCH] fs: Fix spinlock recursion in get_active_super()
> 
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  fs/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 8a06881..e203e2d 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -503,8 +503,8 @@ struct super_block *get_active_super(struct block_device *bdev)
>  	if (!bdev)
>  		return NULL;
>  
> -restart:
>  	spin_lock(&sb_lock);
> +restart:
>  	list_for_each_entry(sb, &super_blocks, s_list) {
>  		if (list_empty(&sb->s_instances))
>  			continue;

WTF?  Have you even tried that?  The *only* place that contains goto restart
is a few line below and it's
                        if (grab_super(sb)) /* drops sb_lock */
                                return sb;
                        else
                                goto restart;
See that comment in there?  Now let's see if it's true:

static int grab_super(struct super_block *s) __releases(sb_lock)
{
        if (atomic_inc_not_zero(&s->s_active)) {
                spin_unlock(&sb_lock);
                return 1;
        }
        /* it's going away */
        s->s_count++;
        spin_unlock(&sb_lock);
        /* wait for it to die */
        down_write(&s->s_umount);
        up_write(&s->s_umount);
        put_super(s);
        return 0;
}

Note spin_unlock on both paths.  Morever, note blocking operations on the
path that returns 0.  If we had somehow managed to get through that without
dropping sb_locked we'd be FUBAR for obvious reasons.

IOW, if your testing had *ever* hit that goto, you'd get instant trouble.
On the exit from get_active_super() you'd hit spin_unlock(&sb_lock), with
rather nasty consequences the next time somebody would try to get it...
