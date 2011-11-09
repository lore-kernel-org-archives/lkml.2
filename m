Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab1KIVxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:53:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58320 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1KIVxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:53:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAAMvZCGQw5YJndHVZMU9pnddFM61o98xOWPWqBKFvJyd1EG77A@mail.gmail.com>
References: <bug-42212-18473@https.bugzilla.kernel.org/> <201109042039.p84KdLNP015975@demeter2.kernel.org>
 <CAAMvZCGzPegbDXjvXdU4b-4=SYVtdN2PQxA15RQTu1631CXbPQ@mail.gmail.com>
 <20111019114215.221535e7@schatten.dmk.lab> <CAAMvZCGM3h7apht5Vz7pE4Vo7p_wufLc_u3uPYyqQaxd+4tVsQ@mail.gmail.com>
 <CAAMvZCGQw5YJndHVZMU9pnddFM61o98xOWPWqBKFvJyd1EG77A@mail.gmail.com>
From: Benjamin Robin <benjarobin@gmail.com>
Date: Wed, 9 Nov 2011 22:52:37 +0100
Message-ID: <CAAMvZCEVCUQX8c=+_=qs3T0M-d-kApDA9jAs=GmVUgn_Rp6=vg@mail.gmail.com>
Subject: Re: [Bug 42212] Asus UL80VT hangs on resume from suspend-to-ram
To: LKML <linux-kernel@vger.kernel.org>
Cc: andi-bz@firstfloor.org, greg@kroah.com, maciej.rutecki@gmail.com,
        rjw@sisk.pl, Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I report a few month ago this bug:
https://bugzilla.kernel.org/show_bug.cgi?id=42212

This bug was a regression, I was not able to wake-up after a sleep
with pm-suspend.
Here the history of this bug report:

***************************** START ************************************
I am running an Asus UL80VT on Archlinux i686.
After doing a git bisect I was able to find the problematic commit:

| I could not believe the result of the bisect, the commit that
produce the regression doesn't look like related to my problem :
|
| commit 512228f0be3af44bf5cf6cc5750ddd279bbedaf3
| Author: Andi Kleen <ak@linux.intel.com>
| Date:   Fri Aug 19 16:15:10 2011 -0700
|
| Add a personality to report 2.6.x version numbers
|
| ... I compiled twice and check that I was using the right kernel

The respond of the author of the personality patch:

>> --- Comment #16 from Andi Kleen <andi-bz@firstfloor.org>  2011-09-04
>> 20:39:19 ---
>> > Hmm, but newuname uses personality already, at least on 64bit kernels
>> Also you should see an oops if a NULL pointer is followed. And I don't
>> see how the low level suspend code should be calling uname anyways.

The bugzilla went down and I made some experimentation during this
delay, here what I found:

- Linux 3.0.6 without the personality patch => OK
- Linux 3.0.6 vanilla still failing the same way
- Linux 3.0 + problematic commit => OK
- On a fresh install (on an USB drive) with x86_64 it's working from
3.0 to 3.0.6 vanilla
- On a fresh install (on an USB drive) with i686 same problem
- I was not really able to find the version of the kernel +
problematic commit where everything is OK

- Debug with RTC (funny but quite long):
   * First test give me :
     [    0.992189]   Magic number: 0:319:980
     [    0.992193]   hash matches drivers/base/power/main.c:510
   It looks like that not device match...

  * After putting a lot of "TRACE_RESUME(X);" into the device_resume
function I was able to find that the problem is around line 531 =>
pm_dev_dbg(dev, state, "type ");

********************************** END***********************************

Today I upgrade the linux kernel to 3.1 and the suspend is working
properly with this kernel version compiled using these ArchLinux
script: http://projects.archlinux.org/svntogit/packages.git/tree/trunk?h=packages/linux&id=20e846c85c47e5593afb5d67d5fb8fc6907d727e

I am able to go to sleep and wake-up without problem.
But I discover that if the PC go to sleep with pm-suspend, after the
wake-up, If I ran swapoff -a, the kernel is logging a non fatal trace
error (The kernel is still working, but in a strange state).
After a fresh start I don't have any problem, I can run swapoff -a
without any problem.

Here the full trace :

**************************** TRACE **************************************
[  448.956919] BUG: unable to handle kernel NULL pointer dereference at 00000001
[  448.957037] IP: [<c0200188>] sys_swapoff+0x28/0x890
[  448.957119] *pde = 00000000
[  448.957167] Oops: 0002 [#1] PREEMPT SMP
[  448.957241] Modules linked in: ipv6 cpufreq_ondemand
nvidia_g210m_acpi fuse cryptd aes_i586 aes_generic ecb uvcvideo
videodev media snd_hda_codec_hdmi btusb bluetooth crc16
snd_hda_codec_realtek arc4 ath9k mac80211 snd_hda_intel snd_hda_codec
joydev snd_hwdep snd_pcm snd_timer snd ath9k_common asus_laptop
soundcore iTCO_wdt iTCO_vendor_support evdev sparse_keymap ath9k_hw
pcspkr snd_page_alloc ath atl1c cfg80211 thermal serio_raw mxm_wmi
psmouse wmi battery ac rfkill acpi_cpufreq freq_table processor mperf
ext3 jbd mbcache sr_mod cdrom sd_mod uhci_hcd ahci libahci libata
scsi_mod ehci_hcd usbcore i915 drm_kms_helper i2c_algo_bit button
video drm i2c_core intel_agp intel_gtt agpgart
[  448.958394]
[  448.958422] Pid: 2871, comm: swapoff Not tainted 3.1.0-4-ARCH #1
ASUSTeK Computer Inc.         UL80VT              /UL80VT
[  448.958592] EIP: 0060:[<c0200188>] EFLAGS: 00010202 CPU: 1
[  448.958672] EIP is at sys_swapoff+0x28/0x890
[  448.958732] EAX: 00000001 EBX: 08b8c9e8 ECX: 00000015 EDX: 00000001
[  448.958815] ESI: 00000001 EDI: ffffffff EBP: cbf59fac ESP: cbf59f2c
[  448.958899]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  448.958973] Process swapoff (pid: 2871, ti=cbf58000 task=cb4427f0
task.ti=cbf58000)
[  448.959072] Stack:
[  448.959105]  c0128680 cbf59fac c012880b 00000028 00141501 c01f402f
cb4427f0 ccde5c38
[  448.959249]  ccde5c00 00000028 00000004 b7715150 c01f402f cbdae948
ccde5c00 cbf59f98
[  448.959392]  c01f4f7a ffffffff b7816000 cbdaed74 ccde5c04 cbdaed68
b7816000 b7815000
[  448.959536] Call Trace:
[  448.959576]  [<c0128680>] ? vmalloc_sync_all+0x120/0x120
[  448.959653]  [<c012880b>] ? do_page_fault+0x18b/0x420
[  448.959728]  [<c01f402f>] ? remove_vma+0x3f/0x60
[  448.959797]  [<c01f402f>] ? remove_vma+0x3f/0x60
[  448.959866]  [<c01f4f7a>] ? do_munmap+0x16a/0x290
[  448.959932]  [<c01f64a9>] ? sys_munmap+0x49/0x60
[  448.959968]  [<c0461f9f>] sysenter_do_call+0x12/0x28
[  448.959968] Code: 00 00 00 55 89 e5 57 56 53 83 ec 74 3e 8d 74 26
00 b8 15 00 00 00 bf ff ff ff ff e8 43 19 f5 ff 84 c0 0f ef ef ef ef
ef ef ef ef
[  448.959968] EIP: [<c0200188>] sys_swapoff+0x28/0x890 SS:ESP 0068:cbf59f2c
[  448.959968] CR2: 0000000000000001
[  448.984347] ---[ end trace ba3f475ccbcab65e ]---
[  461.661939] kbd_keycode: 10 callbacks suppressed
[  461.661946] keyboard: can't emulate rawmode for keycode 240
[  461.661965] keyboard: can't emulate rawmode for keycode 240
[  493.804902] BUG: unable to handle kernel NULL pointer dereference at 00000001
[  493.805027] IP: [<c0200188>] sys_swapoff+0x28/0x890
[  493.805111] *pde = 00000000
[  493.805163] Oops: 0002 [#2] PREEMPT SMP
[  493.805244] Modules linked in: ipv6 cpufreq_ondemand
nvidia_g210m_acpi fuse cryptd aes_i586 aes_generic ecb uvcvideo
videodev media snd_hda_codec_hdmi btusb bluetooth crc16
snd_hda_codec_realtek arc4 ath9k mac80211 snd_hda_intel snd_hda_codec
joydev snd_hwdep snd_pcm snd_timer snd ath9k_common asus_laptop
soundcore iTCO_wdt iTCO_vendor_support evdev sparse_keymap ath9k_hw
pcspkr snd_page_alloc ath atl1c cfg80211 thermal serio_raw mxm_wmi
psmouse wmi battery ac rfkill acpi_cpufreq freq_table processor mperf
ext3 jbd mbcache sr_mod cdrom sd_mod uhci_hcd ahci libahci libata
scsi_mod ehci_hcd usbcore i915 drm_kms_helper i2c_algo_bit button
video drm i2c_core intel_agp intel_gtt agpgart
[  493.806564]
[  493.806593] Pid: 3408, comm: swapoff Tainted: G      D
3.1.0-4-ARCH #1 ASUSTeK Computer Inc.         UL80VT
/UL80VT
[  493.806782] EIP: 0060:[<c0200188>] EFLAGS: 00010202 CPU: 0
[  493.806864] EIP is at sys_swapoff+0x28/0x890
[  493.806927] EAX: 00000001 EBX: 092c61c0 ECX: 00000015 EDX: 00000001
[  493.807014] ESI: 00000001 EDI: ffffffff EBP: cd217fac ESP: cd217f2c
[  493.807100]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  493.807175] Process swapoff (pid: 3408, ti=cd216000 task=cbd53540
task.ti=cd216000)
[  493.807277] Stack:
[  493.807277]  c0128680 cd217fac c012880b 00000028 00171401 c01f402f
cbd53540 cc61fe38
[  493.807277]  cc61fe00 00000028 00000004 b762e150 c01f402f cbdaeb00
cc61fe00 cd217f98
[  493.807277]  c01f4f7a ffffffff b772f000 cbdae16c cc61fe04 cbdae160
b772f000 b772e000
[  493.807277] Call Trace:
[  493.807277]  [<c0128680>] ? vmalloc_sync_all+0x120/0x120
[  493.807277]  [<c012880b>] ? do_page_fault+0x18b/0x420
[  493.807277]  [<c01f402f>] ? remove_vma+0x3f/0x60
[  493.807277]  [<c01f402f>] ? remove_vma+0x3f/0x60
[  493.807277]  [<c01f4f7a>] ? do_munmap+0x16a/0x290
[  493.807277]  [<c01f64a9>] ? sys_munmap+0x49/0x60
[  493.807277]  [<c0461f9f>] sysenter_do_call+0x12/0x28
[  493.807277] Code: 00 00 00 55 89 e5 57 56 53 83 ec 74 3e 8d 74 26
00 b8 15 00 00 00 bf ff ff ff ff e8 43 19 f5 ff 84 c0 0f ef ef ef ef
ef ef ef ef
[  493.807277] EIP: [<c0200188>] sys_swapoff+0x28/0x890 SS:ESP 0068:cd217f2c
[  493.807277] CR2: 0000000000000001
[  493.821691] ---[ end trace ba3f475ccbcab65f ]---

******************************************************************************************

Regards,

Benjamin Robin
