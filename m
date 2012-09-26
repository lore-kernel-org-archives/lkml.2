Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2IZCmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:42:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40625 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751051Ab2IZCma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:42:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19c79wOOKRcywxcgpu/nJ0VXLa8gtSMrq3BpBNgv6
	xJL2zlx1A4Uhrg
Message-ID: <1348627344.7100.177.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 26 Sep 2012 04:42:24 +0200
In-Reply-To: <CA+55aFw8F=M7O6KfpotnhWoyJ6MiFF1U5S4RDboxyzPjW4hs6A@mail.gmail.com>
References: <1348503163.11847.97.camel@twins>
	 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
	 <1348505683.11847.111.camel@twins>
	 <1348511193.6951.44.camel@marge.simpson.net>
	 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
	 <20120924192056.GB4082@liondog.tnic>
	 <1348538258.7100.23.camel@marge.simpson.net>
	 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
	 <20120925170058.GC30158@x1.osrc.amd.com>
	 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
	 <1348624845.7100.147.camel@marge.simpson.net>
	 <CA+55aFw8F=M7O6KfpotnhWoyJ6MiFF1U5S4RDboxyzPjW4hs6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 19:22 -0700, Linus Torvalds wrote: 
> On Tue, Sep 25, 2012 at 7:00 PM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > Yes.  On AMD, the best thing you can do for fast switchers AFAIKT is
> > turn it off.  Different story on Intel.
> 
> I doubt it's all that different on Intel.

The behavioral difference is pretty large, question is why.

<quoting self>
> Am I on the right track here? Or do you mean something completely
> different? Please explain it more verbosely.

A picture is worth a thousand words they say...

x3550 M3 E5620, SMT off, revert reverted, nohz off, zero knob twiddles,
governor=performance.

tbench    1     2     4
        398   820  1574  -select_idle_sibling() 
        454   902  1574  +select_idle_sibling()
        397   737  1556  +select_idle_sibling() virgin source

netperf TCP_RR, one unbound pair
114674   -select_idle_sibling()
131422   +select_idle_sibling()
111551   +select_idle_sibling() virgin source

These 1:1 buddy pairs scheduled cross core on E5620 feel no pain once
you kill the bouncing.  The bounce pain with 4 cores is _tons_ less
intense than on the 10 core Westmere, but it's still quite visible.  The
point though is that cross core doesn't hurt Westmere, but demolishes
Opteron for some reason.  (OTOH, bounce _helps_ fugly 1:N load.. grr;)
</quoting self>

> Your patch showed improvement for Intel too on this same benchmark
> (tbench). Borislav just went even further. I'd suggest testing that
> patch on Intel too, and wouldn't be surprised at all if it shows
> improvement there too.

See above.

> It's pgbench that then regressed with your patch, and I suspect it
> will regress with Borislav's too.

Yeah, strongly suspect you're right.

> You probably looked at the fact that the original report from Nikolay
> says that the Intel E6300 hadn't regressed on pgbench, but I suspect
> you didn't realize that E6300 is just a dual-core CPU without even HT.
> So I doubt it's about "Intel vs AMD", it's more about "six cores" vs
> "just two".

No, I knew, and yeah, it's about number of paths.

> And the thing is - with just two cores, the fact that your patch
> didn't change the Intel numbers is totally irrelevant. With two cores,
> the whole "buddy_cpu" was equivalent to the old code, since there was
> ever only one other core to begin with!
> 
> So AMD and Intel do have differences, but they aren't all that radical.

Looks fairly radical to me, but as noted in mail to Boris, it boils down
to "what does it cost, and where does the breakeven lie?".

-Mike

