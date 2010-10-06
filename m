Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab0JFIzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 04:55:05 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:39910 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab0JFIzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 04:55:01 -0400
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2010 04:55:01 EDT
Date: Wed, 6 Oct 2010 10:50:52 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Linux kernel list <linux-kernel@vger.kernel.org>
Cc: nikola.ciprich@linuxbox.cz, cluster-devel@redhat.com,
        joel.becker@oracle.com
Subject: 2.6.36-rc6-git4 - dlm/lockfs - general protection fault
Message-ID: <20101006085052.GA3736@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4053610 records (last update: 20101006)
X-Envelope-From: ciprich@linuxbox.cz
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
while playing with clustered LVM and OCFS2, I noticed there is some problem either
with DLM or lockfs (just my guess). With older kernels (latest 2.6.32.x, 2.6.35.x) I
had similar but different problems (I'll report them separately), so I tried 2.6.36-rc6-git4
but when stopping services, sometimes I get GPF:

[ 2825.242446] general protection fault: 0000 [#1] PREEMPT SMP
[ 2825.242634] last sysfs file: /sys/kernel/dlm/2909AB2695824E64A2AE47317799EE25/control
[ 2825.242771] CPU 0
[ 2825.242807] Modules linked in: tun bitrev ocfs2 ocfs2_nodemanager ocfs2_stack_user ocfs2_stackglue dlm configfs drbd lru_cache cn ipv6 autofs4 ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables lockd sunrpc bridge stp llc ext3 jbd video backlight output sbs sbshc fan battery ac lp nvram kvm_intel kvm sg container e1000e processor thermal thermal_sys button parport_pc parport tpm_tis tpm tpm_bios shpchp i2c_i801 piix rng_core i3000_edac pci_hotplug iTCO_wdt pcspkr edac_core i2c_core pata_acpi ide_pci_generic ide_core ata_piix ata_generic sd_mod crc_t10dif raid1 dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ext4 jbd2 crc32 crc16 uhci_hcd ohci_hcd ehci_hcd ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
[ 2825.245812]
[ 2825.245812] Pid: 4924, comm: dlm_controld.pc Not tainted 2.6.36lb.00_01_PRE04 #1 PDSMi-LN4+/PDSMi-LN4
[ 2825.245812] RIP: 0010:[<ffffffffa04fa0c3>]  [<ffffffffa04fa0c3>] unlink_group+0x13/0x50 [configfs]
[ 2825.245812] RSP: 0018:ffff880147ae1dd8  EFLAGS: 00010282
[ 2825.245812] RAX: 9c59a2546b3185a1 RBX: 0000000000000008 RCX: 0000000000000000
[ 2825.245812] RDX: ffffffffa051f570 RSI: ffff880144945f00 RDI: ffff88010100000a
[ 2825.245812] RBP: ffff880147ae1de8 R08: 2222222222222222 R09: 2222222222222222
[ 2825.245812] R10: 0000000000000000 R11: 2222222222222222 R12: ffff88010100000a
[ 2825.245812] R13: ffff88015149aaa8 R14: ffff880144945f00 R15: ffff88014f0b1280
[ 2825.245812] FS:  00007fac4fbe9730(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
[ 2825.245812] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2825.245812] CR2: 00007fdf580adb61 CR3: 0000000147e71000 CR4: 00000000000006f0
[ 2825.245812] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2825.245812] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2825.245812] Process dlm_controld.pc (pid: 4924, threadinfo ffff880147ae0000, task ffff8801518d2e60)
[ 2825.245812] Stack:
[ 2825.245812]  0000000000000008 ffff880144945f00 ffff880147ae1e08 ffffffffa04fa0d5
[ 2825.245812] <0> 0000000000000000 ffffffffa051f550 ffff880147ae1e68 ffffffffa04fb994
[ 2825.245812] <0> ffffffffa051f4e0 ffffffffa05200a0 ffffffffa05200a0 ffff88014d7d1950
[ 2825.245812] Call Trace:
[ 2825.245812]  [<ffffffffa04fa0d5>] unlink_group+0x25/0x50 [configfs]
[ 2825.245812]  [<ffffffffa04fb994>] configfs_rmdir+0x244/0x2e0 [configfs]
[ 2825.245812]  [<ffffffff8111f890>] vfs_rmdir+0xb0/0x100
[ 2825.245812]  [<ffffffff81121879>] do_rmdir+0xf9/0x110
[ 2825.245812]  [<ffffffff81111b28>] ? filp_close+0x58/0x90
[ 2825.245812]  [<ffffffff811218d1>] sys_rmdir+0x11/0x20
[ 2825.245812]  [<ffffffff8100242b>] system_call_fastpath+0x16/0x1b
[ 2825.245812] Code: 00 00 48 83 c4 08 5b c9 c3 0f 1f 80 00 00 00 00 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 54 49 89 fc 53 48 8b 47 68 48 85 c0 74 24 <48> 8b 38 48 85 ff 74 1c bb 08 00 00 00 e8 db ff ff ff 49 8b 44
[ 2825.245812] RIP  [<ffffffffa04fa0c3>] unlink_group+0x13/0x50 [configfs]
[ 2825.245812]  RSP <ffff880147ae1dd8>

it's x86_64 system.

If somebody could spot problem just on sight, it would be great, otherwise I can
try to find exact steps to reproduce..
thanks a lot in advance!
BR
nik


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
