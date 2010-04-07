Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0DGH5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:57:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab0DGH5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:57:38 -0400
Date: Wed, 7 Apr 2010 17:57:30 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: David Howells <dhowells@redhat.com>, paulmck@linux.vnet.ibm.com,
       corbet@lwn.net, linux-kernel@vger.kernel.org, linux-cachefs@redhat.com
Subject: Re: An incorrect assumption over radix_tree_tag_get()
Message-ID: <20100407075730.GA5433@laptop>
References: <23428.1270570789@redhat.com>
 <20100406170903.GH5288@laptop>
 <20100406233438.GH11036@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406233438.GH11036@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 09:34:38AM +1000, Dave Chinner wrote:
> On Wed, Apr 07, 2010 at 03:09:03AM +1000, Nick Piggin wrote:
> > On Tue, Apr 06, 2010 at 05:19:49PM +0100, David Howells wrote:
> > > 
> > > Hi,
> > > 
> > > I think I've made a bad assumption over my usage of radix_tree_tag_get() in
> > > fs/fscache/page.c.
> > > 
> > > I've assumed that radix_tree_tag_get() is protected from radix_tree_tag_set()
> > > and radix_tree_tag_clear() by the RCU read lock.  However, now I'm not so
> > > sure.  I think it's only protected against removal of part of the tree.
> > > 
> > > Can you confirm?
> > 
> > It is safe. Synchronization requirements for using the radix tree API
> > are documented.
> 
> I don't think it is safe - I made modifications to XFS that modified
> radix tree tags under a read lock (not RCU), but this resulted in
> corrupted tag state as concurrent tag set/clear operations for
> different slots propagated through the tree and got mixed up.
> Christoph fixed the problem (f1f724e4b523d444c5a598d74505aefa3d6844d2)
> by putting all tag modifications under the write lock.  I can't see
> how doing tag modifications under RCU read locks is any safer than
> doing it under a spinning read lock....

No the modifications must all be serialized, but they can run in
parallel with a radix_tree_tag_get().

