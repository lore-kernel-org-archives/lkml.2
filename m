Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab0G3RwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:52:21 -0400
Received: from kroah.org ([198.145.64.141]:35940 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313Ab0G3RfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:15 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:10 2010
Message-Id: <20100730173110.311526615@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Vorontsov <avorontsov@mvista.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [084/140] powerpc/cpm1: Fix build with various CONFIG_*_UCODE_PATCH combinations
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Vorontsov <avorontsov@mvista.com>

commit 2069a6ae19a34d96cc9cb284eb645b165138e03f upstream.

Warnings are treated as errors for arch/powerpc code, so build fails
with CONFIG_I2C_SPI_UCODE_PATCH=y:

    CC      arch/powerpc/sysdev/micropatch.o
  cc1: warnings being treated as errors
  arch/powerpc/sysdev/micropatch.c: In function 'cpm_load_patch':
  arch/powerpc/sysdev/micropatch.c:630: warning: unused variable 'smp'
  make[1]: *** [arch/powerpc/sysdev/micropatch.o] Error 1

And with CONFIG_USB_SOF_UCODE_PATCH=y:

  CC      arch/powerpc/sysdev/micropatch.o
  cc1: warnings being treated as errors
  arch/powerpc/sysdev/micropatch.c: In function 'cpm_load_patch':
  arch/powerpc/sysdev/micropatch.c:629: warning: unused variable 'spp'
  arch/powerpc/sysdev/micropatch.c:628: warning: unused variable 'iip'
  make[1]: *** [arch/powerpc/sysdev/micropatch.o] Error 1

This patch fixes these issues by introducing proper #ifdefs.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/sysdev/micropatch.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/powerpc/sysdev/micropatch.c
+++ b/arch/powerpc/sysdev/micropatch.c
@@ -626,9 +626,14 @@ cpm_load_patch(cpm8xx_t	*cp)
 {
 	volatile uint		*dp;		/* Dual-ported RAM. */
 	volatile cpm8xx_t	*commproc;
+#if defined(CONFIG_I2C_SPI_UCODE_PATCH) || \
+    defined(CONFIG_I2C_SPI_SMC1_UCODE_PATCH)
 	volatile iic_t		*iip;
 	volatile struct spi_pram *spp;
+#ifdef CONFIG_I2C_SPI_SMC1_UCODE_PATCH
 	volatile smc_uart_t	*smp;
+#endif
+#endif
 	int	i;
 
 	commproc = cp;


