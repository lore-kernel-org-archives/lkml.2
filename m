Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab1CAViG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:38:06 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:42079 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab1CAViE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:38:04 -0500
Date: Tue, 1 Mar 2011 16:37:56 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] tpm_tis on Lenovo T410 broken in 2.6.38-rc6
Message-ID: <20110301213756.GA2959@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
References: <E1PuKHL-0000lw-RM@tytso-glaptop>
 <4D6CFA80.3020505@linux.vnet.ibm.com>
 <AANLkTi=BtfXYV+1_JZh0SRZhJz=Ys3wCF-t5rBR2iz8O@mail.gmail.com>
 <4D6D61B1.7000302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6D61B1.7000302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 06:14:25PM -0300, Rajiv Andrade wrote:
> 
> I was referring to the first, 9b29050f, and the commitc4ff4b82  reverted by Ted fixes a bug for other users.

What's the bug that other users suffer by having a longer timeout?  It
means that if things fails it takes longer for them to get an error
message in the case of something that's going to fail anyway, right?
Somehow that seems less serious than the TPM simply completely failing
to function caused by too-short timeouts.  (My situation).  So sorry
if I'm feeling selfish, but a longer timeout before returning failure
seems less important than my not being able to access the TPM at all.

So, the results of my experiments.  First of all, trying to merge in
your for_james branch doesn't help at all.  I used the tip of Linus's
tree as of this morning (commit 3e1f2356ce2) and then merged in your
for-james tree (commit b83452256e).  No go.  I tried setting the
interrupts parameter to both 0 and 1, and either way, things still
didn't work.

OK, next, I tried Linus's idea, which was to put a WARN macro here in
tpm_calc_ordinal_duration:

        if (duration_idx != TPM_UNDEFINED) {
		duration = chip->vendor.duration[duration_idx];
                /* if duration is 0, it's because chip->vendor.duration wasn't \
*/
                /* filled yet, so we set the lowest timeout just to give enough\
 */
                /* time for tpm_get_timeouts() to succeed */
NEW ---->	WARN(duration <=0,
		    "no duration for ordinal %x (diration_idx %d)",
		    ordinal, duration_idx);
                return (duration <= 0 ? HZ : duration);
	} else
                return 2 * 60 * HZ;
}

That resulted in the following data (see attached), which you will
hopefully find useful.

At least for now I'm running very happily with commit c4ff4b829e
reverted.  Let me know if there's something else you want me to test.

	       	       	  	  	    	 - Ted

[   17.780661] tpm_tis 00:0b: 1.2 TPM (device-id 0x0, rev-id 78)
[   17.780794] ------------[ cut here ]------------
[   17.780802] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   17.780805] Hardware name: 2516CTO
[   17.780807] no duration for ordinal 65 (diration_idx 0)
[   17.780810] Modules linked in: tpm_tis(+) tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   17.780823] Pid: 539, comm: modprobe Not tainted 2.6.38-rc6-00212-g3e1f235-dirty #6
[   17.780825] Call Trace:
[   17.780833]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   17.780837]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   17.780842]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   17.780847]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   17.780852]  [<ffffffffa00359e1>] ? transmit_cmd+0x19/0x33 [tpm]
[   17.780856]  [<ffffffffa0035f15>] ? tpm_get_timeouts+0x76/0x1b6 [tpm]
[   17.780863]  [<ffffffff8125476e>] ? ioremap_page_range+0x232/0x294
[   17.780871]  [<ffffffff8108835d>] ? mark_held_locks+0x52/0x70
[   17.780878]  [<ffffffff8101184a>] ? native_sched_clock+0x2d/0x5f
[   17.780882]  [<ffffffff81010e1d>] ? sched_clock+0x9/0xd
[   17.780888]  [<ffffffff8107d033>] ? sched_clock_cpu+0x44/0xce
[   17.780893]  [<ffffffff81086bb5>] ? trace_hardirqs_off+0xd/0xf
[   17.780897]  [<ffffffff8107d0fe>] ? local_clock+0x41/0x5a
[   17.780901]  [<ffffffff8108721c>] ? lock_release_holdtime+0x2c/0xd7
[   17.780907]  [<ffffffff812607f7>] ? do_raw_spin_unlock+0x8f/0x98
[   17.780913]  [<ffffffffa0040b2d>] ? tpm_tis_init+0x3f9/0x43e [tpm_tis]
[   17.780918]  [<ffffffffa0040fc7>] ? tpm_tis_pnp_init+0xfa/0x11b [tpm_tis]
[   17.780926]  [<ffffffff812c564f>] ? pnp_device_probe+0x9f/0xc7
[   17.780932]  [<ffffffff812fef72>] ? driver_sysfs_add+0x70/0x95
[   17.780936]  [<ffffffff812ff0d5>] ? driver_probe_device+0xb7/0x151
[   17.780940]  [<ffffffff812ff1d0>] ? __driver_attach+0x61/0x85
[   17.780943]  [<ffffffff812ff16f>] ? __driver_attach+0x0/0x85
[   17.780951]  [<ffffffff812fe644>] ? bus_for_each_dev+0x59/0x8e
[   17.780955]  [<ffffffff812fef00>] ? driver_attach+0x1e/0x20
[   17.780959]  [<ffffffff812feb0e>] ? bus_add_driver+0xb9/0x20b
[   17.780964]  [<ffffffffa0045000>] ? init_tis+0x0/0x9c [tpm_tis]
[   17.780968]  [<ffffffff812ff4d8>] ? driver_register+0x9e/0x10f
[   17.780973]  [<ffffffffa0045000>] ? init_tis+0x0/0x9c [tpm_tis]
[   17.780977]  [<ffffffff812c53ff>] ? pnp_register_driver+0x21/0x23
[   17.780982]  [<ffffffffa004501d>] ? init_tis+0x1d/0x9c [tpm_tis]
[   17.780987]  [<ffffffff8107c592>] ? __blocking_notifier_call_chain+0x61/0x6d
[   17.780993]  [<ffffffff8100208a>] ? do_one_initcall+0x7f/0x13e
[   17.781000]  [<ffffffff81095a1f>] ? sys_init_module+0xa1/0x1e2
[   17.781006]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   17.781009] ---[ end trace bfa920319f4d3b50 ]---
[   17.796438] ------------[ cut here ]------------
[   17.796448] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   17.796451] Hardware name: 2516CTO
[   17.796454] no duration for ordinal 65 (diration_idx 0)
[   17.796456] Modules linked in: tpm_tis(+) tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   17.796471] Pid: 539, comm: modprobe Tainted: G        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   17.796474] Call Trace:
[   17.796481]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   17.796485]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   17.796489]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   17.796494]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   17.796498]  [<ffffffffa00359e1>] ? transmit_cmd+0x19/0x33 [tpm]
[   17.796502]  [<ffffffffa0035fdd>] ? tpm_get_timeouts+0x13e/0x1b6 [tpm]
[   17.796509]  [<ffffffff8125476e>] ? ioremap_page_range+0x232/0x294
[   17.796516]  [<ffffffff8108835d>] ? mark_held_locks+0x52/0x70
[   17.796523]  [<ffffffff8101184a>] ? native_sched_clock+0x2d/0x5f
[   17.796526]  [<ffffffff81010e1d>] ? sched_clock+0x9/0xd
[   17.796532]  [<ffffffff8107d033>] ? sched_clock_cpu+0x44/0xce
[   17.796536]  [<ffffffff81086bb5>] ? trace_hardirqs_off+0xd/0xf
[   17.796540]  [<ffffffff8107d0fe>] ? local_clock+0x41/0x5a
[   17.796543]  [<ffffffff8108721c>] ? lock_release_holdtime+0x2c/0xd7
[   17.796549]  [<ffffffff812607f7>] ? do_raw_spin_unlock+0x8f/0x98
[   17.796555]  [<ffffffffa0040b2d>] ? tpm_tis_init+0x3f9/0x43e [tpm_tis]
[   17.796561]  [<ffffffffa0040fc7>] ? tpm_tis_pnp_init+0xfa/0x11b [tpm_tis]
[   17.796570]  [<ffffffff812c564f>] ? pnp_device_probe+0x9f/0xc7
[   17.796575]  [<ffffffff812fef72>] ? driver_sysfs_add+0x70/0x95
[   17.796579]  [<ffffffff812ff0d5>] ? driver_probe_device+0xb7/0x151
[   17.796583]  [<ffffffff812ff1d0>] ? __driver_attach+0x61/0x85
[   17.796587]  [<ffffffff812ff16f>] ? __driver_attach+0x0/0x85
[   17.796593]  [<ffffffff812fe644>] ? bus_for_each_dev+0x59/0x8e
[   17.796597]  [<ffffffff812fef00>] ? driver_attach+0x1e/0x20
[   17.796601]  [<ffffffff812feb0e>] ? bus_add_driver+0xb9/0x20b
[   17.796606]  [<ffffffffa0045000>] ? init_tis+0x0/0x9c [tpm_tis]
[   17.796610]  [<ffffffff812ff4d8>] ? driver_register+0x9e/0x10f
[   17.796614]  [<ffffffffa0045000>] ? init_tis+0x0/0x9c [tpm_tis]
[   17.796619]  [<ffffffff812c53ff>] ? pnp_register_driver+0x21/0x23
[   17.796624]  [<ffffffffa004501d>] ? init_tis+0x1d/0x9c [tpm_tis]
[   17.796628]  [<ffffffff8107c592>] ? __blocking_notifier_call_chain+0x61/0x6d
[   17.796634]  [<ffffffff8100208a>] ? do_one_initcall+0x7f/0x13e
[   17.796640]  [<ffffffff81095a1f>] ? sys_init_module+0xa1/0x1e2
[   17.796646]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   17.796649] ---[ end trace bfa920319f4d3b51 ]---
[   17.816272] ------------[ cut here ]------------
[   17.816282] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   17.816285] Hardware name: 2516CTO
[   17.816288] no duration for ordinal 53 (diration_idx 2)
[   17.816290] Modules linked in: tpm_tis(+) tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   17.816304] Pid: 539, comm: modprobe Tainted: G        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   17.816307] Call Trace:
[   17.816315]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   17.816320]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   17.816325]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   17.816330]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   17.816335]  [<ffffffffa00366a7>] ? tpm_continue_selftest+0x52/0x6b [tpm]
[   17.816341]  [<ffffffffa0040b35>] ? tpm_tis_init+0x401/0x43e [tpm_tis]
[   17.816347]  [<ffffffffa0040fc7>] ? tpm_tis_pnp_init+0xfa/0x11b [tpm_tis]
[   17.816355]  [<ffffffff812c564f>] ? pnp_device_probe+0x9f/0xc7
[   17.816360]  [<ffffffff812fef72>] ? driver_sysfs_add+0x70/0x95
[   17.816364]  [<ffffffff812ff0d5>] ? driver_probe_device+0xb7/0x151
[   17.816368]  [<ffffffff812ff1d0>] ? __driver_attach+0x61/0x85
[   17.816371]  [<ffffffff812ff16f>] ? __driver_attach+0x0/0x85
[   17.816378]  [<ffffffff812fe644>] ? bus_for_each_dev+0x59/0x8e
[   17.816382]  [<ffffffff812fef00>] ? driver_attach+0x1e/0x20
[   17.816386]  [<ffffffff812feb0e>] ? bus_add_driver+0xb9/0x20b
[   17.816391]  [<ffffffffa0045000>] ? init_tis+0x0/0x9c [tpm_tis]
[   17.816394]  [<ffffffff812ff4d8>] ? driver_register+0x9e/0x10f
[   17.816399]  [<ffffffffa0045000>] ? init_tis+0x0/0x9c [tpm_tis]
[   17.816404]  [<ffffffff812c53ff>] ? pnp_register_driver+0x21/0x23
[   17.816409]  [<ffffffffa004501d>] ? init_tis+0x1d/0x9c [tpm_tis]
[   17.816415]  [<ffffffff8107c592>] ? __blocking_notifier_call_chain+0x61/0x6d
[   17.816421]  [<ffffffff8100208a>] ? do_one_initcall+0x7f/0x13e
[   17.816428]  [<ffffffff81095a1f>] ? sys_init_module+0xa1/0x1e2
[   17.816434]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   17.816438] ---[ end trace bfa920319f4d3b52 ]---
[   30.008687] ------------[ cut here ]------------
[   30.008714] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   30.008719] Hardware name: 2516CTO
[   30.008723] no duration for ordinal 65 (diration_idx 0)
[   30.008726] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   30.008832] Pid: 2082, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   30.008837] Call Trace:
[   30.008849]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   30.008856]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   30.008867]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   30.008876]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   30.008885]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   30.008895]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   30.008901]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   30.008911]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   30.008916] ---[ end trace bfa920319f4d3b53 ]---
[   30.025772] ------------[ cut here ]------------
[   30.025798] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   30.025804] Hardware name: 2516CTO
[   30.025809] no duration for ordinal 65 (diration_idx 0)
[   30.025814] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   30.025960] Pid: 2082, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   30.025967] Call Trace:
[   30.025981]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   30.025991]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   30.026006]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   30.026019]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   30.026032]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   30.026043]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   30.026052]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   30.026065]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   30.026072] ---[ end trace bfa920319f4d3b54 ]---
[   30.055613] ------------[ cut here ]------------
[   30.055639] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   30.055642] Hardware name: 2516CTO
[   30.055644] no duration for ordinal 65 (diration_idx 0)
[   30.055646] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   30.055709] Pid: 2082, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   30.055711] Call Trace:
[   30.055720]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   30.055724]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   30.055729]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   30.055733]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   30.055738]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   30.055743]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   30.055746]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   30.055752]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   30.055755] ---[ end trace bfa920319f4d3b55 ]---
[   30.075613] ------------[ cut here ]------------
[   30.075637] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   30.075644] Hardware name: 2516CTO
[   30.075649] no duration for ordinal 65 (diration_idx 0)
[   30.075654] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   30.075799] Pid: 2082, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   30.075805] Call Trace:
[   30.075819]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   30.075829]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   30.075843]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   30.075856]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   30.075870]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   30.075880]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   30.075890]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   30.075902]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   30.075907] ---[ end trace bfa920319f4d3b56 ]---
[   30.095573] ------------[ cut here ]------------
[   30.095602] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   30.095609] Hardware name: 2516CTO
[   30.095615] no duration for ordinal 65 (diration_idx 0)
[   30.095620] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   30.095728] Pid: 2082, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   30.095732] Call Trace:
[   30.095744]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   30.095751]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   30.095762]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   30.095772]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   30.095781]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   30.095789]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   30.095796]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   30.095806]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   30.095811] ---[ end trace bfa920319f4d3b57 ]---
[   30.115517] ------------[ cut here ]------------
[   30.115542] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   30.115547] Hardware name: 2516CTO
[   30.115550] no duration for ordinal 65 (diration_idx 0)
[   30.115554] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   30.115659] Pid: 2082, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   30.115663] Call Trace:
[   30.115675]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   30.115682]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   30.115692]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   30.115702]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   30.115711]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   30.115718]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   30.115725]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   30.115734]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   30.115739] ---[ end trace bfa920319f4d3b58 ]---
[   30.135460] ------------[ cut here ]------------
[   30.135484] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   30.135489] Hardware name: 2516CTO
[   30.135493] no duration for ordinal 65 (diration_idx 0)
[   30.135496] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   30.135602] Pid: 2082, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   30.135606] Call Trace:
[   30.135618]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   30.135625]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   30.135636]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   30.135645]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   30.135654]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   30.135663]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   30.135669]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   30.135679]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   30.135684] ---[ end trace bfa920319f4d3b59 ]---
[   30.155380] ------------[ cut here ]------------
[   30.155406] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   30.155413] Hardware name: 2516CTO
[   30.155418] no duration for ordinal 65 (diration_idx 0)
[   30.155423] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   30.155605] Pid: 2082, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   30.155609] Call Trace:
[   30.155621]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   30.155628]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   30.155639]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   30.155648]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   30.155658]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   30.155666]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   30.155672]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   30.155682]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   30.155687] ---[ end trace bfa920319f4d3b5a ]---
[   30.175343] ------------[ cut here ]------------
[   30.175363] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   30.175368] Hardware name: 2516CTO
[   30.175372] no duration for ordinal 65 (diration_idx 0)
[   30.175375] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   30.175477] Pid: 2082, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   30.175481] Call Trace:
[   30.175491]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   30.175498]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   30.175508]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   30.175518]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   30.175527]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   30.175535]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   30.175541]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   30.175550]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   30.175555] ---[ end trace bfa920319f4d3b5b ]---
[   30.180789] wlan0: authenticate with 00:1a:1e:2f:e5:10 (try 1)
[   30.180833] wlan0: deauthenticating from 00:1a:1e:2f:e5:10 by local choice (reason=3)
[   30.195323] ------------[ cut here ]------------
[   30.195340] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   30.195391] Hardware name: 2516CTO
[   30.195396] no duration for ordinal 65 (diration_idx 0)
[   30.195401] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   30.195549] Pid: 2082, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   30.195555] Call Trace:
[   30.195567]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   30.195577]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   30.195594]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   30.195608]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   30.195623]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   30.195634]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   30.195644]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   30.195655]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   30.195662] ---[ end trace bfa920319f4d3b5c ]---
[   31.300796] ------------[ cut here ]------------
[   31.300808] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   31.300810] Hardware name: 2516CTO
[   31.300812] no duration for ordinal a (diration_idx 0)
[   31.300813] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   31.300857] Pid: 2110, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   31.300859] Call Trace:
[   31.300866]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   31.300869]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   31.300873]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   31.300877]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   31.300881]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   31.300886]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   31.300888]  [<ffffffff81130c29>] ? fget_light+0x57/0xf0
[   31.300891]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   31.300897]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   31.300899] ---[ end trace bfa920319f4d3b5d ]---
[   31.312639] ------------[ cut here ]------------
[   31.312645] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   31.312647] Hardware name: 2516CTO
[   31.312648] no duration for ordinal 65 (diration_idx 0)
[   31.312650] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   31.312689] Pid: 2110, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   31.312691] Call Trace:
[   31.312694]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   31.312697]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   31.312701]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   31.312705]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   31.312708]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   31.312711]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   31.312714]  [<ffffffff81130c29>] ? fget_light+0x57/0xf0
[   31.312716]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   31.312719]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   31.312721] ---[ end trace bfa920319f4d3b5e ]---
[   31.332812] ------------[ cut here ]------------
[   31.332818] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   31.332820] Hardware name: 2516CTO
[   31.332822] no duration for ordinal 41 (diration_idx 1)
[   31.332823] Modules linked in: ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   31.332862] Pid: 2110, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   31.332864] Call Trace:
[   31.332867]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   31.332870]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   31.332874]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   31.332878]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   31.332881]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   31.332884]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   31.332887]  [<ffffffff81130c29>] ? fget_light+0x57/0xf0
[   31.332889]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   31.332892]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   31.332894] ---[ end trace bfa920319f4d3b5f ]---
[   32.329790] tpm_tis 00:0b: Operation Timed out
[   85.384332] ------------[ cut here ]------------
[   85.384360] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   85.384365] Hardware name: 2516CTO
[   85.384369] no duration for ordinal a (diration_idx 0)
[   85.384373] Modules linked in: binfmt_misc ppdev ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   85.384481] Pid: 2110, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   85.384485] Call Trace:
[   85.384498]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   85.384505]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   85.384516]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   85.384525]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   85.384534]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   85.384544]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   85.384550]  [<ffffffff81130c29>] ? fget_light+0x57/0xf0
[   85.384556]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   85.384566]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   85.384571] ---[ end trace bfa920319f4d3b60 ]---
[   85.397380] ------------[ cut here ]------------
[   85.397395] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   85.397399] Hardware name: 2516CTO
[   85.397403] no duration for ordinal 65 (diration_idx 0)
[   85.397406] Modules linked in: binfmt_misc ppdev ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   85.397510] Pid: 2110, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   85.397514] Call Trace:
[   85.397522]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   85.397529]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   85.397540]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   85.397549]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   85.397558]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   85.397566]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   85.397572]  [<ffffffff81130c29>] ? fget_light+0x57/0xf0
[   85.397578]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   85.397586]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   85.397590] ---[ end trace bfa920319f4d3b61 ]---
[   85.417397] ------------[ cut here ]------------
[   85.417409] WARNING: at drivers/char/tpm/tpm.c:374 tpm_calc_ordinal_duration+0x63/0x71 [tpm]()
[   85.417413] Hardware name: 2516CTO
[   85.417416] no duration for ordinal 41 (diration_idx 1)
[   85.417419] Modules linked in: binfmt_misc ppdev ipt_MASQUERADE iptable_nat snd_hda_codec_hdmi rfcomm kvm_intel kvm sco bridge stp bnep l2cap ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 iwlagn uvcvideo btusb bluetooth ipt_REJECT nvidia(P) videodev iwlcore ipt_ULOG v4l2_compat_ioctl32 xt_limit xt_tcpudp ipt_addrtype mac80211 xt_owner xt_conntrack ip6table_filter ip6_tables xt_state xt_helper nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack snd_hda_codec_conexant iptable_filter cfg80211 ip_tables x_tables sdhci_pci intel_ips thinkpad_acpi snd_hda_intel snd_hda_codec nvram snd_hwdep tpm_tis tpm tpm_bios lp parport intel_agp intel_gtt ehci_hcd
[   85.417503] Pid: 2110, comm: tcsd Tainted: P        W   2.6.38-rc6-00212-g3e1f235-dirty #6
[   85.417507] Call Trace:
[   85.417514]  [<ffffffff8105b3b2>] ? warn_slowpath_common+0x85/0x9d
[   85.417519]  [<ffffffff8105b46d>] ? warn_slowpath_fmt+0x46/0x48
[   85.417528]  [<ffffffffa003583e>] ? tpm_calc_ordinal_duration+0x63/0x71 [tpm]
[   85.417536]  [<ffffffffa0035907>] ? tpm_transmit+0xbb/0x17c [tpm]
[   85.417543]  [<ffffffffa0036620>] ? tpm_write+0x98/0xcd [tpm]
[   85.417549]  [<ffffffff81130557>] ? vfs_write+0xb1/0x10d
[   85.417554]  [<ffffffff81130c29>] ? fget_light+0x57/0xf0
[   85.417559]  [<ffffffff8113067c>] ? sys_write+0x4d/0x77
[   85.417566]  [<ffffffff8100abc2>] ? system_call_fastpath+0x16/0x1b
[   85.417569] ---[ end trace bfa920319f4d3b62 ]---
[   86.414402] tpm_tis 00:0b: Operation Timed out
