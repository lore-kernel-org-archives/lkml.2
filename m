Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0I2QBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:01:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41504 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab0I2QBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rxto82xOgSpDJoFxMzK6HHSsvGwXJQGIK9u2W1vbm6NH+qoSf/qxXSXSb70CPg3qNZ
         hNxuTJcR1LA6a7QiwMPA==
MIME-Version: 1.0
In-Reply-To: <20100929154528.GD9440@lenovo>
References: <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
	<AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
	<20100929125301.GG13563@erda.amd.com>
	<20100929125453.GH13563@erda.amd.com>
	<AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
	<AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
	<20100929150140.GK13563@erda.amd.com>
	<20100929151253.GL13563@erda.amd.com>
	<20100929152745.GC9440@lenovo>
	<AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
	<20100929154528.GD9440@lenovo>
Date: Wed, 29 Sep 2010 18:00:35 +0200
Message-ID: <AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 5:45 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Sep 29, 2010 at 05:33:07PM +0200, Stephane Eranian wrote:
>> Robert,
>>
>> There is something else bothering me with cpuc->running.
>>
>> It is not reset outside of the interrupt handler. So what if
>> event scheduling shuffles things around and an event is
>> moved somewhere else. Don't you need to clear the
>> cpuc->running[idx] for the old counter index?
>>
>>
>
> Both bitmasks are set and test with same index though it might
> be a bit obscure scheme (we could be clearing this bit in
> x86_pmu_stop but it just a wasting cycles).
>
But you cannot clear it in x86_pmu_stop() because otherwise it
turns into active_mask[]. My understanding is that you need
to remember this counter has been active at some point in the
past.

My point is that you cannot keep this around forever. After a
"while" it becomes stale and you have to remove it otherwise
you may wrongly increment handled.

Here is a scenario:

event A -> counter 0, cpuc->running = 0x1 active_mask = 0x1
move A
event A -> counter 1, cpuc->running = 0x3, active_mask = 0x2

No interrupt, we are just counting for a short period.
Then, you get an NMI interrupt, suppose it is not generated
by the PMU, it is destined for another handler.

For i=0, you have (active_mask & 0x1) == 0, but (running & 0x1) == 1,
you mark the interrupt as handled, i.e., you swallow it, the actual
handler never gets it.


> Btw, since x86 architectural and p4 are using same tests for
> running I presume better to have some helper rather then
> open coded pile?
>
> Cyrill
>
