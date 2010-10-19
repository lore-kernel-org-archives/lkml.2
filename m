Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab0JSLIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:08:10 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:54242 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab0JSLII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:08:08 -0400
Date: Tue, 19 Oct 2010 13:08:03 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>, mmarek@suse.cz,
        Sam Ravnborg <sam@ravnborg.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Subject: [PATCH] initramfs: Fix build break on symbol-prefixed archs
Message-ID: <20101019110801.GA4128@linux.vnet.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Mike Frysinger <vapier.adi@gmail.com>, mmarek@suse.cz,
	Sam Ravnborg <sam@ravnborg.org>,
	Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
	vda.linux@googlemail.com, hpa@linux.intel.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com> <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com> <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Mon, Oct 18, 2010 at 07:07:13PM -0400, Mike Frysinger wrote:
> On Mon, Oct 18, 2010 at 06:37, Hendrik Brueckner wrote:
> > On Sun, Oct 17, 2010 at 02:28:11PM -0400, Mike Frysinger wrote:
> >> On Tue, Aug 31, 2010 at 04:23, Hendrik Brueckner wrote:
> >> i'm pretty sure this breaks on every symbol-prefixed arch.  at least,
> >> it broke every Blackfin board:
> >> init/built-in.o: In function `populate_rootfs':
> >> init/initramfs.c:(.init.text+0x2548): undefined reference to `__initramfs_size'
> >> init/initramfs.c:(.init.text+0x254e): undefined reference to `__initramfs_size'
> >> make: *** [.tmp_vmlinux1] Error 1
> >>
> negative.  same error.  vmlinux.lds.h might need to be switched to
> CONFIG_SYMBOL_PREFIX.

In my previous patch I missed a change regarding the SYMBOL_PREFIX symbol.
The SYMBOL_PREFIX symbol, which is used by VMLINUX_SYMBOL, is derived
from the CONFIG_SYMBOL_PREFIX and must be defined in the Makefile.

Below you can find the updated patch which worked for my blackfin test build.

Thanks and kind regards,
  Hendrik

--- 8< -----------------------
Define the __initramfs_size variable using VMLINUX_SYMBOL() to take
care of symbol-prefixed architectures, for example, blackfin.

Depending on the CONFIG_SYMBOL_PREFIX configuration option, define
the SYMBOL_PREFIX symbol which is evaluated by VMLINUX_SYMBOL().

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 usr/Makefile         |    3 +++
 usr/initramfs_data.S |    5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/usr/Makefile
+++ b/usr/Makefile
@@ -19,6 +19,9 @@ suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZ
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   = .lzo
 
 AFLAGS_initramfs_data.o += -DINITRAMFS_IMAGE="usr/initramfs_data.cpio$(suffix_y)"
+ifdef CONFIG_SYMBOL_PREFIX
+AFLAGS_initramfs_data.o += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
+endif
 
 # Generate builtin.o based on initramfs_data.o
 obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
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
