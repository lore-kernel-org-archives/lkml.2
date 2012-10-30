Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab2J3UvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:51:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42034 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2J3UvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:51:04 -0400
Date: Tue, 30 Oct 2012 16:38:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Persistent grant maps for xen blk drivers
Message-ID: <20121030203827.GB16465@phenom.dumpdata.com>
References: <1351097925-26221-1-git-send-email-roger.pau@citrix.com>
 <20121030170157.GA29485@phenom.dumpdata.com>
 <50901D6C.6020500@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <50901D6C.6020500@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 07:33:16PM +0100, Roger Pau Monné wrote:
> On 30/10/12 18:01, Konrad Rzeszutek Wilk wrote:
> > On Wed, Oct 24, 2012 at 06:58:45PM +0200, Roger Pau Monne wrote:
> >> This patch implements persistent grants for the xen-blk{front,back}
> >> mechanism. The effect of this change is to reduce the number of unmap
> >> operations performed, since they cause a (costly) TLB shootdown. This
> >> allows the I/O performance to scale better when a large number of VMs
> >> are performing I/O.
> >>
> >> Previously, the blkfront driver was supplied a bvec[] from the request
> >> queue. This was granted to dom0; dom0 performed the I/O and wrote
> >> directly into the grant-mapped memory and unmapped it; blkfront then
> >> removed foreign access for that grant. The cost of unmapping scales
> >> badly with the number of CPUs in Dom0. An experiment showed that when
> >> Dom0 has 24 VCPUs, and guests are performing parallel I/O to a
> >> ramdisk, the IPIs from performing unmap's is a bottleneck at 5 guests
> >> (at which point 650,000 IOPS are being performed in total). If more
> >> than 5 guests are used, the performance declines. By 10 guests, only
> >> 400,000 IOPS are being performed.
> >>
> >> This patch improves performance by only unmapping when the connection
> >> between blkfront and back is broken.
> >>
> >> On startup blkfront notifies blkback that it is using persistent
> >> grants, and blkback will do the same. If blkback is not capable of
> >> persistent mapping, blkfront will still use the same grants, since it
> >> is compatible with the previous protocol, and simplifies the code
> >> complexity in blkfront.
> >>
> >> To perform a read, in persistent mode, blkfront uses a separate pool
> >> of pages that it maps to dom0. When a request comes in, blkfront
> >> transmutes the request so that blkback will write into one of these
> >> free pages. Blkback keeps note of which grefs it has already
> >> mapped. When a new ring request comes to blkback, it looks to see if
> >> it has already mapped that page. If so, it will not map it again. If
> >> the page hasn't been previously mapped, it is mapped now, and a record
> >> is kept of this mapping. Blkback proceeds as usual. When blkfront is
> >> notified that blkback has completed a request, it memcpy's from the
> >> shared memory, into the bvec supplied. A record that the {gref, page}
> >> tuple is mapped, and not inflight is kept.
> >>
> >> Writes are similar, except that the memcpy is peformed from the
> >> supplied bvecs, into the shared pages, before the request is put onto
> >> the ring.
> >>
> >> Blkback stores a mapping of grefs=>{page mapped to by gref} in
> >> a red-black tree. As the grefs are not known apriori, and provide no
> >> guarantees on their ordering, we have to perform a search
> >> through this tree to find the page, for every gref we receive. This
> >> operation takes O(log n) time in the worst case. In blkfront grants
> >> are stored using a single linked list.
> >>
> >> The maximum number of grants that blkback will persistenly map is
> >> currently set to RING_SIZE * BLKIF_MAX_SEGMENTS_PER_REQUEST, to
> >> prevent a malicios guest from attempting a DoS, by supplying fresh
> >> grefs, causing the Dom0 kernel to map excessively. If a guest
> >> is using persistent grants and exceeds the maximum number of grants to
> >> map persistenly the newly passed grefs will be mapped and unmaped.
> >> Using this approach, we can have requests that mix persistent and
> >> non-persistent grants, and we need to handle them correctly.
> >> This allows us to set the maximum number of persistent grants to a
> >> lower value than RING_SIZE * BLKIF_MAX_SEGMENTS_PER_REQUEST, although
> >> setting it will lead to unpredictable performance.
> >>
> >> In writing this patch, the question arrises as to if the additional
> >> cost of performing memcpys in the guest (to/from the pool of granted
> >> pages) outweigh the gains of not performing TLB shootdowns. The answer
> >> to that question is `no'. There appears to be very little, if any
> >> additional cost to the guest of using persistent grants. There is
> >> perhaps a small saving, from the reduced number of hypercalls
> >> performed in granting, and ending foreign access.
> >>
> >> Signed-off-by: Oliver Chick <oliver.chick@citrix.com>
> >> Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>
> >> Cc: <konrad.wilk@oracle.com>
> >> Cc: <linux-kernel@vger.kernel.org>
> >> ---
> >> Changes since v1:
> >>  * Changed the unmap_seg array to a bitmap.
> >>  * Only report using persistent grants in blkfront if blkback supports
> >>    it.
> >>  * Reword some comments.
> >>  * Fix a bug when setting the handler, index j was not incremented
> >>    correctly.
> >>  * Check that the tree of grants in blkback is not empty before
> >>    iterating over it when doing the cleanup.
> >>  * Rebase on top of linux-net.
> > 
> > I fixed the 'new_map = [1|0]' you had in and altered it to use 'true'
> > or 'false', but when running some tests (with a 64-bit PV guest) I got it
> > to bug.
> 
> Thanks for the testing. I'm going to rebase on top of your linux-next
> branch and see if I can reproduce it. Did you run any kind of specific
> test/benchmark? I've been running with this patch for a long time (on

None. Just booted a guest with a phy:/dev/vg_guest/blah.

> top of your previous linux-next branch), and I haven't been able to get
> it to bug.
