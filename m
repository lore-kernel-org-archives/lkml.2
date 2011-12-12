Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1LLTm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:42:57 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:51083 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab1LLTm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:42:56 -0500
Date: Mon, 12 Dec 2011 14:42:53 -0500
Message-Id: <E1RaBm1-0001JR-8a@tytso-glaptop.cam.corp.google.com>
To: linux-kernel@vger.kernel.org
cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: REGRESSION: v3.2-rcX: iwlagn refuses to associate with my AP's
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I recently discovered a regression in the iwlagn driver (works in v3.1
but not in v3.2-rc2... I'm going to continue to bisect, but I thought
I'd give a heads up now).  I'm using a Lenovo T410, with the following
wireless card:

[   11.197410] iwlwifi 0000:03:00.0: HW Revision ID = 0x35
[   11.197637] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N + WiMAX 6250 AGN, REV=0x84

This doesn't appear to be the same regression as the one reported in the
thread "iwlagn regression in v3.1.5", since the commit which Andrej
pointed at (and which fixed his problem when he reverted it, "iwlwifi:
do not re-configure HT40 after associated") does not appear in v3.2-rc2.

The failure to associate with access points happens at work, with
whatever AP's are in use at the Cambridge Google office.  When I tried
v3.2-rc5 at home, I was able to associate with a consumer-grade NetGear
AP, although it was flaky --- that is, it completely failed to associate
initially, but then I tried rebooting and I was eventually able to get
it to work.   At work, I was able to reproduce the problem with a
v3.2-rc5 and v3.2-rc2 kernel, but the problem did not manifest itself
with a v3.1 kernel.

One interesting thing is that I'm getting the following WARNING message
triggering in my dmesg logs:

[   48.518246] wlan0: deauthenticating from 00:1a:1e:26:2b:30 by local choice (r
eason=3)
[   48.525625] ------------[ cut here ]------------
[   48.525653] WARNING: at net/wireless/mlme.c:309 __cfg80211_auth_remove+0xc2/0xcf [cfg80211]()
[   48.525656] Hardware name: 2516CTO
[   48.525658] Modules linked in: ecryptfs encrypted_keys trusted binfmt_misc rfcomm ppdev bridge stp bnep snd_hda_codec_hdmi ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT ipt_LOG nvidia(P) ipt_ULOG xt_limit xt_tcpudp btusb xt_addrtype bluetooth xt_owner uvcvideo xt_conntrack videodev v4l2_compat_ioctl32 ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc iwlwifi nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp snd_hda_codec_conexant mac80211 intel_ips nf_conntrack iptable_filter ip_tables x_tables cfg80211 sdhci_pci snd_hda_intel snd_hda_codec snd_hwdep thinkpad_acpi nvram tpm_tis tpm tpm_bios lp parport mxm_wmi intel_agp ehci_hcd intel_gtt
[   48.525782] Pid: 69, comm: kworker/u:5 Tainted: P           O 3.2.0-rc5 #14
[   48.525786] Call Trace:
[   48.525798]  [<ffffffff8105bf6e>] warn_slowpath_common+0x85/0x9d
[   48.525804]  [<ffffffff8105bfa0>] warn_slowpath_null+0x1a/0x1c
[   48.525816]  [<ffffffffa00b29db>] __cfg80211_auth_remove+0xc2/0xcf [cfg80211]
[   48.525828]  [<ffffffffa00b3290>] cfg80211_send_auth_timeout+0x98/0xaf [cfg80211]
[   48.525845]  [<ffffffffa0106cdb>] ieee80211_probe_auth_done+0x39/0xcb [mac80211]
[   48.525858]  [<ffffffffa01096f2>] ieee80211_work_work+0x1003/0x1074 [mac80211]
[   48.525864]  [<ffffffff8108ac9d>] ? print_lock_contention_bug+0x1b/0xee
[   48.525877]  [<ffffffffa01086ef>] ? free_work+0x19/0x19 [mac80211]
[   48.525884]  [<ffffffff81074989>] process_one_work+0x230/0x398
[   48.525889]  [<ffffffff810748fa>] ? process_one_work+0x1a1/0x398
[   48.525897]  [<ffffffff81074c2c>] worker_thread+0x13b/0x25a
[   48.525902]  [<ffffffff81074af1>] ? process_one_work+0x398/0x398
[   48.525909]  [<ffffffff810789f7>] kthread+0xa0/0xa8
[   48.525915]  [<ffffffff8108b66f>] ? trace_hardirqs_on_caller+0x123/0x15a
[   48.525923]  [<ffffffff815173c4>] kernel_thread_helper+0x4/0x10
[   48.525930]  [<ffffffff8150f274>] ? retint_restore_args+0x13/0x13
[   48.525936]  [<ffffffff81078957>] ? __init_kthread_worker+0x5b/0x5b
[   48.525941]  [<ffffffff815173c0>] ? gs_change+0x13/0x13
[   48.525945] ---[ end trace d5c80202b94eccb9 ]---
[   64.008073] wlan0: deauthenticating from 00:1a:1e:26:2c:90 by local choice (reason=3)
[   64.014596] ------------[ cut here ]------------

This seems to be happening after the failure to associate with the AP,
so it could be a red herring.

							- Ted
