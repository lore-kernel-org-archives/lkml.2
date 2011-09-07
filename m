Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1IGQMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:12:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46765 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1IGQM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:12:26 -0400
Date: Wed, 7 Sep 2011 08:48:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Jackson <Ian.Jackson@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jens Axboe <jaxboe@fusionio.com>, Marsden <greg.marsden@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Greg@acsinet13.oracle.com,
        Kurt C Hackel <KURT.HACKEL@oracle.com>
Subject: Re: [Xen-devel] Re: [patch] xen-blkback: sync I/O after backend
 disconnected
Message-ID: <20110907124800.GC32190@dumpdata.com>
References: <4E48A6A6.4040706@oracle.com>
 <20110815144610.GA3707@infradead.org>
 <m2n.s.1QsyrJ-132485@chiark.greenend.org.uk>
 <20054.29964.556177.999449@mariner.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20054.29964.556177.999449@mariner.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E6797E9.0009:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 05:15:08PM +0100, Ian Jackson wrote:
> Konrad Rzeszutek Wilk writes ("Re: [Xen-devel] Re: [patch] xen-blkback: sync I/O after backend disconnected"):
> > And the guest would normally issues a FLUSH when unmounting the
> > disk. Hm, I wonder what the conditions are when we forcibly kill the
> > guest - there might be outstanding I/Os in the disk's cache -
> > at which point we should probably sync the write cache, no?
> 
> If we forcibly kill the guest we don't care about its IO in flight.

Why don't we care about it? It might have become wedged but that does
not mean we don't want to preserve as much as possible.

> After all we are throwing away everything that the guest has in its
> queue.

We end up finishing all of the outstanding I/Os that guest has sent.
When all of the bio_submit callbacks have finished then we release
the guest backend. So adding in a 'SYNC' to the queue would force
the disk cache to flush all the writes at least.

> 
> Bear in mind that the reason for forcibly killing (or perhaps forcibly
> detaching) might be that the underlying device has wedged somehow.  It
> would be annoying if that prevented even a force detach.
> 
> Or to put it in other words: force detach and force kill should be
> lossy.  Their whole point is to be the lossy version.

Hm, I think you still end up holding on the request queue and not
freeing the blkback thread and all of its goodies until the bio callbacks
have completed. When the device gets wedged they become wedged too.
You have to wait for the error handler to give up and then the avalanche
of 'write page lost' and 'error secxtor XX' along with the -ENXIO being
returned ends up in the bio callbacks.

What I am saying is that the force detach is still stuck waiting
if the device has wedged - irregardless of this patch.

> 
> Ian.
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
