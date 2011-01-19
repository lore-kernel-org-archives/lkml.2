Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1ASXeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:34:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769Ab1ASXeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:34:09 -0500
Date: Wed, 19 Jan 2011 15:33:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: improve timestamp precision
Message-Id: <20110119153335.06b4637b.akpm@linux-foundation.org>
In-Reply-To: <4D2DECDC.7020801@gmail.com>
References: <4D2DECDC.7020801@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 18:03:08 +0000
Stuart Swales <stuart.swales.croftnuisk@gmail.com> wrote:

> From: Stuart Swales<stuart.swales.croftnuisk@gmail.com>
> 
> ADFS (FileCore) storage complies with the RISC OS timestamp specification
> (40-bit centiseconds since 01 Jan 1900 00:00:00).  It is desirable that stored
> timestamp precision be maintained to facilitate a precise copy of data and
> metadata from a hard disc (or image thereof) into a RISC OS emulator (such as RPCEmu).
> This patch implements a full-precision conversion from ADFS to Unix timestamp as the
> existing driver, for ease of calculation with old 32-bit compilers, uses the common
> trick of shifting the 40-bits representing centiseconds around into 32-bits
> representing seconds thereby losing precision.
> 

The patch looks sane to me but I was unable to extract a diff which
applies.  Your email client is doing weird things.  Please fix it and
resend.

> --- linux-2.6.37-vanilla/fs/adfs/inode.c	2011-01-05 00:50:19.000000000 +0000
> +++ linux-2.6.37-sks-adfs/fs/adfs/inode.c	2011-01-12 17:08:19.000000000 +0000
> @@ -175,50 +175,48 @@ adfs_mode2atts(struct super_block *sb, s
> 
>   /*
>    * Convert an ADFS time to Unix time.  ADFS has a 40-bit centi-second time
> - * referenced to 1 Jan 1900 (til 2248)
> + * referenced to 1 Jan 1900 (til 2248) so we need to discard 2208988800 seconds
> + * of time to convert from RISC OS epoch to Unix epoch.
>    */
>   static void
>   adfs_adfs2unix_time(struct timespec *tv, struct inode *inode)
>   {
>   	unsigned int high, low;
> +	/* 01 Jan 1970 00:00:00 (Unix epoch) as nanoseconds since
> +	 * 01 Jan 1900 00:00:00 (RISC OS epoch)
> +	 */
> +	static const s64 nsec_unix_epoch_diff_risc_os_epoch =
> +							2208988800000000000LL;
> +	s64 nsec;
> 
>   	if (ADFS_I(inode)->stamped == 0)
>   		goto cur_time;
> 
> -	high = ADFS_I(inode)->loadaddr<<  24;
> -	low  = ADFS_I(inode)->execaddr;
> +	high = ADFS_I(inode)->loadaddr&  0xFF; /* top 8 bits of timestamp */

We have weird things going on with the code layout.

> +	low  = ADFS_I(inode)->execaddr;    /* bottom 32 bits of timestamp */
> 
> -	high |= low>>  8;
> -	low&= 255;
> +	/* convert 40-bit centi-seconds to 32-bit seconds
> +	 * going via nanoseconds to retain precision
> +	 */
> +	nsec = (((s64) high<<  32) | (s64) low) * 10000000; /* cs to ns */

and here.

	nsec = (((s64)high << 32) | (s64)low) * 10000000; /* cs to ns */

would be typical.

>   	/* Files dated pre  01 Jan 1970 00:00:00. */
> -	if (high<  0x336e996a)
> +	if (nsec<  nsec_unix_epoch_diff_risc_os_epoch)

more.  Feel free to fix things up when altering code.

>   		goto too_early;
> 
> -	/* Files dated post 18 Jan 2038 03:14:05. */
> -	if (high>= 0x656e9969)
> -		goto too_late;
> -
> -	/* discard 2208988800 (0x336e996a00) seconds of time */
> -	high -= 0x336e996a;
> -
> -	/* convert 40-bit centi-seconds to 32-bit seconds */
> -	tv->tv_sec = (((high % 100)<<  8) + low) / 100 + (high / 100<<  8);
> -	tv->tv_nsec = 0;
> +	/* convert from RISC OS to Unix epoch */
> +	nsec -= nsec_unix_epoch_diff_risc_os_epoch;
> +
> +	*tv = ns_to_timespec(nsec);
>   	return;
> 
>    cur_time:
> -	*tv = CURRENT_TIME_SEC;
> +	*tv = CURRENT_TIME;
>   	return;
> 
>    too_early:
>   	tv->tv_sec = tv->tv_nsec = 0;
>   	return;
> -
> - too_late:
> -	tv->tv_sec = 0x7ffffffd;
> -	tv->tv_nsec = 0;
> -	return;

