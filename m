Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1L0TsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 14:48:17 -0500
Received: from mail2.charite.de ([141.42.206.200]:56776 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1L0TsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 14:48:15 -0500
Date: Tue, 27 Dec 2011 20:48:13 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: regression in 3.2-rc7 (kernel tried to execute NX-protected page)
Message-ID: <20111227194813.GR31759@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from dmesg after booting today's git checkout:

...
[    6.366980] hpwdt: New timer passed in is 30 seconds.
[    6.367040] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    6.367113] BUG: unable to handle kernel paging request at c00f0000
[    6.367232] IP: [<c00f0000>] 0xc00effff
[    6.367318] *pdpt = 00000000013b1001 *pde = 00000000013de067 *pte = 80000000000f0163 
[    6.367486] Oops: 0011 [#1] SMP 
[    6.367600] Modules linked in: hpwdt(+) bnx2(+) psmouse container thermal button processor
[    6.367927] 
[    6.367976] Pid: 669, comm: modprobe Not tainted 3.2.0-rc7+ #17 HP ProLiant DL360 G5
[    6.368002] EIP: 0060:[<c00f0000>] EFLAGS: 00010286 CPU: 1
[    6.368002] EIP is at 0xc00f0000
[    6.368002] EAX: 55524324 EBX: 00000000 ECX: 00000000 EDX: 00000000
[    6.368002] ESI: 00000000 EDI: 00000000 EBP: f0783dd8 ESP: f0783da8
[    6.368002]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    6.368002] Process modprobe (pid: 669, ti=f0782000 task=f009db20 task.ti=f0782000)
[    6.368002] Stack:
[    6.368002]  f8426020 00000060 ffff007b 00000286 c00ffee0 ffffffed f0783dd8 f0783dd8
[    6.368002]  c00f0000 00000001 00000000 c00f0000 f2cdbc00 f8426558 f8428100 c00f0000
[    6.368002]  f2c30564 ffffffff f8428030 000f0000 000f0000 f2cfcea0 c0100000 c00f0000
[    6.368002] Call Trace:
[    6.368002]  [<f8426020>] ? asminline_call+0x20/0x46 [hpwdt]
[    6.368002]  [<f8426558>] ? hpwdt_init_one+0x1a7/0x3c0 [hpwdt]
[    6.368002]  [<c115dcf6>] ? pci_device_probe+0x47/0x68
[    6.368002]  [<c11aa167>] ? driver_probe_device+0x4a/0x13a
[    6.368002]  [<c115dbc4>] ? pci_match_device+0xf/0x8a
[    6.368002]  [<c11aa2b9>] ? __driver_attach+0x62/0x64
[    6.368002]  [<c11aa257>] ? driver_probe_device+0x13a/0x13a
[    6.368002]  [<c11a9603>] ? bus_for_each_dev+0x3e/0x62
[    6.368002]  [<c115dc62>] ? pci_dev_put+0xd/0xd
[    6.368002]  [<c11a9f29>] ? driver_attach+0x19/0x1e
[    6.368002]  [<c11aa257>] ? driver_probe_device+0x13a/0x13a
[    6.368002]  [<c11a9cab>] ? bus_add_driver+0x17d/0x24d
[    6.368002]  [<c115dc62>] ? pci_dev_put+0xd/0xd
[    6.368002]  [<c11aa499>] ? driver_register+0x57/0xec
[    6.368002]  [<c115e0af>] ? __pci_register_driver+0x31/0x92
[    6.368002]  [<c1001027>] ? do_one_initcall+0x27/0x150
[    6.368002]  [<c101c97e>] ? set_memory_nx+0x57/0x5b
[    6.368002]  [<f842b000>] ? 0xf842afff
[    6.368002]  [<c1054426>] ? sys_init_module+0xdff/0x1a14
[    6.368002]  [<c126fa97>] ? sysenter_do_call+0x12/0x26
[    6.368002] Code: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff <90> 90 80 fc d8 75 0d e9 da 06 00 00 69 04 00 00 ad 04 00 00 9c 
[    6.368002] EIP: [<c00f0000>] 0xc00f0000 SS:ESP 0068:f0783da8
[    6.368002] CR2: 00000000c00f0000
[    6.368002] ---[ end trace 865af1d8b782ff50 ]---
[    6.487054] bnx2 0000:03:00.0: BAR 0: set to [mem 0xf8000000-0xf9ffffff 64bit] (PCI address [0xf8000000-0xf9ffffff])
...

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12203 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  ralf.hildebrandt@charite.de | http://www.charite.de
	    
