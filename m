Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470Ab0FPTXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:23:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759458Ab0FPTW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:22:59 -0400
Date: Wed, 16 Jun 2010 15:22:57 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: sparclinux@vger.kernel.org, Simone Ricci <simone.ricci@gmail.com>,
       scst-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Couchman <Nick.Couchman@seakr.com>, davem@davemloft.net
Subject: Re: Error "Unknown relocation: 36" on module load on Sparc
Message-ID: <20100616192257.GW20317@bombadil.infradead.org>
References: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com> <4C192085.2090404@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C192085.2090404@vlnb.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 11:05:41PM +0400, Vladislav Bolkhovitin wrote:
> FATAL: Error inserting scst  
> (/lib/modules/2.6.26-2-sparc64/extra/scst.ko): Invalid module format
>
> The following message is immediately spit out by the kernel:
> [ 1686.676534] module scst: Unknown relocation: 36
>

The error is caused because gcc is generating a relocation type that the
kernel's module loader cannot handle.

This appears to be:
libelf/elf.h:#define R_SPARC_LM22               36      /* Low middle 22
bits of ... */

It doesn't occur when patched into the kernel build, since the
relocations are handled at link time as opposed to load time.

arch/sparc/kernel/module.c needs to be patched to support the new
relocation type... Based on binutils/gas/config/tc-sparc.c and gold's
sparc config this looks to be the same as the hi22 reloc...

Can you test the following patch?

regards, Kyle

---
diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_64.h
index e678803..8bf59f1 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -52,6 +52,7 @@
 #define R_SPARC_11		31
 #define R_SPARC_64		32
 #define R_SPARC_OLO10		33
+#define R_SPARC_LM22		36
 #define R_SPARC_WDISP16		40
 #define R_SPARC_WDISP19		41
 #define R_SPARC_7		43
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index f848aad..49b1b21 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -207,6 +207,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			*loc32 = (*loc32 & ~0x3ff) | (v & 0x3ff);
 			break;
 
+		case R_SPARC_LM22:
 		case R_SPARC_HI22:
 			*loc32 = (*loc32 & ~0x3fffff) |
 				((v >> 10) & 0x3fffff);
