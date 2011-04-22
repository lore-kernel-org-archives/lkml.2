Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1DVJnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:43:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab1DVJnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:43:12 -0400
Subject: Re: [PATCH 4/4] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTi=Eoa9jpiLmFTgcNrY334ZAfz6P=w@mail.gmail.com>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
	 <1303398203-2918-5-git-send-email-dzickus@redhat.com>
	 <20110422081838.GA24011@elte.hu>
	 <BANLkTimh80LorfC8O-HOPAAWK9BLYNjcXA@mail.gmail.com>
	 <1303462476.2035.215.camel@laptop>
	 <BANLkTi=Eoa9jpiLmFTgcNrY334ZAfz6P=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 11:45:46 +0200
Message-ID: <1303465546.2035.224.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 13:24 +0400, Cyrill Gorcunov wrote:
> On Fri, Apr 22, 2011 at 12:54 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Fri, 2011-04-22 at 12:43 +0400, Cyrill Gorcunov wrote:
> >> we need a different event and counters for watchdog.
> >>
> > Does it count the same thing though? If so we could look at having
> > alternative encodings support (we might need something like that for
> > offcore too).
> >
> 
> Yes, they count the same thing (well some tech details are different but
> not much).By using different counters we are allowed to run them
> simultaneously which makes perf top works again.
> 
> Could you elaborate what you have in mind with "alternative encodings"
> here?

Right, so the idea is that one event (concept) has two (or more)
representations in the config space. And when scheduling the events we
find we have a conflict, we simply try the alternative encoding(s).

For example, with the offcore bits, we have two events: r1b7 and r1bb
that both have an extra MSR to fill (01A6 and 01A7 resp). Now if you
were to write the same value to these MSRs these events would count the
exact same thing.

So eg. for counting remote dram hits, you can use: r1b7:20ff or
r1bb:20ff, both count the same. So if we want to support a generic event
that counts remote dram hits we must pick one. Now if that one is taken
for measuring some L3 event, we'll have a conflict and not schedule the
thing, even though the other counter might be available.

POWER has something similar and has already implemented this alternative
encoding scheme.



