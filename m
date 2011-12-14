Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab1LNGoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 01:44:23 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63442 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1LNGoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 01:44:22 -0500
Message-ID: <1323845054.2846.18.camel@edumazet-laptop>
Subject: RE: [PATCH 1/3] slub: set a criteria for slub node partial adding
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Wed, 14 Dec 2011 07:44:14 +0100
In-Reply-To: <1323842761.16790.8295.camel@debian>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
	 <alpine.DEB.2.00.1112020842280.10975@router.home>
	 <1323419402.16790.6105.camel@debian>
	 <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B67236EED18@shsmsx502.ccr.corp.intel.com>
	 <alpine.DEB.2.00.1112131734070.8593@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1112131835100.31514@chino.kir.corp.google.com>
	 <1323842761.16790.8295.camel@debian>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 décembre 2011 à 14:06 +0800, Alex,Shi a écrit :
> On Wed, 2011-12-14 at 10:36 +0800, David Rientjes wrote:
> > On Tue, 13 Dec 2011, David Rientjes wrote:
> > 
> > > > > 	{
> > > > > 	        n->nr_partial++;
> > > > > 	-       if (tail == DEACTIVATE_TO_TAIL)
> > > > > 	-               list_add_tail(&page->lru, &n->partial);
> > > > > 	-       else
> > > > > 	-               list_add(&page->lru, &n->partial);
> > > > > 	+       list_add_tail(&page->lru, &n->partial);
> > > > > 	}
> > > > > 
> > 
> > 2 machines (one netserver, one netperf) both with 16 cores, 64GB memory 
> > with netperf-2.4.5 comparing Linus' -git with and without this patch:
> > 
> > 	threads		SLUB		SLUB+patch
> > 	 16		116614		117213 (+0.5%)
> > 	 32		216436		215065 (-0.6%)
> > 	 48		299991		299399 (-0.2%)
> > 	 64		373753		374617 (+0.2%)
> > 	 80		435688		435765 (UNCH)
> > 	 96		494630		496590 (+0.4%)
> > 	112		546766		546259 (-0.1%)
> > 
> > This suggests the difference is within the noise, so this patch neither 
> > helps nor hurts netperf on my setup, as expected.
> 
> Thanks for the data. Real netperf is hard to give enough press on SLUB.
> but as I mentioned before, I also didn't find real performance change on
> my loopback netperf testing. 
> 
> I retested hackbench again. about 1% performance increase still exists
> on my 2 sockets SNB/WSM and 4 sockets NHM.  and no performance drop for
> other machines. 
> 
> Christoph, what's comments you like to offer for the results or for this
> code change? 

I believe far more aggressive mechanism is needed to help these
workloads.

Please note that the COLD/HOT page concept is not very well used in
kernel, because its not really obvious that some decisions are always
good (or maybe this is not well known)

We should try to batch things a bit, instead of doing a very small unit
of work in slow path.

We now have a very fast fastpath, but inefficient slow path.

SLAB has a litle cache per cpu, we could add one to SLUB for freed
objects, not belonging to current slab. This could avoid all these
activate/deactivate overhead.



