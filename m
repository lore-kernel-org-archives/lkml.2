Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570Ab1F1Sqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 14:46:30 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17818 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758999Ab1F1SqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 14:46:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=lsbDDyCiAIl5X6h2YHIKY0cl0C1MbxacWYAJiniaZN4YlOYD+G3yDZk/5gDXS3iC3
	4qW8JysC1RwsQNw5+R00w==
MIME-Version: 1.0
In-Reply-To: <1309255310.6701.186.camel@twins>
References: <20110621071649.862846205@google.com> <20110621071701.165027089@google.com>
 <1308842778.1022.136.camel@twins> <CAPM31RLtNnJqX00vTQ6PbUcGRhNufbvb1OdGkXs4i2+=4=A5eA@mail.gmail.com>
 <1309255310.6701.186.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 28 Jun 2011 11:45:48 -0700
Message-ID: <CAPM31R+ULd88FHvu8_wNi6LCxN=6vYfQJwNwjdBk1QVA_cbFzw@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 3:01 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-06-27 at 18:42 -0700, Paul Turner wrote:
>
>> - The aesthetics of releasing rq->lock in the put path.  Quick
>> inspection suggests it should actually be safe to do at that point,
>> and we do similar for idle_balance().
>>
>> Given consideration the above two factors are not requirements, this
>> could be moved out of a timer and into the put_path directly (with the
>> fact that we drop rq->lock strongly commented).  I have no strong
>> preference between either choice.
>
> Argh, ok I see, distribute_cfs_runtime() wants that. Dropping rq->lock
> is very fragile esp from the put path, you can only do that _before_ the
> put path updates rq->curr etc.. So I'd rather you didn't, just keep the
> timer crap and add some comments there.
>

Done.

An alternative that does come to mind is something like:

- cfs_b->lock may be sufficient synchronization to twiddle
cfs_rq->runtime_assigned (once it has been throttled, modulo alb)
- we could use this to synchronize a per-rq "to-be-unthrottled" list
which could be checked under something like task_tick_fair

We'd have to be careful about making sure we wake-up a sleeping cpu
but this hides the rq->lock requirements and would let us kill the
timer.

Perhaps this could be a future incremental improvement.

> And we need that distribute_cfs_runtime() muck because that's what
> unthrottles rqs when more runtime is available.. bah.
>
>
>
