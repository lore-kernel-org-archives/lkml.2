Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1GTLMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 07:12:07 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55727 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1GTLMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 07:12:05 -0400
Date: Wed, 20 Jul 2011 07:11:56 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry
Message-ID: <20110720111156.GA12349@hmsreliant.think-freely.org>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
 <20110720103813.GL15108@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720103813.GL15108@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.7 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 12:38:13PM +0200, Roedel, Joerg wrote:
> Hi Neil,
> 
> thanks for your work on this :)
> 
> On Tue, Jul 19, 2011 at 01:41:18PM -0400, Neil Horman wrote:
> >  lib/dma-debug.c |   17 +++++++++++++++--
> >  1 files changed, 15 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> > index db07bfd..333f0ee 100644
> > --- a/lib/dma-debug.c
> > +++ b/lib/dma-debug.c
> > @@ -248,10 +248,23 @@ static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
> >  {
> >  	struct dma_debug_entry *entry, *ret = NULL;
> >  	int matches = 0, match_lvl, last_lvl = 0;
> > +	u64 estart, eend, rstart, rend;
> > +
> > +	rstart = ref->dev_addr;
> > +	rend = rstart + ref->size;
> >  
> >  	list_for_each_entry(entry, &bucket->list, list) {
> > -		if ((entry->dev_addr != ref->dev_addr) ||
> > -		    (entry->dev != ref->dev))
> > +		estart = entry->dev_addr;
> > +		eend = estart + entry->size;
> > +
> > +		/*
> > +		 * An entry matches if the address range specified by the ref
> > +		 * dev_addr and size falls entirely within the range specified
> > +		 * by the entries dev_addr and size and the devices match
> > +		 */
> > +		if (entry->dev != ref->dev)
> > +			continue;
> > +		if ((estart > rstart) || (eend < rend))
> >  			continue;
> >  
> >  		/*
> 
> But it is not that easy. The hash_fn works on the dev_addr, this means
> to search all entries which might match you need to scan multiple
> hash-buckets potentially.
> In fact, you need to scan
> 
> 	hash_fn(estart) <= idx <= hash_fn(eend)
> 
Ah, good point.  Its actually a bit more difficult that what you describe I
think.  Given a ref->dev_addr, this check needs to find the entry in any bucket
for a matching device that has an entry->dev_addr less than ref->dev_addr, where
the former has a larger size than the latter.  And since we don't know the true
size of the entry we are looking for, we could have crossed the HASH_FN_SHIFT
many times over to get to the ref->dev addr that was passed in.  It almost
sounds like the hash table for this needs to be accessible by device rather than
by address.

> to be sure. The patch above also lifts up the check_unmap which is not
> desired.
Hm, you're right, I suppose we need to add an exact map option to the passed in
ref structure or some such, I'll rework this

Thanks
Neil

> 
> Thanks,
> 
> 	Joerg
> 
> -- 
> AMD Operating System Research Center
> 
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632
> 
> 
