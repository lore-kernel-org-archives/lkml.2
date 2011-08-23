Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1HWVj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:39:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886Ab1HWVjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:39:22 -0400
Date: Tue, 23 Aug 2011 14:39:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Amerigo Wang <amwang@redhat.com>,
        gregkh@suse.de, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH -next] drivers/base/inode.c: let vmstat_text be optional
Message-Id: <20110823143912.0691d442.akpm@linux-foundation.org>
In-Reply-To: <20110804152211.ea10e3e7.rdunlap@xenotime.net>
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au>
	<20110804152211.ea10e3e7.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH -next] drivers/base/inode.c: let vmstat_text be optional

The patch-against-next thing always disturbs me.  It implies that the
patch is only needed in linux-next, but often that's wrong.  So I have
to go off and work out what kernel it really is applicable to.

And that's OK, it keeps me healthy.  But two minds are better than one,
and if the originator has already worked this out, they should state it
explicitly, please.

On Thu, 4 Aug 2011 15:22:11 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> vmstat_text is only available when PROC_FS or SYSFS is enabled.
> This causes build errors in drivers/base/node.c when they are
> both disabled:
> 
> drivers/built-in.o: In function `node_read_vmstat':
> node.c:(.text+0x10e28f): undefined reference to `vmstat_text'
> 
> Rather than litter drivers/base/node.c with #ifdef/#endif around
> the affected lines of code, add macros for optional sysdev
> attributes so that those lines of code will be ignored, without
> using #ifdef/#endif in the .c file(s).  I.e., the ifdeffery
> is done only in a header file with sysdev_create_file_optional()
> and sysdev_remove_file_optional().
> 
> --- linux-next-20110804.orig/include/linux/vmstat.h
> +++ linux-next-20110804/include/linux/vmstat.h
> @@ -258,6 +258,8 @@ static inline void refresh_zone_stat_thr
>  
>  #endif		/* CONFIG_SMP */
>  
> +#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS)
>  extern const char * const vmstat_text[];
> +#endif
>

The ifdef around the declaration isn't needed, really.  If we remove
it then a build-time error becomes a link-time (or even moddep-time) error,
which is a bit of a pain.  But it's less painful than having ifdefs
around squillions of declarations.


