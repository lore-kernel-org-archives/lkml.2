Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1BYD0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 22:26:47 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13671 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab1BYD0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 22:26:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=a5a1pEbP9jEzTZG6uoYMXTiAIKCSGK5yWo/8JYvbT0pgnsvVjYEPcB0I4ashFhhjp+
         EVVm1y8fqFAZEJh36KJQ==
MIME-Version: 1.0
In-Reply-To: <1298467932.2217.763.camel@twins>
References: <20110216031831.571628191@google.com> <20110216031841.258879435@google.com>
 <1298467932.2217.763.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Thu, 24 Feb 2011 19:26:14 -0800
Message-ID: <AANLkTinqp_gfhoLGe0_ShbahzHBLeMZoho46_aMAe17k@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 5/7] sched: add exports tracking cfs
 bandwidth control statistics
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 5:32 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:
>> +       raw_spin_lock(&cfs_b->lock);
>> +       cfs_b->throttled_time += (rq->clock - cfs_rq->throttled_timestamp);
>> +       raw_spin_unlock(&cfs_b->lock);
>
> That seems to put the cost of things on the wrong side. Read is rare,
> update is frequent, and you made the frequent thing the most expensive
> one.

Hum.. the trade-off here is non-trivial I think

- This update is only once per-quota period (*if* we throttled within
that period).  This places the frequency in the 10s-100s of ms range.
- Sampling would probably occur on an order of once a second (assuming
some enterprise management system that cares about these statistics).

If we make the update cheaper by moving this per-cpu, then yes the
updates are cheaper but the reads now having per-cpu cost makes the
overall cost about the same (multiplying frequency by delta cost).

We could move the global accrual to an atomic, but this isn't any
cheaper given that this lock shouldn't be
contended.

>
>
>
