Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab0ERVhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:37:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36177 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0ERVhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:37:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=sRqgNzSm280QYm1tH+CUFvZseMi1Q1zkj++Qezf8NheJ197yEfy7od12gcw0zruPXj
         nf1TnFlQj867pw3HyIXQNuR6t8YzbNPfzDYs98fxfHkibFxGtpOxndyTDo0NNrXxlhJC
         KUl8YOpKU+7nagWjWmpYDJzv7pZBxyHuLyOuM=
MIME-Version: 1.0
In-Reply-To: <20100518204204.GA23204@elte.hu>
References: <4BF18995.6070008@redhat.com> <4BF2392A.9040409@jp.fujitsu.com>
	 <4BF2C3D1.10009@redhat.com>
	 <1274204560.17703.82.camel@Joe-Laptop.home>
	 <20100518185305.GA23921@elte.hu>
	 <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
	 <20100518193022.GB30936@elte.hu> <20100518204204.GA23204@elte.hu>
Date: Tue, 18 May 2010 14:37:06 -0700
X-Google-Sender-Auth: RXnXTHi6CsfsQlTiuX0ckNzy0Y4
Message-ID: <AANLkTimPRvuoW5-OcPlPx5cvnCTJa7xhAQDSLrYziB4j@mail.gmail.com>
Subject: Re: Hardware Error Kernel Mini-Summit
From: Tony Luck <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, "Young, Brent" <brent.young@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 1:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> I proposed a (fairly straightforward) extension to which
>> Boris agreed: we can introduce 'persistent events',
>> which have task-less buffers attached to them, which
>> will hold (a configurable amount of) of events.
>>
>> Those can then be picked up by a task later on and no
>> event is lost.
>>
>> Would such a feature address your concern?
>
> Tony, should we accelerate the development of this
> persistent events sub-feature?

The persistent event feature sounds like it will solve
the early logging issue.

> Boris posted initial patches of the new perf events based
> EDAC/MCE/RAS design direction to lkml and indicated that
> it works for him. He also indicated that he can do the
> initial work of unifying EDAC and MCE without the
> persistent events feature for now. (this all is obviously
> v2.6.36-ish material)
>
> But if it's important, if you'd like to move ahead with
> the unification swiftly then we can certainly increase its
> priority.

We've missed the deadlines for inclusion in certain
popular distributions ... so it may be OK to take a
relatively leisurely path to getting this done right
rather than rushing.

> 3) Another new perf feature of interest is 'perf inject'
> (this too went upstream today): to inject artificial
> events into the stream of events. This mechanism could be
> used to simulate rare error conditions and to test out
> policy reactions systematically - an important part of
> system error recovery testing.

Simulated errors are handy for testing the very
top level of the s/w stack. But real errors are
better. There's some APEI code in Len's tree
that can inject real errors (on systems with the
right BIOS hooks enabled).

> This gives us a broad platform to add various RAS events
> as well, beyond raw hardware events: we could for example
> events for various system anomalies such as lockup
> messages, kernel warnings/oopses, IOMMU exceptions - maybe
> even pure software concepts such as fatal segmentation
> fault events, etc. etc.

This looks like sticky ground.  I can see the event mechanism
passing data to a user daemon working well for all kinds of
corrected and minor errors. But when you start talking about
lockups and fatal errors things get a lot trickier. Often the
main concern at this point is error containment. Making sure
that the flaky data doesn't become visible (saved to storage,
transmitted to the network, etc.). Getting from a machine check
handler through some context switches (and page
faults etc.) to a user level daemon before the error
gets recorded looks to be really hard.

> That way the RAS daemon could build and utilize a complete
> and coherent set of events it wants to subscribe to - all
> via the same event transport mechanism. It would thus have
> a comprehensive 'system health' view, via a single,
> reliable mechanism, and could act in a wide range of
> scenarios, with a wide range of policy actions, based on a
> very complete picture.

In a cluster/cloud/datacenter that daemon will need to be
networked and hooked to the system management tools
that are controlling the bigger environment. But I agree
that this looks like a worthy end goal.

-Tony
