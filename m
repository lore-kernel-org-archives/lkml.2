Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0HBLjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:39:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51250 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0HBLjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:39:45 -0400
Subject: Re: [PATCH 0/6] [RFC] Large weight differential leads to
 inefficient load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>
In-Reply-To: <1280467146-32218-1-git-send-email-ncrao@google.com>
References: <1280467146-32218-1-git-send-email-ncrao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 02 Aug 2010 13:39:38 +0200
Message-ID: <1280749178.1923.114.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 22:19 -0700, Nikhil Rao wrote:
> If folks think this is a good direction and this idea has some merit, then I
> will be more than happy to continue working with the community to improve this
> patchset. If there is another way to fix this problem, then please do tell; I
> would be more than happy to help out.


No its terrible. I've already explained how to solve this on several
occasions (although my google skillz seem to fail me to find the latest
occasion a few months ago).

The thing is that from a fairness point of view 1 nice-0 (weight=1024)
on one CPU and 512 SCHED_IDLE (weight=2) tasks on another CPU and all
other CPUs idle is correct.

It just doesn't seem to be the thing that most people expect.

Special casing things like you've done is utterly the wrong thing to do.

This problem comes in two forms and its name is infeasible weight
distribution. The load-balancer tries to ensure W_k ~= W_l, k,l elem_of
CPUs, where W_k = \Sum_i w_i^k, where w_i^k is the i-th task on CPU k.

The two cases are statically infeasible, and dynamically infeasible. 

We say the task-set is statically infeasible if for a task set of n
tasks there is no way to statically distribute them on N <= n CPUs such
that each task gets equal service (assuming the scheduling on each CPU
is fair).

We say the task-set is dynamically infeasible if for the given scenario
there is no way to rotate the tasks to obtain equality.

Lets assume 2 CPUs.

Ex.1: 2 tasks of different weight.

Ex.2: 3 tasks of equal weight.

The first example is both statically and dynamically infeasible as there
is no way to occupy both CPUs such that each task gets the proportional
correct service.

The second example is statically infeasible, but dynamically feasible,
for if we rotate one task, such that we alternate between 2:1 and 1:2 in
equal measures, each task will receive its correct 2/3rd CPU service.

The current load-balancer isn't particularly skilled at either issue.

The proper solution is to 'fix' find_busiest_group() so that it will:
 - pick the heaviest cpu with more than 1 task on it
 - slowly over-balance things

The first thing will solve your issue.
