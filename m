Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2I0FJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:09:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55418 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751332Ab2I0FJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:09:34 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18okb8u2wUo/VH8chz1QKVzIFFJSQzdU1wAFC5Dlv
	TUUa9NfHWnVhqN
Message-ID: <1348722568.7059.115.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 27 Sep 2012 07:09:28 +0200
In-Reply-To: <20120926213723.GA27692@liondog.tnic>
References: <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
	 <20120924192056.GB4082@liondog.tnic>
	 <1348538258.7100.23.camel@marge.simpson.net>
	 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
	 <20120925170058.GC30158@x1.osrc.amd.com>
	 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
	 <20120926163233.GA5339@x1.osrc.amd.com>
	 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
	 <20120926213723.GA27692@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 23:37 +0200, Borislav Petkov wrote:

> The way I understand it is, you either want to share L2 with a process,
> because, for example, both working sets fit in the L2 and/or there's
> some sharing which saves you moving everything over the L3. This is
> where selecting a core on the same L2 is actually a good thing.

Yeah, and if the wakee can't get to the L2 hot data instantly, it may be
better to let wakee drag the data to an instantly accessible spot.

> Or, they're too big to fit into the L2 and they start kicking each-other
> out. Then you want to spread them out to different L2s - i.e., different
> HT groups in Intel-speak.
> 
> Oh, and then there's the userspace spinlocks thingie where Mike's patch
> hurts us.
> 
> Btw, Mike, you can jump in anytime :-)

I think the pgbench problem is more about latency for the 1 in 1:N than
spinlocks.

> So I'd say, this is the hard scheduling problem where fitting the
> workload to the architecture doesn't make everyone happy.

Yup.  I find it hard at least.

> A crazy thought: one could go and sample tasks while running their
> timeslices with the perf counters to know exactly what type of workload
> we're looking at. I.e., do I have a large number of L2 evictions? Yes,
> then spread them out. No, then select the other core on the L2. And so
> on.

Hm.  That sampling better be really cheap.  Might help... but how does
that affect pgbench and ilk that must spread regardless of footprints.

-Mike

