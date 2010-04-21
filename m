Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab0DUG2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 02:28:05 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:38062 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0DUG2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 02:28:00 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: core: workque: workqueue recursion when unplugging usb WCDMA modem on 2.6.32 kernel
Date: Tue, 20 Apr 2010 23:27:55 -0700
Message-ID: <ED2979D1CA1B3E4BB166ED9990088522765C8C@SJOAMSEXB01.AMERICAS.ROOT.PRI>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: core: workque: workqueue recursion when unplugging usb WCDMA modem on 2.6.32 kernel
Thread-Index: AcrhFjav2pPGHUInRoOrOebH7XjV9g==
From: "YuPing Luo" <YuPing.Luo@csr.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
X-OriginalArrivalTime: 21 Apr 2010 06:27:58.0246 (UTC) FILETIME=[C8C8F460:01CAE11B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I have one ARM11-based board, while upgrading the kernel from 27 to
32, got the workqueue recursion warning almost, and the console get
lost. While the issue can be resolved by applying the patch "[PATCH v2]
core: workqueue: return on workqueue recursion", and I am still
struggling to find the root cause. 
   Following are logs:(power on the modem, then gprs dial succ, unplug
it)
   
[14052.354076] usb 1-1: new high speed USB device using usbc and address
7
[14052.523956] usb 1-1: configuration #1 chosen from 1 choice
[14052.559707] option 1-1:1.1: GSM modem (1-port) converter detected
[14052.594464] usb 1-1: GSM modem (1-port) converter now attached to
ttyUSB0
[14052.624239] scsi5 : SCSI emulation for USB Mass Storage devices
[14052.692267] option 1-1:1.3: GSM modem (1-port) converter detected
[14052.754367] usb 1-1: GSM modem (1-port) converter now attached to
ttyUSB1

[14058.038563] scsi 5:0:0:0: Direct-Access     USBModem Disk
2.31 PQ: 0 ANSI: 2
[14058.072847] sd 5:0:0:0: Attached scsi generic sg0 type 0
[14058.093247] sd 5:0:0:0: [sda] Attached SCSI removable disk
[14074.570071] flush_cpu_workqueue:cwq->thread [events/0],current [pppd]
[14083.842280] usb 1-1: USB disconnect, address 7
[14083.844571] option: option_instat_callback: error -108
[14083.855977] option_close
[14083.872270] option1 ttyUSB0: GSM modem (1-port) converter now
disconnected from ttyUSB0
[14083.892532] option_disconnect
[14083.892691] option 1-1:1.1: device disconnected
[14083.900518] binder_deferred_func:proc task [rild],current [events/0]
[14083.908593] flush_cpu_workqueue:cwq->thread [events/0],current
[events/0]
[14083.912553] ------------[ cut here ]------------
[14083.917336] WARNING: at
/home/ypluo/ws/L32EVB/Main/kernel/kernel/workqueue.c:370
flush_cpu_workqueue+0xd0/0xf0()
[14083.927344] Modules linked in: usb_storage sd_mod scsi_wait_scan sg
scsi_mod dm9000 pvrmved sirfsoc_vpp sirfsoc_wdt sirfsoc_uspserial
g_ether g_file_storc
[14083.957425] Backtrace: 
[14083.959898] [<c008dd0c>] (dump_backtrace+0x0/0x118) from [<c008de58>]
(dump_stack+0x18/0x1c)
[14083.968312]  r7:00000000 r6:c00c43d8 r5:c036ec48 r4:00000172
[14083.973959] [<c008de40>] (dump_stack+0x0/0x1c) from [<c00acab0>]
(warn_slowpath_common+0x50/0x68)
[14083.982825] [<c00aca60>] (warn_slowpath_common+0x0/0x68) from
[<c00acae0>] (warn_slowpath_null+0x18/0x1c)
[14083.992354]  r7:00000000 r6:c782c000 r5:c7801920 r4:c782c000
[14083.997981] [<c00acac8>] (warn_slowpath_null+0x0/0x1c) from
[<c00c43d8>] (flush_cpu_workqueue+0xd0/0xf0)
[14084.007465] [<c00c4308>] (flush_cpu_workqueue+0x0/0xf0) from
[<c00c4534>] (flush_workqueue+0x14/0x18)
[14084.016655]  r5:c710d814 r4:c710d800
[14084.020197] [<c00c4520>] (flush_workqueue+0x0/0x18) from [<c00c4550>]
(flush_scheduled_work+0x18/0x20)
[14084.029535] [<c00c4538>] (flush_scheduled_work+0x0/0x20) from
[<c02251c8>] (tty_ldisc_release+0x20/0x70)
[14084.038980] [<c02251a8>] (tty_ldisc_release+0x0/0x70) from
[<c021eff8>] (tty_release_dev+0x33c/0x490)
[14084.048161]  r7:c67f3ec0 r6:c782c000 r5:c710d800 r4:00000000
[14084.053790] [<c021ecbc>] (tty_release_dev+0x0/0x490) from
[<c021f168>] (tty_release+0x1c/0x28)
[14084.062424] [<c021f14c>] (tty_release+0x0/0x28) from [<c01318dc>]
(__fput+0xe0/0x210)
[14084.070212]  r5:00000008 r4:c67f3ec0
[14084.073756] [<c01317fc>] (__fput+0x0/0x210) from [<c0131f4c>]
(fput+0x30/0x34)
[14084.080986] [<c0131f1c>] (fput+0x0/0x34) from [<c012e430>]
(filp_close+0x60/0x84)
[14084.088477] [<c012e3d0>] (filp_close+0x0/0x84) from [<c00aec64>]
(put_files_struct+0xdc/0xec)
[14084.096946]  r7:c78a6e40 r6:c78a6e48 r5:00000000 r4:00000001
[14084.102592] [<c00aeb88>] (put_files_struct+0x0/0xec) from
[<c0278ba8>] (binder_deferred_func+0x470/0x62c)
[14084.112140]  r9:c03cf1e0 r8:c7997200 r7:c7816360 r6:c7801920
r5:00000001
[14084.118613] r4:00000000
[14084.121241] [<c0278738>] (binder_deferred_func+0x0/0x62c) from
[<c00c56b0>] (worker_thread+0x158/0x2b8)
[14084.130648] [<c00c5558>] (worker_thread+0x0/0x2b8) from [<c00c946c>]
(kthread+0x88/0x90)
[14084.138708] [<c00c93e4>] (kthread+0x0/0x90) from [<c00b0008>]
(do_exit+0x0/0x700)
[14084.146157]  r6:00000000 r5:00000000 r4:00000000
[14084.150733] ---[ end trace 08510fb4b295aa33 ]---
[14084.524672] option_release
[14084.524846] option_close
[14084.555312] option1 ttyUSB1: GSM modem (1-port) converter now
disconnected from ttyUSB1
[14084.582033] option_disconnect
[14084.582186] option 1-1:1.3: device disconnected

# [14085.794313] flush_cpu_workqueue:cwq->thread [events/0],current
[pppd]
[14085.797985] option_release

   one user-mode daemon will get the unplug event, and close the two
usb-serial ports,then the daemon itself.
   if ignore the uevent, everyting is ok.
   
thanks.
Yuping


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
