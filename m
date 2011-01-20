Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1ATOaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:30:18 -0500
Received: from www.tglx.de ([62.245.132.106]:43490 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab1ATOaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:30:15 -0500
To: balbi@ti.com
Cc: paul@pwsan.com, tony@atomide.com, r-woodruff2@ti.com,
        linux-kernel@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2] omap2: fix DPLL_FREQSEL calculation
From: John Ogness <john.ogness@linutronix.de>
References: <87ei8726wf.fsf@vostro.fn.ogness.net>
	<20110120111645.GB2223@legolas.emea.dhcp.ti.com>
Date: Thu, 20 Jan 2011 15:29:50 +0100
In-Reply-To: <20110120111645.GB2223@legolas.emea.dhcp.ti.com> (Felipe Balbi's message of "Thu\, 20 Jan 2011 13\:16\:45 +0200")
Message-ID: <8739on1wdd.fsf_-_@vostro.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-20, Felipe Balbi <balbi@ti.com> wrote:
> scripts/get_maintainer.pl would've helped you getting a better Cc
> list. I'm adding linux-omap and lakml

Thanks.

After investigating the issue further it seems that I had it
backwards. The value of "n" is the value to divide by, not the value
that goes in the register. This means that it is _dpll_test_fint()
that is doing it incorrectly. Here is a new version of the patch to
fix the right function.



This patch fixes the calculation of the internal frequency. The value
of "n" is the actual divider to use.

This patch is against linux-next-20110120.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 arch/arm/mach-omap2/clkt_dpll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/clkt_dpll.c b/arch/arm/mach-omap2/clkt_dpll.c
index 337392c..acb7ae5 100644
--- a/arch/arm/mach-omap2/clkt_dpll.c
+++ b/arch/arm/mach-omap2/clkt_dpll.c
@@ -77,7 +77,7 @@ static int _dpll_test_fint(struct clk *clk, u8 n)
 	dd = clk->dpll_data;
 
 	/* DPLL divider must result in a valid jitter correction val */
-	fint = clk->parent->rate / (n + 1);
+	fint = clk->parent->rate / n;
 	if (fint < DPLL_FINT_BAND1_MIN) {
 
 		pr_debug("rejecting n=%d due to Fint failure, "
