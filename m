Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab1FKPyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 11:54:19 -0400
Received: from wp186.webpack.hosteurope.de ([80.237.132.193]:34300 "EHLO
	wp186.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758709Ab1FKPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 11:54:17 -0400
X-Greylist: delayed 1492 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jun 2011 11:54:16 EDT
Message-ID: <4DF389D1.4090909@xaipete.org>
Date: Sat, 11 Jun 2011 17:29:21 +0200
From: Robert Uhl <ruhl@xaipete.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Access to local APIC registers during an interrupt handler
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;ruhl@xaipete.org;1307807656;a2eb79a0;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote a small interrupt handler (for a 64 bit system) which is 
installed by a kernel module in the IDT. My handler just increments a 
global variable and then jumps to the original interrupt handler. So 
Linux does (hopefully ;-) not notice my handler. With sysfs I can read 
the value of these interrupt counter and know exactly how often a 
specific interrupt occured.
Of course on a multicore system the interrupts of all cores are counted 
together, but I want to separate between the cores. On newer CPUs I can 
use the instruction RDTSCP to get the CPU number in ECX, but on older 
CPUs it's unsupported.
So I had the idea to use the local APIC ID to check on which core my 
handler is executed, even though sometimes local APIC ID != core number, 
but the ID should be at least unique.
I get the address of the local APIC ID register at module init with

u64 lapic_idregister = (u64) fix_to_virt(FIX_APIC_BASE) + 0x20;

and use it in my interrupt handler (of course I push/pop all used 
registers):

movq (lapic_idregister), %rcx
movq (%rcx), %rcx

But on real hardware the last instruction seems to cause a page fault or 
something (SUSE with 2.6.37.6, Fedora with 2.6.38.6), the system simply 
reboots. Without this instruction, the handler is executed without any 
problems.
And in qemu with vanilla 2.6.37.6 and a buildroot system everything 
works fine!

I already had a look with qemu which instructions are executed at a 
local APIC timer interrupt (0xEF) until it writes 0x00 to the local APIC 
EOI register (same page), but I still can't figure out what's the 
problem with my code.

Maybe someone knows what is missing or if there is any other fast way to 
figure out on which core the handler is running?

Kind regards,
Robert
