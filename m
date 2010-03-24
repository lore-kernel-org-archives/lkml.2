Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0CXGYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 02:24:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:32788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab0CXGYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 02:24:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,300,1267430400"; 
   d="scan'208";a="551612755"
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with
 gas 2.16.1
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20100323142324.a53b20de.akpm@linux-foundation.org>
References: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
	 <20100323142324.a53b20de.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 14:24:18 +0800
Message-ID: <1269411858.23970.26.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

On Wed, 2010-03-24 at 05:23 +0800, Andrew Morton wrote:
> On Fri, 12 Mar 2010 15:01:47 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > Andrew Morton reported that AES-NI CTR optimization failed to compile
> > with gas 2.16.1, the error message is as follow:
> > 
> > arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
> > arch/x86/crypto/aesni-intel_asm.S:752: Error: suffix or operands invalid for `movq'
> > arch/x86/crypto/aesni-intel_asm.S:753: Error: suffix or operands invalid for `movq'
> > 
> > To fix this, a gas macro is defined to assemble movq with 64bit
> > general purpose registers and XMM registers. The macro will generate
> > the raw .byte sequence for needed instructions.
> > 
> 
> Still no go.
> 
> arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
> arch/x86/crypto/aesni-intel_asm.S:752: Error: bad expression
> arch/x86/crypto/aesni-intel_asm.S:752: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/crypto/aesni-intel_asm.S:753: Error: bad expression
> arch/x86/crypto/aesni-intel_asm.S:753: Error: junk at end of line, first unrecognized character is `1'
> 
> it doesn't like this:
> 
>         REG_TYPE movq_r64_xmm_opd1_type \opd1

Try to compile the latest kernel with binutils 2.16.1 this time to debug
and verify my fix. Now, with patch followed, aesni-intel_asm.S can be
compiled. But I failed to compile whole kernel with binutils 2.16.1.
First ld report unknown options, after use latest ld instead of that of
2.16.1, "as" reports errors as follow:

AS      arch/x86/kernel/acpi/realmode/wakeup.o
cc1: error: CPU you selected does not support x86-64 instruction set
cc1: error: CPU you selected does not support x86-64 instruction set
cc1: warning: -mregparm is ignored in 64-bit mode

Can you tell me how to setup the building environment with binutils
2.16.1? I just build it by hand and make the installed bin directory the
first one in $PATH.

Best Regards,
Huang Ying
------------------------------------------------------------------------>
Subject: [BUGFIX] Fix another AES-NI CTR optimization compiling failure with gas 2.16.1

The previous AES-NI CTR optimization compiling failure gas 2.16.1 fix
introduces another compiling failure by itself. This patch fixes that.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/inst.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/inst.h
+++ b/arch/x86/include/asm/inst.h
@@ -120,9 +120,9 @@
 	.macro REG_TYPE type reg
 	R64_NUM reg_type_r64 \reg
 	XMM_NUM reg_type_xmm \reg
-	.if reg_type_r64 != REG_NUM_INVALID
+	.if reg_type_r64 <> REG_NUM_INVALID
 	\type = REG_TYPE_R64
-	.elseif reg_type_xmm != REG_NUM_INVALID
+	.elseif reg_type_xmm <> REG_NUM_INVALID
 	\type = REG_TYPE_XMM
 	.else
 	\type = REG_TYPE_INVALID


