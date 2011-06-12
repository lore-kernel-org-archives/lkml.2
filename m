Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1FLLBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 07:01:31 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:62208 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab1FLLBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 07:01:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19956.40070.962218.422362@pilspetsen.it.uu.se>
Date: Sun, 12 Jun 2011 13:01:26 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Robert Uhl <ruhl@xaipete.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Access to local APIC registers during an interrupt handler
In-Reply-To: <4DF389D1.4090909@xaipete.org>
References: <4DF389D1.4090909@xaipete.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Uhl writes:
 > Hi,
 > 
 > I wrote a small interrupt handler (for a 64 bit system) which is 
 > installed by a kernel module in the IDT. My handler just increments a 
 > global variable and then jumps to the original interrupt handler. So 
 > Linux does (hopefully ;-) not notice my handler. With sysfs I can read 
 > the value of these interrupt counter and know exactly how often a 
 > specific interrupt occured.
 > Of course on a multicore system the interrupts of all cores are counted 
 > together, but I want to separate between the cores. On newer CPUs I can 
 > use the instruction RDTSCP to get the CPU number in ECX, but on older 
 > CPUs it's unsupported.
 > So I had the idea to use the local APIC ID to check on which core my 
 > handler is executed, even though sometimes local APIC ID != core number, 
 > but the ID should be at least unique.
 > I get the address of the local APIC ID register at module init with
 > 
 > u64 lapic_idregister = (u64) fix_to_virt(FIX_APIC_BASE) + 0x20;
 > 
 > and use it in my interrupt handler (of course I push/pop all used 
 > registers):
 > 
 > movq (lapic_idregister), %rcx
 > movq (%rcx), %rcx

You're doing a 64-bit load from a 32-bit lapic register.

 > But on real hardware the last instruction seems to cause a page fault or 
 > something (SUSE with 2.6.37.6, Fedora with 2.6.38.6), the system simply 
 > reboots. Without this instruction, the handler is executed without any 
 > problems.
 > And in qemu with vanilla 2.6.37.6 and a buildroot system everything 
 > works fine!

If changing the above movq (%rcx), %rcx to use movl instead makes it
work in real HW, then you've found an accepts-invalid bug in qemu.
