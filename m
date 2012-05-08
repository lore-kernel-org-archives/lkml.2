Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2EHSIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:08:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33150 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2EHSIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:08:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120502203653.GC27158@kroah.com>
References: <20120501173739.4fe61fb5@pyramind.ukuu.org.uk>
	<20120502044544.GA32521@kroah.com>
	<20120502114515.2cc22a26@pyramind.ukuu.org.uk>
	<20120502203653.GC27158@kroah.com>
Date: Tue, 8 May 2012 11:08:29 -0700
X-Google-Sender-Auth: umBBZBdwBA1P91eAtunk9_nI5-I
Message-ID: <CAE9FiQWyjP7yqJ5HBg-8NvZPu9JZMEpG10sQE1oNRzOnPdYx1g@mail.gmail.com>
Subject: Re: Killing the tty lock
From: Yinghai Lu <yinghai@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 1:36 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, May 02, 2012 at 11:45:15AM +0100, Alan Cox wrote:
>> > It's mostly pretty "sane", but what is this:
>> >
>> > > +/*
>> > > + * Getting the big tty mutex for a pair of ttys with lock ordering
>> > > + * On a non pty/tty pair tty2 can be NULL which is just fine.
>> > > + */
>> > > +void __lockfunc tty_lock_pair(struct tty_struct *tty,
>> > > +                                 struct tty_struct *tty2)
>> > > +{
>> > > + if (tty < tty2) {
>> > > +         tty_lock(tty);
>> > > +         tty_lock(tty2);
>> > > + } else {
>> > > +         if (tty2 && tty2 != tty)
>> > > +                 tty_lock(tty2);
>> > > +         tty_lock(tty);
>> > > + }
>> > > +}
>> > > +EXPORT_SYMBOL(tty_lock_pair);
>> > > +
>> > > +void __lockfunc tty_unlock_pair(struct tty_struct *tty,
>> > > +                                         struct tty_struct *tty2)
>> > > +{
>> > > + tty_unlock(tty);
>> > > + if (tty2 && tty2 != tty)
>> > > +         tty_unlock(tty2);
>> > > +}
>> > > +EXPORT_SYMBOL(tty_unlock_pair);
>> >
>> > for?
>>
>> We need to take locks on a pair of tty devices at the same time in some
>> cases (pty/tty pairs).
>
> Ok.
>
>> > And what's with the comparing of pointers as "<"?  How portable is that
>> > really, and how are we supposed to control the memory location of these
>> > structures?
>>
>> You don't need to. The point is that we must lock any arbitrary pair of
>> tty structs in a defined order. Pointer comparisons work just fine for
>> this. The fs layer uses similar logic for inode locking. We only care
>> that for any given pair of objects the lock ordering is consistent.
>
> Ah, ok, that makes more sense, sorry, I didn't understand that.

looks like some patches from Alan in your tty-next cause dead look...


[ INFO: possible recursive locking detected ]
udevd (3502): /proc/3502/oom_adj is deprecated, please use
/proc/3502/oom_score_adj instead.
udevd version 128 started
3.4.0-rc6-yh-03495-g952810c-dirty #304 Not tainted
---------------------------------------------
boot.ipconfig/3484 is trying to acquire lock:
 (
&tty->legacy_mutex
){+.+.+.}
, at:
[<ffffffff81dc8fc6>] tty_lock+0x69/0x6d

but task is already holding lock:
 (
&tty->legacy_mutex
){+.+.+.}
, at:
[<ffffffff81dc8fc6>] tty_lock+0x69/0x6d

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(
&tty->legacy_mutex
);
  lock(
&tty->legacy_mutex
);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by boot.ipconfig/3484:
 #0:
 (
tty_mutex
){+.+.+.}
, at:
[<ffffffff81469a46>] tty_release+0x126/0x410
 #1:
 (
&tty->legacy_mutex
){+.+.+.}
, at:
[<ffffffff81dc8fc6>] tty_lock+0x69/0x6d

stack backtrace:
Pid: 3484, comm: boot.ipconfig Not tainted
3.4.0-rc6-yh-03495-g952810c-dirty #304
Call Trace:
 [<ffffffff810b2cac>] print_deadlock_bug+0xde/0xe9
 [<ffffffff810b2ddc>] check_deadlock.isra.15+0x125/0x149
 [<ffffffff810b4393>] validate_chain.isra.16+0x481/0x48b
 [<ffffffff810b66c8>] __lock_acquire+0x6e3/0x76c
 [<ffffffff81dc8fc6>] ? tty_lock+0x69/0x6d
 [<ffffffff810b6c5b>] lock_acquire+0xcb/0xf1
 [<ffffffff81dc8fc6>] ? tty_lock+0x69/0x6d
 [<ffffffff81dc64c8>] mutex_lock_nested+0x4c/0x2b4
 [<ffffffff81dc8fc6>] ? tty_lock+0x69/0x6d
 [<ffffffff810b4d91>] ? trace_hardirqs_on_caller+0xff/0x110
 [<ffffffff81dc8fc6>] ? tty_lock+0x69/0x6d
 [<ffffffff81dc8fc6>] tty_lock+0x69/0x6d
 [<ffffffff81dc9005>] tty_lock_pair+0x3b/0x40
 [<ffffffff81469a51>] tty_release+0x131/0x410
 [<ffffffff8114a4f8>] __fput+0xf3/0x1dd
 [<ffffffff8114a5fc>] fput+0x1a/0x1c
 [<ffffffff811470db>] filp_close+0x71/0x7c
 [<ffffffff8106d9ba>] close_files+0xa2/0xc9
 [<ffffffff8106d918>] ? exit_mm+0x115/0x115
 [<ffffffff8106eb93>] put_files_struct+0x22/0x94
 [<ffffffff81dc8e2a>] ? _raw_spin_unlock+0x29/0x2e
 [<ffffffff8106eca0>] exit_files+0x49/0x51
 [<ffffffff8106eef2>] do_exit+0x24a/0x361
 [<ffffffff810b4d91>] ? trace_hardirqs_on_caller+0xff/0x110
 [<ffffffff8106f1d1>] do_group_exit+0x88/0xb6
 [<ffffffff8106f216>] sys_exit_group+0x17/0x17
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
g952810c-dirty/modules.dep: No such file or directory

hwclock: With --noadjfile, you must specify either --utc or --localtime
                                                                     failed
Disabling IP forwarding                                              done
                                                                     done
Starting udevd:                                                      done
Loading drivers, configuring devices: ata_id[4471]: HDIO_GET_IDENTITY
failed for '/dev/.tmp-8-0'

                                                                     done
Loading required kernel modules                                      done
Activating device mapper...
FATAL: Could not load
/lib/modules/3.4.0-rc6-yh-03495-g952810c-dirty/modules.dep: mdadm:
sending ioctl 800c0910 to a partition!
mdadm: sending ioctl 800c0910 to a partition!
mdadm: sending ioctl 1261 to a partition!
No such file or mdadm: sending ioctl 1261 to a partition!
directory
dadm: sending ioctl 1261 to a partition!
?25l
dadm: sending ioctl 1261 to a partition!
[1;31mfailedmdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!

Startmdadm: sending ioctl 1261 to a partition!
ing MD Raid mdadm: sending ioctl 1261 to a partition!
                                                                     unused
Waiting for udev to settle...
Scanning for LVM volume groups...
File descriptor 3 left open
  Reading all phdevice: '9:0': device_unregister
PM: Removing info for No Bus:9:0
ysical volumes. device: '9:0': device_create_release
 This may take aPM: Removing info for No Bus:md0
 while...
Activating LVM volume groups...
File descriptor 3 left open
                                                                     done
Waiting for /firmware
microcode . no more events
Checking file systems...
fsck 1.41.1 (01-Sep-2008)
Checking all file systems.                                           done
                                                                     done
Mounting local file systems...
/proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
debugfs on /sys/kernel/debug type debugfs (rw)
udev on /dev type tmpfs (rw)
devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
/firmware on /lib/firmware type tmpfs (rw)
microcode on /usr/lib/microcode type tmpfs (rw)
done      evice: 'vcs4': device_addp-devices in /etc/fstab...
         done
PM: Adding info for No Bus:vcs4                                      done
device: 'vcsa4': device_addtc/ld.so.cache) using ldconfig            done
PM: Adding info for No Bus:vcsa4ca05-0a81e09e'
0D3ting up hostname 'sca05-0a81e09e'                                 done
device: 'vcs5': device_addace     lo
PM: Adding info for No Bus:vcs5.0.1/8
device: 'vcsa5': device_add27.0.0.2/8
PM: Adding info for No Bus:vcsa5                                     done
Starting D-Bus ddevice: 'vcs10': device_add                          set up
PM: Adding info for No Bus:vcs10                                 boot.md
device: 'vcsa10': device_add /etc/init.d/boot.local                  done
device: 'vcs7': device_addvcsa10
PM: Adding info for No Bus:vcs7yS0(/dev/console) at Wed May  9 18:00:37 2012
device: 'vcsa7': device_addvcs6us runlevel: N, device: 'vcs2': device_add
PM: Adding info for No Bus:vcsa7
PM: Adding info for No Bus:vcsa6
Initializing rdevice: 'vcs8': device_add
PM: Adding info for No Bus:vcs8 device_add
device: 'vcsa8': device_addvcs3
PM: Adding info for No Bus:vcsa8
andom number gendevice: 'vcs9': device_add
PM: Adding info for No Bus:vcs9
device: 'vcsa9': device_add
PM: Adding info for No Bus:vcsa9
device: 'vcs11': device_add
PM: Adding info for No Bus:vcs11
device: 'vcsa11': device_add
PM: Adding info for No Bus:vcsa11
device: 'vcs12': device_add
PM: Adding info for No Bus:vcs12
device: 'vcsa12': device_add
PM: Adding info for No Bus:vcsa12
done  device: 'vcs13': device_add
PM: Adding info for No Bus:vcs13
device: 'vcsa13': device_add
PM: Adding info for No Bus:vcsa13

device: 'vcs14': device_add
PM: Adding info for No Bus:vcs14
device: 'vcsa14': device_add
PM: Adding info for No Bus:vcsa14
Starting syslog device: 'vcs15': device_add
PM: Adding info for No Bus:vcs15
device: 'vcsa15': device_add
PM: Adding info for No Bus:vcsa15
servicesdevice: 'vcs16': device_add
PM: Adding info for No Bus:vcs16
device: 'vcsa16': device_add
PM: Adding info for No Bus:vcsa16

[1;3device: 'vcs17': device_add
PM: Adding info for No Bus:vcs17
device: 'vcsa17': device_add
PM: Adding info for No Bus:vcsa17
2mdone  [?2device: 'vcs18': device_add
PM: Adding info for No Bus:vcs18
device: 'vcsa18': device_add
PM: Adding info for No Bus:vcsa18
5h
device: 'vcs19': device_add
PM: Adding info for No Bus:vcs19
device: 'vcsa19': device_add
PM: Adding info for No Bus:vcsa19
device: 'vcs20': device_add
PM: Adding info for No Bus:vcs20
device: 'vcsa20': device_add
PM: Adding info for No Bus:vcsa20
device: 'vcs21': device_add
PM: Adding info for No Bus:vcs21
device: 'vcsa21': device_add
PM: Adding info for No Bus:vcsa21
device: 'vcs22': device_add
PM: Adding info for No Bus:vcs22
device: 'vcsa22': device_add
PM: Adding info for No Bus:vcsa22
device: 'vcs23': device_add
PM: Adding info for No Bus:vcs23
device: 'vcsa23': device_add
PM: Adding info for No Bus:vcsa23
device: 'vcs24': device_add
PM: Adding info for No Bus:vcs24
device: 'vcsa24': device_add
PM: Adding info for No Bus:vcsa24
Loading CPUFreq modules (CPUFreq not supported)
Starting HAL daemon                                                  done
Setting up (localfs) network interfaces:
    lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8                                done
    eth0      device: Intel Corporation I350 Gigabit Network Connection (rev 01)
              No configuration found for eth0                        unused
    eth1      device: Intel Corporation I350 Gigabit Network Connection (rev 01)
              No configuration found for eth1                        unused
    eth2      device: Intel Corporation Ethernet Controller 10 Gigabit
X540-AT2 (rev 01)
              No configuration found for eth2                        unused
    eth3      device: Intel Corporation Ethernet Controller 10 Gigabit
X540-AT2 (rev 01)
              No configuration found for eth3                        unused
    ib0       device: Mellanox Technologies MT26428 [ConnectX VPI PCIe
2.0 5GT/s - IB QDR / 10GigE] (rev b0)
              No configuration found for ib0                         unused
    ib1       device: Mellanox Technologies MT26428 [ConnectX VPI PCIe
2.0 5GT/s - IB QDR / 10GigE] (rev b0)
              No configuration found for ib1                         unused
    usb0
              No configuration found for usb0                        unused
Setting up service (localfs) network  .  .  .  .  .  .  .  .  .  .   done
Starting RPC portmap daemon                                          done
Setting up (remotefs) network interfaces:
Setting up service (remotefs) network  .  .  .  .  .  .  .  .  .  .  done
Master Resource Control: runlevel 3 has been                         reached
INFO: task ifup:6216 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ifup            D ffffffff8262c3b8     0  6216      1 0x00000000
 ffff880271b97c28 0000000000000046 ffff88026f88a260 ffff880271b97fd8
 0000000000004000 00000000001d2a00 ffff880178dcc4c0 ffff88026f88a260
 0000000000000001 ffff88017723c4c0 ffff88026f88a260 ffff88026f88a260
Call Trace:
 [<ffffffff81dc8e67>] ? _raw_spin_unlock_irqrestore+0x38/0x46
 [<ffffffff810b1ecc>] ? trace_hardirqs_off_caller+0x1f/0x10e
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff810b5819>] ? __lock_contended+0x38/0x263
 [<ffffffff81dc65f8>] ? mutex_lock_nested+0x17c/0x2b4
 [<ffffffff81dc79f8>] schedule+0x64/0x66
 [<ffffffff81dc7c5c>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81dc6600>] mutex_lock_nested+0x184/0x2b4
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff810b4ca8>] ? trace_hardirqs_on_caller+0x16/0x110
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff81469a46>] tty_release+0x126/0x410
 [<ffffffff8114a4f8>] __fput+0xf3/0x1dd
 [<ffffffff8114a5fc>] fput+0x1a/0x1c
 [<ffffffff811470db>] filp_close+0x71/0x7c
 [<ffffffff8106d9ba>] close_files+0xa2/0xc9
 [<ffffffff8106d918>] ? exit_mm+0x115/0x115
 [<ffffffff8106eb93>] put_files_struct+0x22/0x94
 [<ffffffff81dc8e2a>] ? _raw_spin_unlock+0x29/0x2e
 [<ffffffff8106eca0>] exit_files+0x49/0x51
 [<ffffffff8106eef2>] do_exit+0x24a/0x361
 [<ffffffff810b4ca8>] ? trace_hardirqs_on_caller+0x16/0x110
 [<ffffffff8106f1d1>] do_group_exit+0x88/0xb6
 [<ffffffff8106f216>] sys_exit_group+0x17/0x17
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task startpar:6270 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
startpar        D ffffffff8262c3b8     0  6270      1 0x00000000
 ffff8801775e9c28 0000000000000046 0000000000000246 ffff8801775e9fd8
 0000000000004000 00000000001d2a00 ffff880178dca260 ffff88017723c4c0
 ffff8801775e9bc8 0000000000000046 0000000000000000 ffff88017723c4c0
Call Trace:
 [<ffffffff81dc8e6e>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff810b5819>] ? __lock_contended+0x38/0x263
 [<ffffffff81dc65f8>] ? mutex_lock_nested+0x17c/0x2b4
 [<ffffffff81dc79f8>] schedule+0x64/0x66
 [<ffffffff81dc7c5c>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81dc6600>] mutex_lock_nested+0x184/0x2b4
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff810b4ca8>] ? trace_hardirqs_on_caller+0x16/0x110
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff81469a46>] tty_release+0x126/0x410
 [<ffffffff8112501b>] ? remove_vma+0x6e/0x76
 [<ffffffff8114a4f8>] __fput+0xf3/0x1dd
 [<ffffffff8114a5fc>] fput+0x1a/0x1c
 [<ffffffff811470db>] filp_close+0x71/0x7c
 [<ffffffff8106d9ba>] close_files+0xa2/0xc9
 [<ffffffff8106d918>] ? exit_mm+0x115/0x115
 [<ffffffff8106eb93>] put_files_struct+0x22/0x94
 [<ffffffff81dc8e2a>] ? _raw_spin_unlock+0x29/0x2e
 [<ffffffff8106eca0>] exit_files+0x49/0x51
 [<ffffffff8106eef2>] do_exit+0x24a/0x361
 [<ffffffff810b4ca8>] ? trace_hardirqs_on_caller+0x16/0x110
 [<ffffffff8106f1d1>] do_group_exit+0x88/0xb6
 [<ffffffff8106f216>] sys_exit_group+0x17/0x17
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task blogd:6290 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
blogd           D ffff880265e870e0     0  6290      1 0x00000000
 ffff880272a61b48 0000000000000046 ffff880272a61a58 ffff880272a61fd8
 0000000000004000 00000000001d2a00 ffffffff825b9410 ffff880272e2a260
 ffff880272a61b38 ffff880272e2a260 0000000000000000 ffffffff81082fb7
Call Trace:
 [<ffffffff81082fb7>] ? wait_on_cpu_work+0x2f/0x97
 [<ffffffff81dc8fc6>] ? tty_lock+0x69/0x6d
 [<ffffffff810b5819>] ? __lock_contended+0x38/0x263
 [<ffffffff81dc65f8>] ? mutex_lock_nested+0x17c/0x2b4
 [<ffffffff81dc79f8>] schedule+0x64/0x66
 [<ffffffff81dc7c5c>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81dc6600>] mutex_lock_nested+0x184/0x2b4
 [<ffffffff81dc8fc6>] ? tty_lock+0x69/0x6d
 [<ffffffff810b4ca8>] ? trace_hardirqs_on_caller+0x16/0x110
 [<ffffffff81dc8fc6>] ? tty_lock+0x69/0x6d
 [<ffffffff81dc8fc6>] tty_lock+0x69/0x6d
 [<ffffffff81dc9005>] tty_lock_pair+0x3b/0x40
 [<ffffffff81469a51>] tty_release+0x131/0x410
 [<ffffffff81dc8e6e>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
 [<ffffffff8114a4f8>] __fput+0xf3/0x1dd
 [<ffffffff8114a5fc>] fput+0x1a/0x1c
 [<ffffffff814690b1>] __tty_hangup+0x321/0x330
 [<ffffffff814690e5>] tty_vhangup+0xe/0x10
 [<ffffffff81470e84>] pty_close+0x13d/0x142
 [<ffffffff81469a06>] tty_release+0xe6/0x410
 [<ffffffff8146ebac>] ? put_ldisc+0xb4/0xb9
 [<ffffffff8114a4f8>] __fput+0xf3/0x1dd
 [<ffffffff8114a5fc>] fput+0x1a/0x1c
 [<ffffffff811470db>] filp_close+0x71/0x7c
 [<ffffffff8114717d>] sys_close+0x97/0xd9
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task ifup:6951 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ifup            D ffffffff8262c3b8     0  6951      1 0x00000000
 ffff8802709d1c28 0000000000000046 ffff88026bb12260 ffff8802709d1fd8
 0000000000004000 00000000001d2a00 ffff880178dcc4c0 ffff88026bb12260
 0000000000000001 ffff8802709a8000 ffff88026bb12260 ffff88026bb12260
Call Trace:
 [<ffffffff81dc8e67>] ? _raw_spin_unlock_irqrestore+0x38/0x46
 [<ffffffff810b1ecc>] ? trace_hardirqs_off_caller+0x1f/0x10e
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff810b5819>] ? __lock_contended+0x38/0x263
 [<ffffffff81dc65f8>] ? mutex_lock_nested+0x17c/0x2b4
 [<ffffffff81dc79f8>] schedule+0x64/0x66
 [<ffffffff81dc7c5c>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81dc6600>] mutex_lock_nested+0x184/0x2b4
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff810b4ca8>] ? trace_hardirqs_on_caller+0x16/0x110
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff81469a46>] tty_release+0x126/0x410
 [<ffffffff8114a4f8>] __fput+0xf3/0x1dd
 [<ffffffff8114a5fc>] fput+0x1a/0x1c
 [<ffffffff811470db>] filp_close+0x71/0x7c
 [<ffffffff8106d9ba>] close_files+0xa2/0xc9
 [<ffffffff8106d918>] ? exit_mm+0x115/0x115
 [<ffffffff8106eb93>] put_files_struct+0x22/0x94
 [<ffffffff81dc8e2a>] ? _raw_spin_unlock+0x29/0x2e
 [<ffffffff8106eca0>] exit_files+0x49/0x51
 [<ffffffff8106eef2>] do_exit+0x24a/0x361
 [<ffffffff810b4ca8>] ? trace_hardirqs_on_caller+0x16/0x110
 [<ffffffff8106f1d1>] do_group_exit+0x88/0xb6
 [<ffffffff8106f216>] sys_exit_group+0x17/0x17
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task startpar:6990 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
startpar        D ffffffff8262c3b8     0  6990      1 0x00000000
 ffff88026a58dc28 0000000000000046 0000000000000246 ffff88026a58dfd8
 0000000000004000 00000000001d2a00 ffff880178da44c0 ffff8802709a8000
 ffff88026a58dbc8 0000000000000046 0000000000000000 ffff8802709a8000
Call Trace:
 [<ffffffff81dc8e6e>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff810b5819>] ? __lock_contended+0x38/0x263
 [<ffffffff81dc65f8>] ? mutex_lock_nested+0x17c/0x2b4
 [<ffffffff81dc79f8>] schedule+0x64/0x66
 [<ffffffff81dc7c5c>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81dc6600>] mutex_lock_nested+0x184/0x2b4
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff810b4ca8>] ? trace_hardirqs_on_caller+0x16/0x110
 [<ffffffff81469a46>] ? tty_release+0x126/0x410
 [<ffffffff81469a46>] tty_release+0x126/0x410
 [<ffffffff8112501b>] ? remove_vma+0x6e/0x76
 [<ffffffff8114a4f8>] __fput+0xf3/0x1dd
 [<ffffffff8114a5fc>] fput+0x1a/0x1c
 [<ffffffff811470db>] filp_close+0x71/0x7c
 [<ffffffff8106d9ba>] close_files+0xa2/0xc9
 [<ffffffff8106d918>] ? exit_mm+0x115/0x115
 [<ffffffff8106eb93>] put_files_struct+0x22/0x94
 [<ffffffff81dc8e2a>] ? _raw_spin_unlock+0x29/0x2e
 [<ffffffff8106eca0>] exit_files+0x49/0x51
 [<ffffffff8106eef2>] do_exit+0x24a/0x361
 [<ffffffff810b4ca8>] ? trace_hardirqs_on_caller+0x16/0x110
 [<ffffffff8106f1d1>] do_group_exit+0x88/0xb6
 [<ffffffff8106f216>] sys_exit_group+0x17/0x17
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task init:7164 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
init            D ffffffff8262c3b8     0  7164      1 0x00000000
 ffff88017871fb28 0000000000000046 0000000000000000 ffff88017871ffd8
 0000000000004000 00000000001d2a00 ffff880178e2a260 ffff880176768000
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff810b5819>] ? __lock_contended+0x38/0x263
 [<ffffffff81dc65f8>] ? mutex_lock_nested+0x17c/0x2b4
 [<ffffffff81dc79f8>] schedule+0x64/0x66
 [<ffffffff81dc7c5c>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81dc6600>] mutex_lock_nested+0x184/0x2b4
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff81469dab>] tty_open+0x7b/0x386
 [<ffffffff8114c896>] ? chrdev_open+0xdd/0x14a
 [<ffffffff8114c8da>] chrdev_open+0x121/0x14a
 [<ffffffff81149be5>] ? files_lglock_local_unlock+0x21/0x36
 [<ffffffff8114c7b9>] ? cdev_put+0x26/0x26
 [<ffffffff811475f6>] __dentry_open.isra.14+0x180/0x2a6
 [<ffffffff811482a7>] nameidata_to_filp+0x48/0x4f
 [<ffffffff81155613>] do_last.isra.31+0x49e/0x541
 [<ffffffff811557bd>] path_openat+0xd4/0x348
 [<ffffffff81dcc3a3>] ? do_page_fault+0x3b3/0x40a
 [<ffffffff811601c5>] ? alloc_fd+0x3c/0xfe
 [<ffffffff81155b35>] do_filp_open+0x38/0x86
 [<ffffffff81dc8e2a>] ? _raw_spin_unlock+0x29/0x2e
 [<ffffffff81160275>] ? alloc_fd+0xec/0xfe
 [<ffffffff811483b3>] do_sys_open+0x105/0x19e
 [<ffffffff8114846d>] sys_open+0x21/0x23
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task init:7165 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
init            D ffffffff8262c3b8     0  7165      1 0x00000000
 ffff88017742fb28 0000000000000046 ffffea0009fcbe40 ffff88017742ffd8
 0000000000004000 00000000001d2a00 ffff880178e2a260 ffff88017676a260
 ffffea0009fcbe40 0000000000000000 ffff88027fbfae80 0000000000000000
Call Trace:
 [<ffffffff81109660>] ? get_page_from_freelist+0x40f/0x4b8
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff810b5819>] ? __lock_contended+0x38/0x263
 [<ffffffff81dc65f8>] ? mutex_lock_nested+0x17c/0x2b4
 [<ffffffff81dc79f8>] schedule+0x64/0x66
 [<ffffffff81dc7c5c>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81dc6600>] mutex_lock_nested+0x184/0x2b4
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff81469dab>] tty_open+0x7b/0x386
 [<ffffffff8114c896>] ? chrdev_open+0xdd/0x14a
 [<ffffffff8114c8da>] chrdev_open+0x121/0x14a
 [<ffffffff81149be5>] ? files_lglock_local_unlock+0x21/0x36
 [<ffffffff8114c7b9>] ? cdev_put+0x26/0x26
 [<ffffffff811475f6>] __dentry_open.isra.14+0x180/0x2a6
 [<ffffffff811482a7>] nameidata_to_filp+0x48/0x4f
 [<ffffffff81155613>] do_last.isra.31+0x49e/0x541
 [<ffffffff811557bd>] path_openat+0xd4/0x348
 [<ffffffff81dcc3a3>] ? do_page_fault+0x3b3/0x40a
 [<ffffffff811601c5>] ? alloc_fd+0x3c/0xfe
 [<ffffffff81155b35>] do_filp_open+0x38/0x86
 [<ffffffff81dc8e2a>] ? _raw_spin_unlock+0x29/0x2e
 [<ffffffff81160275>] ? alloc_fd+0xec/0xfe
 [<ffffffff811483b3>] do_sys_open+0x105/0x19e
 [<ffffffff8114846d>] sys_open+0x21/0x23
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task init:7166 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
init            D ffffffff8262c3b8     0  7166      1 0x00000000
 ffff88016574fb28 0000000000000046 0000000000000246 ffff88016574ffd8
 0000000000004000 00000000001d2a00 ffff880178e2a260 ffff88017676c4c0
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81109d6f>] ? __alloc_pages_nodemask+0x1ea/0x826
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff810b5819>] ? __lock_contended+0x38/0x263
 [<ffffffff81dc65f8>] ? mutex_lock_nested+0x17c/0x2b4
 [<ffffffff81dc79f8>] schedule+0x64/0x66
 [<ffffffff81dc7c5c>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81dc6600>] mutex_lock_nested+0x184/0x2b4
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff81469dab>] tty_open+0x7b/0x386
 [<ffffffff8114c896>] ? chrdev_open+0xdd/0x14a
 [<ffffffff8114c8da>] chrdev_open+0x121/0x14a
 [<ffffffff81149be5>] ? files_lglock_local_unlock+0x21/0x36
 [<ffffffff8114c7b9>] ? cdev_put+0x26/0x26
 [<ffffffff811475f6>] __dentry_open.isra.14+0x180/0x2a6
 [<ffffffff811482a7>] nameidata_to_filp+0x48/0x4f
 [<ffffffff81155613>] do_last.isra.31+0x49e/0x541
 [<ffffffff811557bd>] path_openat+0xd4/0x348
 [<ffffffff811601c5>] ? alloc_fd+0x3c/0xfe
 [<ffffffff81155b35>] do_filp_open+0x38/0x86
 [<ffffffff81dc8e2a>] ? _raw_spin_unlock+0x29/0x2e
 [<ffffffff81160275>] ? alloc_fd+0xec/0xfe
 [<ffffffff811483b3>] do_sys_open+0x105/0x19e
 [<ffffffff8114846d>] sys_open+0x21/0x23
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task init:7167 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
init            D ffffffff8262c3b8     0  7167      1 0x00000000
 ffff880165437b28 0000000000000046 ffffea0009768300 ffff880165437fd8
 0000000000004000 00000000001d2a00 ffff880178e2a260 ffff8801767c2260
 ffffea0009768300 0000000000000000 ffff88027fbfae80 0000000000000000
Call Trace:
 [<ffffffff81109660>] ? get_page_from_freelist+0x40f/0x4b8
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff810b5819>] ? __lock_contended+0x38/0x263
 [<ffffffff81dc65f8>] ? mutex_lock_nested+0x17c/0x2b4
 [<ffffffff81dc79f8>] schedule+0x64/0x66
 [<ffffffff81dc7c5c>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81dc6600>] mutex_lock_nested+0x184/0x2b4
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff81469dab>] tty_open+0x7b/0x386
 [<ffffffff8114c896>] ? chrdev_open+0xdd/0x14a
 [<ffffffff8114c8da>] chrdev_open+0x121/0x14a
 [<ffffffff81149be5>] ? files_lglock_local_unlock+0x21/0x36
 [<ffffffff8114c7b9>] ? cdev_put+0x26/0x26
 [<ffffffff811475f6>] __dentry_open.isra.14+0x180/0x2a6
 [<ffffffff811482a7>] nameidata_to_filp+0x48/0x4f
 [<ffffffff81155613>] do_last.isra.31+0x49e/0x541
 [<ffffffff811557bd>] path_openat+0xd4/0x348
 [<ffffffff81dcc3a3>] ? do_page_fault+0x3b3/0x40a
 [<ffffffff811601c5>] ? alloc_fd+0x3c/0xfe
 [<ffffffff81155b35>] do_filp_open+0x38/0x86
 [<ffffffff81dc8e2a>] ? _raw_spin_unlock+0x29/0x2e
 [<ffffffff81160275>] ? alloc_fd+0xec/0xfe
 [<ffffffff811483b3>] do_sys_open+0x105/0x19e
 [<ffffffff8114846d>] sys_open+0x21/0x23
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task init:7168 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
init            D ffffffff8262c3b8     0  7168      1 0x00000000
 ffff8801657f1b28 0000000000000046 0000000000000246 ffff8801657f1fd8
 0000000000004000 00000000001d2a00 ffff880178e2a260 ffff8801767c0000
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81109d6f>] ? __alloc_pages_nodemask+0x1ea/0x826
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff810b5819>] ? __lock_contended+0x38/0x263
 [<ffffffff81dc65f8>] ? mutex_lock_nested+0x17c/0x2b4
 [<ffffffff81dc79f8>] schedule+0x64/0x66
 [<ffffffff81dc7c5c>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81dc6600>] mutex_lock_nested+0x184/0x2b4
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff81469dab>] ? tty_open+0x7b/0x386
 [<ffffffff81469dab>] tty_open+0x7b/0x386
 [<ffffffff8114c896>] ? chrdev_open+0xdd/0x14a
 [<ffffffff8114c8da>] chrdev_open+0x121/0x14a
 [<ffffffff81149be5>] ? files_lglock_local_unlock+0x21/0x36
 [<ffffffff8114c7b9>] ? cdev_put+0x26/0x26
 [<ffffffff811475f6>] __dentry_open.isra.14+0x180/0x2a6
 [<ffffffff811482a7>] nameidata_to_filp+0x48/0x4f
 [<ffffffff81155613>] do_last.isra.31+0x49e/0x541
 [<ffffffff811557bd>] path_openat+0xd4/0x348
 [<ffffffff81dcc3a3>] ? do_page_fault+0x3b3/0x40a
 [<ffffffff811601c5>] ? alloc_fd+0x3c/0xfe
 [<ffffffff81155b35>] do_filp_open+0x38/0x86
 [<ffffffff81dc8e2a>] ? _raw_spin_unlock+0x29/0x2e
 [<ffffffff81160275>] ? alloc_fd+0xec/0xfe
 [<ffffffff811483b3>] do_sys_open+0x105/0x19e
 [<ffffffff8114846d>] sys_open+0x21/0x23
 [<ffffffff81dcfd52>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
