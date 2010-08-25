Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab0HYSGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 14:06:08 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:57550 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab0HYSGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 14:06:07 -0400
Date: Wed, 25 Aug 2010 20:06:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: tabbott@ksplice.com, vda.linux@googlemail.com, mmarek@suse.cz,
        hpa@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        brueckner@linux.vnet.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH] Fix initramfs size calculation
Message-ID: <20100825180601.GA2116@merkur.ravnborg.org>
References: <1282751832.3676.17.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282751832.3676.17.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 05:57:12PM +0200, Michael Holzheu wrote:
> The size of a built-in initramfs is calculated in init/initramfs.c by 
> "__initramfs_end - __initramfs_start".  Those symbols are defined in the
> linker script include/asm-generic/vmlinux.lds.h:
> 
> #define INIT_RAM_FS                                                     \
>         . = ALIGN(PAGE_SIZE);                                           \
>         VMLINUX_SYMBOL(__initramfs_start) = .;                          \
>         *(.init.ramfs)                                                  \
>         VMLINUX_SYMBOL(__initramfs_end) = .;
> 
> If the initramfs file has an odd number of bytes, the "__initramfs_end"
> symbol points to an odd address, for example, the symbols in the System.map
> might look like:
> 
>     0000000000572000 T __initramfs_start
>     00000000005bcd05 T __initramfs_end	  <-- odd address
> 
> At least on s390 this is a problem:

Another way to fix this could be to align . to an even
address like this:
> #define INIT_RAM_FS                                                     \
>         . = ALIGN(PAGE_SIZE);                                           \
>         VMLINUX_SYMBOL(__initramfs_start) = .;                          \
>         *(.init.ramfs)                                                  \
          . = ALIGN(32);                                                  \
>         VMLINUX_SYMBOL(__initramfs_end) = .;
> 

32 was selected as this is what we will introduce as the default
alignment in linker scripts anyway.

This I guess is a problem we have had some time and a minimal fix is
easier to have backported by the stable team.

> The patch also restructures the "usr/initramfs_data.xxx.S" files to use a
> common macro that includes the (compressed) initramfs file and calculates
> the __initramfs_size.
I like this anyway. Could you do this as a separate patch?

	Sam
