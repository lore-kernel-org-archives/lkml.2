Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1F2C3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 22:29:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38939 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1F2C3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 22:29:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tarH1e+60l/QFfLRllC2qHeU39e18I3OGvSCwm4HASrotDITSKkN5MUbtIEhMlpP7
	RQHE8heEbrnmNxmYUgeVQ==
MIME-Version: 1.0
In-Reply-To: <CAPM31RK7O3Fk5nb+ApiOBjeN5texNodCNibAbLLLxbwXtaCoog@mail.gmail.com>
References: <20110621071649.862846205@google.com> <20110621071700.395400025@google.com>
 <1308757658.1022.50.camel@twins> <CAPM31RK7O3Fk5nb+ApiOBjeN5texNodCNibAbLLLxbwXtaCoog@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 28 Jun 2011 19:29:03 -0700
Message-ID: <CAPM31RKsOoKMBVFCHC=1D+XGgdNbYXLA2Cur1vOzJ9RX=pbs2g@mail.gmail.com>
Subject: Re: [patch 07/16] sched: expire invalid runtime
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

On Mon, Jun 27, 2011 at 9:42 PM, Paul Turner <pjt@google.com> wrote:
> On Wed, Jun 22, 2011 at 8:47 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Tue, 2011-06-21 at 00:16 -0700, Paul Turner wrote:
>>
>>> +     now = sched_clock_cpu(smp_processor_id());
>>> +     cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
>>
>>> +     if ((s64)(rq->clock - cfs_rq->runtime_expires) < 0)
>>
>> Is there a good reason to mix these two (related) time sources?
>>
>
> It does make sense to remove the (current) aliasing dependency, will
> use rq->clock for setting expiration.
>

So looking more closely at this I think i prefer the "mix" after all.

Using rq->clock within __refill_cfs_bandwidth_runtime adds the requirement
of taking rq->lock on the current cpu within the period timer so that
we can update rq->clock (which then just gets set to sched_clock
anyway).

Expiration logic is already dependent on the fact that rq->clock
snapshots sched_clock (the 2ms bound on clock-to-clock drift).  Given
that this is an infrequent (once/period) operation I think it's better
to leave it as an explicit sched_clock_cpu call, with an explanatory
comment.
