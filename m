Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1KUXZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:25:07 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:43444 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1KUXZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:25:05 -0500
Date: Tue, 22 Nov 2011 08:24:54 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111121232454.GC840@gamma.logic.tuwien.ac.at>
References: <20111104045817.GA25778@gamma.logic.tuwien.ac.at> <20111107123812.GB23508@gamma.logic.tuwien.ac.at> <1320709047.31823.188.camel@wwguy-huron> <20111108043233.GA21171@gamma.logic.tuwien.ac.at> <CANUX_P0Q0wve4D6fZPsMv2Zw=02gb9u+3C2cjRv7UAmWqXnjzw@mail.gmail.com> <CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com> <20111109051152.GA16006@gamma.logic.tuwien.ac.at> <CANUX_P2Yz9bWP_EmU1Acs7Mu2w78CXxO-njhiMt97b0TJHFYiQ@mail.gmail.com> <20111121030640.GI32505@gamma.logic.tuwien.ac.at> <CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 21 Nov 2011, Emmanuel Grumbach wrote:
> iwlwifi: add debug information on queue stop / wake
> 
> and run with debug flags 0x80000000 (bit 31)
> This will print a message each time a queue is stopped / started.

I have these patches in addition to current git:
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -436,7 +436,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
-       priv->power_data.bus_pm = bus_get_pm_support(bus(priv));
+       priv->power_data.bus_pm = false;
 
        priv->power_data.debug_sleep_level_override = -1;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index da34110..2df3bac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1512,8 +1512,12 @@ static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
        if (time_after(jiffies, timeout)) {
                IWL_ERR(trans, "Queue %d stuck for %u ms.\n", q->id,
                        hw_params(trans).wd_timeout);
-               IWL_ERR(trans, "Current read_ptr %d write_ptr %d\n",
+               IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
                        q->read_ptr, q->write_ptr);
+               IWL_ERR(trans, "Current HW read_ptr %d write_ptr %d\n",
+                       iwl_read_prph(bus(trans), SCD_QUEUE_RDPTR(cnt))
+                               & (TFD_QUEUE_SIZE_MAX - 1),
+                       iwl_read_prph(bus(trans), SCD_QUEUE_WRPTR(cnt)));
                return 1;
        }
 

That is all I get. Is that what you mean?

Related to that this morning at home (not university!) I had the hanging
again, had to remove the module. Always after wake up from ram (s2ram).
There I had in the log:
Nov 22 07:55:32 mithrandir kernel: [ 4536.000032] iwlwifi 0000:06:00.0: Queue 11
 stuck for 10000 ms.
Nov 22 07:55:32 mithrandir kernel: [ 4536.000044] iwlwifi 0000:06:00.0: Current 
SW read_ptr 155 write_ptr 164
Nov 22 07:55:32 mithrandir kernel: [ 4536.000099] iwlwifi 0000:06:00.0: Current HW read_ptr 155 write_ptr 164
Nov 22 07:55:32 mithrandir kernel: [ 4536.000107] iwlwifi 0000:06:00.0: On demand firmware reload
Nov 22 07:55:32 mithrandir kernel: [ 4536.000546] ieee80211 phy1: Hardware restart was requested
Nov 22 07:55:32 mithrandir kernel: [ 4536.000648] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
Nov 22 07:55:32 mithrandir kernel: [ 4536.003755] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0

But somehow it didn't actually start working again.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
ULLINGSWICK (n.)
An over-developed epiglottis found in middle-aged coloraturas.
			--- Douglas Adams, The Meaning of Liff
