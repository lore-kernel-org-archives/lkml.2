Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0JDIxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:53:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12696 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0JDIxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:53:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FLZeddsqQXVUuzD8Sl0BPj2xV56JtAzoZFN7ujnB3x5n+Xa4h06QKO4WWf/hyG66pX
         BlTtmP9OHMBOlZaMovew==
MIME-Version: 1.0
In-Reply-To: <20101002093524.GJ13563@erda.amd.com>
References: <20100929154528.GD9440@lenovo>
	<AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com>
	<20100929170924.GR13563@erda.amd.com>
	<20100929181207.GW26290@redhat.com>
	<AANLkTimp=+1GzBOYaUZWtDF6teGt6FZe+RTpb9fAyOyd@mail.gmail.com>
	<20100930091246.GV13563@erda.amd.com>
	<20100930194451.GI26290@redhat.com>
	<20101001071750.GB13563@erda.amd.com>
	<AANLkTimUyLaVaBigjm0-CwRsdh4UXWDiss2ffX53S+k_@mail.gmail.com>
	<AANLkTik4KmzqeHTGXZAcQtg80YkBRPDqegLOaMvTvDAQ@mail.gmail.com>
	<20101002093524.GJ13563@erda.amd.com>
Date: Mon, 4 Oct 2010 10:53:02 +0200
Message-ID: <AANLkTi=YNhc0g+Cwcwg=DdoYJUxO7sb6GZSAEC-qvEU+@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 2, 2010 at 11:35 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 01.10.10 07:53:37, Stephane Eranian wrote:
>
>> That's another issue I have with this NMI callchain logic. It is hard to tell
>> who's in front of who in each callchain. You may have two registered users
>> at the same priority, the one which registers last gets priority.
>>
>> We may not want perf_event to run at the lowest priority because it is
>> performance sensitive, remember that the counters are running until
>> you get to the handler. Unlike many of the other subsystems on the
>> call chain perf_event is doing performance monitoring not debugging.
>> The rate of calls on the chain is now very high.
>
> Yes, actually the perf handler should run with the highest priority to
> reduce overhead when executing the handler chain. As this will cause
> implications to other handlers I think the most promising approach
> will be Andi's suggestion to separate the nmi handlers from the die
> chain by adding a new one. We should consider this when reworking the
> die handler (cc'ing Huang).
>
I haven't seen Andi's suggestion. But I am guessing he is suggesting
adding a new chain that would be called first and where there would
ONLY be the perf_event subsystem. To handle the spurious PMU
interrupts perf_events would also be added to the lowest priority
list (the one called last) and it would be placed as the last item on
that list (equiv to NMI_UNKNOWN).

Is that the idea?
