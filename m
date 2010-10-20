Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0JTJYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:24:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12619 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0JTJYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HdCs8NYqkcuG8q5MAg8YmgDUSPWwRGwx73H2cfVHT8VTD+nTqYM+wg5M5CI98jhaQK
         0AxZohn//16+DlNzpZTQ==
MIME-Version: 1.0
In-Reply-To: <20101018223539.GB5370@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
	<1286946421-32202-3-git-send-regression-fweisbec@gmail.com>
	<1286954453.29097.58.camel@twins>
	<AANLkTinhGrdGyLaOGtXPktQM2uQ_0M9XQ1GjtBAYf+LY@mail.gmail.com>
	<20101014112000.GA5336@nowhere>
	<AANLkTimVPNntcSexdRnkvd+4VdGf2HU+rM7Zhyu=i7CS@mail.gmail.com>
	<20101015225722.GA5354@nowhere>
	<1287310023.1998.150.camel@laptop>
	<AANLkTi=Ja1Yem9Nkdz06_ZxtvxGZUPbGYqusfcf3iN-G@mail.gmail.com>
	<20101018223539.GB5370@nowhere>
Date: Wed, 20 Oct 2010 11:24:42 +0200
Message-ID: <AANLkTinteS8FFNZQ6ZadB4WMZUUKYeTYfatggBNdF1xA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] perf: Add ability to dump user regs
From: Stephane Eranian <eranian@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:35 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> On Mon, Oct 18, 2010 at 12:01:18PM +0200, Stephane Eranian wrote:
>> On Sun, Oct 17, 2010 at 12:07 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Sat, 2010-10-16 at 00:58 +0200, Frederic Weisbecker wrote:
>> >> > Yes, PEBS does not capture the entire state.
>> >> >
>> >> > Here is what you get on Intel Core:
>> >> >         u64 flags, ip;
>> >> >         u64 ax, bx, cx, dx;
>> >> >         u64 si, di, bp, sp;
>> >> >         u64 r8,  r9,  r10, r11;
>> >> >         u64 r12, r13, r14, r15;
>> >
>> >> Ok, that seems to cover most of the state. I guess few people care
>> >> about cs, ds, es, fs, gs, most of the time.
>> >
>> > Yeah, except if you want to profile wine or something like that ;-)
>> >
>> That means that if you want the segment registers, then you cannot
>> use PEBS. I think you could catch that when the event is created.
>>
>> The other problem here is how to name registers at the API level.
>> You would be introducing architecture-specific register names
>> in perf_event.h. There is no such a thing today.
>
>
> That can go into an asm/perf_regs.h or something. It's up to the
> arch to name its registers.
>
I am fine with that.

Starting with Nehalem,  there is a PEBS mode where HW captures
not just actual register state but also information about cache misses
such as the data address, miss latency, data source. Those are
stored in the PEBS record as u64. I believe we could also expose
this thru this register bitmask mechanism. Of course, you'd get a
failure if PEBS is not programmed correctly.

The alternative would be to invent yet another generic abstraction
to sample cache misses. Note that PEBS cache miss sampling
cannot be attached to an existing generic cache miss event. It
uses a dedicated event which does not count all cache misses.
