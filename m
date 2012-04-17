Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2DQPgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:36:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49243 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2DQPgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:36:42 -0400
MIME-Version: 1.0
Message-ID: <ee9b0e64-9659-40bc-938d-f02fb411b6a4@default>
Date: Tue, 17 Apr 2012 08:36:11 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        xen-devel <xen-devel@lists.xen.org>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        "Tim(Xen.org)" <tim@xen.org>, Sheng Yang <sheng@yasker.org>
Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
 <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com>
 <049b7b93-fb37-4962-b272-d786e1dcfacb@default>
 <4F8C619C020000780007E34E@nat28.tlf.novell.com>
 <84023b26-a682-44b5-990e-1635da6949ff@default>
 <4F8D3778020000780007E63A@nat28.tlf.novell.com>
In-Reply-To: <4F8D3778020000780007E63A@nat28.tlf.novell.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F8D8DF8.00C0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jan Beulich [mailto:JBeulich@suse.com]
> Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
> 
> >>> On 16.04.12 at 19:22, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> > In upstream (and recent pv-ops) kernels, is there any need for there
> > to be a difference between HVM and PV in the clocksource chosen?  The
> 
> Yes, because RDTSC interception for PV guests is slow (using #GP
> and requiring instruction decode).

"Slow" is relative.  I showed (somewhere on xen-devel years ago) that
the emulation performance hit is much smaller than the original developers
expected and is detectable only with certain applications that
execute rdtsc ~100K/second.  Furthermore, the cycle count of an rdtsc
has gone up on modern systems, so the cost ratio of emulating
rdtsc vs executing the raw instruction is going down.
 
> > pvclock algorithm was necessary for PV when non-TSC hardware clocks
> > were privileged and the only non-privileged hardware clock (TSC)
> > was badly broken in hardware and for migration/save/restore.
> > With TSC now working and stable, and now that we are making changes
> > in the upstream kernel that work for both PV and HVM, is it
> > time to drop pvclock (at least as the default for PV)?
> >
> > Certainly if an old (non-pv-ops) kernel is broken, something like
> > David's patch might be an acceptable workaround.  I'm just arguing
> > against perpetuating pvclock-as-the-only-xen-clock upstream.
> 
> Afaict, the only uniformly reliable clocksource for PV guests is the
> virtual one which pvclock builds upon. Raw TSC is definitely not an
> option on NUMA systems (and PV guests aren't aware of the
> NUMAness of the underlying system).

You'll have to define NUMA.  On "old" NUMA systems, where there are
multiple motherboards, your statement is true.  On newer systems
where NUMA simply means there are multiple memory controllers and
all of them are cache-coherent, even when there are multiple
"motherboards" joined by HT or QPI, processor and system vendors
take great pains to ensure that the clock signal (and thus TSC) is
synchronized and "stable" across all cpus.

But I agree there ARE exceptions... for those, I proposed a Xen boot
option that said "don't trust TSC even if all the evidence implies
that you can", but Keir shot it down (also years ago).

Dan
