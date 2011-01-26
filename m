Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1AZMBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:01:03 -0500
Received: from smtp-out.google.com ([216.239.44.51]:20962 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1AZMBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O0GUNU+a+pdlV3dIkz8dg329SCtQNNeLz73iCY5Pll10S2LNE9/J2sncltfqTJMGc6
         3owk8YzPrg5G4LBVd2vQ==
MIME-Version: 1.0
In-Reply-To: <20110126113740.GA13911@elte.hu>
References: <201101062000.p06K0ESw011195@hera.kernel.org>
	<20110126113740.GA13911@elte.hu>
Date: Wed, 26 Jan 2011 13:00:56 +0100
Message-ID: <AANLkTintgqOkwo=WRH_9vGwGgXf0XrfU2e++daUOOG=i@mail.gmail.com>
Subject: Re: perf, x86: Provide a PEBS capable cycle event
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 12:37 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
>
>> Gitweb:     http://git.kernel.org/linus/7639dae0ca11038286bbbcda05f2bef601c1eb8d
>> Commit:     7639dae0ca11038286bbbcda05f2bef601c1eb8d
>> Parent:     abe43400579d5de0078c2d3a760e6598e183f871
>> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
>> AuthorDate: Tue Dec 14 21:26:40 2010 +0100
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Thu Dec 16 11:36:44 2010 +0100
>>
>>     perf, x86: Provide a PEBS capable cycle event
>>
>>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>     LKML-Reference: <new-submission>
>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel.c |   26 ++++++++++++++++++++++++++
>>  1 files changed, 26 insertions(+), 0 deletions(-)
>
> btw., precise profiling via PEBS:
>
>  perf record -e cycles:p ...
>
> works pretty nicely now on Nehalem CPUs and later.
>
The problem is that cycles:p is not equivalent to cycles in terms of how
cycles are counted. cycles counts only unhalted cycles. cycles:p counts
ALL cycles, event when the CPU is in halted state.

Thus, in per-thread mode, I believe you, it works.

In system-wide, it all depends on how the kernel is configured w.r.t. to idle
and what your workload does. If you know you're never going idle on any
of the monitored CPUs during the measurement, then you're fine.

Otherwise, you have a distortion. You can get samples from halted CPUs,
likely pointing to the idle routine.

If your system uses idle=poll, then you are okay. Otherwise, the problem
mentioned above applies.


> Could we perhaps make perf record and perf top default to cycles:p on x86, and
> silently fall back to regular cycles events if the CPU does not support this event
> type?
>
> That would make our profiles more precise by default - without users having to do
> anything funky.
>
> Thanks,
>
>        Ingo
>
