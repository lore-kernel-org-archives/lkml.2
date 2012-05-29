Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2E2K4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2E2K4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:56:50 -0400
Date: Tue, 29 May 2012 12:56:44 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-1-248.brq.redhat.com
To: Lukas Czerner <lczerner@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        mbroz@redhat.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] vfs: Do not allow mnt_longterm to go negative
In-Reply-To: <1337959776-16564-1-git-send-email-lczerner@redhat.com>
Message-ID: <alpine.LFD.2.00.1205290807350.2144@dhcp-1-248.brq.redhat.com>
References: <1337959776-16564-1-git-send-email-lczerner@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Anyone can take a look at this ? It's pretty pressing I would say
since this bug will not only disallow to unattach the loop devices
but also make it unable to actually unmount the file system!

You can reproduce it like this:

mkdir -p /tmp/namespace/root/tmp
mkdir -p /tmp/namespace/private
mount --make-rshared /
mount --rbind /tmp/namespace/root/tmp /tmp/namespace/private/

losetup /dev/loop0 /aaa
mount /dev/loop0 /mnt/tst
umount /mnt/tst

I probably need to update description as I forgot about the
--make-shared thing though...sorry about that. Will resend patch
with updated description right away.

Thanks!
-Lukas

On Fri, 25 May 2012, Lukas Czerner wrote:

> Date: Fri, 25 May 2012 17:29:35 +0200
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org, mbroz@redhat.com,
>     Lukas Czerner <lczerner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
> Subject: [PATCH 1/2] vfs: Do not allow mnt_longterm to go negative
> 
> Currently when someone calls __mnt_make_shortterm() and the mnt_longterm
> is already zero, it will come negative which is exactly opposite of what
> the function should to. So fix this by decrementing mnt_longterm only in
> case that it's not zero. Note that mnt_longterm should not be touched
> directly, but rather via __mnt_make_shortterm() and mnt_make_shortterm()
> functions - the former does not have this problem.
> 
> Moreover this will fix very nasty bug which might cause file systems not
> being properly cleaned up while unmounting. Specifically it might cause
> deactivate_super() not being called at all, hence the file system would
> be still up and running even after successful unmount without user even
> noticing it.
> 
> The following scenario leads to a bug. While mounting propagate_mnt()
> would walk through propagation tree cloning the mount for every every
> mount the root propagates to. Even for mounts which parents are not
> parents of the directory you're trying to mount to. So it will bump up
> the s_active counter.
> 
> However before the propagate_mnt() is left it will clean the unneeded
> cloned mounts (those which parent root is not parent of your new mount
> point), but it will _NOT_ decrement the s_active because umount_tree()
> would decrement mnt_longterm causing it to underflow, hence
> mntput_no_expire() would bail out before actually calling mntfree() and
> releasing the super block (decreasing s_active). At this point super
> block will never get released.
> 
> User can not directly observe this (aside from seeing running file system
> processes even after unmount), but it can be easily reproduced with loop
> device.
> 
> mount --bind /tmp/one /tmp/two
> losetup /dev/loop0 /mnt/test/file0
> mount /dev/loop0 /mnt/test1
> umount /mnt/test1
> losetup -d /dev/loop0
> ^^^^^^^^^^^^^^^^^^^^^
> This will fail because the device is still busy (super block is still
> active and s_active is non zero).
> 
> This commit fixes this issue.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Milan Broz <mbroz@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/namespace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index e608199..e72fec7 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -632,7 +632,7 @@ static inline void __mnt_make_longterm(struct mount *mnt)
>  static inline void __mnt_make_shortterm(struct mount *mnt)
>  {
>  #ifdef CONFIG_SMP
> -	atomic_dec(&mnt->mnt_longterm);
> +	atomic_add_unless(&mnt->mnt_longterm, -1, 0);
>  #endif
>  }
>  
> 
