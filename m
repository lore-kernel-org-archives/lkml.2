Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab2E1JGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:06:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39992 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2E1JGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:06:30 -0400
Message-ID: <4FC34011.4040505@gmail.com>
Date: Mon, 28 May 2012 11:06:25 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Subject: Re: [RFC][PATCH 00/15] sched: SCHED_DEADLINE v5
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com> <1337942569.9783.183.camel@laptop>
In-Reply-To: <1337942569.9783.183.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/25/2012 12:42 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 23:42 +0200, Juri Lelli wrote:
>> Still missing/incomplete:
>>    - (c)group based bandwidth management, and maybe scheduling;
>
> The b/w stuff for cgroups shouldn't be particularly hard, right? It
> shouldn't be more than ensuring the utilization sum of all children
> stays below the set value.
>
> Or am I missing something?
>

Yes, the sum of the bandwidths of entities (tasks and groups) belonging
to a group stays below its own set bandwidth. Actually, I quoted this
sentence from code that was included in previous versions (removed since
v3). I tried to build historical reasons why it was removed, but I failed
:-). Anyway, shouldn't be too hard to adapt that code to the new version
and see if it will raise any new concern.

>>    - bandwidth inheritance (to replace deadline/priority inheritance);
>
> Yes please, but this is somewhat longer term, I think the band-aids in
> place are sufficient to allow us to move fwd.
>

Yes, but I fear it could affect next point. Anyway, I agree that this is
something that I would consider long-term.

>>    - access control for non-root users (and related security concerns to
>>      address).
>
> Right, so could you detail what all is needed to allow regular users to
> create dl tasks?
>

Ok, I'll try to summarize what I think it would be a _minimal_ set of
requirements:

  o  define deadline(period) and runtime utilization caps; as it was in v3,
     RLIMIT_DLDLINE would be the minimum value a user task can use as its
     own deadline, while (as you pointed out) RLIMIT_DLRTIME would be a per
     user utilization cap, but it would also be tracked in user_struct to
     enforce a max utilization cap per user.
  
  o  At server parameters change/destruction some mechanism is needed to
     prevent possible attacks such as (ref. Tommaso's paper):

        - an app creates a task with an associated server;
        - when the runtime (budget) is about to be exhausted, the app
          destroys the server, returning the task to the default sched
          policy;
        - then, the app immediately creates a new server for the task,
          and keeps repeating the loop over and over.

     A possible solution is that, whenever a server is destroyed, the
     system doesn't completely forget about its existence, but it must
     continue to consider its utilization as not available until the
     next server period expired.
  
  o  The only "big problem" I fear is related to the current deadline
     inheritance mechanism. As Steven pointed out during the last review,
     a task could force more bandwidth than was allowed if:

        - it takes a futex;
        - it is boosted while holding it;
        - never releases the futex;

     and this is sadly achievable since, if boosted, a task inherits top
     waiter parameters and the enforcement mechanism is temporarily
     disabled for it.
  
Thanks and regards,

- Juri
