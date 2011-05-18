Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1ERH6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:58:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50510 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab1ERH6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:58:39 -0400
Date: Wed, 18 May 2011 09:58:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] v6 Improve task->comm locking situation
Message-ID: <20110518075815.GE2945@elte.hu>
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
 <20110518062554.GB2945@elte.hu>
 <20110518000527.bcced636.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518000527.bcced636.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 18 May 2011 08:25:54 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> >   " Hey, this looks a bit racy and 'top' very rarely, on rare workloads that 
> >     play with ->comm[], might display a weird reading task name for a second, 
> >     amongst the many other temporarily nonsensical statistical things it 
> >     already prints every now and then. "
> 
> Well we should at least make sure that `top' won't run off the end of comm[] 
> and go oops.  I think that's guaranteed by the fact(s) that init_tasks's 
> comm[15] is zero and is always copied-by-value across fork and can never be 
> overwritten in any task_struct.

Correct.

> But I didn't check that.

I actually have a highly threaded app that uses PR_SET_NAME heavily and would 
have noticed any oopsing potential long ago.

Since ->comm is often observed from other tasks, regardless whether it's set 
from the prctl() or from the newfangled /proc vector, the race for seeing 
partial updates to ->comm always existed - for more than 10 years.

So the premise of the whole series is wrong: temporarily incomplete ->comm[]s 
were *always* possible and did not start 1.5+ years ago with:

  4614a696bd1c: procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm

when i see series being built on a fundamentally wrong premise i get a bit sad!

Thanks,

	Ingo
