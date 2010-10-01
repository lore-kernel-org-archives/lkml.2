Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0JALxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:53:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:14991 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab0JALxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ocx7pgpHliA1nV62IRdDKbyhIx5P+JN/AIUAmXczhJrORtIwzEVygm6DwI6KxK0/NV
         xzvKQ0mEHQOyyqIqDWLA==
MIME-Version: 1.0
In-Reply-To: <AANLkTimUyLaVaBigjm0-CwRsdh4UXWDiss2ffX53S+k_@mail.gmail.com>
References: <20100929151253.GL13563@erda.amd.com>
	<20100929152745.GC9440@lenovo>
	<AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
	<20100929154528.GD9440@lenovo>
	<AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com>
	<20100929170924.GR13563@erda.amd.com>
	<20100929181207.GW26290@redhat.com>
	<AANLkTimp=+1GzBOYaUZWtDF6teGt6FZe+RTpb9fAyOyd@mail.gmail.com>
	<20100930091246.GV13563@erda.amd.com>
	<20100930194451.GI26290@redhat.com>
	<20101001071750.GB13563@erda.amd.com>
	<AANLkTimUyLaVaBigjm0-CwRsdh4UXWDiss2ffX53S+k_@mail.gmail.com>
Date: Fri, 1 Oct 2010 13:53:37 +0200
Message-ID: <AANLkTik4KmzqeHTGXZAcQtg80YkBRPDqegLOaMvTvDAQ@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[repost due to mime-encoding error on my part]

On Fri, Oct 1, 2010 at 9:17 AM, Robert Richter <robert.richter@amd.com>wrote:

> On 30.09.10 15:44:51, Don Zickus wrote:
> > On Thu, Sep 30, 2010 at 11:12:46AM +0200, Robert Richter wrote:
>
> > > As soon as you stop executing the chain, there are chances to miss an
> > > nmi for other parts of the system. Where is no way to avoid this. So
> > > your argument above is valid also for regular perf nmis and not only
> > > for catched-spurious or back-to-back nmis.
> >
> > I don't agree with that.  Most nmi handlers can do a check to see if
> their
> > subsystem triggered an nmi or not.  Now we may not catch it in the right
> > order because one handler is higher in the chain than the other, but
> > ultimately the other handler will get its chance to execute because it
> > fired its own nmi (which hasn't been lost).
>
> No, as soon as a handler with higher priority detected an nmi by its
> own and handled it, it returns with a stop and all subsequent handlers
> get ignored without the chance to check their hardware. So, if perf
> consumes an nmi because a counter triggered, there are rare cases that
> other handlers may not be executed.
>

And that's what you want to avoid.

> > Whereas the problem Stephane is describing is that the heurestics of the
> > perf counters 'eats' an NMI, thus possibly starving another handler.
> > With back-to-back nmis we are at least polite, letting everyone have a chance
> > to process the nmi before we indulge ourselves and 'eat' it (if it still
> > around to be eaten).
> >
> > However in the case of the 'catched-spurious', we selfishly 'eat' the NMI
> > without really knowing if it was our to be eaten.  That was the
> > difference and the concern.
>
> But, this argument is valid. It would be better to handle
> catched-spurious in the 'unknown' path to give other handlers the
> chance to check their hardware.
>

Yes, that was my point. You cannot do it until the kernel invokes the
handler on the 'unknown nmi' callchain.


> I don't think this is a show-stopper for v2.6.36 even because the perf
> handler runs with the lowest priority now. So we will have enough time
> after the merge window to improve the code here.
>
>
That's another issue I have with this NMI callchain logic. It is hard to tell
who's in front of who in each callchain. You may have two registered users
at the same priority, the one which registers last gets priority.

We may not want perf_event to run at the lowest priority because it is
performance sensitive, remember that the counters are running until
you get to the handler. Unlike many of the other subsystems on the
call chain perf_event is doing performance monitoring not debugging.
The rate of calls on the chain is now very high.
