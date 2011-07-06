Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1GFVim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:38:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23186 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1GFVil convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:38:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=equCUxwqNiOVWDgguoVBPmuNULSjdH3SEjuPwByQ8lQbYYCyU163l3JaXPQl+0ZLE
	i56qbDlPhKVkNos+ydO1A==
MIME-Version: 1.0
In-Reply-To: <1308739924.1022.19.camel@twins>
References: <20110621071649.862846205@google.com> <20110621071659.996203495@google.com>
 <1308739924.1022.19.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 6 Jul 2011 14:38:08 -0700
Message-ID: <CAPM31RKD+u1Xwb2bsWJbaOc13yBqAzx-hB5yb9+9wNnMDpYTiQ@mail.gmail.com>
Subject: Re: [patch 03/16] sched: introduce primitives to account for CFS
 bandwidth tracking
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 3:52 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-06-21 at 00:16 -0700, Paul Turner wrote:
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +       {
>> +               .name = "cfs_quota_us",
>> +               .read_s64 = cpu_cfs_quota_read_s64,
>> +               .write_s64 = cpu_cfs_quota_write_s64,
>> +       },
>> +       {
>> +               .name = "cfs_period_us",
>> +               .read_u64 = cpu_cfs_period_read_u64,
>> +               .write_u64 = cpu_cfs_period_write_u64,
>> +       },
>> +#endif
>
> Did I miss a reply to:
> lkml.kernel.org/r/1305538202.2466.4047.camel@twins ? why does it make
> sense to have different periods per cgroup? what does it mean?
>

Sorry for the delayed reply -- I never hit send on this one.

The reason asymmetric periods are beneficial is a trade-off exists
between latency and throughput.  The 3 major "classes" I see are:

Latency sensitive applications with a very continuous work
distribution of work may look to use a very tight bandwidth period
(e.g. 10ms).  This provides very consistent/predictable/repeatable
performance as well as limiting their bandwidth imposed tail
latencies.

Latency sensitive applications who experience "bursty", or
inconsistent work distributions.  In this case expanding the period
slightly to improve burst capacity yields a large performance benefit;
while protecting the rest of the system's applications should they
burst beyond their provisioning.

Latency insensitive applications in which we care only about
throughput.  For this type of application we care only about limiting
their usage over a prolonged period of time, with tail latency
concern.  For applications in this class we can use large periods to
minimize overheads / maximize throughput.

These classes are somewhat orthogonal and as such they pack fairly
well on machines together; but support for this requires period
granularity to be at the hierarchy -- and not machine -- level.

(This is also briefly covered in the updated documentation.)
