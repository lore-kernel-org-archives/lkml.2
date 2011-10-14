Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab1JNS1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:27:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:38281 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1JNS1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:27:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,347,1315206000"; 
   d="scan'208";a="26812756"
Subject: Re: Questions on interrupt routing / balancing (on x86)
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 14 Oct 2011 11:29:35 -0700
In-Reply-To: <201110141436.27186.jdelvare@suse.de>
References: <201110141436.27186.jdelvare@suse.de>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318616976.11592.285.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 05:36 -0700, Jean Delvare wrote:
> * In physical flat mode, all interrupts are bound to CPU0 by default. As 
> I understand it, it stays that way until user-space (for example 
> irqbalance) adjusts the smp_affinity masks in /proc/irq. Why don't we 
> pick a different CPU for every interrupt by default? For example 
> irq_nr%cpu_max? This would seem a better default for performance, but 
> maybe not for power savings. Is it the reason why it isn't done?

It really depends on what apic mode is selected and how HW implements
etc.

Also that may not always be better default. For example, two heavily
loaded irq's like network/disk interrupt can end up on two hyperthreaded
siblings leading to poor performance. So irqbalance is the right place
to have all the smartness.

> 
> * In (non-physical) flat mode, my understanding is that a given 
> interrupt can be mapped to several CPUs (and this happens by default) 
> and live round-robin balancing can happen. I have seen systems where it 
> actually happens, with interrupt counters perfectly balanced on all 
> CPUs, but I have also seen systems where CPU0 gets all the interrupts 
> all the time. Why is it so? Where is the kernel code which decides if 
> round-robin balancing should happen? Or is this a hardware decision?

Its chipset decision. Some chipsets implement round-robin and some
don't.

> 
> * Would it be possible to have a kernel boot parameter to force (non-
> physical) flat mode even with more than 8 CPUs, in order to restore 
> round-robin balancing? I understand that this would limit interrupt 
> routing to CPUs 0-7, but other than this, would it work?

you can use logical cluster mode which can support upto 60 logical
cpu's. Some old linux kernels used to support this mode.

> 
> * Do I properly understand that MSI and MSI-X interrupts do NOT go 
> through the IO-APIC and are thus not affected by flat vs. physical flat 
> APIC routing mode? If so, what determines whether these interrupts get 
> round-robin balanced or not? Here too, I've seen systems where it 
> happens and others where it doesn't (looking at /proc/interrupts.)
> 

Even though MSI and MSI-X don't go through io-apic, they still use the
apic model that is selected by the kernel.

Anyways, newer platforms are supporting x2apic extensions that will
support more cpu's in logical/physical mode etc.

thanks,
suresh

