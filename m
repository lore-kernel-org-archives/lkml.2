Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab0G3Rfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:35:40 -0400
Received: from kroah.org ([198.145.64.141]:35665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759387Ab0G3Re3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:29 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:06 2010
Message-Id: <20100730173106.342298823@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [040/140] iwlwifi: cancel scan watchdog in iwl_bg_abort_scan
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit a69b03e941abae00380fc6bc1877fb797a1b31e6 upstream.

Avoids this:

WARNING: at net/mac80211/scan.c:312 ieee80211_scan_completed+0x5f/0x1f1
[mac80211]()
Hardware name: Latitude E5400
Modules linked in: aes_x86_64 aes_generic fuse ipt_MASQUERADE iptable_nat
nf_nat rfcomm sco bridge stp llc bnep l2cap sunrpc cpufreq_ondemand
acpi_cpufreq freq_table xt_physdev ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput arc4 ecb
snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel iwlagn snd_hda_codec
snd_hwdep snd_seq snd_seq_device iwlcore snd_pcm dell_wmi sdhci_pci sdhci
iTCO_wdt tg3 dell_laptop mmc_core i2c_i801 wmi mac80211 snd_timer
iTCO_vendor_support btusb joydev dcdbas cfg80211 bluetooth snd soundcore
microcode rfkill snd_page_alloc firewire_ohci firewire_core crc_itu_t
yenta_socket rsrc_nonstatic i915 drm_kms_helper drm i2c_algo_bit i2c_core video
output [last unloaded: scsi_wait_scan]
Pid: 979, comm: iwlagn Tainted: G        W  2.6.33.3-85.fc13.x86_64 #1
Call Trace:
[<ffffffff8104b558>] warn_slowpath_common+0x77/0x8f
[<ffffffff8104b57f>] warn_slowpath_null+0xf/0x11
[<ffffffffa01bb7d9>] ieee80211_scan_completed+0x5f/0x1f1 [mac80211]
[<ffffffffa02a23f0>] iwl_bg_scan_completed+0xbb/0x17a [iwlcore]
[<ffffffff81060d3d>] worker_thread+0x1a4/0x232
[<ffffffffa02a2335>] ? iwl_bg_scan_completed+0x0/0x17a [iwlcore]
[<ffffffff81064817>] ? autoremove_wake_function+0x0/0x34
[<ffffffff81060b99>] ? worker_thread+0x0/0x232
[<ffffffff810643c7>] kthread+0x7a/0x82
[<ffffffff8100a924>] kernel_thread_helper+0x4/0x10
[<ffffffff8106434d>] ? kthread+0x0/0x82
[<ffffffff8100a920>] ? kernel_thread_helper+0x0/0x10

Reported here:

	https://bugzilla.redhat.com/show_bug.cgi?id=590436

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Reported-by: Mihai Harpau <mishu@piatafinanciara.ro>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -812,6 +812,7 @@ void iwl_bg_abort_scan(struct work_struc
 
 	mutex_lock(&priv->mutex);
 
+	cancel_delayed_work_sync(&priv->scan_check);
 	set_bit(STATUS_SCAN_ABORTING, &priv->status);
 	iwl_send_scan_abort(priv);
 


