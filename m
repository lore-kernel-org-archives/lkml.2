Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1LMSFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:05:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:9628 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab1LMSFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:05:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208,223";a="86139005"
Subject: Re: [Ilw] Re: REGRESSION: v3.2-rcX: iwlagn refuses to associate
 with my AP's
From: wwguy <wey-yi.w.guy@intel.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111213172642.GA4962@thunk.org>
References: <E1RaBm1-0001JR-8a@tytso-glaptop.cam.corp.google.com>
	 <20111213172642.GA4962@thunk.org>
Content-Type: multipart/mixed; boundary="=-6XAQ+NU6magmxzqkeVTD"
Date: Tue, 13 Dec 2011 09:54:34 -0800
Message-ID: <1323798874.7144.4.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6XAQ+NU6magmxzqkeVTD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Ted,

On Tue, 2011-12-13 at 09:26 -0800, Ted Ts'o wrote:
> On Mon, Dec 12, 2011 at 02:42:53PM -0500, Theodore Ts'o wrote:
> > Hi there,
> > 
> > I recently discovered a regression in the iwlagn driver (works in v3.1
> > but not in v3.2-rc2... I'm going to continue to bisect, but I thought
> > I'd give a heads up now).  I'm using a Lenovo T410, with the following
> > wireless card:
> > 
> > [   11.197410] iwlwifi 0000:03:00.0: HW Revision ID = 0x35
> > [   11.197637] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N + WiMAX 6250 AGN, REV=0x84
> > 
> > The failure to associate with access points happens at work, with
> > whatever AP's are in use at the Cambridge Google office.  When I tried
> > v3.2-rc5 at home, I was able to associate with a consumer-grade NetGear
> > AP, although it was flaky --- that is, it completely failed to associate
> > initially, but then I tried rebooting and I was eventually able to get
> > it to work.   At work, I was able to reproduce the problem with a
> > v3.2-rc5 and v3.2-rc2 kernel, but the problem did not manifest itself
> > with a v3.1 kernel.
> 
> OK, a follow up.  A bisection puts the finger of blame very firmly at:
> 
> debcf73 iwlagn: handle GO powersave
> 
> Specifically, I can't associate with *any* access points (encrypted or
> not) if I compile a kernel at commit debcf73, but if I compile a
> kernel with its parent (commit 8ad71be), it works fine.
> 
> However, as a puzzler, when I tried reverted compiling 3.2-rc5 with
> debcf73 reverted, it did not make the problem go away.  So there's
> something debcf73more going on here.  I could try doing a bisect with reverts
> of debcf73 at each step, trying to find the problem, but I'm hoping
> this is enough of a hint that someone can tell me either that this is
> fixed already in the linux-wireless tree, or that they know what's
> wrong and can provide a test patch...
> 
Thank you for doing all those works, 

The "debcf73 iwlagn: handle GO powersave" is part of new WiFi Direct
feature we are introducing for our up-coming new products. As you can
see, the feature still under development and for sure there are a lot
issues we need to flush out and make it perfect.

Here I attach a patch which will disable P2P feature by default, could
you please give it a try, so we know for sure it is something being
introduced by P2P changes. 

Of cause, we still need to understand why it is happening and find the
correct solution for it.

Thanks
Wey
> 
> _______________________________________________
> ilw mailing list
> ilw@linux.intel.com
> http://linux.intel.com/mailman/listinfo/ilw


--=-6XAQ+NU6magmxzqkeVTD
Content-Disposition: attachment; filename="0001-iwlwifi-P2P-is-not-enabled-by-default.patch"
Content-Type: text/x-patch; name="0001-iwlwifi-P2P-is-not-enabled-by-default.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 788e8d4221b118c1818eb501858323c7f10b5bff Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Fri, 2 Dec 2011 07:32:08 -0800
Subject: [PATCH v2 1/1] iwlwifi: P2P is not enabled by default

P2P still under development. it will not enabled by default, but user
always can enable it manually for testing.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
v2: only disable p2p but not newscan, need testing
---
 drivers/net/wireless/iwlwifi/Kconfig   |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c |   10 +++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 82c8cca..ae08498 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -111,3 +111,19 @@ config IWLWIFI_DEVICE_TESTMODE
 	  NL80211_TESTMODE. This provide the capabilities of enable user space
 	  validation applications to interacts with the device through the
 	  generic netlink message via NL80211_TESTMODE channel.
+
+config IWLWIFI_P2P
+       bool "iwlwifi experimental P2P support"
+       depends on IWLWIFI
+       help
+         This option enables experimental P2P support for some devices
+         based on microcode support. Since P2P support is still under
+         development, this option may even enable it for some devices
+         now that turn out to not support it in the future due to
+         microcode restrictions.
+
+         To determine if your microcode supports the experimental P2P
+         offered by this option, check if the driver advertises AP
+         support when it is loaded.
+
+         Say Y only if you want to experiment with P2P.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8ca6ad3..368c28e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1036,6 +1036,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		priv->inst_evtlog_size =
 			priv->cfg->base_params->max_event_log_size;
 	priv->inst_errlog_ptr = pieces.inst_errlog_ptr;
+#ifndef CONFIG_IWLWIFI_P2P
+	ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+#endif
 
 	priv->new_scan_threshold_behaviour =
 		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
@@ -1057,7 +1060,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 		priv->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
 	}
-
 	/*
 	 * figure out the offset of chain noise reset and gain commands
 	 * base on the size of standard phy calibration commands table size
@@ -1707,6 +1709,12 @@ static void iwl_debug_config(struct iwl_priv *priv)
 #else
 		"disabled\n");
 #endif
+	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_P2P "
+#ifdef CONFIG_IWLWIFI_P2P
+		"enabled\n");
+#else
+		"disabled\n");
+#endif
 }
 
 int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
-- 
1.7.0.4


--=-6XAQ+NU6magmxzqkeVTD--

