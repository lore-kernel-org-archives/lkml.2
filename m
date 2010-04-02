Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0DBTiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:38:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:33668 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0DBTiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:38:15 -0400
Message-ID: <4BB64762.6040806@windriver.com>
Date: Fri, 02 Apr 2010 14:37:06 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net, linux-arm@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/5] kgdb: Use atomic operators which use barriers
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com> <1270233145-29335-2-git-send-email-jason.wessel@windriver.com> <1270233145-29335-3-git-send-email-jason.wessel@windriver.com> <1270233145-29335-4-git-send-email-jason.wessel@windriver.com> <1270233145-29335-5-git-send-email-jason.wessel@windriver.com> <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2010 19:37:07.0128 (UTC) FILETIME=[E111BB80:01CAD29B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2010 02:12 PM, Linus Torvalds wrote:
>
>   
> Hmm. While I absolutely agree that 'cpu_relax()' does not imply a memory 
> barrier, I disagree that this change should be needed. If ARM has odd 
> semantics where it will never see changes in a busy loop, then ARM is 
> buggy, and that has _nothing_ to do with the Linux notion of memory 
> barriers.
>
> The _whole_ point of "cpu_relax()" is to have busy loops. And the point of 
> busy loops is that they are waiting for something to change. So if this 
> loop:
>
>   
>>  		for_each_online_cpu(i) {
>> -			while (atomic_read(&cpu_in_kgdb[i]))
>> +			while (atomic_add_return(0, &cpu_in_kgdb[i]))
>>  				cpu_relax();
>>  		}
>>     
>
>   

So this part might be overkill, but I don't actually have the hardware,
schematics or reference manuals to ascertain what is going on.  The
other changes in this patch should be correct because we really do want
memory barriers which come along with the inc and dec operators.

> can somehow lock up because "cpu_relax()" doesn't work with an infinite 
> "while (atomic_read(..))" loop, then the ARM implementation of cpu_relax() 
> is buggy.
>
>   

Will originally proposed a patch for cpu_relax:
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-March/011076.html
--- The patch ---

+#if __LINUX_ARM_ARCH__ == 6
+#define cpu_relax()			smp_mb()
+#else
 #define cpu_relax()			barrier()
+#endif

---

Russell had this thread: 
http://permalink.gmane.org/gmane.linux.ports.arm.kernel/75717

--- clip from url ---

cpu_relax() is also defined to be a compiler barrier so that the compiler
reloads the variable on every iteration.

> This patch changes the definition of cpu_relax() to smp_mb() for ARMv6 cores,
> forcing a flushing of the write buffer on SMP systems. If the Kernel is not
> compiled for SMP support, this will expand to a barrier() as before.

I don't think this is correct.  You're making a macro do something on ARM
which no other platform, apart from blackfin (which I believe is wrong)
makes it do.

---

> Does ARM have some broken cache coherency model where writes by other 
> CPU's _never_ show up unless the reading CPU does some memory sync thing? 
> If so, then cpu_relax() obviously does need to do that syncing 
> instruction.
>
>   

Given your statements, I can just keep the atomic reads as they were
previously, but keep the inc and dec parts.  And we can wait for a
further response from either Will or Russell.

Thanks,
Jason.
