Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2BUVyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:54:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:48642 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab2BUVyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:54:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109163141"
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 21 Feb 2012 13:54:32 -0800
In-Reply-To: <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
	 <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
	 <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org>
	 <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
	 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1329861273.29790.261.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 11:48 -0800, Linus Torvalds wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sun, 19 Feb 2012 13:27:00 -0800
> Subject: [PATCH v2 3/3] i387: support lazy restore of FPU state
> 
> This makes us recognize when we try to restore FPU state that matches
> what we already have in the FPU on this CPU, and avoids the restore
> entirely if so.
> 
> To do this, we add two new data fields:
> 
>  - a percpu 'fpu_owner_task' variable that gets written any time we
>    update the "has_fpu" field, and thus acts as a kind of back-pointer
>    to the task that owns the CPU.  The exception is when we save the FPU
>    state as part of a context switch - if the save can keep the FPU
>    state around, we leave the 'fpu_owner_task' variable pointing at the
>    task whose FP state still remains on the CPU.
> 
>  - a per-thread 'last_cpu' field, that indicates which CPU that thread
>    used its FPU on last.  We update this on every context switch
>    (writing an invalid CPU number if the last context switch didn't
>    leave the FPU in a lazily usable state), so we know that *that*
>    thread has done nothing else with the FPU since.
> 
> These two fields together can be used when next switching back to the
> task to see if the CPU still matches: if 'fpu_owner_task' matches the
> task we are switching to, we know that no other task (or kernel FPU
> usage) touched the FPU on this CPU in the meantime, and if the current
> CPU number matches the 'last_cpu' field, we know that this thread did no
> other FP work on any other CPU, so the FPU state on the CPU must match
> what was saved on last context switch.
> 
> In that case, we can avoid the 'f[x]rstor' entirely, and just clear the
> CR0.TS bit.
> 

Reviewing this code, I think we need to set the 'last_cpu' to an invalid
number in the fpu_alloc too. Appended is the patch.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, fpu: set the last_cpu in fpu_alloc() to an invalid cpu

Initialize the struct fpu's last_cpu in fpu_alloc() to an invalid cpu number,
so that the check in fpu_lazy_restore() will always return false
on the first context-switch in of this new task.

Otherwise, on a fork(), last_cpu of the new task's fpu will be copied from
the parent task and fpu_lazy_restore() can potentially return success wrongly
on the first context-switch in of this new task, leading to fpu corruption.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/i387.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 2479049..58ba656 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -627,6 +627,7 @@ static inline int fpu_alloc(struct fpu *fpu)
 	if (!fpu->state)
 		return -ENOMEM;
 	WARN_ON((unsigned long)fpu->state & 15);
+	fpu->last_cpu = ~0;
 	return 0;
 }
 


