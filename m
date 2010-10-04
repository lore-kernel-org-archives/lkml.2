Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab0JDW5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:57:34 -0400
Received: from tuxonice.net ([74.207.252.127]:43384 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab0JDW5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:57:33 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CAA5BDA.7080705@tuxonice.net>
Date: Tue, 05 Oct 2010 09:57:30 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [BUG][PATCH] 2.6.36-rc showstopper (at least for me) in vmwgfx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a kernel based on the Rafael's -next tree, under VMware, I get the following oops while booting:

Entering kdb (current=0xd73e2f70, pid 1024) on processor 0 Oops: (null)
due to oops @ 0xc108bc94
<d>Modules linked in: ext4 jbd2 crc16 mptspi mptscsih mptbase
<c>
<d>Pid: 1024, comm: plymouthd Not tainted 2.6.36-rc4+ #60 440BX Desktop Reference Platform/VMware Virtual Platform
<d>EIP: 0060:[<c108bc94>] EFLAGS: 00010246 CPU: 0
EIP is at kfree+0x36/0x88
<d>EAX: c146ccbd EBX: dc46e980 ECX: 40000400 EDX: c182cd80
<d>ESI: dfabf800 EDI: dfabf8c0 EBP: dfa7befc ESP: dfa7beec
<d> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
<0>Process plymouthd (pid: 1024, ti=dfa7a000 task=d73e2f70 task.ti=dfa7a000)
<0>Stack:
 dfabf800 dc46e980 dfabf800 dfabf8c0 dfa7bf18 c11c4ea0 c11d237c dfabf8c0
<0> dc46e980 c11c4e13 c11d5bd9 dfa7bf28 c113d3d1 dc437468 dc46e780 dfa7bf34
<0> c11c4d9d dc437468 dfa7bf40 c11d5f35 dfabf800 dfa7bf68 c11c1e3e dfabf800
<0>Call Trace:
<0> [<c11c4ea0>] ? drm_master_destroy+0x8d/0xf0
<0> [<c11d237c>] ? ttm_object_file_destroy+0x0/0xd
<0> [<c11c4e13>] ? drm_master_destroy+0x0/0xf0
<0> [<c11d5bd9>] ? vmw_master_drop+0x0/0x76
<0> [<c113d3d1>] ? kref_put+0x39/0x42
<0> [<c11c4d9d>] ? drm_master_put+0x12/0x1b
[0]more>
Only 'q' or 'Q' are processed at more prompt, input ignored
<0> [<c11d5f35>] ? vmw_postclose+0x1b/0x25
<0> [<c11c1e3e>] ? drm_release+0x459/0x4cb
<0> [<c1091274>] ? fput+0xcc/0x1b1
<0> [<c108ec5b>] ? filp_close+0x51/0x5b
<0> [<c108ecbf>] ? sys_close+0x5a/0x88
<0> [<c1002690>] ? sysenter_do_call+0x12/0x26
<0>Code: 10 76 72 8d 90 00 00 00 40 c1 ea 0c c1 e2 05 03 15 00 1b 7e c1 66 83 3a 00 79 03 8b 52 0c 8b 0a 84 c9 78 14 66 f7 c1 00 c0 75 04 <0f> 0b eb fe 89 d0 e8 0a 3a fe ff eb 3d 8b 75 04 8b 5a 0c 9c 8f
Call Trace:
 [<c11c4ea0>] drm_master_destroy+0x8d/0xf0
 [<c11d237c>] ? ttm_object_file_destroy+0x0/0xd
 [<c11c4e13>] ? drm_master_destroy+0x0/0xf0
 [<c11d5bd9>] ? vmw_master_drop+0x0/0x76
 [<c113d3d1>] kref_put+0x39/0x42
 [<c11c4d9d>] drm_master_put+0x12/0x1b
 [<c11d5f35>] vmw_postclose+0x1b/0x25
 [<c11c1e3e>] drm_release+0x459/0x4cb
 [<c1091274>] fput+0xcc/0x1b1
 [<c108ec5b>] filp_close+0x51/0x5b
 [<c108ecbf>] sys_close+0x5a/0x88
 [<c1002690>] sysenter_do_call+0x12/0x26

This oops is caused by vmwgfx setting it's dev->devicename to a static char * instead of kmallocing memory. The kfree that's done in drm_master_destroy then explodes :)

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 72ec2e2..1ca0ebc 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -343,8 +343,16 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 
        dev->dev_private = dev_priv;
 
-       if (!dev->devname)
-               dev->devname = vmw_devname;
+       if (!dev->devname) {
+               dev->devname = kmalloc(strlen(vmw_devname) + 1, GFP_KERNEL);
+               if (!dev->devname) {
+                       DRM_ERROR("Unable to allocate memory for device "
+                                       "name.\n");
+                       ret = -ENOMEM;
+                       goto out_err4;
+               }
+               strcpy(dev->devname, vmw_devname);
+       }
 
        if (dev_priv->capabilities & SVGA_CAP_IRQMASK) {
                ret = drm_irq_install(dev);

