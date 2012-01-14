Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2ANCmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 21:42:11 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54405 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab2ANCmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 21:42:08 -0500
Message-ID: <4F10EB5B.5060804@linux.vnet.ibm.com>
Date: Sat, 14 Jan 2012 08:11:31 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com> <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com> <4F10BDF7.8030306@linux.vnet.ibm.com> <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
In-Reply-To: <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011402-2000-0000-0000-00000609F7A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2012 05:35 AM, Linus Torvalds wrote:

> On Fri, Jan 13, 2012 at 3:27 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>
>> # echo 1 > /sys/devices/system/cpu/cpu1/online
>>
>> [   75.476772] Booting Node 0 Processor 1 APIC 0x2
>> [   75.481495] smpboot cpu 1: start_ip = 97000
>> [   75.492927] Calibrating delay loop (skipped) already calibrated this CPU
>> [   75.508449] NMI watchdog enabled, takes one hw-pmu counter.
>> [   75.515402] general protection fault: 0000 [#1] SMP
>> [   75.518940]
>> [   75.518940] Pid: 6631, comm: bash Tainted: G        W    3.2.0-debugkernel-0.0.0.28.36b5ec9-default #4 IBM IBM System x -[7870C4Q]-/68Y8033
>> [   75.518940] RIP: 0010:[<ffffffff81270779>]  [<ffffffff81270779>] kobject_get+0x19/0x60
>> [   75.518940] RSP: 0018:ffff8808c6cc7c18  EFLAGS: 00010206
>> [   75.518940] RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b7b RCX: 0000000000000006
>> [   75.518940] RDX: ffffffff81e98ae0 RSI: ffff8808ccc93080 RDI: 6b6b6b6b6b6b6b7b
> 
> The magic is the %rdi value. The instruction that oopses is
> 
>     mov    0x38(%rdi),%eax
> 
> and "rdi" is 0x10 + the magic 6b6b6b.. pattern. Which is obviously
> 'poison_free'.
> 
> And the 0x10 is because get_device() does
> 
>     return dev ? to_dev(kobject_get(&dev->kobj)) : NULL;
> 
> and I bet "kobj" is at offset 16 in the device structure. So we had a
> pointer to a "struct device", but it was loaded from memory that was
> free'd, turning the kobject pointer into that 0x6b6b6b6b6b6b6b7b
> 
> So somebody got a pointer from free'd memory. That somebody seems to
> be 'klist_devices_get()' that got it from a 'struct klist_node', so I
> think we have free'd something from the klist_devices list in the bus.
> But I dunno. Odd. I would have expected us to hit that invalid pointer
> long before if the klist entry was bogus.
> 
> I'm not seeign anything obvious in mce.c. But the fact that it's that
> magic per_cpu allocation makes me nervous. It uses that magic
> "mce_device_initialized" bit array etc, and ti clearly must have
> worked before, but it equally clearly does *not* work now.
> 
> Looking more at it, I think that maybe something keeps the mce_device
> around (refcounts that didn't use to exist before?) so when we
> unregister it, it is still in use. And then when we re-register it
> when we bring it up, we do that
> 
>     memset(&dev->kobj, 0, sizeof(struct kobject));
> 
> on the device that is in use. I dunno. It's all scary. Somebody who
> knows the MCE layer should look at it.
> 
>                    Linus
> 


YES!! Finally I have a fix for this whole MCE thing! :-)

The patch below works perfectly for me - I tested multiple CPU hotplug
operations as well as multiple pm_test runs at core level. Please let me
know if this solves the suspend issue as well..

Of course, the warnings at drivers/base/core.c: device_release()
as well as the IPI to offline cpu warnings still appear but are rather
unrelated and harmless to the issue being discussed.
So, with this patch CPU hotplug doesn't crash the system and suspend and
hibernate are expected to work fine.

-------
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] x86/mce: Fix CPU hotplug and suspend regression related to MCE

Commit 8a25a2f (cpu: convert 'cpu' and 'machinecheck' sysdev_class
to a regular subsystem) changed how things are dealt with in
the MCE subsystem. Some of the things that got broken due to this
are CPU hotplug and suspend/hibernate.

MCE uses per_cpu allocations of struct device. So, when a CPU goes
offline and comes back online, in order to ensure that we start
from a clean slate with respect to the MCE subsystem, zero out the
entire per_cpu device structure to 0 before using it.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index f22a9f7..29ba329 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2011,7 +2011,7 @@ static __cpuinit int mce_device_create(unsigned int cpu)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	memset(&dev->kobj, 0, sizeof(struct kobject));
+	memset(dev, 0, sizeof(struct device));
 	dev->id  = cpu;
 	dev->bus = &mce_subsys;
 


