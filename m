Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1BJRYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:24:18 -0500
Received: from smtp-out.google.com ([216.239.44.51]:19052 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab1BJRYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:24:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lK1X7GsvI1+7BztnKWbl7j64hibOurulaTcrKq3HNOvcjwSPdvnA25Q/L8BavW0ik/
         gaRDDxQWQEHZwI+O3jDw==
MIME-Version: 1.0
In-Reply-To: <1297243778.13327.143.camel@laptop>
References: <AANLkTikmWfLv3iMNUky7TRvQtUknLckftiQ4-Br614Rm@mail.gmail.com>
	<1297188819-19999-1-git-send-email-venki@google.com>
	<1297243778.13327.143.camel@laptop>
Date: Thu, 10 Feb 2011 09:24:11 -0800
Message-ID: <AANLkTi=fKQB1sYzh=rfPRMMmjXEOd9REvg+J05bfkwFv@mail.gmail.com>
Subject: Re: Misc sd_idle related fixes
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 1:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-02-08 at 10:13 -0800, Venkatesh Pallipadi wrote:
>> Here are the 3 sd_idle related changes I tested with, for reference. Among
>> the three, the third patch is the one that helps us in reducing idle cycles
>> with one of our workloads and thus improves the latency response.
>
> Have you tried what happens if you simply rip all that SMT stuff out and
> simplify the code? Afaict much of the capacity stuff we have should have
> a similar effect and is less confusing, no?
>

Among the benchmarks I looked at (tbench and internal workload that
showed benefit with these fixes), I see both no sd_idle and
sd_idle+fixes have similar effect. So, I do not see any problems with
ripping out sd_idle altogether.

We may still need to change first_idle_cpu logic a bit for SMT though.
It can prevent 2 hop migrations in cases like:
{ [ (A B) (C D) ] [ (E F) (G H) ] } grouping, if B is busy, EFGH are
busy and ACD are idle;
As A happens to be first idle CPU, it will be the one bringing in the
load from socket EFGH and then C or D have to pull the load from A.
Instead if C or D is nominated to pull the task from other socket, we
can reduce one hop.
I do not see capacity logic handling this case. But, this is more of a
micro-optimization and may affect workloads like SPECjbb at low
utilization, etc. I haven't seen this affecting the workloads we care
about.

Thanks,
Venki
