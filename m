Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab0CRBzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 21:55:45 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11524 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0CRBzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 21:55:44 -0400
Subject: Re: [PATCH 3/5] tmpfs: handle MPOL_LOCAL mount option properly
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, kiran@scalex86.org,
       cl@linux-foundation.org, mel@csn.ul.ie, stable@kernel.org,
       linux-mm <linux-mm@kvack.org>, akpm@linux-foundation.org
In-Reply-To: <20100318084915.8723.A69D9226@jp.fujitsu.com>
References: <20100316145022.4C4E.A69D9226@jp.fujitsu.com>
	 <alpine.LSU.2.00.1003171619410.29003@sister.anvils>
	 <20100318084915.8723.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 17 Mar 2010 21:55:38 -0400
Message-Id: <1268877338.4773.151.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 08:52 +0900, KOSAKI Motohiro wrote:
> > On Tue, 16 Mar 2010, KOSAKI Motohiro wrote:
> > 
> > > commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
> > > shmem_sb_info) added mpol=local mount option. but its feature is
> > > broken since it was born. because such code always return 1 (i.e.
> > > mount failure).
> > > 
> > > This patch fixes it.
> > > 
> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > Cc: Ravikiran Thirumalai <kiran@scalex86.org>
> > 
> > Thank you both for finding and fixing these mpol embarrassments.
> > 
> > But if this "mpol=local" feature was never documented (not even in the
> > commit log), has been broken since birth 20 months ago, and nobody has
> > noticed: wouldn't it be better to save a little bloat and just rip it out?
> 
> I have no objection if lee agreed, lee?
> Of cource, if we agree it, we can make the new patch soon :)
> 

Well, given the other issues with mpol_parse_str(), I suspect the entire
tmpfs mpol option is not used all that often in the mainline kernel.  I
recall that this feature was introduced by SGI for some of their
customers who may depend on it.  There have been cases where I could
have used it were it supported for the SYSV shm and MAP_ANON_MAP_SHARED
internal tmpfs mount.  Further, note that the addition of "mpol=local"
occurred between when the major "enterprise distributions" selected a
new mainline kernel.  Production users of those distros, who are the
likely users of this feature, tend not to live on the bleeding edge.
So, maybe we shouldn't read too much into it not being discovered until
now.

That being said, I suppose I wouldn't be all that opposed to deprecating
the entire tmpfs mpol option, and see who yells.   If the mpol mount
options stays, I'd like to see the 'local' option stay.  It's a
legitimate behavior that one can specify via the system calls and see
via numa_maps, so I think the mpol mount option, if it exists, should
support a way to specify it.  

As for bloat, the additional code on the mount option side to support it
is:

        case MPOL_LOCAL:
                /*
                 * Don't allow a nodelist;  mpol_new() checks flags
                 */
                if (nodelist)
                        goto out;
                mode = MPOL_PREFERRED;
                break;

Lee



