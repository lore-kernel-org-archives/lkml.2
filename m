Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1F1Bns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:43:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17590 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab1F1Bmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=nG+YdY915f6940tA1yaX5fo0Vn9GjfFypbIS802k6iNka5KLMTpIc77TACGrsRTTu2
         z+EHyvjPpUg/0e7VbiDA==
MIME-Version: 1.0
In-Reply-To: <1308842778.1022.136.camel@twins>
References: <20110621071649.862846205@google.com> <20110621071701.165027089@google.com>
 <1308842778.1022.136.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Mon, 27 Jun 2011 18:42:11 -0700
Message-ID: <CAPM31RLtNnJqX00vTQ6PbUcGRhNufbvb1OdGkXs4i2+=4=A5eA@mail.gmail.com>
Subject: Re: [patch 15/16] sched: return unused runtime on voluntary sleep
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 8:26 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-06-21 at 00:17 -0700, Paul Turner wrote:
>> plain text document attachment (sched-bwc-simple_return_quota.patch)
>> When a local cfs_rq blocks we return the majority of its remaining quota to the
>> global bandwidth pool for use by other runqueues.
>
> OK, I saw return_cfs_rq_runtime() do that.
>
>> We do this only when the quota is current and there is more than
>> min_cfs_rq_quota [1ms by default] of runtime remaining on the rq.
>
> sure..
>
>> In the case where there are throttled runqueues and we have sufficient
>> bandwidth to meter out a slice, a second timer is kicked off to handle this
>> delivery, unthrottling where appropriate.
>
> I'm having trouble there, what's the purpose of the timer, you could
> redistribute immediately. None of this is well explained.
>

Current reasons:
- There was concern regarding thrashing the unthrottle path on a task
that is rapidly oscillating between runnable states, using a timer
this operation is inherently limited both in frequency and to a single
cpu.  I think the move to using a throttled list (as opposed to having
to poll all cpus) as well as the fact that we only return quota in
excess of min_cfs_rq_quota probably mitigates this to the point where
we could just do away with this and do it directly in the put path.

- The aesthetics of releasing rq->lock in the put path.  Quick
inspection suggests it should actually be safe to do at that point,
and we do similar for idle_balance().

Given consideration the above two factors are not requirements, this
could be moved out of a timer and into the put_path directly (with the
fact that we drop rq->lock strongly commented).  I have no strong
preference between either choice.

Uninteresting additional historical reason:
The /original/ requirement for a timer here is that previous versions
placed some of the bandwidth distribution under cfs_b->lock.  This
meant that we couldn't take rq->lock under cfs_b->lock (as the nesting
is the other way around).  This is no longer a requirement
(advancement of expiration now provides what cfs_b->lock used to
here).




A timer is used so that we don't have to release rq->lock within the put path
