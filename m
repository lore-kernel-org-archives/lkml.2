Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0EQBdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 21:33:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42096 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0EQBdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 21:33:49 -0400
MIME-Version: 1.0
Message-ID: <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>
Date: Sun, 16 May 2010 18:31:30 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Venkatesh Pallipadi <venki@google.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <1273887635-27610-1-git-send-email-venki@google.com>
 <87tyq9mqrz.fsf@basil.nowhere.org>
 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
 <20100515121424.38f5b389@infradead.org>
 <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
 <20100515224305.17a04022@infradead.org>
 <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>
 <b7b4f345-944c-4cbc-b98a-700f915183b9@default
 alpine.LFD.2.00.1005161925480.3368@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005161925480.3368@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BF09CDD.01C2:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > > What we can talk about is a vget_tsc_raw() interface along with a
> 
> What I have in mind and what I'm working on for quite a while is going
> to work on both bare metal and VMs w/o hidden slowness.

Well, if this can be done today/soon and is fast enough
(say <2x the cycles of a rdtsc), I am very interested and
"won't let my friends use rdtsc" :-)  Anything I can do
to help?

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> We try to use it for performance sake, but the kernel does at least
> it's very best to find out when it goes bad. We then switch back to a
> hpet or pm-timer which is horrible performance wise but does not screw
> up timekeeping and everything which relies on it completely.
>  :
> As I said, we try our very best to determine when things go awry, but
> there are small errors which occur either sporadic or after longer
> uptime which we cannot yet detect reliably. Multi-socket falls into
> that category, but we are working on that.

> From: Arjan van de Ven [mailto:arjan@infradead.org]
> Why do you think we do extensive and continuous validation of the tsc
> (and soon, continuous recalibration)

So the kernel has the ability to detect that the TSC
is "OK for now", but must use some kind of polling
(periodic warp test) to recognize that TSC has
gone "bad".  As long as TSC is good AND a sophisticated
enterprise app understands that TSC might go bad at
some point in the future AND if the kernel exposes
"goodness" information AND the app (like the kernel) is
resilient** to the possibility that there might be some
period of time that obtained timestamps might be
"bad" before the app polls the kernel to find out that
the kernel says they are indeed "bad"... why should it
be forbidden for an app to use TSC?

(** e.g. increments its own tsc_last to ensure time never goes
backwards)

It seems like the only advantages the kernel has here over
a reasonably intelligent app is that: 1) the kernel can run
a warp test and the app can't, and 2) the kernel can
estimate the frequency of the TSC and the app can't.
AND, in the case of a virtual machine, the kernel has
neither of these advantages anyway.

So though I now understand and agree that neither the kernel
nor an app can guarantee that TSC won't unexpectedly go from
"good" to "bad", I still don't understand why "TSC goodness"
information shouldn't be exposed to userland, where an
intelligent enterprise app can choose to use TSC when it is good
(for the same reason the kernel does: "for performance sake")
and choose to stop using it when it goes bad (for the same
reason the kernel does: to "not screw up timekeeping").

It sounds as if you are saying that "the kernel is allowed
to use a rope because if it accidentally gets the rope
around its neck, it has a knife to ensure it doesn't hang
itself" BUT "the app isn't allowed to use a rope because
it might hang itself and we'll be damned if we loan
our knife to an app because, well... because it doesn't
need a knife because we said it shouldn't use the rope".

I think you can understand why this isn't a very satisfying
explanation.

P.S. Thanks for taking the time to discuss this!

