Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab0E0OpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:45:13 -0400
Received: from snt0-omc1-s28.snt0.hotmail.com ([65.55.90.39]:14872 "EHLO
	snt0-omc1-s28.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608Ab0E0OpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:45:10 -0400
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS950CCF6E91293F5E19DF3A7EA0@phx.gbl>
From: "limp" <johnkyr83@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Cannot remove IRQ0 or replace its handler after the system has been booted. 
Date: Thu, 27 May 2010 15:44:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acr9qyfFcZcKonyMRReF5uVfmfT1ZA==
Content-Language: en-gb
X-OriginalArrivalTime: 27 May 2010 14:45:10.0271 (UTC) FILETIME=[34EDB8F0:01CAFDAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am trying to replace the handler of IRQ0 (that is PIT timer) with my
handler but I am having difficulties when I am trying to free IRQ0. At the
time at which I am trying to do that, IRQ0 is not being used at all as LAPIC
timer has been started (IRQ0 has been stalled) but the kernel hasn't freed
it.

After doing an investigation on the kernel source, I found out that no
dev_id is being set for IRQ0, so I've setup my own dev_id for it and tried
to remove it by writing a module that calls free_irq() using this dev_id as
a second parameter like that: free_irq(0, IRQ0_dev);

When I am inserting my module, I am getting that:

[  210.784539] init_module() called
[  210.785534] ------------[ cut here ]------------
[  210.786522] kernel BUG at mm/slub.c:2929!
[  210.786522] invalid opcode: 0000 [#1]
[  210.786522] last sysfs file:
[  210.786522] Modules linked in: request_irq(+) [last unloaded:
hpet_per_smis]
[  210.786522]
[  210.786522] Pid: 782, comm: insmod Tainted: G        W  (2.6.31.6 #69)
Bochs
[  210.786522] EIP: 0060:[<c1084d64>] EFLAGS: 00010246 CPU: 0
[  210.786522] EIP is at kfree+0x59/0xb3
[  210.786522] EAX: c17d5540 EBX: dfff64e8 ECX: 00010000 EDX: 40000400
[  210.786522] ESI: c162a364 EDI: c105317a EBP: debf7f74 ESP: debf7f68
[  210.786522]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  210.786522] Process insmod (pid: 782, ti=debf6000 task=de852b50
task.ti=debf6000)
[  210.786522] Stack:
[  210.786522]  dfff64e8 00000000 dfff6033 debf7f7c c105317a debf7f84
dfff6057 debf7f9c
[  210.786522] <0> c1001133 00000000 dfff64e8 00000000 00000020 debf7fac
c103f774 087c56e0
[  210.786522] <0> bfe44f3a debf6000 c1002da5 087c56e0 00000b72 087c56c8
bfe44f3a 00000020
[  210.786522] Call Trace:
[  210.786522]  [<dfff6033>] ? init_module+0x0/0x71 [request_irq]
[  210.786522]  [<c105317a>] ? free_irq+0xd/0xf
[  210.786522]  [<dfff6057>] ? init_module+0x24/0x71 [request_irq]
[  210.786522]  [<c1001133>] ? do_one_initcall+0x4b/0x130
[  210.786522]  [<c103f774>] ? sys_init_module+0xa7/0x1b7
[  210.786522]  [<c1002da5>] ? syscall_call+0x7/0xb
[  210.786522] Code: 10 76 7a 8d 86 00 00 00 40 c1 e8 0c c1 e0 05 03 05 d4
65 78 c1 66 83 38 00 79 03 8b 40 0c 8b 10 84 d2 78 12 66 f7 c2 00 c0 75 04
<0f> 0b eb fe e8 3d 73 fe ff eb 47 8b 55 04 8b 58 0c 9c 5f fa 3b
[  210.786522] EIP: [<c1084d64>] kfree+0x59/0xb3 SS:ESP 0068:debf7f68
[  210.786524] ---[ end trace 2516b27218338232 ]---
Segmentation fault

If I check /proc/interrupts after that, the devname of IRQ0 which was
"timer" has been disappeared: 

# cat /proc/interrupts
           CPU0
  0:      34455   IO-APIC-edge 

Can anyone advise me on how to remove IRQ0 so that I can then call
request_irq() to set it to use my handler?

Thanks in advance.
 
P.S. please CC me.

-John K.

