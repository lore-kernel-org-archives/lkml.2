Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1JROuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:50:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22295 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab1JROuu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:50:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Btsi8WlNaDiwTH/DMbEolGzhf9zIxPCFU6fQLJzNPijbJk+jLBreTglHpPtgnRJhx
	FpKi+hP4aYwIJ0o/rs4FQ==
MIME-Version: 1.0
In-Reply-To: <1318949002.21167.20.camel@twins>
References: <20111007204247.GA5444@mgebm.net>
	<20111010233842.GC24583@mgebm.net>
	<1318319095.14400.54.camel@laptop>
	<20111012165154.GB6158@mgebm.net>
	<CABPqkBRHkiOYEW+5Yo9p43c_2Dy+aAdJRXj3tah5J1QsV4AXrw@mail.gmail.com>
	<20111018135322.GA11530@mgebm.net>
	<1318949002.21167.20.camel@twins>
Date: Tue, 18 Oct 2011 16:50:42 +0200
Message-ID: <CABPqkBRxqC5c1JvvpDawkK9PizAfBGNCksR8bpyJ-rWB4LKmrQ@mail.gmail.com>
Subject: Re: Oprofile Regression Caused by commit e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25
 on PPC
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric B Munson <emunson@mgebm.net>, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I suspect it's because of this chunk:
        rcu_read_lock();

        list_for_each_entry_rcu(pmu, &pmus, entry) {
-
                cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);

-               perf_pmu_disable(cpuctx->ctx.pmu);
-
                /*
                 * perf_cgroup_events says at least one
                 * context on this CPU has cgroup events.
@@ -353,6 +366,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
                 * events for a context.
                 */
                if (cpuctx->ctx.nr_cgroups > 0) {
+                       perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+                       perf_pmu_disable(cpuctx->ctx.pmu);


In other words, you don't call perf_pmu_disable() unless you know
you have cgroup events.

Without that, I think you will touch the PMU on cgroup switch and
that night conflict with another subsystem using the PMU, e.g. OProfile.


On Tue, Oct 18, 2011 at 4:43 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-10-18 at 09:53 -0400, Eric B Munson wrote:
>> On Wed, 12 Oct 2011, Stephane Eranian wrote:
>>
>> > Could be:
>> >    a8d757e perf events: Fix slow and broken cgroup context switch code
>> >
>>
>> Thanks for the pointer, but the fix was in:
>>     facc4307 perf: Optimize event scheduling locking
>>
>> This might be a candidate for stable given that oprofile is broken without it.
>
> I might feel much more confident about recommending that if someone
> could explain why that patches fixes what exact problem.
>
