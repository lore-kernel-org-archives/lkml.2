Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1CXPbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:31:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1CXPbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:31:49 -0400
Subject: Re: [Patch 1/1] fsnotify,fanotify: adding flag for execution
From: Eric Paris <eparis@redhat.com>
To: "jozef.kralik@eset.sk" <jozef.kralik@eset.sk>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        viro@zeniv.linux.org.uk
Date: Thu, 24 Mar 2011 11:30:53 -0400
In-Reply-To: <417044.386125298-sendEmail@jojo-hp-compaq-8100-elite-cmt-pc>
References: <417044.386125298-sendEmail@jojo-hp-compaq-8100-elite-cmt-pc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1300980654.2398.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 12:49 +0000, jozef.kralik@eset.sk wrote:
> From: Jozef Kralik <jozef.kralik@eset.sk>
> 
> This patch add flag FS_OPENEXEC[FAN_OPENEXEC] to event
> FS_OPEN_PERM[FAN_OPEN_PERM], when file is opened with flag FMODE_EXEC. 
> 
> Signed-off-by: Jozef Kralik <jozef.kralik@eset.sk>

I keep waffling back and forth on this patch (for months now) mostly
because of the fact that I'm scared it will give people a false sense
that they will get notification of all files that might be executed.  I
don't understand the use case at all so I don't know if it good idea to
expose such notifications....

I'm just having a hard time deciding if I'm comfortable solving half of
a problem...  What exactly is your goal here and how do you see others
using it, usefully.

-Eric

> ---
> Example:
> if (metadata->mask & FAN_OPEN_PERM)
> 	if (metadata->mask & FAN_OPENEXEC)
> 		printf("file was executed");
> 	else
> 	printf("file was opened");
> 
> Patch for kernel: 2.6.38
> Developed kernel: 2.6.37-rc4 with patch-v2.6.37-rc4-next-20101201 
> Tested kernel: 2.6.38
> 
> diffstat -p1 ./patch_exec_2.6.38.diff 
> fs/notify/fanotify/fanotify.c    |    1 +
> fs/notify/fsnotify.c             |    2 +-
> include/linux/fanotify.h         |    4 +++-
> include/linux/fsnotify.h         |    9 ++++++---
> include/linux/fsnotify_backend.h |    4 +++-
> 5 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff -uprN -X linux-2.6.38/Documentation/dontdiff linux-2.6.38/fs/notify/fanotify/fanotify.c linux-2.6.38-dev/fs/notify/fanotify/fanotify.c
> --- linux-2.6.38/fs/notify/fanotify/fanotify.c	2011-03-15 02:20:32.000000000 +0100
> +++ linux-2.6.38-dev/fs/notify/fanotify/fanotify.c	2011-03-24 12:34:40.182283000 +0100
> @@ -131,6 +131,7 @@ static int fanotify_handle_event(struct
>  	BUILD_BUG_ON(FAN_CLOSE_NOWRITE != FS_CLOSE_NOWRITE);
>  	BUILD_BUG_ON(FAN_CLOSE_WRITE != FS_CLOSE_WRITE);
>  	BUILD_BUG_ON(FAN_OPEN != FS_OPEN);
> +	BUILD_BUG_ON(FAN_OPENEXEC != FS_OPENEXEC);
>  	BUILD_BUG_ON(FAN_EVENT_ON_CHILD != FS_EVENT_ON_CHILD);
>  	BUILD_BUG_ON(FAN_Q_OVERFLOW != FS_Q_OVERFLOW);
>  	BUILD_BUG_ON(FAN_OPEN_PERM != FS_OPEN_PERM);
> diff -uprN -X linux-2.6.38/Documentation/dontdiff linux-2.6.38/fs/notify/fsnotify.c linux-2.6.38-dev/fs/notify/fsnotify.c
> --- linux-2.6.38/fs/notify/fsnotify.c	2011-03-15 02:20:32.000000000 +0100
> +++ linux-2.6.38-dev/fs/notify/fsnotify.c	2011-03-24 12:34:40.186283000 +0100
> @@ -299,7 +299,7 @@ static __init int fsnotify_init(void)
>  {
>  	int ret;
>  
> -	BUG_ON(hweight32(ALL_FSNOTIFY_EVENTS) != 23);
> +	BUG_ON(hweight32(ALL_FSNOTIFY_EVENTS) != 24);
>  
>  	ret = init_srcu_struct(&fsnotify_mark_srcu);
>  	if (ret)
> diff -uprN -X linux-2.6.38/Documentation/dontdiff linux-2.6.38/include/linux/fanotify.h linux-2.6.38-dev/include/linux/fanotify.h
> --- linux-2.6.38/include/linux/fanotify.h	2011-03-15 02:20:32.000000000 +0100
> +++ linux-2.6.38-dev/include/linux/fanotify.h	2011-03-24 12:34:40.190283001 +0100
> @@ -9,6 +9,7 @@
>  #define FAN_CLOSE_WRITE		0x00000008	/* Writtable file closed */
>  #define FAN_CLOSE_NOWRITE	0x00000010	/* Unwrittable file closed */
>  #define FAN_OPEN		0x00000020	/* File was opened */
> +#define FAN_OPENEXEC	0x00001000	/* File had exec flag */
>  
>  #define FAN_Q_OVERFLOW		0x00004000	/* Event queued overflowed */
>  
> @@ -81,7 +82,8 @@
>  
>  #define FAN_ALL_OUTGOING_EVENTS	(FAN_ALL_EVENTS |\
>  				 FAN_ALL_PERM_EVENTS |\
> -				 FAN_Q_OVERFLOW)
> +				FAN_Q_OVERFLOW |\
> +				FAN_OPENEXEC)
>  
>  #define FANOTIFY_METADATA_VERSION	3
>  
> diff -uprN -X linux-2.6.38/Documentation/dontdiff linux-2.6.38/include/linux/fsnotify_backend.h linux-2.6.38-dev/include/linux/fsnotify_backend.h
> --- linux-2.6.38/include/linux/fsnotify_backend.h	2011-03-15 02:20:32.000000000 +0100
> +++ linux-2.6.38-dev/include/linux/fsnotify_backend.h	2011-03-24 12:34:40.262283001 +0100
> @@ -36,6 +36,7 @@
>  #define FS_DELETE		0x00000200	/* Subfile was deleted */
>  #define FS_DELETE_SELF		0x00000400	/* Self was deleted */
>  #define FS_MOVE_SELF		0x00000800	/* Self was moved */
> +#define FS_OPENEXEC		0x00001000	/* File had exec flag */
>  
>  #define FS_UNMOUNT		0x00002000	/* inode on umount fs */
>  #define FS_Q_OVERFLOW		0x00004000	/* Event queued overflowed */
> @@ -73,7 +74,8 @@
>  			     FS_UNMOUNT | FS_Q_OVERFLOW | FS_IN_IGNORED | \
>  			     FS_OPEN_PERM | FS_ACCESS_PERM | FS_EXCL_UNLINK | \
>  			     FS_ISDIR | FS_IN_ONESHOT | FS_DN_RENAME | \
> -			     FS_DN_MULTISHOT | FS_EVENT_ON_CHILD)
> +				FS_DN_MULTISHOT | FS_EVENT_ON_CHILD | \
> +				FS_OPENEXEC)
>  
>  struct fsnotify_group;
>  struct fsnotify_event;
> diff -uprN -X linux-2.6.38/Documentation/dontdiff linux-2.6.38/include/linux/fsnotify.h linux-2.6.38-dev/include/linux/fsnotify.h
> --- linux-2.6.38/include/linux/fsnotify.h	2011-03-15 02:20:32.000000000 +0100
> +++ linux-2.6.38-dev/include/linux/fsnotify.h	2011-03-24 12:34:40.274283001 +0100
> @@ -45,12 +45,15 @@ static inline int fsnotify_perm(struct f
>  		return 0;
>  	if (!(mask & (MAY_READ | MAY_OPEN)))
>  		return 0;
> -	if (mask & MAY_OPEN)
> +	if (mask & MAY_OPEN) {
>  		fsnotify_mask = FS_OPEN_PERM;
> -	else if (mask & MAY_READ)
> +		if (file->f_flags & FMODE_EXEC)
> +			fsnotify_mask |= FS_OPENEXEC;
> +	} else if (mask & MAY_READ) {
>  		fsnotify_mask = FS_ACCESS_PERM;
> -	else
> +	} else {
>  		BUG();
> +	}
>  
>  	ret = fsnotify_parent(path, NULL, fsnotify_mask);
>  	if (ret)
> 


