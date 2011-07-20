Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1GTOcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:32:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46326 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1GTOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:32:30 -0400
Date: Wed, 20 Jul 2011 10:32:22 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry
Message-ID: <20110720143222.GB12349@hmsreliant.think-freely.org>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
 <20110720103813.GL15108@amd.com>
 <20110720111156.GA12349@hmsreliant.think-freely.org>
 <20110720132925.GB21948@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720132925.GB21948@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.9 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 03:29:25PM +0200, Roedel, Joerg wrote:
> On Wed, Jul 20, 2011 at 07:11:56AM -0400, Neil Horman wrote:
> > On Wed, Jul 20, 2011 at 12:38:13PM +0200, Roedel, Joerg wrote:
> 
> > > But it is not that easy. The hash_fn works on the dev_addr, this means
> > > to search all entries which might match you need to scan multiple
> > > hash-buckets potentially.
> > > In fact, you need to scan
> > > 
> > > 	hash_fn(estart) <= idx <= hash_fn(eend)
> > > 
> > Ah, good point.  Its actually a bit more difficult that what you describe I
> > think.  Given a ref->dev_addr, this check needs to find the entry in any bucket
> > for a matching device that has an entry->dev_addr less than ref->dev_addr, where
> > the former has a larger size than the latter.  And since we don't know the true
> > size of the entry we are looking for, we could have crossed the HASH_FN_SHIFT
> > many times over to get to the ref->dev addr that was passed in.  It almost
> > sounds like the hash table for this needs to be accessible by device rather than
> > by address.
> 
> You are right. We need to scan
> 
> 	0 <= idx <= hash_fn(rstart)
> 
> Probably we can fix that with a better hash-function. Any ideas? Using
> the device is not an option because then all entries would end up in
> only a few buckets. This will impact scanning performance too much.
> 
Unfortunately I don't have any ideas for a better hash function here, but I had
been thinking about fixing this in add_dma_entry.  We could detect there that a
debug entry to be added crossed one or more hash bucket boundaries, and, if it
did, split it along those boundaries into multiple entries, hashing each of them
in separately.  The check_unmap and check_sync routines would of course then
potentially have to do multiple lookups as well to ensure that they found all of
the correct entries to validate/remove.  It would work in all cases, but it
might be overkill.  What do you think?

> For now, the partial syncs seem to happen rarely enough so that we can
> make it a slow-path. It is probably the best to do the exact scan first
> and do the full scan only if exact-scan failed (until we come up with a
> better solution).
> 
Agreed, if you don't like my above idea, I'll get to work on this this
afternoon.

Regards
Neil


