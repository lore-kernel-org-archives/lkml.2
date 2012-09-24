Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2IXPxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:53:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53699 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2IXPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:53:08 -0400
MIME-Version: 1.0
In-Reply-To: <1348500647.11847.69.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic> <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Sep 2012 08:52:45 -0700
X-Google-Sender-Auth: UmRg9bYEusqpwfdvez84m-b4Sjs
Message-ID: <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mgorman@suse.de>, Borislav Petkov <bp@alien8.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 8:30 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> No idea if its sufficient, but its a start.

Can we please do this too?

    diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
    index 96e2b18b6283..2010c1ece7b3 100644
    --- a/kernel/sched/fair.c
    +++ b/kernel/sched/fair.c
    @@ -2634,25 +2634,12 @@ find_idlest_cpu(struct sched_group *group,
struct task_struct *p, int this_cpu)
      */
     static int select_idle_sibling(struct task_struct *p, int target)
     {
    -	int cpu = smp_processor_id();
    -	int prev_cpu = task_cpu(p);
     	struct sched_domain *sd;
     	struct sched_group *sg;
     	int i;

    -	/*
    -	 * If the task is going to be woken-up on this cpu and if it is
    -	 * already idle, then it is the right target.
    -	 */
    -	if (target == cpu && idle_cpu(cpu))
    -		return cpu;
    -
    -	/*
    -	 * If the task is going to be woken-up on the cpu where it previously
    -	 * ran and if it is currently idle, then it the right target.
    -	 */
    -	if (target == prev_cpu && idle_cpu(prev_cpu))
    -		return prev_cpu;
    +	if (idle_cpu(target))
    +		return target;

     	/*
     	 * Otherwise, iterate the domains and find an elegible idle cpu.

(obviously whitespace-damaged). The whole "let's test prev_cpu or cpu"
seems stupid and counter-productive. The only possible values for
'target' are the two we test for.

Your patch looks odd, though. Why do you use some complex initial
value for 'candidate' (nr_cpu_ids) instead of a simple and readable
one (-1)?

And the whole "if we find any non-idle cpu, skip the whole domain"
logic really seems a bit odd (that's not new to your patch, though).
Can somebody explain what the whole point of that idiotically written
function is?

                  Linus
