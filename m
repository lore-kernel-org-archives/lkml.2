Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0KZMbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:31:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57709 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0KZMbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:31:46 -0500
Message-ID: <4CEFA8AE.2090804@petalogix.com>
Date: Fri, 26 Nov 2010 13:31:42 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        John Williams <john.williams@petalogix.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Flushing whole page instead of work for ptrace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have found one problem when I debug multithread application on 
Microblaze. Let me describe what I discovered.

GDB has internal timeout which is setup to value 3. Which should mean if 
GDB sends packet and doesn't receive answer for it then after 3 internal 
timeouts GDB announces "Ignoring packet error, continuing..." and then 
fail. (communication is done over TCP).

In any older version we could debug multithread application that's why
I bisected all new patches which I have added to the kernel and I 
identify that the problem is caused by my patch.

microblaze: Implement flush_dcache_page macro
sha1(79e87830faf22ca636b1a1d8f4deb430ea6e1c8b)

I had to implemented flush_dcache_page macro for new systems with 
write-back(WB) cache which is important for several components (for 
example jffs2 rootfs) to get it work on WB.
BTW: For systems with write-through(WT) caches I don't need to implement 
this macro because flushing is done automatically.

Then I replaced macro on WT by udelay loop to find out if the problem is 
time dependent. I tested it on two hw designs(on the same HZ and cache 
size) with two different network IPs/drivers (one with DMA and second 
without) and I found that system with dma network driver can spend more 
time on dcache flushing before GDB timeout happens because TCP 
communication is faster. Which means that the problem also depends on 
cpu speed and cache configuration - size, cache line length.

Then I traced kernel part and I was focused why this macro is causing 
this problem.

GDB sends symbol-lookup command (qSymbol) and I see a lot of kernel 
ptrace PEEKTEXT requests. I parse it and here is calling sequence.

(kernel/ptrace.c) sys_ptrace -> 
(arch/microblaze/kernel/ptrace.c)arch_ptrace -> 
(kernel/ptrace.c)ptrace_request -> generic_ptrace_peek/poke data/text -> 
(mm/memory.c) access_process_vm -> get_user_pages -> __get_user_pages -> 
flush_dcache_page

Function access_process_vm calls __get_user_pages which doesn't work 
with buffer len (which is for PEEK/POKE TEXT/DATA just 32 bit - for 
32bit Microblaze) but only with start and PAGE size. There is also 
called flush_dcache_page macro which takes more time than in past, 
because was empty. Macro flushes whole page but it is necessary, for 
this case, just flush one address if is called from ptrace.

What is the best way how to ensure that there will be flush only address 
instead of whole page for ptrace requests?
I think that there shouldn't be a reason to flush whole page for ptraces.

Please correct me if I am wrong somewhere.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
