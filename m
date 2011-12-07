Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab1LGQV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:21:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933449Ab1LGQVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:21:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:15 2011
Message-Id: <20111207161215.528198772@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:11 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Eric Anholt <eric@anholt.net>,
        Keith Packard <keithp@keithp.com>
Subject: [009/104] drm/i915: Turn on a required 3D clock gating bit on Sandybridge.
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Anholt <eric@anholt.net>

commit 406478dc911e16677fbd9c84d1d50cdffbc031ab upstream.

Fixes rendering failures in Unigine Tropics and Sanctuary and the mesa
"fire" demo.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    3 +++
 drivers/gpu/drm/i915/intel_display.c |    9 +++++++++
 2 files changed, 12 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3401,6 +3401,9 @@
 #define  GT_FIFO_FREE_ENTRIES			0x120008
 #define    GT_FIFO_NUM_RESERVED_ENTRIES		20
 
+#define GEN6_UCGCTL2				0x9404
+# define GEN6_RCPBUNIT_CLOCK_GATE_DISABLE		(1 << 12)
+
 #define GEN6_RPNSWREQ				0xA008
 #define   GEN6_TURBO_DISABLE			(1<<31)
 #define   GEN6_FREQUENCY(x)			((x)<<25)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7882,6 +7882,15 @@ static void gen6_init_clock_gating(struc
 	I915_WRITE(WM2_LP_ILK, 0);
 	I915_WRITE(WM1_LP_ILK, 0);
 
+	/* According to the BSpec vol1g, bit 12 (RCPBUNIT) clock
+	 * gating disable must be set.  Failure to set it results in
+	 * flickering pixels due to Z write ordering failures after
+	 * some amount of runtime in the Mesa "fire" demo, and Unigine
+	 * Sanctuary and Tropics, and apparently anything else with
+	 * alpha test or pixel discard.
+	 */
+	I915_WRITE(GEN6_UCGCTL2, GEN6_RCPBUNIT_CLOCK_GATE_DISABLE);
+
 	/*
 	 * According to the spec the following bits should be
 	 * set in order to enable memory self-refresh and fbc:


