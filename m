Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1DSSLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 14:11:05 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:41993 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752386Ab1DSSLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 14:11:04 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5DgR6WYVM1nxd2v1acPyXE2GIv8AOzi.qDprt119XZrD4tu
 UDw2.u7RoD62pHszxuEblCY.bhpkpRyUIQiAtM2E2jiyLFeY7TzkhHpB5V7f
 AjwWJB2VidQuKVhOfmmNNdKdoL4cje6nat5PBBy7niGxQxGRXC4frnZ_5jFF
 0A8WAJihCP7jRVOxoLqntA8yVzuomylmU8si87VnL4Yye2Ofd_cmayaxLfKi
 5NsnaLVRIOCGOgRXsz9lF8f3vfnZyS2gCVvcTs.uDhQvFTV4mb8IDs3q7lwU
 qgiQos6c7OqxFjtylJQYzQtPXjRpmrfaR_g3fMT4lli8oAduv
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 19 Apr 2011 13:10:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303235306.3171.33.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104191254300.19358@router.home>
References: <20110415135144.GE8828@tiehlicka.suse.cz>  <alpine.LSU.2.00.1104171952040.22679@sister.anvils>  <20110418100131.GD8925@tiehlicka.suse.cz>  <20110418135637.5baac204.akpm@linux-foundation.org>  <20110419111004.GE21689@tiehlicka.suse.cz> 
 <1303228009.3171.18.camel@mulgrave.site>  <BANLkTimYrD_Sby_u-fPSwn-RJJyEVavU5w@mail.gmail.com>  <1303233088.3171.26.camel@mulgrave.site>  <alpine.DEB.2.00.1104191213120.17888@router.home> <1303235306.3171.33.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011, James Bottomley wrote:

> > Right !NUMA systems only have node 0.
>
> That's rubbish.  Discontigmem uses the nodes field to identify the
> discontiguous region.  page_to_nid() returns this value.  Your code
> wrongly assumes this is zero for non NUMA.

Sorry the kernel has no node awareness if you do not set CONFIG_NUMA

F.e. zone node lookups work the following way

static inline int
zone_to_nid(struct zone *zone)
{
#ifdef CONFIG_NUMA
        return zone->node;
#else
        return 0;
#endif
}

How in the world did you get a zone setup in node 1 with a !NUMA config?


The problem seems to be that the kernel seems to allow a
definition of a page_to_nid() function that returns non zero in the !NUMA
case. And slub relies on page_to_nid returning zero in the !NUMA case.
Because NODES_WIDTH should be 0 in the !NUMA case and therefore
page_to_nid must return 0.

> I can fix the panic by hard coding get_nodes() to return the zero node
> for the non-numa case ... however, presumably it's more than just this
> that's broken in slub?

If you think that is broken then we have brokenness all over the kernel
whenever we determine the node from a page and use that to do a lookup.

