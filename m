Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab1LGRcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:32:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab1LGRb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:31:59 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=x9VNfy9Nl58A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=MXoOvAPF7ZH97oQbhCMA:9 a=eIB65MLBhXCsFlk8nRkA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Perhaps a side effect regarding NMI returns
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
In-Reply-To: <CA+55aFzvGcVRDdm82OdjwP-D-fnrgTVFekVVVKYZSbsexGhN-w@mail.gmail.com>
References: <1322539673.17003.45.camel@frodo>
	 <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
	 <m2r50qlmgk.fsf@firstfloor.org> <1322598920.17003.71.camel@frodo>
	 <CA+55aFzgM55hXTs4griX5e9=v_O+=ue+7Rj0PTD=M7hFYpyULQ@mail.gmail.com>
	 <1323275800.30977.101.camel@frodo>
	 <CA+55aFzvGcVRDdm82OdjwP-D-fnrgTVFekVVVKYZSbsexGhN-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 12:31:56 -0500
Message-ID: <1323279116.30977.109.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 08:44 -0800, Linus Torvalds wrote:

> Sure. If it's tested, I have no problem with signing off on it, so
> just add it. Do you have some kind of commit message that makes sense
> and explains the NMI shadow issue?

How about something like this:

The NMI handler uses the paranoid_exit routine that checks the
NEED_RESCHED flag, and if it is set and the return is for userspace,
then interrupts are enabled, the stack is swapped to the thread's stack,
and schedule is called. The problem with this is that we are still in an
NMI context until an iret is executed. This means that any new NMIs are
now starved until an interrupt or exception occurs and does the iret.

As NMIs can not be masked and can interrupt any location, they are
treated as a special case. NEED_RESCHED should not be set in an NMI
handler. The interruption by the NMI should not disturb the work flow
for scheduling. Any IPI sent to a processor after sending the
NEED_RESCHED would have to wait for the NMI anyway, and after the IPI
finishes the schedule would be called as required.

There is no reason to do anything special leaving an NMI. Remove the
call to paranoid_exit and do a simple return. This not only fixes the
bug of starved NMIs, but it also cleans up the code.

-- Steve

