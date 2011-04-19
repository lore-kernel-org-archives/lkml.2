Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1DSSUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 14:20:23 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49717 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587Ab1DSSUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 14:20:21 -0400
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
In-Reply-To: <alpine.DEB.2.00.1104191254300.19358@router.home>
References: <20110415135144.GE8828@tiehlicka.suse.cz>
	 <alpine.LSU.2.00.1104171952040.22679@sister.anvils>
	 <20110418100131.GD8925@tiehlicka.suse.cz>
	 <20110418135637.5baac204.akpm@linux-foundation.org>
	 <20110419111004.GE21689@tiehlicka.suse.cz>
	 <1303228009.3171.18.camel@mulgrave.site>
	 <BANLkTimYrD_Sby_u-fPSwn-RJJyEVavU5w@mail.gmail.com>
	 <1303233088.3171.26.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104191213120.17888@router.home>
	 <1303235306.3171.33.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104191254300.19358@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 13:20:17 -0500
Message-ID: <1303237217.3171.39.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 13:10 -0500, Christoph Lameter wrote:
> On Tue, 19 Apr 2011, James Bottomley wrote:
> 
> > > Right !NUMA systems only have node 0.
> >
> > That's rubbish.  Discontigmem uses the nodes field to identify the
> > discontiguous region.  page_to_nid() returns this value.  Your code
> > wrongly assumes this is zero for non NUMA.
> 
> Sorry the kernel has no node awareness if you do not set CONFIG_NUMA
> 
> F.e. zone node lookups work the following way
> 
> static inline int
> zone_to_nid(struct zone *zone)
> {
> #ifdef CONFIG_NUMA
>         return zone->node;
> #else
>         return 0;
> #endif
> }
> 
> How in the world did you get a zone setup in node 1 with a !NUMA config?

I told you ... I forced an allocation into the first discontiguous
region.  That will return 1 for page_to_nid().

> The problem seems to be that the kernel seems to allow a
> definition of a page_to_nid() function that returns non zero in the !NUMA
> case.

This is called reality, yes.

>  And slub relies on page_to_nid returning zero in the !NUMA case.
> Because NODES_WIDTH should be 0 in the !NUMA case and therefore
> page_to_nid must return 0.

right, that's what I told you: slub is broken because it's making a
wrong assumption.  Look in asm-generic/memory_model.h it shows how the
page_to_nid() is used in finding the pfn array.  DISCONTIGMEM uses some
of the numa properties (including assigning zones to the discontiguous
regions).

> > I can fix the panic by hard coding get_nodes() to return the zero node
> > for the non-numa case ... however, presumably it's more than just this
> > that's broken in slub?
> 
> If you think that is broken then we have brokenness all over the kernel
> whenever we determine the node from a page and use that to do a lookup.

Not really.  The rest of the kernel uses the proper macros.  in
DISCONTIGMEM but !NUMA configs, the numa macros expand correctly.
You've cut across that with all the CONFIG_NUMA checks in slub.

James


