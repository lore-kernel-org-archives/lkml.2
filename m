Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab1DZGdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:33:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1DZGdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:33:21 -0400
Date: Tue, 26 Apr 2011 08:32:12 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [IWL4965] TX Power requested while scanning!
Message-ID: <20110426063211.GA2419@redhat.com>
References: <1303498582.2103.15.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303498582.2103.15.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 08:56:22PM +0200, Paul Bolle wrote:
> 0) Running v2.6.39-rc4 I ran into this (after a resume):
> 
> WARNING: at drivers/net/wireless/iwlegacy/iwl-4965.c:1128 iwl4965_send_tx_power+0x61/0x102 [iwl4965]()
> Hardware name: [...]
> TX Power requested while scanning!
> Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput btusb arc4 snd_hda_codec_analog bluetooth ecb snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_seq iwl_legacy snd_seq_device thinkpad_acpi mac80211 cfg80211 rfkill snd_pcm snd_timer iTCO_wdt snd i2c_i801 snd_page_alloc iTCO_vendor_support soundcore e1000e pcspkr microcode sdhci_pci sdhci firewire_ohci mmc_core firewire_core yenta_socket crc_itu_t i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> Pid: 5723, comm: kworker/u:28 Not tainted 2.6.39-0.rc4.4.fc14.x86_64 #1
> Call Trace:
>  [<ffffffff8104e27b>] warn_slowpath_common+0x85/0x9d
>  [<ffffffffa02782e0>] ? iwl4965_show_temperature+0x49/0x49 [iwl4965]
>  [<ffffffff8104e336>] warn_slowpath_fmt+0x46/0x48
>  [<ffffffffa027712f>] iwl4965_send_tx_power+0x61/0x102 [iwl4965]
>  [<ffffffff81477e05>] ? mutex_lock+0x36/0x50
>  [<ffffffffa0278337>] iwl4965_bg_txpower_work+0x57/0x73 [iwl4965]
>  [<ffffffff810647f3>] process_one_work+0x18d/0x286
>  [<ffffffff81065a5e>] worker_thread+0xfd/0x181
>  [<ffffffff81065961>] ? manage_workers.clone.16+0x172/0x172
>  [<ffffffff81069036>] kthread+0x82/0x8a
>  [<ffffffff81480524>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81068fb4>] ? kthread_worker_fn+0x14b/0x14b
>  [<ffffffff81480520>] ? gs_change+0x13/0x13
> 
> (2.6.39-0.rc4.4.fc14.x86_64 is not a Fedora blessed kernel, but a self
> compiled "vanilla" kernel.) I have similar WARNINGs for rc2 and rc3 in
> my log too.
> 
> 1) The thing is that this triggers Fedora's "Automatic Bug Reporting
> Tool", and is a bit noisy in dmesg and friends too, but everything seems
> to be running just fine after that. I'm posting this from the session
> that just triggered this! So why is this warning needed?

Warning correctly indicate a bug. Please try below patch.

diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 58a2e63..46966e9 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -2988,15 +2988,15 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 			txpower_work);
 
+	mutex_lock(&priv->mutex);
+
 	/* If a scan happened to start before we got here
 	 * then just return; the statistics notification will
 	 * kick off another scheduled work to compensate for
 	 * any temperature delta we missed here. */
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
 	    test_bit(STATUS_SCANNING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
+		goto out;
 
 	/* Regardless of if we are associated, we must reconfigure the
 	 * TX power since frames can be sent on non-radar channels while
@@ -3006,7 +3006,7 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
 	/* Update last_temperature to keep is_calib_needed from running
 	 * when it isn't needed... */
 	priv->last_temperature = priv->temperature;
-
+out:
 	mutex_unlock(&priv->mutex);
 }
 
