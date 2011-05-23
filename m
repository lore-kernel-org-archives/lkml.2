Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab1EWCvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 22:51:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:48053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab1EWCva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 22:51:30 -0400
X-ExtLoop1: 1
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Parag Warudkar <parag.lkml@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Dmitry Torokhov <dtor@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 22 May 2011 19:49:18 -0700
Subject: RE: Resume Issues :Exec of NX page, Synaptics Botchup
Thread-Topic: Resume Issues :Exec of NX page, Synaptics Botchup
Thread-Index: AcwY0VXQ2gYE2FqwTAGr32aNZRidZgAIfCvg
Message-ID: <493994B35A117E4F832F97C4719C4C04011E13400F@orsmsx505.amr.corp.intel.com>
References: <alpine.DEB.2.02.1105221720040.2065@natty-nar>
 <BANLkTik9ZmQz1A0PBC4P-9XF-hB6Ywr3uQ@mail.gmail.com>
 <alpine.DEB.2.02.1105221817100.1868@natty-nar>
 <201105230041.14729.rjw@sisk.pl>
In-Reply-To: <201105230041.14729.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday, May 23, 2011, Parag Warudkar wrote:
> >
> > On Sun, 22 May 2011, Linus Torvalds wrote:
> >
> > >
> > > Hmm. The "Code: " line is just full of complete garbage, so I think
> > > the real issue is that you really are trying to execute data.
> > >
> > > And that in turn seems to be because "setup_disablecpuid()" has
> > > actually been free'd, because it is marked as __init.
> > >
> > > Which is fine at the initial bootup, but not so fine at resume
> time,
> > > since it was free'd long long ago by then.
> > >
> > > And it definitely shouldn' t be called at resume time. There's
> > > something wrong there. That call trace is odd:
> > >
> > >   Call Trace:
> > >    [<ffffffff8148a119>] ? identify_cpu+0xd8/0x2d8
> > >    [<ffffffff8148a32d>] identify_secondary_cpu+0x14/0x1b
> > >    [<ffffffff8148bf0f>] smp_store_cpu_info+0x3c/0x3e
> > >    [<ffffffff8148c2ef>] start_secondary+0xf7/0x1d2
> > >
> > > because none of those should be calling "setup_disablecpuid()" at
> all.
> > >
> > > Hmm. In fact, RIP is "setup_disablecpuid+0x40/0x40", ie it is one
> past
> > > the _end_ of setup_disablecpuid.
> > >
> > > I suspect that is actually "setup_smep()" that got called, an dthat
> > > there was some garbage data in there that caused it to jump back a
> > > bit.
> > >
> > > Does the attached patch fix it?
> > >
> >
> > Now I get a different call trace for the same NX error. (And
> Synaptics is
> > completely dead this time - not attributable to the patch, it was
> dumb
> > luck perhaps that it wored last time.)
> 
> Any chance to try with commit de5397ad5b9ad22e2401c4dacdf1bb3b19c05679
> (x86, cpu: Enable/disable Supervisor Mode Execution Protection)
> reverted?
> 
> Rafael

de5397ad5b9ad22e2401c4dacdf1bb3b19c05679 shouldn't affect a system unless the CPU has SMEP feature which is unlikely available out there.

You can check if your CPU has "smep" feature in /proc/cpuinfo. Unlikely you will see the feature on your machine. Then the commit shouldn't cause the problem.

You can unconditionally disable SMEP by kernel option "nosmep".

Thanks.

-Fenghua
