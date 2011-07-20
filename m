Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1GTQnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:43:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1GTQne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:43:34 -0400
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anton Blanchard <anton@samba.org>, mahesh@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mingo@elte.hu, benh@kernel.crashing.org
In-Reply-To: <CA+55aFxpH9-4rkH6CRXbjFCQMGNYGRMKgdgHUEthefQPumFKVg@mail.gmail.com>
References: <20110707102107.GA16666@in.ibm.com>
	 <1310036375.3282.509.camel@twins> <20110714103418.7ef25b68@kryten>
	 <20110714143521.5fe4fab6@kryten> <1310649379.2586.273.camel@twins>
	 <20110715104547.29c3c509@kryten> <1311024956.2309.22.camel@laptop>
	 <20110719144451.79bc69ab@kryten> <1311070894.13765.180.camel@twins>
	 <20110720201436.19e9689a@kryten> <1311158708.5345.12.camel@twins>
	 <20110720221420.153b0830@kryten>
	 <CA+55aFxzaaMj8OUaust90c_hYKzg8NpRfmX4SzJ9SMwXzg5ocA@mail.gmail.com>
	 <1311173910.5345.94.camel@twins>
	 <CA+55aFxpH9-4rkH6CRXbjFCQMGNYGRMKgdgHUEthefQPumFKVg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 18:42:57 +0200
Message-ID: <1311180177.29152.57.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 09:04 -0700, Linus Torvalds wrote:
> On Wed, Jul 20, 2011 at 7:58 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > Right, so we can either merge my scary patches now and have 3.0 boot on
> > 16+ node machines (and risk breaking something), or delay them until
> > 3.0.1 and have 16+ node machines suffer a little.
> 
> So how much impact does your scary patch have on machines that don't
> have multiple nodes? If it's a "the code isn't even called by normal
> machines" kind of setup, I don't think I care a lot.

Hmm, it does get called, but it looks relatively straight forward to
make it so that it doesn't. Let me try that.

Yes, the below works nicely (on top of the previous two).

Built and boot tested on a single-node and multi-node x86_64.

---
Subject: sched: Avoid creating superfluous domains
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jul 20 18:34:30 CEST 2011

When creating sched_domains, stop when we've covered the entire target
span instead of continuing to create domains, only to later find
they're redundant and throw them away again.

This avoids single node systems from touching funny NUMA sched_domain
creation code.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7436,6 +7436,8 @@ static int build_sched_domains(const str
 			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
 			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
 				sd->flags |= SD_OVERLAP;
+			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
+				break;
 		}
 
 		while (sd->child)

