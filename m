Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab2LWJXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 04:23:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab2LWJXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 04:23:51 -0500
Date: Sun, 23 Dec 2012 11:23:24 +0200
From: Gleb Natapov <gleb@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
Message-ID: <20121223092324.GN17584@redhat.com>
References: <20121211090910.GA22985@gmail.com>
 <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94A9C.2050900@gmail.com>
 <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
 <50C94ECD.6020504@gmail.com>
 <20121217102000.GE11016@redhat.com>
 <50D60A5B.1020700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D60A5B.1020700@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 12:30:35PM -0700, David Ahern wrote:
> On 12/17/12 3:20 AM, Gleb Natapov wrote:
> >Does the regression happen because of commit 20b279ddb38c. If it does I
> >think it is safe to revert it. KVM disables PEBS during guest entry now, so
> >VMs shouldn't be blowing up (they do not in my testing) and if they still
> >do we can disable the counter that has PEBS enabled on a guest entry too.
> >Yes, if user runs "perf record -e cycles:ppG" he will not know that
> >kernel ignored :pp modifier (with 20b279ddb38c he will get an error), but
> >at least old binaries will continue working and new binaries can do the
> >checking in userspace.
> >
> 
> Your patch alone was not enough. Start here:
>  https://lkml.org/lkml/2012/7/12/3
>
I cannot reproduce this failure. I reverted 20b279ddb38c and ran "perf
record -e cycles:ppG" while guest was running. Admittedly I ran the test
for a short time, but without disabling PEBS during the guest entry this
was enough to crash a guest.

The difference between "perf record -e cycles:ppG" and "perf record -e
cycles:ppH" from KVM point of view is that for ppH  PMU counter and PEBS
will be disabled during a guest entry for ppG only PEBS will be disabled,
so may be my testing is not enough and if counter remains enabled PEBS
write can eventually overshoot guest entry. In this case we can treat
ppG and ppH the same during guest entry and disable both counter and PEBS.

> And from your response:
> https://lkml.org/lkml/2012/7/12/337
> 
> "Do not run perf kvm. It does not set exclude_guest and :p and :pp
> is not compatible with guest profiling and should be disallowed.
> Again Peter's patch takes care of this."
> 
I stand by this :) It should be disallowed as in "user should get
a warning that he does something wrong and hist settings will be
ignored". Unfortunately the way it was implemented breaks old perf
binaries and keeping them running is more important than warning users
about something that never worked anyway. New perf binary can do the
check in userspace. Kernel should still disallow configuration that may
crash a guest, but not in a way that breaks the userspace that does not
set exclude_guest. What about forcing exclude_guest on an event that
has precise flag set without reporting error to userspace?
 
> 20b279ddb38c is Peter's patch -- kernel side enforcement that
> exclude_guest needs to be set when using precise mode.
> 
> David

--
			Gleb.
