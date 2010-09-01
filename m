Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0IAHri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:47:38 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55414 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab0IAHrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZyP3u2lCibQaM+fkE7V6sU4Ve43G4XQ7ryBCJPhn1QL6BkM2nQtNgUrGNaU2MMulMJ
         FphKUGKhzuzMF+QwrJZF9i98XVzXWfAi0NcmcE+Pwt89Ex6tuqJlkc6jfEemwtT7ItTs
         94RL3Yt4CgJTR3n7/MCsyfrvQXlbsd9L1T4MA=
Date: Wed, 1 Sep 2010 15:47:21 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: mmarek@suse.cz, Sam Ravnborg <sam@ravnborg.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 2/2] initramfs: Fix initramfs size calculation
Message-ID: <20100901074721.GA5671@cr0.nay.redhat.com>
References: <20100831082307.064687027@linux.vnet.ibm.com>
 <20100831083844.043619334@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831083844.043619334@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 10:23:09AM +0200, Hendrik Brueckner wrote:
>The size of a built-in initramfs is calculated in init/initramfs.c by 
>"__initramfs_end - __initramfs_start".  Those symbols are defined in the
>linker script include/asm-generic/vmlinux.lds.h:
>
>#define INIT_RAM_FS                                                     \
>        . = ALIGN(PAGE_SIZE);                                           \
>        VMLINUX_SYMBOL(__initramfs_start) = .;                          \
>        *(.init.ramfs)                                                  \
>        VMLINUX_SYMBOL(__initramfs_end) = .;
>
>If the initramfs file has an odd number of bytes, the "__initramfs_end"
>symbol points to an odd address, for example, the symbols in the System.map
>might look like:
>
>    0000000000572000 T __initramfs_start
>    00000000005bcd05 T __initramfs_end	  <-- odd address
>
>At least on s390 this causes a problem:
>
>Certain s390 instructions, especially instructions for loading addresses
>(larl) or branch addresses must be on even addresses. 
>The compiler loads the symbol addresses with the "larl" instruction. This
>instruction sets the last bit to 0 and, therefore, for odd size files, the
>calculated size is one byte less than it should be:
>
>    0000000000540a9c <populate_rootfs>:
>      540a9c:     eb cf f0 78 00 24       stmg    %r12,%r15,120(%r15),
>      540aa2:     c0 10 00 01 8a af       larl    %r1,572000 <__initramfs_start>
>      540aa8:     c0 c0 00 03 e1 2e       larl    %r12,5bcd04 <initramfs_end>
>                                                  (Instead of  5bcd05)
>      ...
>      540abe:     1b c1                   sr      %r12,%r1
>
>To fix the problem, this patch introduces the global variable
>__initramfs_size, which is calculated in the "usr/initramfs_data.S" file.
>The populate_rootfs() function can then use the start marker of the
>.init.ramfs section and the value of __initramfs_size for loading the
>initramfs.  Because the start marker and size is sufficient, the
>__initramfs_end symbol is no longer needed and is removed.
>
>Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
>Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>


This patch looks good for me too,

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

I think Michal will take this into kbuild tree.

Thanks!
