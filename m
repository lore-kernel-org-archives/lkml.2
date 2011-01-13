Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1AMBt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 20:49:58 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36507 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab1AMBty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 20:49:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FqHqzsSg6Hpt+Wl1DU0rOWjTaBCR0n/roBdLleMOin4HdeC7mbn6pOOU848nV+Psct
         GPz/5RbkVymmm60iok1FRtsYo9wms1y7/s2e/xTGuswFtKXlOvqsaJCMtfh8Nw/HBA3A
         4OOnl8tgsjxPo+OM0aWt0lanyOdtjFT3Ad6cQ=
MIME-Version: 1.0
In-Reply-To: <E1Pd1eC-0001hR-LW@pomaz-ex.szeredi.hu>
References: <E1Pcd7R-0007XC-VO@pomaz-ex.szeredi.hu>
	<AANLkTik-=LqSHQ=7zDznx9oCJFViPpp406Yz7J5Z-quj@mail.gmail.com>
	<E1Pd1eC-0001hR-LW@pomaz-ex.szeredi.hu>
Date: Thu, 13 Jan 2011 12:49:53 +1100
Message-ID: <AANLkTikEStNgB58Q-797rQST3QW=maz9LiGFSC=A8kkc@mail.gmail.com>
Subject: Re: [PATCH] fuse: make fuse_permission() RCU aware
From: Nick Piggin <npiggin@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 1:26 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, 12 Jan 2011, Nick Piggin wrote:
>> On Tue, Jan 11, 2011 at 11:14 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > From: Miklos Szeredi <mszeredi@suse.cz>
>> >
>> > Only bail out of fuse_permission() on IPERM_FLAG_RCU when it is
>> > actually necessary.
>>
>> Great, thanks for taking a look... How about d_revalidate?
>
> Yeah, here's the patch
>
> Do you want to collect these patches from fs maintainers, or should I
> submit to Linus directly?

I would like to have a look over them and ack them before they go to Linus,
but I think the most logical and merge friendly approach is just going via
filesystems trees.


> From: Miklos Szeredi <mszeredi@suse.cz>
> Subject: fuse: make fuse_dentry_revalidate() RCU aware
>
> Only bail out of fuse_dentry_revalidate() on LOOKUP_RCU when blocking
> is actually necessary.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/fuse/dir.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/fs/fuse/dir.c
> ===================================================================
> --- linux-2.6.orig/fs/fuse/dir.c        2011-01-12 13:06:04.000000000 +0100
> +++ linux-2.6/fs/fuse/dir.c     2011-01-12 13:07:30.000000000 +0100
> @@ -158,9 +158,6 @@ static int fuse_dentry_revalidate(struct
>  {
>        struct inode *inode;
>
> -       if (nd->flags & LOOKUP_RCU)
> -               return -ECHILD;
> -
>        inode = entry->d_inode;
>        if (inode && is_bad_inode(inode))
>                return 0;

Now it can be the case that entry->d_inode is not stable -- it can
go away or even flip between inodes in the case of concurrent
unlink/creat activity. And you may be using a different inode than
the namei path walk is using!

This isn't as scary as it sounds actually, because any such changes
do get detected and the path walk restarted in that case.

You might be OK becuse you do test for NULL (although it really
wants an ACCESS_ONCE() so it doesn't load a NULL or different
inodes, but that's quite theoretical).

But this is a little unfriendly for filesystems, and I do want to impress
the rule to not touch ->d_parent or ->d_inode in rcu walk mode
(just to avoid any surprises).

So what I have done in such cases is to update the API to provide
what the callers want. In this case, we could consider adding an
inode parameter to .d_revalidate, which callers can be sure matches
the inode used by vfs, and will not change.

Aside from that detail, the changes seem good. Thanks for looking
at it.


> @@ -177,6 +174,9 @@ static int fuse_dentry_revalidate(struct
>                if (!inode)
>                        return 0;
>
> +               if (nd->flags & LOOKUP_RCU)
> +                       return -ECHILD;
> +
>                fc = get_fuse_conn(inode);
>                req = fuse_get_req(fc);
>                if (IS_ERR(req))
>
