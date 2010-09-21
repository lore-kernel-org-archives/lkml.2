Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0IUG4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:56:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61306 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab0IUG4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:56:19 -0400
Message-ID: <4C98569A.3050109@kernel.org>
Date: Mon, 20 Sep 2010 23:54:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>, Andrew Morton <akpm@linux-foundation.org>
CC: Matthew Garrett <mjg@redhat.com>, Myron Stowe <myron.stowe@hp.com>,
        Len Brown <len.brown@intel.com>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] ipmi: Fix hardcoded ipmi device exit path warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When modprobe.conf has
options ipmi_si type="kcs" ports=0xCA2 regspacings="4"

ipmi_si can be loaded properly, but when try to unload it get:

Sep 20 15:00:27 xx abrt: Kerneloops: Reported 1 kernel oopses to Abrt
Sep 20 15:00:27 xx abrtd: Directory 'kerneloops-1285020027-1' creation detected
Sep 20 15:00:27 xx abrtd: New crash /var/spool/abrt/kerneloops-1285020027-1, processing
Sep 20 15:01:09 xx kernel: ------------[ cut here ]------------
Sep 20 15:01:09 xx kernel: WARNING: at drivers/base/driver.c:262 driver_unregister+0x8a/0xa0()
Sep 20 15:01:09 xx kernel: Hardware name: Sun Fire x4800
Sep 20 15:01:09 xx kernel: Unexpected driver unregister!
Sep 20 15:01:09 xx kernel: Modules linked in: ipmi_si(-) ipmi_msghandler ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat bridge stp llc autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i iw_cxgb3 cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan tun kvm_intel kvm uinput sg ses enclosure ahci libahci pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support igb dca i7core_edac edac_core ext3 jbd mbcache sd_mod crc_t10dif megaraid_sas [last unloaded: ipmi_devintf]
Sep 20 15:01:09 xx kernel: Pid: 10625, comm: modprobe Tainted: G        W   2.6.36-rc5-tip+ #6
Sep 20 15:01:09 xx kernel: Call Trace:
Sep 20 15:01:09 xx kernel: [<ffffffff810600df>] warn_slowpath_common+0x7f/0xc0
Sep 20 15:01:09 xx kernel: [<ffffffff810601d6>] warn_slowpath_fmt+0x46/0x50
Sep 20 15:01:09 xx kernel: [<ffffffff812ff60a>] driver_unregister+0x8a/0xa0
Sep 20 15:01:09 xx kernel: [<ffffffff812ae112>] pnp_unregister_driver+0x12/0x20
Sep 20 15:01:09 xx kernel: [<ffffffffa01d0327>] cleanup_ipmi_si+0x3c/0xa7 [ipmi_si]
Sep 20 15:01:09 xx kernel: [<ffffffff81099a60>] sys_delete_module+0x1a0/0x270
Sep 20 15:01:09 xx kernel: [<ffffffff814b7070>] ? do_page_fault+0x150/0x320
Sep 20 15:01:09 xx kernel: [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
Sep 20 15:01:09 xx kernel: ---[ end trace 0d1967161adcee0d ]---

We need to check if ipmi_pnp_driver is loaded before we try to unload it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 3822b4f..dcada64 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -305,6 +305,9 @@ static int num_force_kipmid;
 #ifdef CONFIG_PCI
 static int pci_registered;
 #endif
+#ifdef CONFIG_ACPI
+static int pnp_registered;
+#endif
 #ifdef CONFIG_PPC_OF
 static int of_registered;
 #endif
@@ -3359,6 +3362,7 @@ static __devinit int init_ipmi_si(void)
 
 #ifdef CONFIG_ACPI
 	pnp_register_driver(&ipmi_pnp_driver);
+	pnp_registered = 1;
 #endif
 
 #ifdef CONFIG_DMI
@@ -3526,7 +3530,8 @@ static __exit void cleanup_ipmi_si(void)
 		pci_unregister_driver(&ipmi_pci_driver);
 #endif
 #ifdef CONFIG_ACPI
-	pnp_unregister_driver(&ipmi_pnp_driver);
+	if (pnp_registered)
+		pnp_unregister_driver(&ipmi_pnp_driver);
 #endif
 
 #ifdef CONFIG_PPC_OF
