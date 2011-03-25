Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1CYQus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:50:48 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56065 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751823Ab1CYQur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:50:47 -0400
Date: Fri, 25 Mar 2011 11:49:44 -0500
From: Jack Steiner <steiner@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
	test_and_set_bit_lock if possible
Message-ID: <20110325164944.GA19854@sgi.com>
References: <201103241026.01624.knikanth@suse.de> <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab> <4D8B83DA02000078000381DE@vpn.id2.novell.com> <20110324171924.GC2414@elte.hu> <4D8C772202000078000384E1@vpn.id2.novell.com> <AANLkTimXLAV-xssvuKMs8ZqUKsRgHDedjTiGM6fxQ-ku@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimXLAV-xssvuKMs8ZqUKsRgHDedjTiGM6fxQ-ku@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 09:29:34AM -0700, Linus Torvalds wrote:
> On Fri, Mar 25, 2011 at 3:06 AM, Jan Beulich <JBeulich@novell.com> wrote:
> >
> > The problem was observed with __lock_page() (in a variant not
> > upstream for reasons not known to me), and prefixing e.g.
> > trylock_page() with an extra PageLocked() check yielded the
> > below quoted improvements.
> 
> Ok. __lock_page() _definitely_ should do the test_bit() thing first,
> because it's normally called from lock_page() that has already tested
> the bit.
> 
> But it already seems to do that, so I'm wondering what your variant is.
> 
> I'm also a bit surprised that lock_page() is that hot (unless your
> _lock_page() variant is simply too broken and ends up spinning?).
> Maybe we have some path that takes the page lock unnecessarily? What's
> the load?

We see the problem primarily on launching very large MPI applications.
The master process rapidly forks a large number (1 per cpu) of processes.
Each faults in a large number of text pages.

The text pages are resident in the page cache. No IO is involved but
the page lock quickly becomes a very hot contended cacheline.

Note also that this is observed in a 2.6.32 distro kernel that has a
different implementation of __lock_page. I think a similar problem
exists in the upstream kernel but have not had a chance to investigate.

We also see a similar problem during boot when a large number of udevd
processes are created.


--- jack

