Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2DSK3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 06:29:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab2DSK3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 06:29:00 -0400
Date: Thu, 19 Apr 2012 12:28:57 +0200
From: Karel Zak <kzak@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, mbroz@redhat.com,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fs: print warning when mount flags was ignored
Message-ID: <20120419102857.GA13436@x2.net.home>
References: <1334826475-11606-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334826475-11606-1-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 11:07:55AM +0200, Lukas Czerner wrote:
> Some mount flags can conflict with each other so they can not be
> handled together. Currently when conflicting flags are specified,
> some of them are silently ignored putting user in believe that
> they was handled correctly.

Unfortunately, it's not so simple ;-)

> -	if (flags & MS_REMOUNT)
> +	if (flags & MS_REMOUNT) {
>  		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
>  				    data_page);
> -	else if (flags & MS_BIND)
> +		flags &= ~MS_REMOUNT;

This is incorrect, the flags may also include many others flags. For
example MS_REMOUNT|MS_BIND|MS_RDONLY is valid (see do_remoun() code).

And it's normal that for "mount -o remount" the mount command reads
flags from mtab/fstab so it includes for example MS_RELATIME, ...

> +	} else if (flags & MS_BIND) {
>  		retval = do_loopback(&path, dev_name, flags & MS_REC);
> -	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
> +		flags &= ~MS_BIND;

 what about MS_REC ?

> +	} else if (flags & (MS_SHARED | MS_PRIVATE |
> +			    MS_SLAVE | MS_UNBINDABLE)) {
>  		retval = do_change_type(&path, flags);
> -	else if (flags & MS_MOVE)
> +		flags &= ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE);

 what about MS_REC ?

 Note that do_change_type() already checks for unexpected flags and
 returns -EINVAL if more flags are specified.

> +	} else if (flags & MS_MOVE) {
>  		retval = do_move_mount(&path, dev_name);
> -	else
> +		flags &= ~MS_MOVE;
> +	} else
>  		retval = do_new_mount(&path, type_page, flags, mnt_flags,
>  				      dev_name, data_page);
> +
> +	flags &= (MS_REMOUNT | MS_BIND | MS_SHARED | MS_PRIVATE |
> +		  MS_SLAVE | MS_UNBINDABLE | MS_MOVE);
> +
> +	if (!retval && flags)
> +		printk(KERN_WARNING "%s(%u): (%s -> %s) Conflicting mount flags"
> +				    " specified. These flags has been "
> +				    "ignored: %#.8lx\n", __func__, current->pid,
> +				    dev_name, dir_name, flags);


    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
