Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab0JNJ1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:27:40 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab0JNJ1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NgQVp0b3+qn/2c7E/ExiyD2Gbno/C3XyrE1pVaFufP+UlUJQGB6Rnkf9rTNm6QzQ4g
         2zrFhtAG0XUUTut3n5Ug==
MIME-Version: 1.0
In-Reply-To: <1287047996.29097.173.camel@twins>
References: <20101012074910.GA9893@in.ibm.com> <20101012075109.GC9893@in.ibm.com>
 <1287047996.29097.173.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Thu, 14 Oct 2010 02:27:02 -0700
Message-ID: <AANLkTinJ_YyzPKZXwALoFyWTzipwd0MAYhJ1c0CBjQcS@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] sched: accumulate per-cfs_rq cpu usage
To: Peter Zijlstra <peterz@infradead.org>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 2:19 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-10-12 at 13:21 +0530, Bharata B Rao wrote:
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +       {
>> +               .procname       = "sched_cfs_bandwidth_slice_us",
>> +               .data           = &sysctl_sched_cfs_bandwidth_slice,
>> +               .maxlen         = sizeof(unsigned int),
>> +               .mode           = 0644,
>> +               .proc_handler   = proc_dointvec_minmax,
>> +               .extra1         = &one,
>> +       },
>> +#endif
>
> So this is basically your scalability knob.. the larger this value less
> less frequent we have to access global state, but the less parallelism
> is possible due to fewer CPUs depleting the total quota, leaving nothing
> for the others.
>

Exactly

> I guess one could go try and play load-balancer games to try and
> mitigate this by pulling this group's tasks to the CPU(s) that have move
> bandwidth for that group, but balancing that against the regular
> load-balancer goal of well balancing load, will undoubtedly be
> 'interesting'...
>

I considered this approach as an alternative previously, but I don't
think it can be enacted effectively:

Since quota will likely expire in a staggered fashion you're going to
get a funnel-herd effect as everything is crowded onto the cpus with
remaining quota.

It's much more easily avoided by keeping the slice small enough
(relative to the bandwidth period) that we're not potentially
stranding a significant percentage of our quota.  The potential for
abuse could be eliminated/reduced here by making the slice size a
constant ratio relative to the period length.  This would also make
possible parallelism more deterministic.

I also think versioning the quota so that it can be potentially
returned and redistributed on sleep is more effective/efficient in
avoiding stranded quota.

>
>
