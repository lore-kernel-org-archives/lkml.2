Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0IUQSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:18:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58401 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab0IUQSC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u15/LtiIOxPP3y7Zr5CISfVmXv3ztyeZzxNNgkodoYjEjCTvZkmclGn5I2B67K9nO5
         UiZs0U4/s+yTg0ExQYCQ==
MIME-Version: 1.0
In-Reply-To: <1285077801.2275.881.camel@laptop>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	<1285061899.2275.824.camel@laptop>
	<1285062228.2275.826.camel@laptop>
	<AANLkTik-oMNJdakwsH=22LzgYvgd35aom+Zu2WkchUte@mail.gmail.com>
	<1285072975.2275.872.camel@laptop>
	<AANLkTinmHGtLFRa4O5DNRGgoRtM4cy65JgCw=sYxEjNF@mail.gmail.com>
	<1285077801.2275.881.camel@laptop>
Date: Tue, 21 Sep 2010 18:17:43 +0200
Message-ID: <AANLkTimFgsOkMaX9FFidqL-6SHStgqW6v73F3rM-Kmmz@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 4:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-09-21 at 15:38 +0200, Stephane Eranian wrote:
>> > Hmm, indeed. One thing we can do about that is move perf into the
>> > cgroup, create the counter (disabled) using self to identify the cgroup,
>> > move perf back to where it came from, and enable the counter.
>> >
>> Yes, that's another possibility. I wonder if there are any non-obvious
>> difficulties with this approach.
>
> Yes, there is, but I think we can fix it. The problem with moving perf
> itself around is that perf is not a fully dormant process and can thus
> interact with the cgroup state.
>
I was thinking about memory accounting for instance.

> If we were to fork a child that's simply sitting idle in waitpid() (or
> any other blocking syscall) we can move that around cgroup without
> affecting the cgroup itself.

But then things get a bit more complicated because the perf_event_open()
has to be done in that child. File descriptors created in child processes
and not shared with their parent. You'd have to pass file descriptors around.
That seems overly complicated.

I wonder if overloading pid to be a file descriptor open to a cgroup_fs file
would not be easier in the end.


>>  Is it as simple as:
>>    FILE *fp;
>>    fp = fopen("/dev/cgroup/test/tasks", "w");
>>    fprintf(fp, "%d", gettid());
>>    close(fp):
>
> Except I've never in my life mounted a cgroup filesystem in /dev/ :-)
>
