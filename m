Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0FHNIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:08:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36450 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab0FHNIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 09:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=D0QYcw7uE8Q/q+EkjvmobpXixYio11o5ylktjWf9wh4FoXu5658c0CsUBYqb/uE9XH
         BRkRoEWGOPxNHUBkKkKNchYBNfRAkIk6O4Hyo/HENybwvmK0v9CcrOADdg6FF0j8SKU1
         1B1JdlbSWW+l9lEUKMxvFmU9jGtVgYGzIyX84=
Message-ID: <4C0E40E1.2080108@tuffmail.co.uk>
Date: Tue, 08 Jun 2010 14:08:49 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Kernel Testers List <kernel-testers@vger.kernel.org>
CC: linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Regression: BUG when battery is removed before resuming from hibernation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found this bug 2.6.34 on my Asus EeePC 701 (x86_32 arch).  It didn't 
happen to me before, when I was running nearly-2.6.33 or 2.6.32-release.

I used git-bisect, but unfortunately the result isn't very helpful.  My 
next step will be to try to narrowing down the culprits by disabling 
individual CONFIG options.  Here are my results so far, in case anyone 
is interested.


== Steps to reproduce ==

I) Boot off mains power, with battery removed.  Login to KDE4 session, 
with Konsole as the only running application.
II) Run "sudo pm-hibernate"

1. When the system switches to text mode (a.k.a the console), 
immediately insert the battery.
2. Once the system has fully hibernated, remove the battery.
3. Press the power button to resume.  The backtrace below is generated 
during resume.


== git-bisect result ==

I don't think it is 100% reproducible.  So during bisection, I tested 
each kernel 3 times.  I tested the "last known good" kernel an 
additional 9 times, and the result held.  It seemed like a solid result.

First bad commit:
v2.6.34-rc3-310-g975f8c5
"drivers/thermal/thermal_sys.c: fix 'key f70f4b50 not in .data' in 
thermal_sys"

Last known good (only parent of above):
v2.6.34-rc3-309-g829f46a


== git-bisect result is useless ==

The "bad" commit can easily be reverted from v2.6.34 (there were no 
subsequent changes to thermal_sys.c).  But that doesn't fix the problem.

I should be able to avoid the altered codepaths by disabling all my 
thermal devices - blacklisting the ACPI processor and thermal modules.  
This leaves me with an empty /sys/class/thermal/.  If I do this on the 
"good" kernel, it successfully avoids the lockdep usage backtrace which 
the "bad" commit is designed to fix.  But if I do this on the "bad" 
kernel, I can still reproduce the BUG message.

It's harder to disable thermal_sys itself, because it's required by ACPI 
video, which is required for I915 w/KMS.  If I disable all these in the 
kernel .config, the "bad" commit is still bad, but the "good" one is now 
bad as well.



== BUG / Backtrace message ==

The BUG looks a bit like a double-free in the power supply class or the 
ACPI battery driver.  (6b6b6b6b is apparently the SLAB poison used to 
mark memory which has been freed).


 BUG: unable to handle kernel paging request at 6b6b6b6f
 IP: [<c11d8657>] led_trigger_unregister+0x18/0x8a
 *pde = 00000000
 Oops: 0002 [#1] SMP
 last sysfs file: /sys/devices/virtual/vc/vcsa8/uevent
 Modules linked in: i915 drm_kms_helper drm i2c_algo_bit fuse loop 
joydev arc4 ecb snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer ath5k snd_seq_device mac80211 
uvcvideo eeepc_laptop snd ath videodev v4l1_compat psmouse cfg80211 
sparse_keymap video intel_agp soundcore i2c_core rfkill serio_raw evdev 
led_class snd_page_alloc agpgart output battery ac pci_hotplug processor 
button ext4 mbcache jbd2 crc16 usb_storage sd_mod crc_t10dif uhci_hcd 
ata_piix ehci_hcd atl2 usbcore thermal thermal_sys [last unloaded: 
scsi_wait_scan]
 
 Pid: 16, comm: kacpi_notify Not tainted 2.6.34eeepc #109 701/701
 EIP: 0060:[<c11d8657>] EFLAGS: 00010282 CPU: 0
 EIP is at led_trigger_unregister+0x18/0x8a
 EAX: 6b6b6b6b EBX: de70a1e0 ECX: 00000001 EDX: 6b6b6b6b
 ESI: de70a1e0 EDI: 00000001 EBP: df0abe98 ESP: df0abe8c
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
 Process kacpi_notify (pid: 16, ti=df0aa000 task=df0a94b0 task.ti=df0aa000)
 Stack:
  de70a1e0 00000000 00000001 df0abea4 c11d86d8 df2ce318 df0abeb0 c11d711c
 <0> df2ce318 df0abebc c11d6b37 df2ce2d8 df0abec8 e0308033 df2ce2d8 df0abeec
 <0> e0308369 df02fd00 00000000 df0abef0 c117a8d1 df2ce2d8 df0d4140 00000001
 Call Trace:
  [<c11d86d8>] ? led_trigger_unregister_simple+0xf/0x19
  [<c11d711c>] ? power_supply_remove_triggers+0x14/0x4c
  [<c11d6b37>] ? power_supply_unregister+0x12/0x24
  [<e0308033>] ? sysfs_remove_battery+0x1f/0x29 [battery]
  [<e0308369>] ? acpi_battery_update+0x65/0x223 [battery]
  [<c117a8d1>] ? acpi_get_data+0x51/0x60
  [<e0308548>] ? acpi_battery_notify+0x21/0x58 [battery]
  [<c1162eb8>] ? acpi_bus_notify+0xb3/0xba
  [<c1162e05>] ? acpi_bus_notify+0x0/0xba
  [<c1170302>] ? acpi_ev_notify_dispatch+0x3b/0x65
  [<c1160d96>] ? acpi_os_execute_deferred+0x1d/0x28
  [<c10401f8>] ? worker_thread+0x19a/0x25d
  [<c10401b6>] ? worker_thread+0x158/0x25d
  [<c1160d79>] ? acpi_os_execute_deferred+0x0/0x28
  [<c10438a1>] ? autoremove_wake_function+0x0/0x2f
  [<c104005e>] ? worker_thread+0x0/0x25d
  [<c104353e>] ? kthread+0x6a/0x6f
  [<c10434d4>] ? kthread+0x0/0x6f
  [<c1002dc2>] ? kernel_thread_helper+0x6/0x1a
 Code: 73 60 8b 56 04 85 d2 74 04 89 d8 ff d2 5a 5b 5e 5f 5d c3 55 89 e5 
57 56 89 c6 53 b8 44 42 43 c1 e8 95 17 0a 00 8b 56 30 8b 46 34 <89> 42 
04 89 10 b8 44 42 43 c1 c7 46 30 00 01 10 00 c7 46 34 00
 EIP: [<c11d8657>] led_trigger_unregister+0x18/0x8a SS:ESP 0068:df0abe8c
 CR2: 000000006b6b6b6f
 ---[ end trace 98ac34cabd457f98 ]---

