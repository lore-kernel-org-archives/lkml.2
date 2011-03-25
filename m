Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab1CYXxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:53:19 -0400
Received: from kroah.org ([198.145.64.141]:41922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab1CYXxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:44 2011
Message-Id: <20110325234843.928750953@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: [47/55] drm: Fix use-after-free in drm_gem_vm_close()
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit b74ad5ae14def5e81ad0be3dddb96e485b861b1b upstream.

As we may release the last reference, we need to store the device in a
local variable in order to unlock afterwards.

[   60.140768] BUG: unable to handle kernel paging request at 6b6b6b9f
[   60.140973] IP: [<c1536d11>] __mutex_unlock_slowpath+0x5a/0x111
[   60.141014] *pdpt = 0000000024a54001 *pde = 0000000000000000
[   60.141014] Oops: 0002 [#1] PREEMPT SMP
[   60.141014] last sysfs file: /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/PNP0C0A:00/power_supply/BAT0/voltage_now
[   60.141014] Modules linked in: uvcvideo ath9k pegasus ath9k_common ath9k_hw hid_egalax ath3k joydev asus_laptop sparse_keymap battery input_polldev
[   60.141014]
[   60.141014] Pid: 771, comm: meego-ux-daemon Not tainted 2.6.37.2-7.1 #1 EXOPC EXOPG06411/EXOPG06411
[   60.141014] EIP: 0060:[<c1536d11>] EFLAGS: 00010046 CPU: 0
[   60.141014] EIP is at __mutex_unlock_slowpath+0x5a/0x111
[   60.141014] EAX: 00000100 EBX: 6b6b6b9b ECX: e9b4a1b0 EDX: e4a4e580
[   60.141014] ESI: db162558 EDI: 00000246 EBP: e480be50 ESP: e480be44
[   60.141014]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   60.141014] Process meego-ux-daemon (pid: 771, ti=e480a000 task=e9b4a1b0 task.ti=e480a000)
[   60.141014] Stack:
[   60.141014]  e4a4e580 db162558 f5a2f838 e480be58 c1536dd0 e480be68 c125ab1b db162558
[   60.141014]  db1624e0 e480be78 c10ba071 db162558 f760241c e480be94 c10bb0bc 000155fe
[   60.141014]  f760241c f5a2f838 f5a2f8c8 00000000 e480bea4 c1037c24 00000000 f5a2f838
[   60.141014] Call Trace:
[   60.141014]  [<c1536dd0>] ? mutex_unlock+0x8/0xa
[   60.141014]  [<c125ab1b>] ? drm_gem_vm_close+0x39/0x3d
[   60.141014]  [<c10ba071>] ? remove_vma+0x2d/0x58
[   60.141014]  [<c10bb0bc>] ? exit_mmap+0x126/0x13f
[   60.141014]  [<c1037c24>] ? mmput+0x37/0x9a
[   60.141014]  [<c10d450d>] ? exec_mmap+0x178/0x19c
[   60.141014]  [<c1537f85>] ? _raw_spin_unlock+0x1d/0x36
[   60.141014]  [<c10d4eb0>] ? flush_old_exec+0x42/0x75
[   60.141014]  [<c1104442>] ? load_elf_binary+0x32a/0x922
[   60.141014]  [<c10d3f76>] ? search_binary_handler+0x200/0x2ea
[   60.141014]  [<c10d3ecf>] ? search_binary_handler+0x159/0x2ea
[   60.141014]  [<c1104118>] ? load_elf_binary+0x0/0x922
[   60.141014]  [<c10d56b2>] ? do_execve+0x1ff/0x2e6
[   60.141014]  [<c100970e>] ? sys_execve+0x2d/0x55
[   60.141014]  [<c1002a5a>] ? ptregs_execve+0x12/0x18
[   60.141014]  [<c10029dc>] ? sysenter_do_call+0x12/0x3c
[   60.141014]  [<c1530000>] ? init_centaur+0x9c/0x1ba
[   60.141014] Code: c1 00 75 0f ba 38 01 00 00 b8 8c 3a 6c c1 e8 cc 2e b0 ff 9c 58 8d 74 26 00 89 c7 fa 90 8d 74 26 00 e8 d2 b4 b2 ff b8 00 01 00 00 <f0> 66 0f c1 43 04 38 e0 74 07 f3 90 8a 43 04 eb f5 83 3d 64 ef
[   60.141014] EIP: [<c1536d11>] __mutex_unlock_slowpath+0x5a/0x111 SS:ESP 0068:e480be44
[   60.141014] CR2: 000000006b6b6b9f

Reported-by: Rusty Lynch <rusty.lynch@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_gem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -498,11 +498,12 @@ EXPORT_SYMBOL(drm_gem_vm_open);
 void drm_gem_vm_close(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
+	struct drm_device *dev = obj->dev;
 
-	mutex_lock(&obj->dev->struct_mutex);
+	mutex_lock(&dev->struct_mutex);
 	drm_vm_close_locked(vma);
 	drm_gem_object_unreference(obj);
-	mutex_unlock(&obj->dev->struct_mutex);
+	mutex_unlock(&dev->struct_mutex);
 }
 EXPORT_SYMBOL(drm_gem_vm_close);
 


