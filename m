Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab2ANAGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 19:06:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45725 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2ANAGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 19:06:04 -0500
MIME-Version: 1.0
In-Reply-To: <4F10BDF7.8030306@linux.vnet.ibm.com>
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
 <4F10BDF7.8030306@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 16:05:42 -0800
X-Google-Sender-Auth: VFk1cZ7_9fN20K8KqOREZ5Agdm4
Message-ID: <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 3:27 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
>
> # echo 1 > /sys/devices/system/cpu/cpu1/online
>
> [   75.476772] Booting Node 0 Processor 1 APIC 0x2
> [   75.481495] smpboot cpu 1: start_ip = 97000
> [   75.492927] Calibrating delay loop (skipped) already calibrated this CPU
> [   75.508449] NMI watchdog enabled, takes one hw-pmu counter.
> [   75.515402] general protection fault: 0000 [#1] SMP
> [   75.518940]
> [   75.518940] Pid: 6631, comm: bash Tainted: G        W    3.2.0-debugkernel-0.0.0.28.36b5ec9-default #4 IBM IBM System x -[7870C4Q]-/68Y8033
> [   75.518940] RIP: 0010:[<ffffffff81270779>]  [<ffffffff81270779>] kobject_get+0x19/0x60
> [   75.518940] RSP: 0018:ffff8808c6cc7c18  EFLAGS: 00010206
> [   75.518940] RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b7b RCX: 0000000000000006
> [   75.518940] RDX: ffffffff81e98ae0 RSI: ffff8808ccc93080 RDI: 6b6b6b6b6b6b6b7b

The magic is the %rdi value. The instruction that oopses is

    mov    0x38(%rdi),%eax

and "rdi" is 0x10 + the magic 6b6b6b.. pattern. Which is obviously
'poison_free'.

And the 0x10 is because get_device() does

    return dev ? to_dev(kobject_get(&dev->kobj)) : NULL;

and I bet "kobj" is at offset 16 in the device structure. So we had a
pointer to a "struct device", but it was loaded from memory that was
free'd, turning the kobject pointer into that 0x6b6b6b6b6b6b6b7b

So somebody got a pointer from free'd memory. That somebody seems to
be 'klist_devices_get()' that got it from a 'struct klist_node', so I
think we have free'd something from the klist_devices list in the bus.
But I dunno. Odd. I would have expected us to hit that invalid pointer
long before if the klist entry was bogus.

I'm not seeign anything obvious in mce.c. But the fact that it's that
magic per_cpu allocation makes me nervous. It uses that magic
"mce_device_initialized" bit array etc, and ti clearly must have
worked before, but it equally clearly does *not* work now.

Looking more at it, I think that maybe something keeps the mce_device
around (refcounts that didn't use to exist before?) so when we
unregister it, it is still in use. And then when we re-register it
when we bring it up, we do that

    memset(&dev->kobj, 0, sizeof(struct kobject));

on the device that is in use. I dunno. It's all scary. Somebody who
knows the MCE layer should look at it.

                   Linus
