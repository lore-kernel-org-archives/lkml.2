Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0JRKh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 06:37:28 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:48878 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0JRKh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 06:37:27 -0400
Date: Mon, 18 Oct 2010 12:37:30 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>, mmarek@suse.cz,
        Sam Ravnborg <sam@ravnborg.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 2/2] initramfs: Fix initramfs size calculation
Message-ID: <20101018103729.GA4122@linux.vnet.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Mike Frysinger <vapier.adi@gmail.com>, mmarek@suse.cz,
	Sam Ravnborg <sam@ravnborg.org>,
	Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
	vda.linux@googlemail.com, hpa@linux.intel.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com> <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Sun, Oct 17, 2010 at 02:28:11PM -0400, Mike Frysinger wrote:
> On Tue, Aug 31, 2010 at 04:23, Hendrik Brueckner wrote:
> i'm pretty sure this breaks on every symbol-prefixed arch.  at least,
> it broke every Blackfin board:
> init/built-in.o: In function `populate_rootfs':
> init/initramfs.c:(.init.text+0x2548): undefined reference to `__initramfs_size'
> init/initramfs.c:(.init.text+0x254e): undefined reference to `__initramfs_size'
> make: *** [.tmp_vmlinux1] Error 1
> 
> look at VMLINUX_SYMBOL() in the vmlinux.lds.h file

Thanks for your feedback.  Could you try the patch below and let me know
if it works for your Blackfin board.

Thanks and kind regards,
  Hendrik

--- 8< ----------------

Define the __initramfs_size variable using VMLINUX_SYMBOL() to take
care of symbol-prefixed architectures, for example, blackfin.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 usr/initramfs_data.S |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/usr/initramfs_data.S
+++ b/usr/initramfs_data.S
@@ -22,14 +22,15 @@
 */
 
 #include <linux/stringify.h>
+#include <asm-generic/vmlinux.lds.h>
 
 .section .init.ramfs,"a"
 __irf_start:
 .incbin __stringify(INITRAMFS_IMAGE)
 __irf_end:
 .section .init.ramfs.info,"a"
-.globl __initramfs_size
-__initramfs_size:
+.globl VMLINUX_SYMBOL(__initramfs_size)
+VMLINUX_SYMBOL(__initramfs_size):
 #ifdef CONFIG_32BIT
 	.long __irf_end - __irf_start
 #else
