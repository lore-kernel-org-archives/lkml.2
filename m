Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0FEFfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 01:35:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36595 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab0FEFfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 01:35:08 -0400
MIME-Version: 1.0
In-Reply-To: <20100605011826.GB21016@count0.beaverton.ibm.com>
References: <20100603193045.GA7188@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<1275644619.27810.39462.camel@twins>
	<201006050138.30859.rjw@sisk.pl>
	<alpine.LFD.2.00.1006050148080.2933@localhost.localdomain>
	<AANLkTikGDSzaENwg_0BAtsYf3ulGd_6sGPR30WsvUxMi@mail.gmail.com>
	<20100605011826.GB21016@count0.beaverton.ibm.com>
Date: Fri, 4 Jun 2010 22:35:06 -0700
Message-ID: <AANLkTim3MMfJ6oa9OhUJch_v1qGyxSfrfxF3zDZhxqHk@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/4 Matt Helsley <matthltc@us.ibm.com>:
> On Fri, Jun 04, 2010 at 05:39:17PM -0700, Arve Hjønnevåg wrote:
>> On Fri, Jun 4, 2010 at 5:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Sat, 5 Jun 2010, Rafael J. Wysocki wrote:
>
> <snip>
>
>>
>> >     With the cgroup freezer you can "suspend" them right away and
>> >     just keep the trusted background task(s) alive which allows us to
>> >     go into deeper idle states instead of letting the crapplications
>> >     run unconfined until the download finished and the suspend
>> >     blocker goes away.
>> >
>>
>> Yes this would be better, but I want it in addition to suspend, not
>> instead of it. It is also unclear if our user-space code could easily
>> make use of it since our trusted code calls into untrusted code.
>>
>
> Perhaps I'm misunderstanding, but suspend and the cgroup freezer
> interoperate well today -- you don't have to choose one or the other.
> If you've discovered otherwise I'd consider it a bug and would like to
> hear more about it.
>

I'm not aware of any bug with combining both, but we cannot use
suspend at all without suspend blockers in the kernel (since wakeup
events may be ignored) and I don't know how we can safely freeze
cgroups without funneling all potential wakeup events through a
process that never gets frozen.

> <snip>
>
>> it can handle bad apps better (assuming you don't combine
>> opportunistic suspend and cgroup freezing).
>
> I don't see why that would be a problem. The cgroup freezer works
> independently of the suspend freezer -- even with suspend blockers.
> So my hunch is this is really the same as the next problem you refer to:
>
>> The biggest hurdle is how
>> to handle dependencies between processes that gets frozen and
>> processes that don't get frozen.
>
> I'm not sure it covers everything you want, but it should be possible to
> identify some of those so long as you know which process you're
> communicating with.
>
> A trusted app can look up the freezer cgroup of a target app in /proc, then
> look at the cgroup's freezer.state file. If it's FREEZING or FROZEN then
> you've very likely got a "bad" dependency.
>

I don't think they are "bad" dependencies. Our framework has to
communicate with apps.

> For example, say a trusted app plans on doing a blocking read() to fetch
> the output of an untrusted app via a pipe. Assuming we know the untrusted
> app's pid we could then check the dependency and determine that we're likely
> to block because the untrusted app's freezer cgroup is FREEZING or FROZEN.
> (certain to block if we see FROZEN)
>
> That said, it involves quite a few system calls compared to a simple read()
> from the pipe. So my guess is it would be a debugging tool at best -- not
> something you always have enabled.
>
> It may even be possible to make an lsof-like debugging tool to do that from
> outside both apps.
>
> Cheers,
>        -Matt Helsley
>

-- 
Arve Hjønnevåg
