Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab1EJPrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:47:04 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:54059
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756602Ab1EJPrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:47:02 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz936eK179dN154dM1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZL65-01-0DJ-02
X-M-MSG: 
Date: Tue, 10 May 2011 17:46:52 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf, tools: Add support for guest/host-only
 profiling
Message-ID: <20110510154652.GF30996@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
 <1305038132-5080-4-git-send-email-joerg.roedel@amd.com>
 <1305039008.2914.98.camel@laptop>
 <20110510150821.GC30996@amd.com>
 <1305041114.2914.105.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305041114.2914.105.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:25:14AM -0400, Peter Zijlstra wrote:
> On Tue, 2011-05-10 at 17:08 +0200, Roedel, Joerg wrote:
> > On Tue, May 10, 2011 at 10:50:08AM -0400, Peter Zijlstra wrote:
> > > On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> > > > @@ -740,6 +740,12 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
> > > >                         if (!exclude)
> > > >                                 exclude = eu = ek = eh = 1;
> > > >                         eh = 0;
> > > > +               } else if (*str == 'G') {
> > > > +                       eg   = 0;
> > > > +                       ehst = 1;
> > > > +               } else if (*str == 'H') {
> > > > +                       eg   = 1;
> > > > +                       ehst = 0; 
> > > 
> > > This doesn't match the existing exclude logic, also eH and eG come to
> > > mind.
> > 
> > OK, eH and eG seems like a better choice. Regarding the logic I
> > explictly decided to do it this way. The reason is that guest/host
> > counting is orthogonal to user/kernel/hv counting. You can decide to
> > only count guest-kernel for example. And if a user just specifies
> > -e cycles:G this would automatically exlucde user and kernel counting.
> > This didn't make sense to me so I decided to keep the logic seperate for
> > guest/host exclusions.
> 
> OK, so the changelog lacked that bit of information ;-)

Okay, so I add this information to the changelog.

> How about you do something like:
> 
> 
> 
> +               } else if (*str == 'G') {
> +			if (!excl_GH)
> +				excl_GH = eH = eG = 1;
> +                       eG   = 0;
> +               } else if (*str == 'H') {
> +			if (!excl_GH)
> +				excl_GH = eH = eG = 1;
> +                       eH   = 0;
> 
> Which mirrors the existing logic but keeps it orthogonal?

Right, it would better fit to the u/k/hv logic. It is not strictly
needed because there are only two excludes here but it makes the code
look more consistent. I'll change it.

> Hmm,. does this nicely integrate with exclude_hv? that seems to want to
> be grouped with G/H.

I intended to re-use the exlude_hv bit originally, but then I looked
into how this bit is used. On PPC it looks like this bit is set when
Linux itself runs as a guest to exclude the hypervisor code being
profiled. The meaning here is different (beacause Linux itself is the
hypervisor) and I wanted to avoid different semantics for this bit
across architectures. So I introduces seperate bits.
The exclude_hv bit can be used when we have some kind of perf-ctr
support for KVM guests.

Regards,

	Joerg


