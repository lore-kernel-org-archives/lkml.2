Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab2J3Pwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:52:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838Ab2J3Pwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:52:32 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=V7vpMoT6iB0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ficjY6ek3-4A:10 a=QgrmKwSj0rEDmE5dbtMA:9 a=PUjeQqilurYA:10 a=f1zr2VQgi52f-w2L:21 a=ZVMf7pOS9KxP0KJy:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351612350.8467.104.camel@gandalf.local.home>
Subject: Re: [PATCH 0/2] irq_work: A couple fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 30 Oct 2012 11:52:30 -0400
In-Reply-To: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 16:34 +0100, Frederic Weisbecker wrote:
> Hi,

> And I still wonder if cpu_relax() is enough to prevent the compiler
> from correctly reloading work->flags in irq_work_sync() loop.
> Do we need ACCESS_ONCE()?

You mean this loop:

       flags = work->flags & ~IRQ_WORK_PENDING;
       for (;;) {
               nflags = flags | IRQ_WORK_FLAGS;
               oflags = cmpxchg(&work->flags, flags, nflags);
               if (oflags == flags)
                       break;
               if (oflags & IRQ_WORK_PENDING)
                       return false;
               flags = oflags;
               cpu_relax();
       }

After the first loading of work->flags, you are worried about the
&work->flags in the cmpxchg()?  The cmpxchg() will handle that itself. I
don't see any place that a ACCESS_ONCE() is required here. The cmpxchg()
acts on the address of work->flags, the compiler isn't involved with the
value at that address.

-- Steve


