Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422885Ab2JaNcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:32:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48737 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964787Ab2JaNce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:32:34 -0400
MIME-Version: 1.0
In-Reply-To: <1351688390.4004.74.camel@gandalf.local.home>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	<1351611301-3520-3-git-send-email-fweisbec@gmail.com>
	<1351622024.1504.13.camel@anish-Inspiron-N5050>
	<CAFTL4hz7Jy69rr4Ze1pOtYPo5CFSZuTGXdY+w3jR4ZboA_8EYg@mail.gmail.com>
	<1351650181.4004.70.camel@gandalf.local.home>
	<1351681467.1504.20.camel@anish-Inspiron-N5050>
	<1351688390.4004.74.camel@gandalf.local.home>
Date: Wed, 31 Oct 2012 14:32:33 +0100
Message-ID: <CAFTL4hx7Xu9hy1ASQgsadvi4bq3L_DgyLWkpY0ZA-Tpmf01y4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: anish kumar <anish198519851985@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/31 Steven Rostedt <rostedt@goodmis.org>:
> On Wed, 2012-10-31 at 20:04 +0900, anish kumar wrote:
>> nflags = 1 | 3
>> nflags = 2 | 3
>> In both cases the result would be same.If I am right then wouldn't this
>> operation be redundant?
>
> Right. Actually we could change the new loop to:
>
>         for (;;) {
>                 oflags = cmpxchg(&work->flags, flags, IRQ_WORK_FLAGS);
>                 if (oflags == flags)
>                         break;
>                 if (oflags & IRQ_WORK_PENDING)
>                         return false;
>                 flags = oflags;
>                 cpu_relax();
>         }

We could. But I wanted to keep the code able to handle new flags in
the future (such as IRQ_WORK_LAZY).

> Frederic,
>
> Would you like to add my explanation to your change log? You can add the
> entire thing, which I think would explain a lot to people.

It's indeed a very clear explanation. I'll put that in the changelog, thanks!
