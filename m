Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2BFVTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:19:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59832 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2BFVTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:19:45 -0500
MIME-Version: 1.0
In-Reply-To: <20120206203738.GB556@aftab>
References: <20120206132546.GA30854@quad>
	<1328538403.2482.4.camel@laptop>
	<20120206153408.GA31237@aftab>
	<1328546246.2482.10.camel@laptop>
	<20120206164626.GA31704@aftab>
	<1328547259.2482.11.camel@laptop>
	<20120206202722.GA556@aftab>
	<1328560293.2482.24.camel@laptop>
	<20120206203738.GB556@aftab>
Date: Mon, 6 Feb 2012 13:19:44 -0800
Message-ID: <CABeCy1ZH_BQhoSegeyBnY0XkjL9afm5=onKrmt9SApufCWgs3A@mail.gmail.com>
Subject: Re: [BUG] perf: perf sched warning possibly due to clock granularity
 on AMD
From: Venki Pallipadi <venki@google.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu, robert.richter@amd.com,
        eric.dumazet@gmail.com, Andreas Herrmann <andreas.herrmann3@amd.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 12:37 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Mon, Feb 06, 2012 at 09:31:33PM +0100, Peter Zijlstra wrote:
>> On Mon, 2012-02-06 at 21:27 +0100, Borislav Petkov wrote:
>> > On Mon, Feb 06, 2012 at 05:54:19PM +0100, Peter Zijlstra wrote:
>> > > On Mon, 2012-02-06 at 17:46 +0100, Borislav Petkov wrote:
>> > > > > across all CPUs in the entire system.
>> > > >
>> > > > Right, by the "entire system" you mean consistent across cores and
>> > > > sockets but not necessarily across cabinets, as in the comment above,
>> > > > correct?
>> > > >
>> > > > If so, let me ask around if this holds true too.
>> > >
>> > > Every CPU available to the kernel. So if you run a single system image
>> > > across your cabinets, then yes those too.
>> >
>> > Ok, but what about that sentence "(but not across cabinets - we turn
>> > it off in that case explicitly.)" - I don't see any place where it is
>> > turned off explicitly... Maybe a stale comment?
>>
>> I suspect it might be the sched_clock_stable = 0 in mark_tsc_unstable(),
>> but lets ask Venki, IIRC he wrote all that.
>
> Yeah, I was looking at the code further and on Intel it does:
>
>        if (c->x86_power & (1 << 8)) {
>                set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>                set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
>                if (!check_tsc_unstable())
>                        sched_clock_stable = 1;
>        }
>
> while on AMD, in early_init_amd() we do:
>
>        if (c->x86_power & (1 << 8)) {
>                set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>                set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
>        }
>
> and having in mind that tsc_unstable is set on generic x86 paths,
> nothing stops us to do the same on AMD too, and as a result, set
> sched_clock_stable too.
>
> But yeah, let's see what Venki has to say first.
>

Looks like cabinet comment came from Ingo (commit 83ce4009) in reference to
    (We will turn this off in DMI quirks for multi-chassis systems)

Yes. If these two flags are set, TSC should be consistent and sched_clock_stable
could be set and it will be reset if there is a call to mark_tsc_unstable().

Thanks,
Venki
