Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2HRMld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 08:41:33 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:56853 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2HRMl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 08:41:26 -0400
Date: Sat, 18 Aug 2012 14:40:39 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/7] HID: picoLCD updates
Message-ID: <20120818144039.0356cc7c@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1208161846240.28475@pobox.suse.cz>
References: <20120730213656.0a9f6d30@neptune.home>
	<alpine.LNX.2.00.1208151016221.7026@pobox.suse.cz>
	<20120815114236.0f7db40e@neptune.home>
	<alpine.LNX.2.00.1208151409500.7026@pobox.suse.cz>
	<20120815171635.2564a4a8@neptune.home>
	<alpine.LNX.2.00.1208152329580.7026@pobox.suse.cz>
	<20120816183021.68c37f37@neptune.home>
	<alpine.LNX.2.00.1208161846240.28475@pobox.suse.cz>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/r=P3l.tW+ncAgVLY/nCl4qZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/r=P3l.tW+ncAgVLY/nCl4qZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Jiri,

[CCing Alan Stern]

On Thu, 16 August 2012 Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 16 Aug 2012, Bruno Pr=C3=A9mont wrote:
>=20
> > > I don't really understand this explanation. Once usb_kill_urb() retur=
ns,=20
> > > the URB should be available for future use (and therefore all queues=
=20
> > > completely drained).
> >=20
> > I won't have time today to check, though my guess is that on each
> > echo $usb-id > bind; echo $usb-id > unbind
> > under /sys/bus/hid/drivers/hid-picolcd/ the USB urb queue fills a bit d=
oes
> > not get cleared.
> >=20
> > Is usb_kill_urb() called when unbinding just the specific hid driver?=20
>=20
> Yup, through hid_hw_stop() -> usbhid_stop().
>=20
> > If so my short timing between bind/unbind must be triggering something=
=20
> > else...
> >=20
> > Otherwise I'm missing something as at first time I got no "output queue=
 full"
> > messages, but as I repeated the bind/unbind sequences the prints per bi=
nd/unbind
> > iteration increased in number.
> >=20
> > Anyhow, on Friday evening/week-end I will continue digging and report b=
ack with my
> > findings.

Huh, after changing some of the hid-picolcd data in order to have less racy
coupling between hid and framebuffer I'm now dying way too often in _mmx_me=
mcpy
and most of the time I don't get a (complete) trace...

The only full trace I got was:
[ 3857.426136] BUG: unable to handle kernel paging request at dbdf9000
[ 3857.432555] IP: [<c11e2be7>] _mmx_memcpy+0x27/0x16c
[ 3857.435906] *pde =3D 1bebb063 *pte =3D 1bdf9161=20
[ 3857.435906] Oops: 0003 [#1]=20
[ 3857.435906] Modules linked in: hid_picolcd fb_sys_fops sysimgblt sysfill=
rect syscopyarea drm_kms_helper nfs3 nfs_acl nfs lockd sunrpc
[ 3857.435906] Pid: 1935, comm: bash Not tainted 3.6.0-rc1-jupiter-00363-g0=
e8ccbc #1 NVIDIA Corporation. nFORCE-MCP/MS-6373
[ 3857.435906] EIP: 0060:[<c11e2be7>] EFLAGS: 00010013 CPU: 0
[ 3857.435906] EIP is at _mmx_memcpy+0x27/0x16c
[ 3857.435906] EAX: dd40a000 EBX: dd6ea010 ECX: 035af77b EDX: dbdf4230
[ 3857.435906] ESI: dbe0d1b0 EDI: dbdf9000 EBP: dd40bea8 ESP: dd40be8c
[ 3857.435906]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 3857.435906] CR0: 8005003b CR2: dbdf9000 CR3: 1d7ee000 CR4: 000007d0
[ 3857.435906] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 3857.435906] DR6: ffff0ff0 DR7: 00000400
[ 3857.435906] Process bash (pid: 1935, ti=3Ddd40a000 task=3Ddcdb6120 task.=
ti=3Ddbce2000)
[ 3857.435906] Stack:
[ 3857.435906]  0d6d6d6f dd6eb49c dd40beb8 dbde0080 dd6ea010 dbde0080 dbd31=
010 dd40bed0
[ 3857.435906]  c133b364 00000000 00000000 ddfaa0e0 dbd31010 dbdf4230 dd6ea=
010 00000046
[ 3857.435906]  dbd31010 dd40bef0 c133bea0 00000000 dbd0c3f0 00000000 dbd0c=
3f0 00000000
[ 3857.435906] Call Trace:
[ 3857.435906]  [<c133b364>] hid_submit_out+0xa4/0x130
[ 3857.435906]  [<c133bea0>] hid_irq_out+0xa0/0x100
[ 3857.435906]  [<c12e425e>] usb_hcd_giveback_urb+0x4e/0x90
[ 3857.435906]  [<c12f9bd2>] finish_urb+0xb2/0xf0
[ 3857.435906]  [<c12fa67d>] takeback_td+0x3d/0x100
[ 3857.435906]  [<c12faccf>] dl_done_list+0x14f/0x180
[ 3857.435906]  [<c12fc351>] ohci_irq+0x191/0x300
[ 3857.435906]  [<c1077790>] ? unmask_irq+0x20/0x20
[ 3857.435906]  [<c12e3ace>] usb_hcd_irq+0x1e/0x40
[ 3857.435906]  [<c107549d>] handle_irq_event_percpu+0x6d/0x1c0
[ 3857.435906]  [<c1077790>] ? unmask_irq+0x20/0x20
[ 3857.435906]  [<c1075618>] handle_irq_event+0x28/0x40
[ 3857.435906]  [<c107781a>] handle_fasteoi_irq+0x8a/0xe0
[ 3857.435906]  <IRQ>=20
[ 3857.435906]  [<c1003e0a>] ? do_IRQ+0x3a/0xb0
[ 3857.435906]  [<c140c870>] ? common_interrupt+0x30/0x38
[ 3857.435906]  [<c1035143>] ? __do_softirq+0x53/0x1c0
[ 3857.435906]  [<c10350f0>] ? local_bh_enable_ip+0x80/0x80
[ 3857.435906]  <IRQ>=20
[ 3857.435906]  [<c103544e>] ? irq_exit+0x3e/0xa0
[ 3857.435906]  [<c101dfde>] ? smp_apic_timer_interrupt+0x6e/0x80
[ 3857.435906]  [<c140bee1>] ? apic_timer_interrupt+0x31/0x38
[ 3857.435906]  [<c102fdba>] ? vprintk_emit+0x34a/0x390
[ 3857.435906]  [<c1409f58>] ? printk+0x38/0x3a
[ 3857.435906]  [<de94b021>] ? picolcd_init_framebuffer+0x261/0x350 [hid_pi=
colcd]
[ 3857.435906]  [<de949bd1>] ? picolcd_probe+0x3d1/0x5a0 [hid_picolcd]
[ 3857.435906]  [<c13321f7>] ? hid_device_probe+0x67/0xf0
[ 3857.435906]  [<c128ac17>] ? driver_sysfs_add+0x57/0x80
[ 3857.435906]  [<c128af1d>] ? driver_probe_device+0xbd/0x1d0
[ 3857.435906]  [<c1331aab>] ? hid_match_device+0x7b/0x90
[ 3857.435906]  [<c1289e65>] ? driver_bind+0x75/0xd0
[ 3857.435906]  [<c1289df0>] ? driver_unbind+0x90/0x90
[ 3857.435906]  [<c1289537>] ? drv_attr_store+0x27/0x30
[ 3857.435906]  [<c111a59c>] ? sysfs_write_file+0xac/0xf0
[ 3857.435906]  [<c10cca0c>] ? vfs_write+0x9c/0x130
[ 3857.435906]  [<c10da2ef>] ? sys_dup3+0x11f/0x160
[ 3857.435906]  [<c111a4f0>] ? sysfs_poll+0x90/0x90
[ 3857.435906]  [<c10ccc7d>] ? sys_write+0x3d/0x70
[ 3857.435906]  [<c140c357>] ? sysenter_do_call+0x12/0x26
[ 3857.435906] Code: 90 90 90 90 55 89 e5 57 56 89 d6 53 83 ec 10 89 45 f0 =
89 4d e4 89 e0 25 00 e0 ff ff f7 40 14 00 ff ff 07 74 17 c1 e9 02 8b 7d f0 =
<f3> a5 8b 4d e4 83 e1 03 74 02 f3 a4 e9 27 01 00 00 8b 45 1
[ 3857.435906] EIP: [<c11e2be7>] _mmx_memcpy+0x27/0x16c SS:ESP 0068:dd40be8c
[ 3857.435906] CR2: 00000000dbdf9000
[ 3857.435906] ---[ end trace 10ae520e65e3b763 ]---
[ 3857.435906] Kernel panic - not syncing: Fatal exception in interrupt

It happens around the time of calling
  device_create_file(dev, &dev_attr_fb_update_rate);
that is, after picolcd_fb_reset(data, 1) has returned but before
calling fb_deferred_io_init(info); according to printk() I put
around the various calls in picolcd_init_framebuffer().

The other case I got part of a trace it was again in _mmx_memcpy()
but the trace output stopped in the middle of register dumping.


The full trace happened after the following sequence:
- system boot
- hotplug of picolcd (triggering modprobe hid-picolcd)
- cd /sys/bus/hid/drivers/hid-picolcd/
- echo 0003:04D8:C002.0003 > unbind
- wait some time
- echo 0003:04D8:C002.0003 > bind

Any idea what it could be? It might be during processing of first
reports send in order to clear the picolcd display.




As (un)binding in hid-picolcd crashes I tried doing so a level above,
at usbhid driver on usb bus which resulted in the following:
- system boot
- hotplug of picolcd (triggering modprobe hid-picolcd)
- cd /sys/bus/usb/drivers/usbhid/
- echo 2-1:1.0 > unbind
- wait some time
- echo 2-1:1.0 > bind
- wait some time
- echo 2-1:1.0 > unbind
produced the following trace:
[ 1418.387466] BUG: unable to handle kernel NULL pointer dereference at 000=
00030
[ 1418.390013] IP: [<c1339c40>] hid_submit_ctrl+0x80/0x2a0
[ 1418.390013] *pde =3D 00000000=20
[ 1418.390013] Oops: 0002 [#1]=20
[ 1418.390013] Modules linked in: hid_picolcd fb_sys_fops sysimgblt sysfill=
rect syscopyarea drm_kms_helper nfs3 nfs_acl nfs lockd sunrpc
[ 1418.390013] Pid: 1994, comm: kworker/0:0 Not tainted 3.6.0-rc1-jupiter-0=
0363-g0e8ccbc #1 NVIDIA Corporation. nFORCE-MCP/MS-6373
[ 1418.390013] EIP: 0060:[<c1339c40>] EFLAGS: 00010086 CPU: 0
[ 1418.390013] EIP is at hid_submit_ctrl+0x80/0x2a0
[ 1418.390013] EAX: 80000200 EBX: dc2d0000 ECX: dcfe2020 EDX: 00000000
[ 1418.390013] ESI: 00000040 EDI: dc1f8f00 EBP: dd743e2c ESP: dd743df4
[ 1418.390013]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 1418.390013] CR0: 8005003b CR2: 00000030 CR3: 1cd42000 CR4: 000007d0
[ 1418.390013] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1418.390013] DR6: ffff0ff0 DR7: 00000400
[ 1418.390013] Process kworker/0:0 (pid: 1994, ti=3Ddd742000 task=3Ddcdd0d4=
0 task.ti=3Ddd742000)
[ 1418.390013] Stack:
[ 1418.390013]  0000003e dc2f9020 dcf64c7c 00000005 00000002 dd743e1c 00000=
002 dc1f8f00
[ 1418.390013]  00000040 dcfe2020 dc2cb4d0 dc2d0000 00000000 dcfe2020 dd743=
e44 c1339ef6
[ 1418.390013]  00000008 dc2d0000 dc2cb4d0 dcfe2020 dd743e74 c133bbeb 00000=
023 000000ff
[ 1418.390013] Call Trace:
[ 1418.390013]  [<c1339ef6>] usbhid_restart_ctrl_queue+0x96/0xe0
[ 1418.390013]  [<c133bbeb>] __usbhid_submit_report+0x29b/0x320
[ 1418.390013]  [<c1330200>] ? hid_parser_local+0x260/0x2d0
[ 1418.390013]  [<c133bd2b>] usbhid_submit_report+0x1b/0x30
[ 1418.390013]  [<de996cb9>] picolcd_fb_deferred_io+0x3b9/0x4c0 [hid_picolc=
d]
[ 1418.390013]  [<c120e118>] fb_deferred_io_work+0x78/0xc0
[ 1418.390013]  [<c1045e3f>] process_one_work+0x1ff/0x380
[ 1418.390013]  [<c120e0a0>] ? fb_deferred_io_fault+0xa0/0xa0
[ 1418.390013]  [<c10467f7>] worker_thread+0x237/0x360
[ 1418.390013]  [<c10465c0>] ? manage_workers.clone.25+0x250/0x250
[ 1418.390013]  [<c10465c0>] ? manage_workers.clone.25+0x250/0x250
[ 1418.390013]  [<c104a30d>] kthread+0x6d/0x80
[ 1418.390013]  [<c104a2a0>] ? kthread_freezable_should_stop+0x70/0x70
[ 1418.390013]  [<c140c87e>] kernel_thread_helper+0x6/0xd
[ 1418.390013] Code: 01 89 45 e8 0f 85 91 00 00 00 8b 4d ec 8b 53 1c 8b 7d =
e4 8b 75 e8 8b 81 68 0c 00 00 8b 00 8b 40 9c c1 e0 08 0d 00 00 00 80 85 ff =
<89> 42 30 8b 43 1c 89 70 54 0f 84 19 01 00 00 81 fe ff 01 0
[ 1418.390013] EIP: [<c1339c40>] hid_submit_ctrl+0x80/0x2a0 SS:ESP 0068:dd7=
43df4
[ 1418.390013] CR2: 0000000000000030
[ 1418.390013] ---[ end trace 089e20ed16261a0a ]---
pretty early during unbind process, e.g. way before picolcd even started to
dispose framebuffer.

Either I'm doing something really wrong or I'm the first one to produce
lots of outbound reports thus exploring corner-cases...

PS: attached is a diff between the hid-picolcd from this patch series to wh=
at
I'm testing right now.

Thanks,
Bruno

--MP_/r=P3l.tW+ncAgVLY/nCl4qZ
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=pico.diff

 drivers/hid/hid-picolcd.h      |   19 +++-
 drivers/hid/hid-picolcd_core.c |    6 +
 drivers/hid/hid-picolcd_fb.c   |  222 +++++++++++++++++++++-------------------
 3 files changed, 138 insertions(+), 109 deletions(-)

diff --git a/drivers/hid/hid-picolcd.h b/drivers/hid/hid-picolcd.h
index 9200be1..dc4c795 100644
--- a/drivers/hid/hid-picolcd.h
+++ b/drivers/hid/hid-picolcd.h
@@ -90,11 +90,6 @@ struct picolcd_data {
 
 #ifdef CONFIG_HID_PICOLCD_FB
 	/* Framebuffer stuff */
-	u8 fb_update_rate;
-	u8 fb_bpp;
-	u8 fb_force;
-	u8 *fb_vbitmap;		/* local copy of what was sent to PicoLCD */
-	u8 *fb_bitmap;		/* framebuffer */
 	struct fb_info *fb_info;
 #endif /* CONFIG_HID_PICOLCD_FB */
 #ifdef CONFIG_HID_PICOLCD_LCD
@@ -119,9 +114,21 @@ struct picolcd_data {
 	int status;
 #define PICOLCD_BOOTLOADER 1
 #define PICOLCD_FAILED 2
-#define PICOLCD_READY_FB 4
 };
 
+#ifdef CONFIG_HID_PICOLCD_FB
+struct picolcd_fb_data {
+	/* Framebuffer stuff */
+	spinlock_t lock;
+	struct picolcd_data *picolcd;
+	u8 update_rate;
+	u8 bpp;
+	u8 force;
+	u8 ready;
+	u8 *vbitmap;		/* local copy of what was sent to PicoLCD */
+	u8 *bitmap;		/* framebuffer */
+};
+#endif /* CONFIG_HID_PICOLCD_FB */
 
 /* Find a given report */
 #define picolcd_in_report(id, dev) picolcd_report(id, dev, HID_INPUT_REPORT)
diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index e08ffd2..153acc2 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -539,6 +539,7 @@ static int picolcd_probe(struct hid_device *hdev,
 	int error = -ENOMEM;
 
 	dbg_hid(PICOLCD_NAME " hardware probe...\n");
+	printk(KERN_INFO "hid-picolcd: probe() 1/4\n");
 
 	/*
 	 * Let's allocate the picolcd data structure, set some reasonable
@@ -559,6 +560,7 @@ static int picolcd_probe(struct hid_device *hdev,
 		data->status |= PICOLCD_BOOTLOADER;
 	hid_set_drvdata(hdev, data);
 
+	printk(KERN_INFO "hid-picolcd: probe(%p) 2/4\n", data);
 	/* Parse the device reports and start it up */
 	error = hid_parse(hdev);
 	if (error) {
@@ -578,6 +580,7 @@ static int picolcd_probe(struct hid_device *hdev,
 		goto err_cleanup_hid_hw;
 	}
 
+	printk(KERN_INFO "hid-picolcd: probe(%p) 3/4\n", data);
 	error = device_create_file(&hdev->dev, &dev_attr_operation_mode_delay);
 	if (error) {
 		hid_err(hdev, "failed to create sysfs attributes\n");
@@ -597,6 +600,7 @@ static int picolcd_probe(struct hid_device *hdev,
 	if (error)
 		goto err_cleanup_sysfs2;
 
+	printk(KERN_INFO "hid-picolcd: probe(%p, [fb=%p]) 4/4\n", data, data->fb_info);
 	dbg_hid(PICOLCD_NAME " activated and initialized\n");
 	return 0;
 
@@ -621,6 +625,7 @@ static void picolcd_remove(struct hid_device *hdev)
 	struct picolcd_data *data = hid_get_drvdata(hdev);
 	unsigned long flags;
 
+	printk(KERN_INFO "hid-picolcd: remove(%p [fb=%p]) ...\n", data, data->fb_info);
 	dbg_hid(PICOLCD_NAME " hardware remove...\n");
 	spin_lock_irqsave(&data->lock, flags);
 	data->status |= PICOLCD_FAILED;
@@ -649,6 +654,7 @@ static void picolcd_remove(struct hid_device *hdev)
 	picolcd_exit_cir(data);
 	picolcd_exit_keys(data);
 
+	printk(KERN_INFO "hid-picolcd: remove(%p [fb=%p]) done\n", data, data->fb_info);
 	mutex_destroy(&data->mutex);
 	/* Finally, clean up the picolcd data itself */
 	kfree(data);
diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
index 4d8e22c..86b7a24 100644
--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -98,16 +98,19 @@ static const struct fb_var_screeninfo picolcdfb_var = {
 };
 
 /* Send a given tile to PicoLCD */
-static int picolcd_fb_send_tile(struct hid_device *hdev, int chip, int tile)
+static int picolcd_fb_send_tile(struct picolcd_data *data, u8 *vbitmap,
+		int chip, int tile)
 {
-	struct picolcd_data *data = hid_get_drvdata(hdev);
-	struct hid_report *report1 = picolcd_out_report(REPORT_LCD_CMD_DATA, hdev);
-	struct hid_report *report2 = picolcd_out_report(REPORT_LCD_DATA, hdev);
+	struct hid_report *report1, *report2;
 	unsigned long flags;
 	u8 *tdata;
 	int i;
 
-	if (!report1 || report1->maxfield != 1 || !report2 || report2->maxfield != 1)
+	report1 = picolcd_out_report(REPORT_LCD_CMD_DATA, data->hdev);
+	if (!report1 || report1->maxfield != 1)
+		return -ENODEV;
+	report2 = picolcd_out_report(REPORT_LCD_DATA, data->hdev);
+	if (!report2 || report2->maxfield != 1)
 		return -ENODEV;
 
 	spin_lock_irqsave(&data->lock, flags);
@@ -128,7 +131,7 @@ static int picolcd_fb_send_tile(struct hid_device *hdev, int chip, int tile)
 	hid_set_field(report2->field[0],  2, 0x00);
 	hid_set_field(report2->field[0],  3,   32);
 
-	tdata = data->fb_vbitmap + (tile * 4 + chip) * 64;
+	tdata = vbitmap + (tile * 4 + chip) * 64;
 	for (i = 0; i < 64; i++)
 		if (i < 32)
 			hid_set_field(report1->field[0], 11 + i, tdata[i]);
@@ -189,6 +192,7 @@ void picolcd_fb_refresh(struct picolcd_data *data)
 int picolcd_fb_reset(struct picolcd_data *data, int clear)
 {
 	struct hid_report *report = picolcd_out_report(REPORT_LCD_CMD, data->hdev);
+	struct picolcd_fb_data *fbdata = data->fb_info->par;
 	int i, j;
 	unsigned long flags;
 	static const u8 mapcmd[8] = { 0x00, 0x02, 0x00, 0x64, 0x3f, 0x00, 0x64, 0xc0 };
@@ -207,20 +211,19 @@ int picolcd_fb_reset(struct picolcd_data *data, int clear)
 				hid_set_field(report->field[0], j, 0);
 		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
 	}
-
-	data->status |= PICOLCD_READY_FB;
 	spin_unlock_irqrestore(&data->lock, flags);
 
-	if (data->fb_bitmap) {
-		if (clear) {
-			memset(data->fb_vbitmap, 0, PICOLCDFB_SIZE);
-			memset(data->fb_bitmap, 0, PICOLCDFB_SIZE*data->fb_bpp);
-		}
-		data->fb_force = 1;
+	if (clear) {
+		memset(fbdata->vbitmap, 0, PICOLCDFB_SIZE);
+		memset(fbdata->bitmap, 0, PICOLCDFB_SIZE*fbdata->bpp);
 	}
+	fbdata->force = 1;
 
 	/* schedule first output of framebuffer */
-	picolcd_fb_refresh(data);
+	if (fbdata->ready)
+		schedule_delayed_work(&data->fb_info->deferred_work, 0);
+	else
+		fbdata->ready = 1;
 
 	return 0;
 }
@@ -230,20 +233,15 @@ static void picolcd_fb_update(struct fb_info *info)
 {
 	int chip, tile, n;
 	unsigned long flags;
+	struct picolcd_fb_data *fbdata = info->par;
 	struct picolcd_data *data;
 
 	mutex_lock(&info->lock);
-	data = info->par;
-	if (!data)
-		goto out;
 
-	spin_lock_irqsave(&data->lock, flags);
-	if (!(data->status & PICOLCD_READY_FB)) {
-		spin_unlock_irqrestore(&data->lock, flags);
-		picolcd_fb_reset(data, 0);
-	} else {
-		spin_unlock_irqrestore(&data->lock, flags);
-	}
+	spin_lock_irqsave(&fbdata->lock, flags);
+	if (!fbdata->ready && fbdata->picolcd)
+		picolcd_fb_reset(fbdata->picolcd, 0);
+	spin_unlock_irqrestore(&fbdata->lock, flags);
 
 	/*
 	 * Translate the framebuffer into the format needed by the PicoLCD.
@@ -254,32 +252,38 @@ static void picolcd_fb_update(struct fb_info *info)
 	 */
 	n = 0;
 	for (chip = 0; chip < 4; chip++)
-		for (tile = 0; tile < 8; tile++)
-			if (picolcd_fb_update_tile(data->fb_vbitmap,
-					data->fb_bitmap, data->fb_bpp, chip, tile) ||
-				data->fb_force) {
-				n += 2;
-				if (n >= HID_OUTPUT_FIFO_SIZE / 2) {
-					mutex_unlock(&info->lock);
-					usbhid_wait_io(data->hdev);
-					mutex_lock(&info->lock);
-					data = info->par;
-					if (!data)
-						goto out;
-					spin_lock_irqsave(&data->lock, flags);
-					if (data->status & PICOLCD_FAILED) {
-						spin_unlock_irqrestore(&data->lock, flags);
-						goto out;
-					}
-					spin_unlock_irqrestore(&data->lock, flags);
-					n = 0;
-				}
-				picolcd_fb_send_tile(data->hdev, chip, tile);
+		for (tile = 0; tile < 8; tile++) {
+			if (!fbdata->force && !picolcd_fb_update_tile(
+					fbdata->vbitmap, fbdata->bitmap,
+					fbdata->bpp, chip, tile))
+				continue;
+			n += 2;
+			if (n >= HID_OUTPUT_FIFO_SIZE / 2) {
+				spin_lock_irqsave(&fbdata->lock, flags);
+				data = fbdata->picolcd;
+				spin_unlock_irqrestore(&fbdata->lock, flags);
+				mutex_unlock(&info->lock);
+				if (!data)
+					return;
+				usbhid_wait_io(data->hdev);
+				mutex_lock(&info->lock);
+				n = 0;
 			}
-	data->fb_force = false;
+			spin_lock_irqsave(&fbdata->lock, flags);
+			data = fbdata->picolcd;
+			spin_unlock_irqrestore(&fbdata->lock, flags);
+			if (!data)
+				goto out;
+			picolcd_fb_send_tile(data, fbdata->vbitmap, chip, tile);
+		}
+	fbdata->force = false;
 	if (n) {
+		spin_lock_irqsave(&fbdata->lock, flags);
+		data = fbdata->picolcd;
+		spin_unlock_irqrestore(&fbdata->lock, flags);
 		mutex_unlock(&info->lock);
-		usbhid_wait_io(data->hdev);
+		if (data)
+			usbhid_wait_io(data->hdev);
 		return;
 	}
 out:
@@ -336,20 +340,24 @@ static ssize_t picolcd_fb_write(struct fb_info *info, const char __user *buf,
 
 static int picolcd_fb_blank(int blank, struct fb_info *info)
 {
-	if (!info->par)
-		return -ENODEV;
 	/* We let fb notification do this for us via lcd/backlight device */
 	return 0;
 }
 
 static void picolcd_fb_destroy(struct fb_info *info)
 {
+	struct picolcd_fb_data *fbdata = info->par;
+
+	printk(KERN_INFO "hid-picolcd: fb_destroy(%p [fb=%p]) ...\n", fbdata->picolcd, info);
 	/* make sure no work is deferred */
 	fb_deferred_io_cleanup(info);
 
+	/* No thridparty should ever unregister our framebuffer! */
+	WARN_ON(fbdata->picolcd != NULL);
+
 	vfree((u8 *)info->fix.smem_start);
 	framebuffer_release(info);
-	printk(KERN_DEBUG "picolcd_fb_destroy(%p)\n", info);
+	printk(KERN_INFO "hid-picolcd: fb_destroy(-- [fb=%p]) done\n", info);
 }
 
 static int picolcd_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
@@ -376,17 +384,15 @@ static int picolcd_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *i
 
 static int picolcd_set_par(struct fb_info *info)
 {
-	struct picolcd_data *data = info->par;
+	struct picolcd_fb_data *fbdata = info->par;
 	u8 *tmp_fb, *o_fb;
-	if (!data)
-		return -ENODEV;
-	if (info->var.bits_per_pixel == data->fb_bpp)
+	if (info->var.bits_per_pixel == fbdata->bpp)
 		return 0;
 	/* switch between 1/8 bit depths */
 	if (info->var.bits_per_pixel != 1 && info->var.bits_per_pixel != 8)
 		return -EINVAL;
 
-	o_fb   = data->fb_bitmap;
+	o_fb   = fbdata->bitmap;
 	tmp_fb = kmalloc(PICOLCDFB_SIZE*info->var.bits_per_pixel, GFP_KERNEL);
 	if (!tmp_fb)
 		return -ENOMEM;
@@ -415,7 +421,7 @@ static int picolcd_set_par(struct fb_info *info)
 	}
 
 	kfree(tmp_fb);
-	data->fb_bpp      = info->var.bits_per_pixel;
+	fbdata->bpp = info->var.bits_per_pixel;
 	return 0;
 }
 
@@ -453,7 +459,8 @@ static ssize_t picolcd_fb_update_rate_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct picolcd_data *data = dev_get_drvdata(dev);
-	unsigned i, fb_update_rate = data->fb_update_rate;
+	struct picolcd_fb_data *fbdata = data->fb_info->par;
+	unsigned i, fb_update_rate = fbdata->update_rate;
 	size_t ret = 0;
 
 	for (i = 1; i <= PICOLCDFB_UPDATE_RATE_LIMIT; i++)
@@ -472,6 +479,7 @@ static ssize_t picolcd_fb_update_rate_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct picolcd_data *data = dev_get_drvdata(dev);
+	struct picolcd_fb_data *fbdata = data->fb_info->par;
 	int i;
 	unsigned u;
 
@@ -487,8 +495,8 @@ static ssize_t picolcd_fb_update_rate_store(struct device *dev,
 	else if (u == 0)
 		u = PICOLCDFB_UPDATE_RATE_DEFAULT;
 
-	data->fb_update_rate = u;
-	data->fb_info->fbdefio->delay = HZ / data->fb_update_rate;
+	fbdata->update_rate = u;
+	data->fb_info->fbdefio->delay = HZ / fbdata->update_rate;
 	return count;
 }
 
@@ -500,30 +508,18 @@ int picolcd_init_framebuffer(struct picolcd_data *data)
 {
 	struct device *dev = &data->hdev->dev;
 	struct fb_info *info = NULL;
+	struct picolcd_fb_data *fbdata = NULL;
 	int i, error = -ENOMEM;
-	u8 *fb_vbitmap = NULL;
-	u8 *fb_bitmap  = NULL;
 	u32 *palette;
 
-	fb_bitmap = vmalloc(PICOLCDFB_SIZE*8);
-	if (fb_bitmap == NULL) {
-		dev_err(dev, "can't get a free page for framebuffer\n");
-		goto err_nomem;
-	}
-
-	fb_vbitmap = kmalloc(PICOLCDFB_SIZE, GFP_KERNEL);
-	if (fb_vbitmap == NULL) {
-		dev_err(dev, "can't alloc vbitmap image buffer\n");
-		goto err_nomem;
-	}
-
-	data->fb_update_rate = PICOLCDFB_UPDATE_RATE_DEFAULT;
 	/* The extra memory is:
 	 * - 256*u32 for pseudo_palette
 	 * - struct fb_deferred_io
 	 */
 	info = framebuffer_alloc(256 * sizeof(u32) +
-			sizeof(struct fb_deferred_io), dev);
+			sizeof(struct fb_deferred_io) +
+			sizeof(struct picolcd_fb_data) +
+			PICOLCDFB_SIZE, dev);
 	if (info == NULL) {
 		dev_err(dev, "failed to allocate a framebuffer\n");
 		goto err_nomem;
@@ -531,74 +527,94 @@ int picolcd_init_framebuffer(struct picolcd_data *data)
 
 	info->fbdefio = info->par;
 	*info->fbdefio = picolcd_fb_defio;
-	palette  = info->par + sizeof(struct fb_deferred_io);
+	info->par += sizeof(struct fb_deferred_io);
+	palette = info->par;
+	info->par += 256 * sizeof(u32);
 	for (i = 0; i < 256; i++)
 		palette[i] = i > 0 && i < 16 ? 0xff : 0;
 	info->pseudo_palette = palette;
-	info->screen_base = (char __force __iomem *)fb_bitmap;
 	info->fbops = &picolcdfb_ops;
 	info->var = picolcdfb_var;
 	info->fix = picolcdfb_fix;
 	info->fix.smem_len   = PICOLCDFB_SIZE*8;
-	info->fix.smem_start = (unsigned long)fb_bitmap;
-	info->par = data;
 	info->flags = FBINFO_FLAG_DEFAULT;
 
-	data->fb_vbitmap = fb_vbitmap;
-	data->fb_bitmap  = fb_bitmap;
-	data->fb_bpp     = picolcdfb_var.bits_per_pixel;
+	fbdata = info->par;
+	spin_lock_init(&fbdata->lock);
+	fbdata->picolcd = data;
+	fbdata->update_rate = PICOLCDFB_UPDATE_RATE_DEFAULT;
+	fbdata->bpp     = picolcdfb_var.bits_per_pixel;
+	fbdata->force   = 1;
+	fbdata->vbitmap = info->par + sizeof(struct picolcd_fb_data);
+	fbdata->bitmap  = vmalloc(PICOLCDFB_SIZE*8);
+	if (fbdata->bitmap == NULL) {
+		dev_err(dev, "can't get a free page for framebuffer\n");
+		goto err_nomem;
+	}
+	info->screen_base = (char __force __iomem *)fbdata->bitmap;
+	info->fix.smem_start = (unsigned long)fbdata->bitmap;
+	memset(fbdata->vbitmap, 0xff, PICOLCDFB_SIZE);
+	data->fb_info = info;
+
+	printk(KERN_INFO "hid-picolcd: init_framebuffer(%p [fb=%p]) 1/5\n", data, info);
 	error = picolcd_fb_reset(data, 1);
 	if (error) {
 		dev_err(dev, "failed to configure display\n");
 		goto err_cleanup;
 	}
+
+	printk(KERN_INFO "hid-picolcd: init_framebuffer(%p [fb=%p]) 2/5\n", data, info);
 	error = device_create_file(dev, &dev_attr_fb_update_rate);
 	if (error) {
 		dev_err(dev, "failed to create sysfs attributes\n");
 		goto err_cleanup;
 	}
+
+	printk(KERN_INFO "hid-picolcd: init_framebuffer(%p [fb=%p]) 3/5\n", data, info);
 	fb_deferred_io_init(info);
-	data->fb_info    = info;
+	printk(KERN_INFO "hid-picolcd: init_framebuffer(%p [fb=%p]) 4/5\n", data, info);
 	error = register_framebuffer(info);
 	if (error) {
 		dev_err(dev, "failed to register framebuffer\n");
 		goto err_sysfs;
 	}
-	/* schedule first output of framebuffer */
-	data->fb_force = 1;
-	schedule_delayed_work(&info->deferred_work, 0);
+	printk(KERN_INFO "hid-picolcd: init_framebuffer(%p [fb=%p]) 5/5\n", data, info);
 	return 0;
 
 err_sysfs:
-	fb_deferred_io_cleanup(info);
 	device_remove_file(dev, &dev_attr_fb_update_rate);
+	fb_deferred_io_cleanup(info);
 err_cleanup:
-	data->fb_vbitmap = NULL;
-	data->fb_bitmap  = NULL;
-	data->fb_bpp     = 0;
 	data->fb_info    = NULL;
 
 err_nomem:
+	if (fbdata)
+		vfree(fbdata->bitmap);
 	framebuffer_release(info);
-	vfree(fb_bitmap);
-	kfree(fb_vbitmap);
+	printk(KERN_INFO "hid-picolcd: init_framebuffer(%p [fb=%p]) failed\n", data, info);
 	return error;
 }
 
 void picolcd_exit_framebuffer(struct picolcd_data *data)
 {
 	struct fb_info *info = data->fb_info;
-	u8 *fb_vbitmap = data->fb_vbitmap;
-
-	if (!info)
-		return;
+	struct picolcd_fb_data *fbdata = info->par;
+	unsigned long flags;
 
+	printk(KERN_INFO "hid-picolcd: exit_framebuffer(%p [fb=%p]) ...\n", data, info);
 	device_remove_file(&data->hdev->dev, &dev_attr_fb_update_rate);
-	info->par = NULL;
+
+	/* disconnect framebuffer from HID dev */
+	spin_lock_irqsave(&fbdata->lock, flags);
+	fbdata->picolcd = NULL;
+	spin_unlock_irqrestore(&fbdata->lock, flags);
+
+	/* make sure there is no running update - thus that fbdata->picolcd
+	 * once obtained under lock is guaranteed not to get free() under
+	 * the feet of the deferred work */
+	flush_delayed_work_sync(&info->deferred_work);
+
+	data->fb_info = NULL;
 	unregister_framebuffer(info);
-	data->fb_vbitmap = NULL;
-	data->fb_bitmap  = NULL;
-	data->fb_bpp     = 0;
-	data->fb_info    = NULL;
-	kfree(fb_vbitmap);
+	printk(KERN_INFO "hid-picolcd: exit_framebuffer(%p [fb=%p]) done\n", data, info);
 }

--MP_/r=P3l.tW+ncAgVLY/nCl4qZ--
