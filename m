Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0GFADq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:03:46 -0400
Received: from ozlabs.org ([203.10.76.45]:54412 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab0GFADo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:03:44 -0400
Date: Tue, 6 Jul 2010 10:03:43 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: LEROY Christophe <christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Kumar Gala <galak@kernel.crashing.org>
Subject: Re: 2.6.34: arch/powerpc/sysdev/micropatch.c not compiling
Message-ID: <20100706000343.GE23985@ozlabs.org>
Mail-Followup-To: LEROY Christophe <christophe.leroy@c-s.fr>,
	linux-kernel@vger.kernel.org,
	LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
	Anton Vorontsov <avorontsov@ru.mvista.com>,
	Kumar Gala <galak@kernel.crashing.org>
References: <4C318D87.1010306@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C318D87.1010306@c-s.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 09:45:11AM +0200, LEROY Christophe wrote:
> When activating micropatch option, the kernel does not compile.

powerpc problems should alos CC linuxppc-dev.
 
> It looks like a spi_t is not defined anywhere.
> 
> CC arch/powerpc/sysdev/micropatch.o
> arch/powerpc/sysdev/micropatch.c: In function ‘cpm_load_patch’:
> arch/powerpc/sysdev/micropatch.c:629: erreur: expected ‘=’, ‘,’,
> ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
> arch/powerpc/sysdev/micropatch.c:629: erreur: ‘spp’ undeclared
> (first use in this function)
> arch/powerpc/sysdev/micropatch.c:629: erreur: (Each undeclared
> identifier is reported only once
> arch/powerpc/sysdev/micropatch.c:629: erreur: for each function it
> appears in.)
> cc1: warnings being treated as errors
> arch/powerpc/sysdev/micropatch.c:630: erreur: ISO C89 interdit les
> mélanges de déclarations et de code
> arch/powerpc/sysdev/micropatch.c:671: erreur: ‘spi_t’ undeclared
> (first use in this function)
> arch/powerpc/sysdev/micropatch.c:671: erreur: expected expression
> before ‘)’ token
> make[1]: *** [arch/powerpc/sysdev/micropatch.o] Erreur 1
> make: *** [arch/powerpc/sysdev] Erreur 2

spi_t was removed in commit 644b2a680ccc51a9ec4d6beb12e9d47d2dee98e2
(powerpc/cpm: Remove SPI defines and spi structs).  Anton, Kumar it looks like
something along the lines of:

diff --git a/arch/powerpc/sysdev/micropatch.c b/arch/powerpc/sysdev/micropatch.c
index d8d6028..aa1785e 100644
--- a/arch/powerpc/sysdev/micropatch.c
+++ b/arch/powerpc/sysdev/micropatch.c
@@ -626,7 +626,6 @@ cpm_load_patch(cpm8xx_t     *cp)
        volatile uint           *dp;            /* Dual-ported RAM. */
        volatile cpm8xx_t       *commproc;
        volatile iic_t          *iip;
-       volatile spi_t          *spp;
        volatile smc_uart_t     *smp;
        int     i;
 
@@ -668,8 +667,8 @@ cpm_load_patch(cpm8xx_t     *cp)
        /* Put SPI above the IIC, also 32-byte aligned.
        */
        i = (RPBASE + sizeof(iic_t) + 31) & ~31;
-       spp = (spi_t *)&commproc->cp_dparam[PROFF_SPI];
-       spp->spi_rpbase = i;
+       smp = (smc_uart_t *)&commproc->cp_dparam[PROFF_SPI];
+       smp->smc_rpbase = i;
 
 # if defined(CONFIG_I2C_SPI_UCODE_PATCH)
        commproc->cp_cpmcr1 = 0x802a;


Would help?

Yours Tony
