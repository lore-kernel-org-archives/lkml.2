Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0JAG6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:58:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38284 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab0JAG6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GAAkHIu7+xZTLvruA96wCwTAEKEvBljAHyzSyVanYC/iAQ7TYG3wQOXwR5IbdrkXCp
         fqJq8F00KJPjGcaK+sy9PiiOp2rCOM8yqGACTZaRPg3cnAERDshmXNOP6AJ2J/SHYxki
         DIxyNuuSxUpgwlOZ2P15iakpv1YUfCNuxAIHk=
Date: Fri, 1 Oct 2010 15:03:08 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] procfs: fix numbering in /proc/locks
Message-ID: <20101001070308.GA5167@cr0.nay.redhat.com>
References: <4CA484BA.7090809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA484BA.7090809@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 02:38:18PM +0200, Jerome Marchand wrote:
>
>The lock number in /proc/locks (first field) is implemented by a counter
>(private field of struct seq_file) which is incremented at each call of
>locks_show() and reset to 1 in locks_start() whatever the offset is. It
>should be reset according to the actual position in the list.
>
>Moreover, locks_show() can be called twice to print a single line thus
>skipping a number. The counter should be incremented in locks_next().
>
>Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

This patch looks good to me,

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Need to Cc -stable?

>---
> locks.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/fs/locks.c b/fs/locks.c
>index ab24d49..49d7343 100644
>--- a/fs/locks.c
>+++ b/fs/locks.c
>@@ -2166,19 +2166,19 @@ static int locks_show(struct seq_file *f, void *v)
> 	list_for_each_entry(bfl, &fl->fl_block, fl_block)
> 		lock_get_status(f, bfl, (long)f->private, " ->");
> 
>-	f->private++;
> 	return 0;
> }
> 
> static void *locks_start(struct seq_file *f, loff_t *pos)
> {
> 	lock_kernel();
>-	f->private = (void *)1;
>+	f->private = (void *) (*pos + 1);
> 	return seq_list_start(&file_lock_list, *pos);
> }
> 
> static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
> {
>+	f->private++;
> 	return seq_list_next(v, &file_lock_list, pos);
> }
> 
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
