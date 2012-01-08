Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab2AHKyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 05:54:09 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:40257 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2AHKyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 05:54:07 -0500
Subject: Re: Switch per cpu partial page support off for debugging
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1201060934550.10460@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1111230923260.16544@router.home>
	 <alpine.LFD.2.02.1112120915030.2555@tux.localdomain>
	 <alpine.DEB.2.00.1112141908410.27595@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1201060934550.10460@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 08 Jan 2012 12:54:01 +0200
Message-ID: <1326020041.32105.3.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 09:37 -0800, David Rientjes wrote:
> On Wed, 14 Dec 2011, David Rientjes wrote:
> 
> > > > Eric saw an issue with accounting of slabs during validation. Its not
> > > > possible to determine accurately how many per cpu partial slabs exist at
> > > > any time so this switches off per cpu partial pages during debug.
> > > > 
> > > > Subject: Switch per cpu partial page support off for debugging
> > > > 
> > > > Otherwise we have accounting issues.
> > > > 
> > > > Signed-off-by: Christoph Lameter <cl@linux.com>
> > > > 
> > > > 
> > > > ---
> > > > mm/slub.c |    4 +++-
> > > > 1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > Index: linux-2.6/mm/slub.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/mm/slub.c	2011-11-22 11:57:21.000000000 -0600
> > > > +++ linux-2.6/mm/slub.c	2011-11-22 11:57:55.000000000 -0600
> > > > @@ -3027,7 +3027,9 @@ static int kmem_cache_open(struct kmem_c
> > > > 	 *    per node list when we run out of per cpu objects. We only fetch
> > > > 50%
> > > > 	 *    to keep some capacity around for frees.
> > > > 	 */
> > > > -	if (s->size >= PAGE_SIZE)
> > > > +	if (kmem_cache_debug(s))
> > > > +		s->cpu_partial = 0;
> > > > +	else if (s->size >= PAGE_SIZE)
> > > > 		s->cpu_partial = 2;
> > > > 	else if (s->size >= 1024)
> > > > 		s->cpu_partial = 6;
> > 
> > I think this deserves a comment since it's not clear why it's being done 
> > neither in the code or by the changelog.  Also, you'd want a check for 
> > kmem_cache_debug() when storing to /sys/kernel/slab/cache/cpu_partial as 
> > well, otherwise this could easily be broken from userspace again.  (It 
> > also seems like Documentation/ABI/testing/sysfs-kernel-slab got left out 
> > of an update when that was added, too.)
> > 
> 
> This patch is merged in slab/urgent without any changes from my comment 
> above; since userspace can alter cpu_partial directly via 
> /sys/kernel/slab/cache/cpu_partial which would reintroduce the 
> "accounting issues", shouldn't that return -EINVAL when debug is enabled?

I think I applied the patch before your comments. EINVAL sounds
reasonable to me. Christoph?

			Pekka

