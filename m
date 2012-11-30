Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992502Ab2K3SxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:53:14 -0500
Received: from mail-wg0-f74.google.com ([74.125.82.74]:37786 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161068Ab2K3SwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:52:16 -0500
From: Vincent Palatin <vpalatin@chromium.org>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Duncan Laurie <dlaurie@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: issue with x86 FPU state after suspend to ram
Date: Fri, 30 Nov 2012 10:52:02 -0800
Message-Id: <1354301523-5252-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On a 4-core Ivybridge platform, when doing a lot of suspend-to-ram/resume
cycles, we were observing processes randomly killed by a SIGFPE.
When dumping the FPU registers state on the SIGFPE (usually a floating stack
underflow/overflow on a floating point arithmetic operation), the FPU registers
looks empty or at least corrupted which was more or less impossible with
respect to the disassembled floating point code.

After doing more tracing, in the faulty case, the process seems to be keeping
FPU ownership over a secondary CPU unplug/re-plug triggered by the suspend.
Then it's doing a lazy restore of its FPU context (ie just using the current
FPU hardware registers as he is the owner) instead of writing them back
to the hardware from the version previously saved in the task context,
despite the fact the whole FPU hardware state has been lost.

Just invalidating the "fpu_owner_task" when disabling a secondary CPU seems
to solve my issue (it's already reset for the primary CPU).

By the way, when FPU the lazy restore patch was discussed back in february,
Ingo commented (in http://permalink.gmane.org/gmane.linux.kernel/1255423) :
"
I guess the CPU hotplug case deserves a comment in the code: CPU
hotplug + replug of the same (but meanwhile reset) CPU is safe
because fpu_owner_task[cpu] gets reset to NULL.
"
That contradicts my previous observation, so maybe I have totally overlooked
something in this mechanism.
Can you comment ?

I'm still putting my patch proposal in this thread.
The issue seems to exist since 3.4 after the FPU lazy restore was actually
implemented by commit 7e16838d "i387: support lazy restore of FPU state".
But the issue is mainly visible on 3.4 and 3.6 since on tip of tree, it is
hidden by the eager fpu implementation for platforms with xsave support,
but it still happens with eagerfpu=off.

To apply this change to 3.4, "this_cpu_write" needs to be replaced by
percpu_write.

--
Vincent

