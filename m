Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1FSNa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 09:30:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57651 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab1FSNay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 09:30:54 -0400
Date: Sun, 19 Jun 2011 15:30:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: linux-acpi@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: acpi_power_off lockdep splat
Message-ID: <20110619133049.GA18168@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
	x86@kernel.org, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is something I'm getting with latest Linus git. The machine is
connected over serial cable and the below lockdep splat appears on the
serial console.

I won't be able to test patches or other stuff in the next couple of
days but I've seen this on a bunch of machines so far so it should be
pretty easy to reproduce on any generic setup: simply do 'halt' on the
command line and stare the the serial console output coming out on
another machine.

I'm attaching dmesg and .config.

Thanks.

INIT: Switching to runINIT: Sending procUsing makefile-style concurrent boot in runlevel 0.
Stopping deferred execution scheduler: atd.
fuse exit
Shutting down ALSA...done.
Asking all remaining processes to terminate...done.
All processes ended within 1 seconds....done.
Stopping enhanced syslogd: rsyslogd.
Saving the system clock.
Cannot access the Hardware Clock via any known method.
Use the --debug option to see the details of our search for an access method.
Deconfiguring network interfaces...done.
Cleaning up ifupdown....
Deactivating swap...done.
Unmounting local filesystems...done.
Will now halt.
Shutdown: hdd
Shutdown: hda
ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0000000000000007) is beyond end of object (20110413/exoparg2-418)
ACPI Error: Method parse/execution failed [\_SB_.PCI0.IDE0.GTM_] (Node de04f2c0), AE_AML_PACKAGE_LIMIT (20110413/pspars)
ACPI Error: Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0._GTM] (Node de04f470), AE_AML_PACKAGE_LIMIT (20110413/p)
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ACPI: Preparing to enter system sleep state S5
Disabling non-boot CPUs ...                                                       
lockdep: fixing up alternatives.                                                  
Power down.                                                                       
acpi_power_off called                                                             

=============================================
[ INFO: possible recursive locking detected ]
3.0.0-rc3-00256-gde505e7 #7
---------------------------------------------
halt/2507 is trying to acquire lock:
 (&(lock)->rlock){......}, at: [<c1177baf>] acpi_os_acquire_lock+0xd/0xf

but task is already holding lock:
 (&(lock)->rlock){......}, at: [<c1177baf>] acpi_os_acquire_lock+0xd/0xf

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(lock)->rlock);
  lock(&(lock)->rlock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by halt/2507:
 #0:  (reboot_mutex){+.+.+.}, at: [<c1041e04>] sys_reboot+0x80/0x140
 #1:  (&(lock)->rlock){......}, at: [<c1177baf>] acpi_os_acquire_lock+0xd/0xf

stack backtrace:
Pid: 2507, comm: halt Not tainted 3.0.0-rc3-00256-gde505e7 #7
Call Trace:
 [<c105b758>] __lock_acquire+0x139b/0x141b
 [<c1361385>] ? _raw_spin_unlock_irqrestore+0x34/0x5e
 [<c1177baf>] ? acpi_os_acquire_lock+0xd/0xf
 [<c105bc33>] lock_acquire+0xb0/0xcf
 [<c1177baf>] ? acpi_os_acquire_lock+0xd/0xf
 [<c1360d82>] _raw_spin_lock_irqsave+0x33/0x43
 [<c1177baf>] ? acpi_os_acquire_lock+0xd/0xf
 [<c1177baf>] acpi_os_acquire_lock+0xd/0xf
 [<c118620f>] acpi_ev_walk_gpe_list+0x1e/0x6e
 [<c118c271>] ? acpi_hw_enable_runtime_gpe_block+0x38/0x38
 [<c118c752>] acpi_hw_clear_acpi_status+0x37/0x4b
 [<c118cc81>] acpi_enter_sleep_state+0x87/0x1ae
 [<c1058213>] ? trace_hardirqs_off+0xb/0xd
 [<c1179380>] ? acpi_power_off+0x1d/0x29
 [<c1179387>] acpi_power_off+0x24/0x29
 [<c10151ab>] native_machine_power_off+0x26/0x28
 [<c10151bb>] machine_power_off+0xe/0x10
 [<c1041c17>] kernel_power_off+0x40/0x43
 [<c1041e6d>] sys_reboot+0xe9/0x140
 [<c103fc74>] ? do_send_sig_info+0x54/0x5f
 [<c103ffce>] ? kill_pid_info+0x76/0x80
 [<c1040219>] ? sys_kill+0xb2/0x180
 [<c10d6e7e>] ? vfsmount_lock_local_unlock+0x3a/0x50
 [<c10d6f13>] ? mntput_no_expire+0x26/0xd8
 [<c10d6fe3>] ? mntput+0x1e/0x20
 [<c10c2365>] ? fput+0x17a/0x183
 [<c1156b90>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c13660c3>] ? sysenter_exit+0xf/0x18
 [<c10592ba>] ? trace_hardirqs_on_caller+0x10a/0x12b
 [<c1366090>] sysenter_do_call+0x12/0x36


-- 
Regards/Gruss,
    Boris.
