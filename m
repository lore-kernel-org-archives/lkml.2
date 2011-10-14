Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab1JNMgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:36:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab1JNMga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:36:30 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: Suse Linux
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Questions on interrupt routing / balancing (on x86)
Date: Fri, 14 Oct 2011 14:36:27 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.32.46-0.3-pae; KDE/4.3.5; i686; ; )
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Tejun Heo <tj@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110141436.27186.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Lately, I have been looking into how interrupts are routed / balanced on 
x86 systems. I've learned a lot of things along the road and feel much 
more familiar with the whole thing now, however there are still a few 
things I don't understand and for which I would appreciate explanations 
or pointers.

I do understand that the IO-APIC has two routing modes, namely flat and 
physical flat, the former being limited to 8 logical CPUs for technical 
reasons. I also found that physical flat routing would be selected even 
with only 8 CPUs installed if the host chipset is known to support more. 
I have also read about how MSI-X allows smarter balancing of interrupts 
across CPUs by allowing multiple interrupt queues per device. Now to the 
things I do not fully understand:

* In physical flat mode, all interrupts are bound to CPU0 by default. As 
I understand it, it stays that way until user-space (for example 
irqbalance) adjusts the smp_affinity masks in /proc/irq. Why don't we 
pick a different CPU for every interrupt by default? For example 
irq_nr%cpu_max? This would seem a better default for performance, but 
maybe not for power savings. Is it the reason why it isn't done?

* In (non-physical) flat mode, my understanding is that a given 
interrupt can be mapped to several CPUs (and this happens by default) 
and live round-robin balancing can happen. I have seen systems where it 
actually happens, with interrupt counters perfectly balanced on all 
CPUs, but I have also seen systems where CPU0 gets all the interrupts 
all the time. Why is it so? Where is the kernel code which decides if 
round-robin balancing should happen? Or is this a hardware decision?

* Would it be possible to have a kernel boot parameter to force (non-
physical) flat mode even with more than 8 CPUs, in order to restore 
round-robin balancing? I understand that this would limit interrupt 
routing to CPUs 0-7, but other than this, would it work?

* Do I properly understand that MSI and MSI-X interrupts do NOT go 
through the IO-APIC and are thus not affected by flat vs. physical flat 
APIC routing mode? If so, what determines whether these interrupts get 
round-robin balanced or not? Here too, I've seen systems where it 
happens and others where it doesn't (looking at /proc/interrupts.)

Thanks for any answer or pointer you can provide.

-- 
Jean Delvare
Suse L3
