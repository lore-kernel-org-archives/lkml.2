Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab0KGX05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:26:57 -0500
Received: from mail.openrapids.net ([64.15.138.104]:35562 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753418Ab0KGX04 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:26:56 -0500
Date: Sun, 7 Nov 2010 18:26:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Arjan Van De Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: x86: rdtsc_barrier possibly missing serializing instruction
Message-ID: <20101107232652.GA14108@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:14:44 up 46 days,  3:16,  4 users,  load average: 0.01, 0.07,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that rdtsc_barrier is possibly missing serializing instructions, so I
am bringing this to your attention. As the comment states above rdtsc_barrier():

 * Stop RDTSC speculation. This is needed when you need to use RDTSC
 * (or get_cycles or vread that possibly accesses the TSC) in a defined
 * code region.

So it seems to imply that the rdtsc will not be reordered wrt other instructions
due to speculative execution, which does not seem to be taken care of here.

rdtsc_barrier() as found in recent (2.6.36) kernel translates into either a
mfence or lfence (or nothing), depending on the architecture. Now the Intel
manuals state the following:

"The MFENCE instruction is ordered with respect to all load and store
instructions, other MFENCE instructions, any SFENCE and LFENCE instructions, and
any serializing instructions (such as the CPUID instruction)."

and...

- Privileged serializing instructions—MOV (to control register), MOV (to debug
  register), WRMSR, INVD, INVLPG, WBINVD, LGDT, LLDT, LIDT, and LTR.
- Nonprivileged serializing instructions—CPUID, IRET, and RSM.

So rdtsc does not appear in the list of serializing instruction, which makes me
wonder how mfence or lfence can ensure that rdtsc does not spill outside of the
memory barrier ? I feel I might be missing an undocumented feature here.

If I get it right, surrounding TSC read with these barriers should end up with
something like:

rdtsc_barrier_acquire()
  m/lfence
  cpuid
get_cycles()
  rdtsc
rdtsc_barrier_release()
  cpuid
  m/lfence

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
