Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0CRVWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:22:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51319 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0CRVWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:22:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=V15GEbTxEmO8uFUAgu41p0tU6VoQwDjjXOmfNTmcx3i7thxvFQ9XjMw+VguLfep4G
	9EtubhcY9/5kJDqfQdJKg==
Date: Thu, 18 Mar 2010 21:21:58 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, kiran@scalex86.org,
       cl@linux-foundation.org, mel@csn.ul.ie, stable@kernel.org,
       linux-mm <linux-mm@kvack.org>, akpm@linux-foundation.org
Subject: Re: [PATCH 3/5] tmpfs: handle MPOL_LOCAL mount option properly
In-Reply-To: <1268877338.4773.151.camel@useless.americas.hpqcorp.net>
Message-ID: <alpine.LSU.2.00.1003182112010.11097@sister.anvils>
References: <20100316145022.4C4E.A69D9226@jp.fujitsu.com>  <alpine.LSU.2.00.1003171619410.29003@sister.anvils>  <20100318084915.8723.A69D9226@jp.fujitsu.com> <1268877338.4773.151.camel@useless.americas.hpqcorp.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010, Lee Schermerhorn wrote:
> On Thu, 2010-03-18 at 08:52 +0900, KOSAKI Motohiro wrote:
> > > On Tue, 16 Mar 2010, KOSAKI Motohiro wrote:
> > > 
> > > > commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
> > > > shmem_sb_info) added mpol=local mount option. but its feature is
> > > > broken since it was born. because such code always return 1 (i.e.
> > > > mount failure).
> > > > 
> > > > This patch fixes it.
> > > > 
> > > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > Cc: Ravikiran Thirumalai <kiran@scalex86.org>
> > > 
> > > Thank you both for finding and fixing these mpol embarrassments.
> > > 
> > > But if this "mpol=local" feature was never documented (not even in the
> > > commit log),

Sorry, I was absolutely wrong to say that: I seem to have been looking at
the wrong commit, but 3f226aa1 does document mpol=local, and does explain
why mpol=default differed; and KOSAKI-san's 5/5 corrects the mpol=default
description in tmpfs.txt, as well as adding mpol=local description.


> > > has been broken since birth 20 months ago, and nobody has
> > > noticed: wouldn't it be better to save a little bloat and just rip it out?
> > 
> > I have no objection if lee agreed, lee?
> > Of cource, if we agree it, we can make the new patch soon :)
> > 
> 
> Well, given the other issues with mpol_parse_str(), I suspect the entire
> tmpfs mpol option is not used all that often in the mainline kernel.  I
> recall that this feature was introduced by SGI for some of their
> customers who may depend on it.  There have been cases where I could
> have used it were it supported for the SYSV shm and MAP_ANON_MAP_SHARED
> internal tmpfs mount.  Further, note that the addition of "mpol=local"
> occurred between when the major "enterprise distributions" selected a
> new mainline kernel.  Production users of those distros, who are the
> likely users of this feature, tend not to live on the bleeding edge.
> So, maybe we shouldn't read too much into it not being discovered until
> now.

True.

> 
> That being said, I suppose I wouldn't be all that opposed to deprecating
> the entire tmpfs mpol option, and see who yells.   If the mpol mount
> options stays, I'd like to see the 'local' option stay.  It's a
> legitimate behavior that one can specify via the system calls and see
> via numa_maps, so I think the mpol mount option, if it exists, should
> support a way to specify it.  
> 
> As for bloat, the additional code on the mount option side to support it
> is:
> 
>         case MPOL_LOCAL:
>                 /*
>                  * Don't allow a nodelist;  mpol_new() checks flags
>                  */
>                 if (nodelist)
>                         goto out;
>                 mode = MPOL_PREFERRED;
>                 break;

Shocking :)

Yes, I withdraw my objection.  I'd been puzzled by why you would have
added an option which nobody was interested in, including yourself;
but as I see it now, you'd noticed a bug in mpol=default, and felt
that the right way to provide the missing functionality was to add
mpol=local: fair enough, let's keep it.

Hugh
