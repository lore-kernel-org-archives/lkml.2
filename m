Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1IVRjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:39:24 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:36595
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021Ab1IVRjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:39:22 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK9371K1432N98dKzz1202hzz8275bhz2fh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E7B72B7.60105@am.sony.com>
Date: Thu, 22 Sep 2011 10:39:03 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Dongdong Deng <libfetion@gmail.com>
CC: Jason Wessel <jason.wessel@windriver.com>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Kgdb-bugreport] [PATCH] kdb: Avoid using dbg_io_ops until it
 is initialized
References: <4E7A46C0.6010804@am.sony.com>  <CAGn38=3WmX0rORerbCapDSD5Gu4tg-Un3ROKpXtrs1DPyqDeFw@mail.gmail.com>
In-Reply-To: <CAGn38=3WmX0rORerbCapDSD5Gu4tg-Un3ROKpXtrs1DPyqDeFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 07:52 PM, Dongdong Deng wrote:
> On Thu, Sep 22, 2011 at 4:19 AM, Tim Bird <tim.bird@am.sony.com> wrote:
>> This fixes a bug with setting a breakpoint during kdb initialization
>> (from kdb_cmds).  Any call to kdb_printf() before the initialization
>> of the kgdboc serial console driver (which happens much later during
>> bootup than kdb_init), results in kernel panic due to the use of
>> dbg_io_ops before it is initialized.
> 
> 
> Did you get the panic for that case?

Yes.  See below (without the patch):

[    0.009552] BUG: unable to handle kernel NULL pointer dereference at 0000001c
[    0.009999] IP: [<c109112f>] vkdb_printf+0xef/0x690
[    0.009999] *pde = 00000000
[    0.009999] Oops: 0000 [#1] SMP
[    0.009999] Modules linked in:
[    0.009999]
[    0.009999] Pid: 0, comm: swapper Not tainted 3.1.0-rc2+ #10                  /D865PERL
[    0.009999] EIP: 0060:[<c109112f>] EFLAGS: 00010002 CPU: 0
[    0.009999] EIP is at vkdb_printf+0xef/0x690
[    0.009999] EAX: 00000000 EBX: c18d06c0 ECX: 0000000f EDX: 00000001
[    0.009999] ESI: 0000000f EDI: c184cd2a EBP: c18adee0 ESP: c18ade70
[    0.009999]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.009999] Process swapper (pid: 0, ti=c18ac000 task=c18b1fa0 task.ti=c18ac000)
[    0.009999] Stack:
[    0.009999]  c18adef8 c18adeb8 c105ecc2 007a6bc8 00000000 00000202 209db643 00000000
[    0.009999]  c18adeb0 00000000 017f5762 c17f5764 c18adebc c18adf40 00000000 c19db643
[    0.009999]  c18adf08 c1094040 c17f5767 c18adf00 c18adecc c19db720 00000001 00000000
[    0.009999] Call Trace:
[    0.009999]  [<c105ecc2>] ? sched_clock_local+0xb2/0x190
[    0.009999]  [<c1094040>] ? kdbgetaddrarg+0x80/0x220
[    0.009999]  [<c10916de>] kdb_printf+0xe/0x10
[    0.009999]  [<c1097bc9>] kdb_printbp+0x39/0xc0
[    0.009999]  [<c111cd30>] ? sync_one_sb+0x20/0x20
[    0.009999]  [<c1097e25>] kdb_bp+0x1d5/0x260
[    0.009999]  [<c111cd30>] ? sync_one_sb+0x20/0x20
[    0.009999]  [<c1094ecd>] kdb_parse+0x2ed/0x630
[    0.009999]  [<c1097950>] ? kdb_bt+0x3b0/0x3b0
[    0.009999]  [<c1913208>] ? kdb_initbptab+0x188/0x18e
[    0.009999]  [<c191301b>] kdb_init+0x5d2/0x637
[    0.009999]  [<c19129f1>] dbg_late_init+0x22/0x24
[    0.009999]  [<c18fd7a3>] start_kernel+0x2a8/0x2ea
[    0.009999]  [<c18fd325>] ? kernel_init+0x13a/0x13a
[    0.009999]  [<c18fd0b3>] i386_start_kernel+0xb3/0xbb
[    0.009999] Code: 00 c6 45 ab 20 c7 45 ac 00 00 00 00 b8 e0 b3 9d c1 e8 76 7a 18 00 8b 15 44 b8 8b c1 85 d2 89 c6 0f 84 1
6 01 00 00 a1 74 65 9d c1 <8b> 78 1c 85 ff 75 19 e9 b3 02 00 00 90 8d 74 26 00 89 d8 89 f1
[    0.009999] EIP: [<c109112f>] vkdb_printf+0xef/0x690 SS:ESP 0068:c18ade70
[    0.009999] CR2: 000000000000001c
[    0.009999] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.009999] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.009999] Pid: 0, comm: swapper Tainted: G      D     3.1.0-rc2+ #10
[    0.009999] Call Trace:
[    0.009999]  [<c160a2f7>] panic+0x57/0x157
[    0.009999]  [<c103ea2b>] do_exit+0x6ab/0x7a0
[    0.009999]  [<c103d2e7>] ? kmsg_dump+0x37/0xc0
[    0.009999]  [<c160a41f>] ? printk+0x28/0x2a
[    0.009999]  [<c160dc45>] oops_end+0x85/0xc0
[    0.009999]  [<c1023ede>] no_context+0xbe/0x150
[    0.009999]  [<c1024000>] __bad_area_nosemaphore+0x90/0x140
[    0.009999]  [<c1041887>] ? irq_exit+0x57/0x90
[    0.009999]  [<c10039d6>] ? do_IRQ+0x46/0xb0
[    0.009999]  [<c160f590>] ? spurious_fault+0xd0/0xd0
[    0.009999]  [<c10240c2>] bad_area_nosemaphore+0x12/0x20
[    0.009999]  [<c160f869>] do_page_fault+0x2d9/0x420
[    0.009999]  [<c121007b>] ? kobject_uevent_env+0x3bb/0x400
[    0.009999]  [<c12164d8>] ? string+0x38/0xc0
[    0.009999]  [<c160f590>] ? spurious_fault+0xd0/0xd0
[    0.009999]  [<c160d1d2>] error_code+0x5a/0x60
[    0.009999]  [<c160f590>] ? spurious_fault+0xd0/0xd0
[    0.009999]  [<c109112f>] ? vkdb_printf+0xef/0x690
[    0.009999]  [<c105ecc2>] ? sched_clock_local+0xb2/0x190
[    0.009999]  [<c1094040>] ? kdbgetaddrarg+0x80/0x220
[    0.009999]  [<c10916de>] kdb_printf+0xe/0x10
[    0.009999]  [<c1097bc9>] kdb_printbp+0x39/0xc0
[    0.009999]  [<c111cd30>] ? sync_one_sb+0x20/0x20
[    0.009999]  [<c1097e25>] kdb_bp+0x1d5/0x260
[    0.009999]  [<c111cd30>] ? sync_one_sb+0x20/0x20
[    0.009999]  [<c1094ecd>] kdb_parse+0x2ed/0x630
[    0.009999]  [<c1097950>] ? kdb_bt+0x3b0/0x3b0
[    0.009999]  [<c1913208>] ? kdb_initbptab+0x188/0x18e
[    0.009999]  [<c191301b>] kdb_init+0x5d2/0x637
[    0.009999]  [<c19129f1>] dbg_late_init+0x22/0x24
[    0.009999]  [<c18fd7a3>] start_kernel+0x2a8/0x2ea
[    0.009999]  [<c18fd325>] ? kernel_init+0x13a/0x13a
[    0.009999]  [<c18fd0b3>] i386_start_kernel+0xb3/0xbb





=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

