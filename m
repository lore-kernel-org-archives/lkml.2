Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1ERHQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:16:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53195 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab1ERHQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:16:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ypG+8zVAlxajwe2OcS344ZaYl1NOcsMLgwx7Jtqf76CIYVAz4dmU76qRkXZ0gp/pqb
         ihbLHdqFhJy2AWwK6bkA==
MIME-Version: 1.0
In-Reply-To: <1305646010.2466.5889.camel@twins>
References: <20110503092846.022272244@google.com> <20110503092904.806273470@google.com>
 <1305539020.2466.4063.camel@twins> <BANLkTinba-p6FJNYAPyE+B8A==vSfK1-rg@mail.gmail.com>
 <1305646010.2466.5889.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 18 May 2011 00:16:08 -0700
Message-ID: <BANLkTikDofPR0TJwV8G=sVhG_GQKru9XhQ@mail.gmail.com>
Subject: Re: [patch 04/15] sched: validate CFS quota hierarchies
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 8:26 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-05-16 at 05:32 -0700, Paul Turner wrote:
>> On Mon, May 16, 2011 at 2:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> >
>> > On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
>> > > This behavior may be disabled (allowing child bandwidth to exceed parent) via
>> > > kernel.sched_cfs_bandwidth_consistent=0
>> >
>> > why? this needs very good justification.
>>
>> I think it was lost in other discussion before, but I think there are
>> two useful use-cases for it:
>>
>> Posting (condensed) relevant snippet:
>
> Such stuff should really live in the changelog
>

Given the discussion below it would seem to make sense to split the CL
into one part that adds the consistency checking.  And (potentially,
depending on the discussion below) another that provides these state
semantics.  This would also give us a chance to clearly call these
details out in the commit description.

>> -----------------------------------------------------------
>> Consider:
>>
>> - I have some application that I want to limit to 3 cpus
>> I have a 2 workers in that application, across a period I would like
>> those workers to use a maximum of say 2.5 cpus each (suppose they
>> serve some sort of co-processor request per user and we want to
>> prevent a single user eating our entire limit and starving out
>> everything else).
>>
>> The goal in this case is not preventing increasing availability within a
>> given limit, while not destroying the (relatively) work-conserving aspect of
>> its performance in general.
>>
>> (...)
>>
>> - There's also the case of managing an abusive user, use cases such
>> as the above means that users can usefully be given write permission
>> to their relevant sub-hierarchy.
>>
>> If the system size changes, or a user becomes newly abusive then being
>> able to set non-conformant constraint avoids the adversarial problem of having
>> to find and bring all of their set (possibly maliciously large) limits
>> within the global limit.
>> -----------------------------------------------------------
>
>
> But what about those where they want both behaviours on the same machine
> but for different sub-trees?

I originally considered a per-tg tunable.  I made the assumption that
users would either handle this themselves (=0) or rely on the kernel
to do it (=1).  There are some additional complexities that lead me to
withdraw from the per-cg approach in this pass given the known
resistance to it.

One concern was the potential ambiguity in the nesting of these values.

When an inconsistent entity is nested under a consistent one:

A) Do we allow this?
B) How do we treat it?

I think if this was the case that it would make sense to allow it and
that each inconsistent entity should effectively be treated as
terminal from the parent's point of view, and as the new root from the
child's point of view.

Does this make sense?  While this is the most intuitive definition for
me there are certainly several other interpretations that could be
argued for.

Would you prefer this approach be taken to consistency vs at a global
level?  Do the use-cases above have sufficient merit that we even make
this an option in the first place?  Should we just always force
hierarchies to be consistent instead?  I'm open on this.

>
> Also, without the constraints, what does the hierarchy mean?
>

It's still an upper-bound for usage, however it may not be achievable
in an inconsistent hierarchy.  Whereas in a consistent one it should
always be achievable.
