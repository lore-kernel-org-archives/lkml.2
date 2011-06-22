Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1FVG6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:58:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55507 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1FVG6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:58:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bbrS3nPt4VX8V4P/r7uN+VVbrQR5WpZuXLo0PrQo5G9tESu6HVrtgjdyhXxh9mEKc1
         njjOsJviGqMHKJNDPPsA==
MIME-Version: 1.0
In-Reply-To: <20110622054340.GA2985@in.ibm.com>
References: <20110621071649.862846205@google.com> <20110621071700.092877579@google.com>
 <20110622054340.GA2985@in.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 21 Jun 2011 23:57:42 -0700
Message-ID: <BANLkTi=i78qcL6ui93+We0jiEVNLn9d2TA@mail.gmail.com>
Subject: Re: [patch 04/16] sched: validate CFS quota hierarchies
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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

On Tue, Jun 21, 2011 at 10:43 PM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
> On Tue, Jun 21, 2011 at 12:16:53AM -0700, Paul Turner wrote:
>> Add constraints validation for CFS bandwidth hierarchies.
>>
>> Validate that:
>>    max(child bandwidth) <= parent_bandwidth
>>
>> In a quota limited hierarchy, an unconstrained entity
>> (e.g. bandwidth==RUNTIME_INF) inherits the bandwidth of its parent.
>>
>> This constraint is chosen over sum(child_bandwidth) as notion of over-commit is
>> valuable within SCHED_OTHER.  Some basic code from the RT case is re-factored
>> for reuse.
>>
>> Signed-off-by: Paul Turner <pjt@google.com>
>>
>> ---
>>  kernel/sched.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 96 insertions(+), 13 deletions(-)
>>
>> Index: tip/kernel/sched.c
>> ===================================================================
>> --- tip.orig/kernel/sched.c
>> +++ tip/kernel/sched.c
>> @@ -249,6 +249,7 @@ struct cfs_bandwidth {
>>       raw_spinlock_t lock;
>>       ktime_t period;
>>       u64 quota;
>> +     s64 hierarchal_quota;
>
> You mean hierarchical I suppose.
>

Yup!  Thanks

> Regards,
> Bharata.
>
