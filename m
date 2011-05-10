Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1EJLm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:42:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab1EJLm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:42:27 -0400
Date: Tue, 10 May 2011 13:42:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Kaywinnit L. Frye" <kaywinnit.lee.frye.2497@gmail.com>,
        linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Subject: Re: [PATCH] wait: include linux/sched.h
Message-ID: <20110510114217.GA24786@elte.hu>
References: <1304372042-12098-1-git-send-email-kaywinnit.lee.frye.2497@gmail.com>
 <20110506075408.GI23166@elte.hu>
 <1305015103.2914.17.camel@laptop>
 <20110510103628.GE2400@elte.hu>
 <1305025620.2914.55.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305025620.2914.55.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-05-10 at 12:36 +0200, Ingo Molnar wrote:
> > 
> > Obviously sched.h would include a lot of basic types to begin with, because it 
> > is a fundamental 'container' type (struct task_struct) sitting at a top, 
> > highlevel node of the type hierarchy - so the initial step you suggest would 
> > indeed get us most of the benefits. 
> 
> I very well understand the whole header mess, and in particular last time I 
> looked at the sched.h vs wait.h thing simply removing the non sched.c related 
> things was enough to resolve this particular problem.

No!

The wait.h problem is this: why do we want to include sched.h in wait.h?

We do not want it:

 - the waitqueue definitions do not need it
 - the main waitqueue accessor methods do not need it

types using waitqueues should not need to include sched.h as well - directly or 
indirectly!

Why does wait.h 'need' sched.h to work standalone right: because a few 
convenience helper functions in wait.h use scheduler functionality and 
scheduler constants.

As a result of this mess much of wait.h is written in hard to read 1970's tech: 
in the C preprocessor macro language.

Note that even *those* helpers do not really need to know the layout of struct 
task_struct (about which most of sched.h's complexity is): they only need to 
know the task state bits and a few scheduler API methods related to the concept 
of scheduling/waiting.

And note in that context it very much makes sense to have wait_types.h and 
wait_api.h (wait.h): all the derivative types that use waitqueues do not need 
all the helper functions like wait_event() and do not need to include scheduler 
lowlevel context switching details ... Only .c files that *use* waitqueues need 
to include the full kit.

But even the first step of purifying the headers will be a big step forward.

> I really don't like the foo_type.h headers much and think we should only use 
> them as absolute last resort solutions.

I understood your point as cleaning up sched.h to be able to include sched.h in 
wait.h and with that solution i disagree violently: sched.h is about struct 
task_struct and wait.h does not need that - nor do the dozens of other types 
need it that use waitqueues.

We can move all the task definitions and APIs from sched.h into wait.h then yes 
that's the first good first step toward purer structure for both sched.h and 
wait.h.

We can also move signal bits into a separate header, to streamline sched.h some 
more - but sched.h will always be a 'container' kind of super-header, by its 
very nature.

Or if you want some other structure for it all then please outine that 
structure. We could certainly move struct task_struct definition into a 
separate task.h and keep all context switch related definitions in sched.h.

Then task.h will need to be included in tons of code that dereferences 
'current' directly. So for pragmatic reasons it's probably better to keep 
struct task_struct in sched.h. But we can do the more complex change as well, 
as long as there's a plan behind it and as long as there's someone doing it ;-)

> I might have mis-read your email, but to me your:
> 
>   "To fix these super-headers like sched.h and to make wait.h
> self-sufficient the right and cleanest approach would be to split data
> types and primitive accessor functions.."
> 
> Seems to suggest to begin with that split, instead of starting with sane
> cleanups like moving the signal and process (groups of tasks) bits out
> into their own headers.

Yeah. Either direction is fine to me and moving out unrelated stuff sure is the 
bulk of the work.

Thanks,

	Ingo
