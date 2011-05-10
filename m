Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab1EJPWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:22:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:40524 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1EJPWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:22:13 -0400
Subject: Re: [PATCH 3/3] perf, tools: Add support for guest/host-only
 profiling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <20110510150821.GC30996@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
	 <1305038132-5080-4-git-send-email-joerg.roedel@amd.com>
	 <1305039008.2914.98.camel@laptop>  <20110510150821.GC30996@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 17:25:14 +0200
Message-ID: <1305041114.2914.105.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 17:08 +0200, Roedel, Joerg wrote:
> On Tue, May 10, 2011 at 10:50:08AM -0400, Peter Zijlstra wrote:
> > On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> > > @@ -740,6 +740,12 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
> > >                         if (!exclude)
> > >                                 exclude = eu = ek = eh = 1;
> > >                         eh = 0;
> > > +               } else if (*str == 'G') {
> > > +                       eg   = 0;
> > > +                       ehst = 1;
> > > +               } else if (*str == 'H') {
> > > +                       eg   = 1;
> > > +                       ehst = 0; 
> > 
> > This doesn't match the existing exclude logic, also eH and eG come to
> > mind.
> 
> OK, eH and eG seems like a better choice. Regarding the logic I
> explictly decided to do it this way. The reason is that guest/host
> counting is orthogonal to user/kernel/hv counting. You can decide to
> only count guest-kernel for example. And if a user just specifies
> -e cycles:G this would automatically exlucde user and kernel counting.
> This didn't make sense to me so I decided to keep the logic seperate for
> guest/host exclusions.

OK, so the changelog lacked that bit of information ;-)

How about you do something like:



+               } else if (*str == 'G') {
+			if (!excl_GH)
+				excl_GH = eH = eG = 1;
+                       eG   = 0;
+               } else if (*str == 'H') {
+			if (!excl_GH)
+				excl_GH = eH = eG = 1;
+                       eH   = 0;

Which mirrors the existing logic but keeps it orthogonal?


Hmm,. does this nicely integrate with exclude_hv? that seems to want to
be grouped with G/H.

