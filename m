Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1FGO1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:27:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50147 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab1FGO06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:26:58 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimEf5VD5ynZam3tKUbBv7gAe6a52w@mail.gmail.com>
References: <BANLkTi=jHc_Ntx+s+3BOOj9QfpCSqqeTBw@mail.gmail.com>
	<BANLkTimEf5VD5ynZam3tKUbBv7gAe6a52w@mail.gmail.com>
Date: Tue, 7 Jun 2011 16:26:57 +0200
Message-ID: <BANLkTikAHL_m6zC4aD_fU1zCY5FxsXjp0g@mail.gmail.com>
Subject: Re: Invalid credentials ( __validate_creds()) due to cred->magic ==
 "DeaD" from sys_clone() (2.6.39 PREEMPT SMP SELinux kernel)
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another BUG(), a quite obvious use-after-free - still trying to create
a reproductible testcase.


=== KDB ===
Stack traceback for pid 28120
0xffff8800cba32ee0    28120    15501  1    1   R  0xffff8800cba33360 *iknowthis
<c> ffff8800cba3dea8<c> 0000000000000018<c> ffffffff810b6f16<c>
ffff880000000104<c>
<c> ffffffff8267436f<c> ffff88010367bf00<c> ffff88010367bf00<c>
ffff8800cba3def8<c>
<c> ffffffff810b6f48<c> ffff880000000104<c> ffffffff8267436f<c>
ffff8800cba3def8<c>
Call Trace:
 [<ffffffff810b6f16>] ? __invalid_creds+0x53/0x55
 [<ffffffff810b6f48>] ? __validate_creds+0x30/0x37
 [<ffffffff810b6fa2>] ? put_cred+0x22/0x3a
 [<ffffffff810b7463>] ? commit_creds+0x1d3/0x1de
 [<ffffffff810a8ea4>] ? sys_setgid+0x75/0x8d
 [<ffffffff81edab82>] ? system_call_fastpath+0x16/0x1b

[1]kdb> summary
sysname    Linux
release    2.6.39
version    #3 SMP PREEMPT Fri May 27 15:27:03 CEST 2011
machine    x86_64
nodename   ise-test
domainname (none)
ccversion  CCVERSION
date       2011-06-07 01:56:05 tz_minuteswest -120
uptime     13:11
load avg   14.40 14.63 16.68

MemTotal:         993059 kB
MemFree:          485955 kB
Buffers:           20849 kB

DMESG:
<3>[47480.305640] CRED: Invalid credentials
<3>[47480.315628] CRED: At include/linux/cred.h:260
<3>[47480.320595] CRED: Specified credentials: ffff88010367bf00
<3>[47480.326668] CRED: ->magic=6b6b6b6b, put_addr=6b6b6b6b6b6b6b6b
<3>[47480.333593] CRED: ->usage=1802201963, subscr=1802201963
<3>[47480.339812] CRED: ->*uid = { 1802201963,1802201963,1802201963,1802201963 }
<3>[47480.347490] CRED: ->*gid = { 1802201963,1802201963,1802201963,1802201963 }
<3>[47480.354947] CRED: ->security is 6b6b6b6b6b6b6b6b

=== KGDB ===
(gdb) bt
#0  __invalid_creds (cred=0xffff88010367bf00, file=<value optimized
out>, line=<value optimized out>)
   at kernel/cred.c:812
#1  0xffffffff810b6f48 in __validate_creds (cred=0xffff88010367bf00,
file=<value optimized out>,
    line=<value optimized out>) at include/linux/cred.h:186
#2  0xffffffff810b6fa2 in put_cred (_cred=<value optimized out>) at
include/linux/cred.h:260
#3  0xffffffff810b7463 in commit_creds (new=0xffff88011aeda200) at
kernel/cred.c:540
#4  0xffffffff810a8ea4 in sys_setgid (gid=65534) at kernel/sys.c:577
#5  <signal handler called>
#6  0x00007ff2b4b78649 in __brk_reservation_fn_dmi_alloc__ ()
#7  0xffff880118cd1770 in __brk_reservation_fn_dmi_alloc__ ()
#8  0xffffffff82a1bed0 in ?? ()
#9  0x0000000200020000 in __brk_reservation_fn_dmi_alloc__ ()
#10 0x0000000300000000 in __brk_reservation_fn_dmi_alloc__ ()
#11 0x00007ffffffff000 in __brk_reservation_fn_dmi_alloc__ ()
#12 0xffffffff810a7406 in sys_restart_syscall () at kernel/signal.c:2085
#13 0x0000000000000000 in ?? ()

[4 frames up]

#4  0xffffffff810a8ea4 in sys_setgid (gid=65534) at kernel/sys.c:577
577		return commit_creds(new);

(gdb) p *old
$1 = {usage = {counter = 1802201963}, subscribers = {counter =
1802201963}, put_addr = 0x6b6b6b6b6b6b6b6b,
  magic = 1802201963, uid = 1802201963, gid = 1802201963, suid =
1802201963, sgid = 1802201963, euid = 1802201963,
  egid = 1802201963, fsuid = 1802201963, fsgid = 1802201963,
securebits = 1802201963, cap_inheritable = {cap = {
      1802201963, 1802201963}}, cap_permitted = {cap = {1802201963,
1802201963}}, cap_effective = {cap = {1802201963,
      1802201963}}, cap_bset = {cap = {1802201963, 1802201963}},
jit_keyring = 107 'k',
  thread_keyring = 0x6b6b6b6b6b6b6b6b, request_key_auth =
0x6b6b6b6b6b6b6b6b, tgcred = 0x6b6b6b6b6b6b6b6b,
  security = 0x6b6b6b6b6b6b6b6b, user = 0x6b6b6b6b6b6b6b6b, user_ns =
0x6b6b6b6b6b6b6b6b,
  group_info = 0x6b6b6b6b6b6b6b6b, rcu = {next = 0x6b6b6b6b6b6b6b6b,
func = 0xa56b6b6b6b6b6b6b}}


(gdb) p *new
$2 = {usage = {counter = 2}, subscribers = {counter = 2}, put_addr =
0x0, magic = 1131636068, uid = 65534,
  gid = 65534, suid = 65534, sgid = 65534, euid = 65534, egid = 65534,
fsuid = 65534, fsgid = 65534, securebits = 0,
  cap_inheritable = {cap = {0, 0}}, cap_permitted = {cap = {0, 0}},
cap_effective = {cap = {0, 0}}, cap_bset = {cap = {
      4294967295, 4294967295}}, jit_keyring = 0 '\000', thread_keyring
= 0x0, request_key_auth = 0x0,
  tgcred = 0xffff880101adce58, security = 0xffff8801146fb340, user =
0xffff88011fcc7240, user_ns = 0xffffffff82a21a80,
  group_info = 0xffff8800cb9fa000, rcu = {next = 0x0, func = 0}}


-- 
Robert Święcki
