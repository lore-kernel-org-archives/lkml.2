Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab0FFPtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:49:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:49967 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab0FFPtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:49:19 -0400
Message-ID: <4C0BC35C.8070003@kernel.org>
Date: Sun, 06 Jun 2010 17:48:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: Re: Linux 2.6.35-rc2
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org> <AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com> <alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 06 Jun 2010 15:48:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Torsten, Linus.

On 06/06/2010 04:19 PM, Linus Torvalds wrote:
>> [   90.040053] general protection fault: 0000 [#1] SMP
>> [   90.045062] last sysfs file: /sys/devices/pci0000:00/0000:00:06.0/0000:05:06.0/resource
>> [   90.050007] CPU 0
>> [   90.050007] Modules linked in: sg
>> [   90.050007]
>> [   90.050007] Pid: 335, comm: kblockd/0 Not tainted 2.6.35-rc2 #1 KFN5-D SLI/KFN5-D SLI
>> [   90.050007] RIP: 0010:[<ffffffff8135aa64>]  [<ffffffff8135aa64>] ata_find_dev+0x24/0x90
>> [   90.050007] RSP: 0018:ffff88007ffdbda0  EFLAGS: 00010082
>> [   90.050007] RAX: 0720072007200720 RBX: ffff88007ffc7000 RCX: 0720072007202558
>> [   90.050007] RDX: ffff880007009e38 RSI: 0000000000000000 RDI: ffff880007008000
>> [   90.050007] RBP: ffff880006cef700 R08: 0000000000000001 R09: 0000000000000008
>> [   90.050007] R10: 0000000000000000 R11: ffff88000723edb0 R12: ffff88007f3a3800
>> [   90.050007] R13: ffff880007008000 R14: ffffffff81340f80 R15: ffff88007ffc7138
>> [   90.050007] FS:  00007f558bc58700(0000) GS:ffff880001c00000(0000) knlGS:0000000000000000
>> [   90.050007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [   90.050007] CR2: 00007fffa9653000 CR3: 0000000006429000 CR4: 00000000000006f0
>> [   90.050007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   90.050007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
...
>> (gdb) list *0xffffffff8135aa64
>> 0xffffffff8135aa64 is in ata_find_dev (include/linux/libata.h:1201).
>> 1196            return ap->nr_pmp_links != 0;
>> 1197    }
>> 1198
>> 1199    static inline int ata_is_host_link(const struct ata_link *link)
>> 1200    {
>> 1201            return link == &link->ap->link || link == link->ap->slave_link;
>> 1202    }
>> 1203    #else /* CONFIG_SATA_PMP */
>> 1204    static inline bool sata_pmp_supported(struct ata_port *ap)
>> 1205    {

Hmmm... that's really odd.  An ata_port contains one ata_link
structure in ap->link which is initialized by ata_link_init() during
ata_port_alloc(), so ap->link.ap == ap should always hold.

In the above case, ap->link.ap is containing 0x0720072007200720 (RAX)
instead of the proper address 0xffff880007008000 (RDI) and
ata_is_host_link() is causing oops trying to derference
ap->link.ap->slave_link.

Odd, I can't think of any change which could cause such behavior
difference.  Where would 0x0720072007200720 come from?  That's a
rather strange value to be there and it doesn't seem to be a magic
value.  I'll see whether I can reproduce the problem.  Can you please
try w/o KMS just in case?

Thanks.

-- 
tejun
