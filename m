Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1KVTqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:46:21 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:20492 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753367Ab1KVTqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:46:16 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8Za12TQVM1nyVyyCH.vwc9xHCO_mtZBr.klOmkC5DM10TWB
 xrN2kYlbgN3xrK3PKLxsSHKDNWqcBaHT.9NDu5suBD2FvvMjx82NV5cOEeZ2
 yIB0QjFgomdcFDDKoFX4xicLT36d4Y_XTEZ9QzsJ2lpmtrIcFMP7cuJll1Vq
 Q2_izcwFFRodmbHzd5oFTM4V6YOuQLcF9W8FaHf5IN8NyXblHXUE.9fKE77e
 1GXNeCJIrOdjeP5emBxqgbFJ7LHEdqcJTI5oypEnSmvdTiQ7stpUfB80njb7
 PNTKZy1cR.jniNmDmrW8pCwCHN1QWUDj93ijZk49JkJgoCEyihyPcWD8OtMw
 hMjeUR7GqlGJ6VjK9CdyenzB6BCLMry3fxpG7ayYOC8WYkVSoV9K6Ubxt7UU
 _CHUW.dP1vzG8_jbT0JscCw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 13:46:11 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: slub: Lockout validation scans during freeing of object
In-Reply-To: <20111122193231.GB1627@x4.trippels.de>
Message-ID: <alpine.DEB.2.00.1111221340320.30368@router.home>
References: <alpine.DEB.2.00.1111221033350.28197@router.home> <alpine.DEB.2.00.1111221040300.28197@router.home> <alpine.DEB.2.00.1111221052130.28197@router.home> <1321982484.18002.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1111221139240.28197@router.home>
 <20111122185540.GA1627@x4.trippels.de> <alpine.DEB.2.00.1111221319070.30368@router.home> <20111122193231.GB1627@x4.trippels.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Markus Trippelsdorf wrote:

> > Could you get me the value of the "slabs" field for the slabs showing the
> > wierd values. I.e. do
> >
> > cat /sys/kernel/slab/signal_cache/slabs
> >
> > > signal_cache               268     920   360.4K 18446744073709551614/7/24   17 2  31  68 A
> >
>
> It's quite easy to explain. You're using unsigned ints in:
> snprintf(dist_str, 40, "%lu/%lu/%d", s->slabs - s->cpu_slabs, s->partial, s->cpu_slabs);
>
> and  (s->slabs - s->cpu_slabs) can get negative. For example:
>
> task_struct                269    1504   557.0K 18446744073709551601/5/32   21 3  29  72
>
> Here s-slabs is 17 and s->cpu_slabs is 32.
> That gives: 17-32=18446744073709551601.

s->cpu_slabs includes the number of per cpu partial slabs since 3.2. And
that calculation is broken it seems. It adds up the number of objects instead
of the number of slab pages.

So much for review and having that stuff in -next for a long time. Sigh.


Subject: slub: Fix per cpu partial statistics

Support for SO_OBJECTS was not properly added to show_slab_objects().

If SO_OBJECTS is not set then the number of slab pages needs to be
returned not the number of objects in the partial slabs.
We do not have that number so just return 1 until we find a better
way to determine that.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-11-22 13:42:23.000000000 -0600
+++ linux-2.6/mm/slub.c	2011-11-22 13:43:56.000000000 -0600
@@ -4451,7 +4451,7 @@ static ssize_t show_slab_objects(struct
 				continue;

 			if (c->page) {
-					if (flags & SO_TOTAL)
+				if (flags & SO_TOTAL)
 						x = c->page->objects;
 				else if (flags & SO_OBJECTS)
 					x = c->page->inuse;
@@ -4464,7 +4464,11 @@ static ssize_t show_slab_objects(struct
 			page = c->partial;

 			if (page) {
-				x = page->pobjects;
+				if (flags & SO_OBJECTS)
+					x = page->pobjects;
+				else
+					/* Assume one */
+					x = 1;
                                 total += x;
                                 nodes[c->node] += x;
 			}
