Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0KELvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 07:51:08 -0400
Received: from webmail.olin.edu ([209.94.128.49]:56863 "EHLO EXCAS01.olin.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab0KELvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 07:51:06 -0400
Message-ID: <E1PEKnc-00010j-O9@approx.mit.edu>
To: <linux-kernel@vger.kernel.org>
Subject: S3 suspend failed freezing tasks (2.6.36, TP T60)
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Fri, 5 Nov 2010 07:49:40 -0400
From: Sanjoy Mahajan <sanjoy@olin.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've had sporadic suspend-to-RAM (S3) failures running vanilla 2.6.36
(Thinkpad T60 with Intel graphics/wireless).

One was a hard crash while suspending.  The laptop just shut off in the
middle of suspending, instead of going to sleep.  Then it wouldn't
reboot until I took out and replaced the battery (with the AC
disconnected).  The cause may have been that I disconnected AC power in
the middle of the suspend; unfortunately, I haven't been able to
reproduce that kind of crash.

The most recent was a failure to suspend while freezing tasks.  The
first two times I suspended with my usual Fn-F4, which runs the
/etc/acpi/sleep.sh and eventually the Debian/Redhat pm-suspend script.
But I think it all ends up in "echo mem > /sys/power/state".  As a
check, I did a third suspend using just "echo mem > /sys/power/state",
which also failed.  To reboot, to get the laptop to respond to the power
switch, I had to take out the battery and put it back (the AC power was
not connected).

The failure messages all begin:

  [94257.412148] Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
  [94257.412211] emacs         T 0000000a     0  3448   3446 0x00800004

Perhaps relevant: I had just upgraded emacs to the latest Debian
unstable/testing version underneath the running emacs, and not restarted
it.  So, I was running the old emacs binary, but a new binary was on the
filesystem.

Here are the dmesgs from the three suspend attempts:

/* here's the first suspend, with Fn-F4 */
[94237.357290] PM: Syncing filesystems ... done.
[94237.396333] PM: Preparing system for mem sleep
[94237.396438] Freezing user space processes ... 
[94257.412148] Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
[94257.412211] emacs         T 0000000a     0  3448   3446 0x00800004
[94257.412226]  f4ca4000 00200082 bfc7e65c 0000000a 00000000 00000000 00200006 c141c3c0
[94257.412246]  c141c3c0 f4ca41a0 00feb000 c103a856 c141c3c0 f4ca41a0 f4ca41a4 f4ca4000
[94257.412265]  c141c3c0 00000001 f4ca4000 00040005 f4ca4000 00000014 c103bf76 f598befc
[94257.412283] Call Trace:
[94257.412300]  [<c103a856>] ? __dequeue_signal+0xa6/0xcd
[94257.412311]  [<c103bf76>] ? do_signal_stop+0xda/0x13c
[94257.412322]  [<c103c80a>] ? get_signal_to_deliver+0x27f/0x361
[94257.412334]  [<c10027b6>] ? do_signal+0x56/0x6a1
[94257.412344]  [<c103b62b>] ? group_send_sig_info+0x23/0x28
[94257.412356]  [<c10c0fa2>] ? f_modown+0x26/0x61
[94257.412366]  [<c10c0fa2>] ? f_modown+0x26/0x61
[94257.412376]  [<c10c1015>] ? __f_setown+0x2b/0x33
[94257.412386]  [<c10c1043>] ? f_setown+0x26/0x2b
[94257.412396]  [<c10c1277>] ? do_fcntl+0x22f/0x3b9
[94257.412406]  [<c1002e21>] ? do_notify_resume+0x20/0x7f
[94257.412419]  [<c127d188>] ? work_notifysig+0x13/0x1b
[94257.412443] hald-probe-vo D 00000086     0 16137   1342 0x00800004
[94257.412455]  f4ca4840 00000086 00000000 00000086 00000000 00000000 f69f0074 c141c3c0
[94257.412473]  c141c3c0 f4ca49e0 00feb000 00000086 c141c3c0 f4ca49e0 f4ca49e4 f4ca4840
[94257.412492]  c141c3c0 00000001 f4ca4840 c24073c0 c20d0f94 f4f61e60 c127bcf2 f4f61e58
[94257.412511] Call Trace:
[94257.412520]  [<c127bcf2>] ? io_schedule+0x57/0x8f
[94257.412531]  [<c1089de6>] ? sync_page+0x39/0x3c
[94257.412541]  [<c1089dee>] ? sync_page_killable+0x5/0x27
[94257.412552]  [<c127c07e>] ? __wait_on_bit_lock+0x2f/0x68
[94257.412562]  [<c1089de9>] ? sync_page_killable+0x0/0x27
[94257.412573]  [<c1089d2d>] ? __lock_page_killable+0x6f/0x75
[94257.412584]  [<c104370b>] ? wake_bit_function+0x0/0x30
[94257.412595]  [<c108ad9f>] ? generic_file_aio_read+0x421/0x5d6
[94257.412608]  [<c10b7155>] ? do_sync_read+0x9e/0xd3
[94257.412620]  [<c109de11>] ? __do_fault+0x39e/0x3cb
[94257.412632]  [<c1108420>] ? fsnotify_perm+0x3c/0x45
[94257.412643]  [<c10b7223>] ? rw_verify_area+0x99/0xba
[94257.412653]  [<c10b70b7>] ? do_sync_read+0x0/0xd3
[94257.412663]  [<c10b775c>] ? vfs_read+0x7c/0xd6
[94257.412673]  [<c113ea1e>] ? copy_to_user+0x2c/0x100
[94257.412683]  [<c10b7849>] ? sys_read+0x3c/0x60
[94257.412693]  [<c1002f1f>] ? sysenter_do_call+0x12/0x28
[94257.412705] 
[94257.412709] Restarting tasks ... done.
[94257.419009] video LNXVIDEO:00: Restoring backlight state

/* attempt number 2 (with Fn-F4 again): */
[94313.358681] PM: Syncing filesystems ... done.
[94313.385268] PM: Preparing system for mem sleep
[94313.385374] Freezing user space processes ... 
[94333.400206] Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
[94333.400271] emacs         T 0000000a     0  3448   3446 0x00800004
[94333.400286]  f4ca4000 00200082 bfc7e65c 0000000a 00000000 00000000 00200006 c141c3c0
[94333.400306]  c141c3c0 f4ca41a0 00feb000 c103a856 c141c3c0 f4ca41a0 f4ca41a4 f4ca4000
[94333.400324]  c141c3c0 00000001 f4ca4000 00040005 f4ca4000 00000014 c103bf76 f598befc
[94333.400343] Call Trace:
[94333.400359]  [<c103a856>] ? __dequeue_signal+0xa6/0xcd
[94333.400371]  [<c103bf76>] ? do_signal_stop+0xda/0x13c
[94333.400381]  [<c103c80a>] ? get_signal_to_deliver+0x27f/0x361
[94333.400393]  [<c10027b6>] ? do_signal+0x56/0x6a1
[94333.400403]  [<c103b62b>] ? group_send_sig_info+0x23/0x28
[94333.400416]  [<c10c0fa2>] ? f_modown+0x26/0x61
[94333.400426]  [<c10c0fa2>] ? f_modown+0x26/0x61
[94333.400436]  [<c10c1015>] ? __f_setown+0x2b/0x33
[94333.400446]  [<c10c1043>] ? f_setown+0x26/0x2b
[94333.400456]  [<c10c1277>] ? do_fcntl+0x22f/0x3b9
[94333.400466]  [<c1002e21>] ? do_notify_resume+0x20/0x7f
[94333.400479]  [<c127d188>] ? work_notifysig+0x13/0x1b
[94333.400501] hald-probe-vo D 00000086     0 16137   1342 0x00800004
[94333.400514]  f4ca4840 00000086 00000000 00000086 00000000 00000000 f69f0074 c141c3c0
[94333.400532]  c141c3c0 f4ca49e0 00feb000 00000086 c141c3c0 f4ca49e0 f4ca49e4 f4ca4840
[94333.400551]  c141c3c0 00000001 f4ca4840 c24073c0 c20d0f94 f4f61e60 c127bcf2 f4f61e58
[94333.400570] Call Trace:
[94333.400579]  [<c127bcf2>] ? io_schedule+0x57/0x8f
[94333.400590]  [<c1089de6>] ? sync_page+0x39/0x3c
[94333.400600]  [<c1089dee>] ? sync_page_killable+0x5/0x27
[94333.400611]  [<c127c07e>] ? __wait_on_bit_lock+0x2f/0x68
[94333.400621]  [<c1089de9>] ? sync_page_killable+0x0/0x27
[94333.400632]  [<c1089d2d>] ? __lock_page_killable+0x6f/0x75
[94333.400643]  [<c104370b>] ? wake_bit_function+0x0/0x30
[94333.400654]  [<c108ad9f>] ? generic_file_aio_read+0x421/0x5d6
[94333.400667]  [<c10b7155>] ? do_sync_read+0x9e/0xd3
[94333.400678]  [<c109de11>] ? __do_fault+0x39e/0x3cb
[94333.400691]  [<c1108420>] ? fsnotify_perm+0x3c/0x45
[94333.400701]  [<c10b7223>] ? rw_verify_area+0x99/0xba
[94333.400711]  [<c10b70b7>] ? do_sync_read+0x0/0xd3
[94333.400721]  [<c10b775c>] ? vfs_read+0x7c/0xd6
[94333.400732]  [<c113ea1e>] ? copy_to_user+0x2c/0x100
[94333.400742]  [<c10b7849>] ? sys_read+0x3c/0x60
[94333.400751]  [<c1002f1f>] ? sysenter_do_call+0x12/0x28
[94333.400765] 
[94333.400769] Restarting tasks ... done.
[94333.413420] video LNXVIDEO:00: Restoring backlight state

/* attempt number 3, using "echo mem > /sys/power/state" directly: */
[94365.444481] PM: Syncing filesystems ... done.
[94365.465514] PM: Preparing system for mem sleep
lient 1417[0:0] has disconnected 
[94365.518984] Freezing user space processes ... 
[94385.534181] Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
[94385.536308] emacs         T 0000000a     0  3448   3446 0x00800004
[94385.538367]  f4ca4000 00200082 bfc7e65c 0000000a 00000000 00000000 00200006 c141c3c0
[94385.540527]  c141c3c0 f4ca41a0 00feb000 c103a856 c141c3c0 f4ca41a0 f4ca41a4 f4ca4000
[94385.542701]  c141c3c0 00000001 f4ca4000 00040005 f4ca4000 00000014 c103bf76 f598befc
[94385.544903] Call Trace:
[94385.547023]  [<c103a856>] ? __dequeue_signal+0xa6/0xcd
[94385.549227]  [<c103bf76>] ? do_signal_stop+0xda/0x13c
[94385.551440]  [<c103c80a>] ? get_signal_to_deliver+0x27f/0x361
[94385.553711]  [<c10027b6>] ? do_signal+0x56/0x6a1
[94385.555997]  [<c103b62b>] ? group_send_sig_info+0x23/0x28
[94385.558309]  [<c10c0fa2>] ? f_modown+0x26/0x61
[94385.560599]  [<c10c0fa2>] ? f_modown+0x26/0x61
[94385.562838]  [<c10c1015>] ? __f_setown+0x2b/0x33
[94385.565061]  [<c10c1043>] ? f_setown+0x26/0x2b
[94385.567234]  [<c10c1277>] ? do_fcntl+0x22f/0x3b9
[94385.569417]  [<c1002e21>] ? do_notify_resume+0x20/0x7f
[94385.571570]  [<c127d188>] ? work_notifysig+0x13/0x1b
[94385.573716] hald-probe-vo D 00000086     0 16137   1342 0x00800004
[94385.575904]  f4ca4840 00000086 00000000 00000086 00000000 00000000 f69f0074 c141c3c0
[94385.578243]  c141c3c0 f4ca49e0 00feb000 00000086 c141c3c0 f4ca49e0 f4ca49e4 f4ca4840
[94385.580559]  c141c3c0 00000001 f4ca4840 c24073c0 c20d0f94 f4f61e60 c127bcf2 f4f61e58
[94385.582884] Call Trace:
[94385.585098]  [<c127bcf2>] ? io_schedule+0x57/0x8f
[94385.587347]  [<c1089de6>] ? sync_page+0x39/0x3c
[94385.589593]  [<c1089dee>] ? sync_page_killable+0x5/0x27
[94385.591826]  [<c127c07e>] ? __wait_on_bit_lock+0x2f/0x68
[94385.594070]  [<c1089de9>] ? sync_page_killable+0x0/0x27
[94385.596317]  [<c1089d2d>] ? __lock_page_killable+0x6f/0x75
[94385.598583]  [<c104370b>] ? wake_bit_function+0x0/0x30
[94385.600849]  [<c108ad9f>] ? generic_file_aio_read+0x421/0x5d6
[94385.603120]  [<c10b7155>] ? do_sync_read+0x9e/0xd3
[94385.605375]  [<c109de11>] ? __do_fault+0x39e/0x3cb
[94385.607626]  [<c1108420>] ? fsnotify_perm+0x3c/0x45
[94385.609865]  [<c10b7223>] ? rw_verify_area+0x99/0xba
[94385.612082]  [<c10b70b7>] ? do_sync_read+0x0/0xd3
[94385.614274]  [<c10b775c>] ? vfs_read+0x7c/0xd6
[94385.616446]  [<c113ea1e>] ? copy_to_user+0x2c/0x100
[94385.618635]  [<c10b7849>] ? sys_read+0x3c/0x60
[94385.620872]  [<c1002f1f>] ? sysenter_do_call+0x12/0x28
[94385.623134] 
[94385.625405] Restarting tasks ... done.
[94385.634492] video LNXVIDEO:00: Restoring backlight state
