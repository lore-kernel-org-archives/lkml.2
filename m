Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1HaHaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 03:30:11 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:57321 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1HaHaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 03:30:07 -0400
Date: Wed, 31 Aug 2011 08:30:04 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: BUG: unable to handle kernel paging request at 6b6b6bcb
 (v4l2_device_disconnect+0x11/0x30)
Message-ID: <20110831073003.GA11064@sucs.org>
References: <20110829204846.GA14699@sucs.org>
 <201108310020.10493.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108310020.10493.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 31, 2011 at 12:20:10AM +0200, Laurent Pinchart wrote:
> 
> Thanks for the report. Can you reproduce this on v3.0 ? What were the exact 
> steps that led to the crash ?

Yes I can reproduce on v3.0 (oops below). The steps that lead to it are:

1. Start GNOME.
2. Plug USB webcam into EeePC 900.
3. Start cheese.
4. Go to Edit | Preferences and change the device to the USB webcam.
5. Click Close.
6. Wait for video from the USB webcam to start playing in cheese.
7. Unplug USB webcam while video is still playing. This will usually
   cause cheese to display error messages on the console and then hang.
8. On the console press Ctrl-C to kill cheese.

With a kernel with debug options turned on, these steps will cause the
oops every time. I have not reproduced the oops on kernels with the
debugging features turned off though.

Oops under 3.0 (3.0 also outputs a lockdep warning for usb-snd before
this oops happens but this seems to be fixed in 3.1):
[  188.072956] BUG: unable to handle kernel paging request at 6b6b6bcb
[  188.073013] IP: [<b0358907>] dev_get_drvdata+0x17/0x20
[  188.073013] *pde = 00000000 
[  188.073013] Oops: 0000 [#1] DEBUG_PAGEALLOC
[  188.073013] 
[  188.073013] Pid: 2001, comm: cheese Not tainted 3.0.0 #486 ASUSTeK Computer INC. 900/900
[  188.073013] EIP: 0060:[<b0358907>] EFLAGS: 00210202 CPU: 0
[  188.073013] EIP is at dev_get_drvdata+0x17/0x20
[  188.073013] EAX: 6b6b6b6b EBX: e2054040 ECX: 00004081 EDX: e2054100
[  188.073013] ESI: e2054040 EDI: e2054040 EBP: e211bcac ESP: e211bcac
[  188.073013]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[  188.073013] Process cheese (pid: 2001, ti=e211a000 task=e2068000 task.ti=e211a000)
[  188.073013] Stack:
[  188.073013]  e211bcb8 b03e8bc1 de22e9e0 e211bccc b03e8bf1 de22e9e0 e2054040 e2054000
[  188.073013]  e211bce4 b03ed847 00200246 de22e9e0 e2054040 e1f38850 e211bcec b03ed9f5
[  188.073013]  e211bcfc b03e1afd e1d56dc0 b06d751c e211bd18 b0355b89 fffffffe e211bd1c
[  188.073013] Call Trace:
[  188.073013]  [<b03e8bc1>] v4l2_device_disconnect+0x11/0x30
[  188.073013]  [<b03e8bf1>] v4l2_device_unregister+0x11/0x50
[  188.073013]  [<b03ed847>] uvc_delete+0x37/0x110
[  188.073013]  [<b03ed9f5>] uvc_release+0x25/0x30
[  188.073013]  [<b03e1afd>] v4l2_device_release+0x9d/0xc0
[  188.073013]  [<b0355b89>] device_release+0x19/0x90
[  188.073013]  [<b03afa1c>] ? usb_hcd_unlink_urb+0x7c/0x90
[  188.073013]  [<b026aebc>] kobject_release+0x3c/0x90
[  188.073013]  [<b026ae80>] ? kobject_del+0x30/0x30
[  188.073013]  [<b026bf6c>] kref_put+0x2c/0x60
[  188.073013]  [<b026adad>] kobject_put+0x1d/0x50
[  188.073013]  [<b03b3dc5>] ? usb_autopm_put_interface+0x25/0x30
[  188.073013]  [<b03f12ed>] ? uvc_v4l2_release+0x5d/0xd0
[  188.073013]  [<b03558ff>] put_device+0xf/0x20
[  188.073013]  [<b03e1119>] v4l2_release+0x59/0x60
[  188.073013]  [<b019c69c>] fput+0xcc/0x210
[  188.073013]  [<b0198ff4>] filp_close+0x44/0x70
[  188.073013]  [<b012b160>] put_files_struct+0x130/0x160
[  188.073013]  [<b012b050>] ? put_files_struct+0x20/0x160
[  188.073013]  [<b012b1d0>] exit_files+0x40/0x50
[  188.073013]  [<b012b8fc>] do_exit+0x58c/0x670
[  188.073013]  [<b0136a92>] ? __dequeue_signal+0x12/0x120
[  188.073013]  [<b0136bcd>] ? dequeue_signal+0x2d/0x180
[  188.073013]  [<b012ba1c>] do_group_exit+0x3c/0xb0
[  188.073013]  [<b0156e2b>] ? trace_hardirqs_on+0xb/0x10
[  188.073013]  [<b01371cc>] get_signal_to_deliver+0x26c/0x450
[  188.073013]  [<b0102148>] do_signal+0x68/0xa80
[  188.073013]  [<b01233a0>] ? T.1021+0x30/0xc0
[  188.073013]  [<b0556353>] ? schedule+0x293/0x630
[  188.073013]  [<b015d29a>] ? sys_futex+0x6a/0x110
[  188.073013]  [<b0155522>] ? lockdep_sys_exit+0x22/0x80
[  188.073013]  [<b0102b98>] do_notify_resume+0x38/0x40
[  188.073013]  [<b0558f14>] work_notifysig+0x9/0x11
[  188.073013]  [<b0550000>] ? pci_scan_bridge+0x100/0x40d
[  188.073013] Code: e5 5d 83 f8 01 19 c0 f7 d0 83 e0 f0 c3 8d b4 26 00 00 00 00 55 85 c0 89 e5 75 09 31 c0 5d c3 90 8d 74 26 00 8b 40 04 85 c0 74 f0 <8b> 40 60 5d c3 8d 74 26 00 55 89 e5 53 89 c3 83 ec 04 8b 40 04 
[  188.073013] EIP: [<b0358907>] dev_get_drvdata+0x17/0x20 SS:ESP 0068:e211bcac
[  188.073013] CR2: 000000006b6b6bcb
[  188.142768] ---[ end trace 801a4e56b6bf7f74 ]---
[  188.142778] Fixing recursive fault but reboot is needed!

-- 
Sitsofe | http://sucs.org/~sits/
