Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab1KWPOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:14:45 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:48552 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756360Ab1KWPOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:14:43 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wG4CSTwVM1kUhgkM2OmnrePbT8IJAxAaZXJrEGZTbzOQVMy
 2RTJmLwkaZHFEJN2aJADlZOE2GGxUFxwRm079u5Oh9rJYfWI3JaWKkxS8cyP
 6AL7r_MElpT4rDPLiR8j5B17vFL8ae6LPIIOrbYLKN56AiVdy1GJMsgpmf0K
 qwbjFLlDg8beaP7szbnyOfAn3Trk.FJlfJMe.dzk391le7R4oSPDNNiiq_C3
 hA2xxfagSd43dIFJSLBhbv9B902gs5zONf1r6go9bkL5qgHst7b7ae_PXaG3
 zc9jje2Hhz_a3rAkcnEDEaCEtTFqSehWJbDBnB35QVemhbB3X0iOpH7_ZqwI
 8tp5jGgASvSlcNKEiGid6Q6.jPV0tlY.NtLLFZ22gQweA8g--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 23 Nov 2011 09:14:38 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>
Subject: slub: use irqsafe_cpu_cmpxchg for put_cpu_partial
In-Reply-To: <CAOJsxLGWTRuwQ04Mg26fNhZEmo7yVXG5vSZgF7Q5GESCk65odA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111230907330.16139@router.home>
References: <20111121131531.GA1679@x4.trippels.de> <20111121153621.GA1678@x4.trippels.de> <1321890510.10470.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121161036.GA1679@x4.trippels.de> <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121173556.GA1673@x4.trippels.de> <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121185215.GA1673@x4.trippels.de> <20111121195113.GA1678@x4.trippels.de>
 <1321907275.13860.12.camel@pasglop> <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org> <alpine.DEB.2.00.1111212105330.19606@router.home> <1321948113.27077.24.camel@edumazet-laptop> <1321999085.14573.2.camel@pasglop> <alpine.DEB.2.01.1111221511070.8000@trent.utfs.org>
 <1322007501.14573.15.camel@pasglop> <alpine.DEB.2.01.1111222145470.8000@trent.utfs.org> <CAOJsxLGWTRuwQ04Mg26fNhZEmo7yVXG5vSZgF7Q5GESCk65odA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Pekka Enberg wrote:

> 2011/11/23 Christian Kujau <lists@nerdbynature.de>:
> > OK, with Christoph's patch applied, 3.2.0-rc2-00274-g6fe4c6d-dirty survives
> > on this machine, with the disk & cpu workload that caused the machine to
> > panic w/o the patch. Load was at 4-5 this time, which is expected for this
> > box. I'll run a few more tests later on, but it seems ok for now.
> >
> > I couldn't resist and ran "slabinfo" anyway (after the workload!) - the
> > box survived, nothing was printed in syslog either. Output attached.
>
> Christoph, Eric, would you mind sending me the final patches that
> Christian tested? Maybe CC David too for extra pair of eyes.

I think he only tested the patch that he showed us. Here is the patch
cleaned up. Do you Want me to feed you the debug fixes patch by patch as
well?

Subject: slub: use irqsafe_cpu_cmpxchg for put_cpu_partial

The cmpxchg must be irq safe. The fallback for this_cpu_cmpxchg only
disables preemption which results in per cpu partial page operation
potentially failing on non x86 platforms.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-11-23 09:10:48.000000000 -0600
+++ linux-2.6/mm/slub.c	2011-11-23 09:10:57.000000000 -0600
@@ -1969,7 +1969,7 @@ int put_cpu_partial(struct kmem_cache *s
 		page->pobjects = pobjects;
 		page->next = oldpage;

-	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
+	} while (irqsafe_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
 	stat(s, CPU_PARTIAL_FREE);
 	return pobjects;
 }
