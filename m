Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0KYNTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:19:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:48422 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab0KYNTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:19:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lHtY4IGjivZrKM175C9uT3UWW0kMZhiZ9pjXeuGo95dFwr1OQbfbqQd/NUzP0+0M7l
         qPF/hpzdlhOq1ciDGEjQ==
MIME-Version: 1.0
In-Reply-To: <1290666760.2072.539.camel@laptop>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
	<1290666760.2072.539.camel@laptop>
Date: Thu, 25 Nov 2010 14:19:46 +0100
Message-ID: <AANLkTi=WE3C6=Jutwnw6=UQ4jxj+q64Qga+C7R0-tGL-@mail.gmail.com>
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to "perf stat"
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 7:32 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2010-11-24 at 17:54 -0800, Corey Ashford wrote:
>> Add the ability to create multiple event groups, each with their own leader
>> using the existing "-e <event>[,<event> ...] [-e <event>[,<event>]]"
>> syntax.  Each additional -e switch creates a new group, and each event
>> listed within a -e switch is within that group.
>>
>> Changes since v1:
>> - Because of a flub, v2 did not contain the changes I had intended to make,
>> and instead, v2 had the same patch contents as v1.
>> - When perf stat is not supplied any events on the command line, put
>> each default event in its own group.
>
> I like this, but could you also extend this to perf-record? its a bit
> odd to diverge between the two.
>
> Using Stephane's latest syntax changes you could actually do something
> like:
>
> perf record -e task-clock:freq=1000,cycles:period=0
>
> Which would create a group with 1 sampling counter and a counting
> counter (at which point we should probably start flipping
> PERF_SAMPLE_READ).
>

I think using PERF_SAMPLE_READ may expose a problem in the
perf.data format. To correctly parse a sample created with SAMPLE_READ,
you need to know the attr.read_format. But for that you need to know the
event which caused the sample, but for that you need the SAMPLE_ID,
and you don't know if it's there or not. In other words, there is a chicken
and egg problem.

I think the issue is that PERF_RECORD_SAMPLE is missing a mandatory
piece of information: overflow event ID. This must a mandatory field, not
optional as it is today. It is okay when you have only one group, but we'd
like to go beyond that.
