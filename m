Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1HBQh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:37:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7493 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab1HBQhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:37:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=AI7vF0OLrmWBGjSL9GgR+EPZO1JjXS7XPAJ/0WlaT9VxraXIDwkJRa4IrvXVQ49o1
	/1rP5fDaQ4bQhAzdKlKHg==
Date: Tue, 2 Aug 2011 09:37:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
Subject: Re: [slub p3 0/7] SLUB: [RFC] Per cpu partial lists V3
In-Reply-To: <alpine.DEB.2.00.1108020909100.18524@router.home>
Message-ID: <alpine.DEB.2.00.1108020925110.1114@chino.kir.corp.google.com>
References: <20110801162823.755182213@linux.com> <alpine.DEB.2.00.1108012112420.7373@chino.kir.corp.google.com> <alpine.DEB.2.00.1108020909100.18524@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011, Christoph Lameter wrote:

> > This applied nicely to Linus' tree so I've moved to testing atop that
> > rather than slub/lockless on the same netperf testing environment as the
> > slab vs. slub comparison.  The benchmarking completed without error and
> > here are the results:
> >
> > 	threads		before		after
> > 	 16		75509		75443  (-0.1%)
> > 	 32		118121		117558 (-0.5%)
> > 	 48		149997		149514 (-0.3%)
> > 	 64		185216		186772 (+0.8%)
> > 	 80		221195		222612 (+0.6%)
> > 	 96		239732		241089 (+0.6%)
> > 	112		261967		266643 (+1.8%)
> > 	128		272946		281794 (+3.2%)
> > 	144		279202		289421 (+3.7%)
> > 	160		285745		297216 (+4.0%)
> >
> > So the patchset certainly looks helpful, especially if it improves other
> > benchmarks as well.
> 
> The problem is that the partial approach has not been fine tuned yet for
> these larger loads. And the proper knobs are not implemented yet.
> 

Aside from per-cpu partial lists, I think this particular benchmark would 
benefit from two other changes on my testing environment:

 - remote cpu freeing so that objects allocated on a different cpu get 
   moved to a separate list that will eventually get flushed back to the 
   origin cpu to be reallocated later with sane heuristics to determine
   when to take the necessary lock and cacheline bounce, and

 - a preference to only pull a slab from the partial lists if there are 
   a sane number of free objects risking perhaps a costly page allocation 
   that will nevertheless allow the fastpaths to be exercised a little 
   more either way (this benchmark suffers horribly when only one or two 
   objects can be allocated from a partial slab).

> > I'll review the patches individually, starting with the cleanup patches
> > that can hopefully be pushed quickly while we discuss per-cpu partial
> > lists further.
> 
> I am currently reworking the patches to operate on a linked list instead
> of a very small array of pointers to page structs. That will allow much
> larger per cpu partial lists and a dynamic configuration of the sizes.
> 

Ok, so is the per-cpu partial list patch in this series worth the review 
or are you going to go under the hood and rework it?
