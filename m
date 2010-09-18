Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0IRSmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 14:42:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab0IRSms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 14:42:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>,
        "linux-pm" <linux-pm@lists.linux-foundation.org>,
        "linux-omap" <linux-omap@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] opp: introduce library for device-specific OPPs
Date: Sat, 18 Sep 2010 20:41:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <[PATCH 1/4] OMAP: introduce OPP layer for device-specific OPPs> <201009180107.51664.rjw@sisk.pl> <4C93FAD1.80108@ti.com>
In-Reply-To: <4C93FAD1.80108@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009182041.41675.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trimming the CC list.]

On Saturday, September 18, 2010, Nishanth Menon wrote:
> Rafael J. Wysocki had written, on 09/17/2010 06:07 PM, the following:
...
> > 
> > Apart from this, it might be a good idea to help callers a bit and actually
> > introduce some sort of locking into the framework.
> in OMAP implementation we have need to use these apis from irq_locked 
> contexts as well..  lock implementation will prevent thier necessary 
> usage.

Why so?  You can use spin_lock_irqsave/spin_unclock_irqrestore  to
avoid that.

> instead we have implemented lock mechanisms in higher layers and 
> ensured that the opp table does not change once created - the rest of 
> them are query functions - the risk is on opp_enable/disable.

OK, but this way you practically make the users of the framework duplicate
some code for the locking purposes.  This is kind of suboptimal, and error
prone too.

> >> In terms of the lifetime rules on the nodes in the list:
> >> The list is expected to be maintained once created, entries are expected 
> >> to be added optimally and not expected to be destroyed, the choice of 
> >> list implementation was for reducing the complexity of the code itself 
> >> and not yet meant as a mechanism to dynamically add and delete nodes on 
> >> the fly.. Essentially, it was intended for the SOC framework to ensure 
> >> it plugs in the OPP entries optimally and not create a humongous list of 
> >> all possible OPPs for all families of the vendor SOCs - even though it 
> >> is possible to use the OPP layer so - it just wont be smart to do so 
> >> considering list scan latencies on hot paths such as cpufreq transitions 
> >> or idle transitions.
> > 
> > If the list nodes are not supposed to be added and removed dynamically,
> > it probably would make sense to create data structures containing
> > the "available" OPPs only, once they are known, and simply free the object
> > representing the other ones.
> I covered the usage in my reply here: 
> http://marc.info/?l=linux-arm-kernel&m=128476570300466&w=2
> but to repeat, the list is dynamic during initialization but remains 
> static after initialization based on SOC framework implementation - this 
> is best implemented with a list (we had started with an original array 
> implementation which evolved to the current list implementation 
> http://marc.info/?l=linux-omap&m=125912217718770&w=2)

Well, my point is, since the _final_ set of OPPs doesn't really change, there's
no need to use a list for storing it in principle.

Your current algorithm seems to be:
(1) Create a list of all _possible_ OPPs.
(2) Mark the ones that can actually be used on the given hardware as
    "available".
(3) Whenever we need to find an OPP to use, browse the entire list.

This isn't optimal, because the OPPs that are not marked as "available" in (2)
will never be used, although they _will_ be inspected while browsing the list.
So, I think a better algorithm would be:
(1) Create a list of all possible OPPs.
(2) Drop the nonavailable OPPs from the list.
(3) Whenever we need to find an OPP to use, browse the entire list.

But then, it may be better to simply move the list we get in (2) into an
array, because the browsing is going to require fewer memory accesses in
that case (also, an array would use less memory than the list).  So, perhaps,
it's better to change the algorithm even further:
(1) Create a list of all possible OPPs.
(2) Drop the nonavailable OPPs from the list.
(3) Move the list we got in (2) into a sorted array.
(4) Whenever we need to find an OPP to use, browse the array
     (perhaps using binary search).

Thanks,
Rafael
