Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2BAWfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:35:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41913 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab2BAWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:35:31 -0500
Message-ID: <4F29BE2F.2000907@suse.cz>
Date: Wed, 01 Feb 2012 23:35:27 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] sysfs:  Optionally count subdirectories to support buggy
 applications
References: <4F27120A.4040106@suse.cz> <20120130220611.GA26655@kroah.com> <20120130221059.26ab5edf@pyramind.ukuu.org.uk> <20120130222717.GA6393@kroah.com> <m18vkoirv9.fsf@fess.ebiederm.org> <4F27C6EB.2070305@suse.cz> <m14nvc82jo.fsf@fess.ebiederm.org> <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com> <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org>
In-Reply-To: <m1ehueyz20.fsf_-_@fess.ebiederm.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 11:21 PM, Eric W. Biederman wrote:
> --- a/fs/sysfs/Kconfig
> +++ b/fs/sysfs/Kconfig
> @@ -21,3 +21,18 @@ config SYSFS
>  	example, "root=03:01" for /dev/hda1.
>  
>  	Designers of embedded systems may wish to say N here to conserve space.
> +
> +config SYSFS_COUNT_LINKS
> +	bool "sysfs count subdirectoires to support buggy applications"
> +	default n
> +	help
> +
> +	Increase the memory and cpu untilization of sysfs by maintaining
> +	by maintaining a count of how hard links from subdirectories a

by maintaining only once.

of how "many"?

> +	directory has.  This allows sysfs to report the directory nlink
> +	as the number of subdirectories plus two.  With out this enabled
> +	sysfs will report the nlink of all directories as 1, which is
> +	the standard way of indicating that the number of subdirectoires
> +	is not tracked.
> +
> +	Unless you know you need this say N here.

You should put the opposite here. "If you are sure you don't need it,
say N."

> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
...
> @@ -127,6 +130,41 @@ do {								\
>  #define sysfs_dirent_init_lockdep(sd) do {} while(0)
>  #endif
>  
> +#ifdef CONFIG_SYSFS_COUNT_LINKS
> +static inline void sysfs_init_nlink(struct sysfs_dirent *sd)
> +{
> +	if (sysfs_type(sd) == SYSFS_DIR)
> +		sd->s_nlink = 2;
> +	else
> +		sd->s_nlink = 1;
> +}
> +static inline void sysfs_inc_nlink(struct sysfs_dirent *sd)
> +{
> +	sd->s_nlink++;
> +}
> +static inline void sysfs_dec_nlink(struct sysfs_dirent *sd)
> +{
> +	sd->s_nlink++;
> +}

Minus minus.

thanks,
-- 
js
suse labs
