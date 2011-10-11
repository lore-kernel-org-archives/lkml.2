Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab1JKUvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 16:51:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35689 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab1JKUvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 16:51:05 -0400
Date: Tue, 11 Oct 2011 16:50:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Li Dongyang <lidongyang@novell.com>
Cc: Jan Beulich <JBeulich@suse.com>, hch@infradead.org,
        Dong Yang Li <lidongyang@suse.com>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH 2/3] xen/blkback: Fix the inhibition to
 map pages when discarding sector ranges.
Message-ID: <20111011205035.GA22668@phenom.oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-3-git-send-email-konrad.wilk@oracle.com>
 <4E940B99020000780005AA12@victor.provo.novell.com>
 <CAKH3R4-HJZBE-yWk=Dwkuwy13z1vdUrgEoJ9zFhTJgXgYfHHfA@mail.gmail.com>
 <20111011183909.GA2357@phenom.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111011183909.GA2357@phenom.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E94AC31.00A4:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 02:39:09PM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Oct 11, 2011 at 03:33:11PM +0800, Li Dongyang wrote:
> > On Tue, Oct 11, 2011 at 3:25 PM, Jan Beulich <JBeulich@suse.com> wrote:
> > >>>> On 10.10.11 at 17:28, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > >> The 'operation' parameters are the ones provided to the bio layer while
> > >> the req->operation are the ones passed in between the backend and
> > >> frontend. We used the wrong 'operation' value to squash the
> > >> call to map pages when processing the discard operation resulting
> > >> in mapping the pages unnecessarily.
> > >>
> > >> CC: Li Dongyang <lidongyang@novell.com>
> > >> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > >> ---
> > >>  drivers/block/xen-blkback/blkback.c |    2 +-
> > >>  1 files changed, 1 insertions(+), 1 deletions(-)
> > >>
> > >> diff --git a/drivers/block/xen-blkback/blkback.c
> > >> b/drivers/block/xen-blkback/blkback.c
> > >> index 184b133..3da9a40 100644
> > >> --- a/drivers/block/xen-blkback/blkback.c
> > >> +++ b/drivers/block/xen-blkback/blkback.c
> > >> @@ -707,7 +707,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> > >>        * the hypercall to unmap the grants - that is all done in
> > >>        * xen_blkbk_unmap.
> > >>        */
> > >> -     if (operation != BLKIF_OP_DISCARD &&
> > >> +     if (operation != REQ_DISCARD &&
> > >
> > > Why is that check necessary in the first place? xen_blkbk_map() doesn't
> > > do any harm when req->nr_segments is zero (as could also be the case
> > > on WRITE_FLUSH ones).
> > >
> > Ah, you are right, we could remove this check then, Thanks
> 
> Except that req->nr_segments for blkif__request_discard is actually
> the reserved field.
> 
> See:
> 
> struct blkif_request {
>     uint8_t        operation;    /* BLKIF_OP_???                         */
>     uint8_t        nr_segments;  /* number of segments                   */
>     blkif_vdev_t   handle;       /* only for read/write requests         */
> .. snip..
> 
> and:
> struct blkif_request_discard {
>     uint8_t        operation;    /* BLKIF_OP_DISCARD                     */
>                                  /* ignored if 'discard-secure=0'        */
> #define BLKIF_OP_DISCARD_FLAG_SECURE (1<<0)
>     uint8_t        flag;         /* BLKIF_OP_DISCARD_FLAG_SECURE or 0    */
>     blkif_vdev_t   handle;       /* same as for read/write requests      */
> 
> which will throw off the logic for nr_segments all wrong since for some
> discard operations it would read the nr_segments as 1.
> 
> So we do need some logic in there to work with this.


So a patch like this (and there is another on top that moves the setting
of nseg) should do it.


commit 12679b29b2f828454f833e17e9090ed576c63afc
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Mon Oct 10 00:47:49 2011 -0400

    xen/blkback: Fix the inhibition to map pages when discarding sector ranges.
    
    The 'operation' parameters are the ones provided to the bio layer while
    the req->operation are the ones passed in between the backend and
    frontend. We used the wrong 'operation' value to squash the
    call to map pages when processing the discard operation resulting
    in an hypercall that did nothing. Lets guard against going in the
    mapping function by checking for the amount of segments.
    
    CC: Li Dongyang <lidongyang@novell.com>
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index c15c559..94e659d 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -707,8 +707,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * the hypercall to unmap the grants - that is all done in
 	 * xen_blkbk_unmap.
 	 */
-	if (operation != BLKIF_OP_DISCARD &&
-			xen_blkbk_map(req, pending_req, seg))
+	if (nseg && xen_blkbk_map(req, pending_req, seg))
 		goto fail_flush;
 
 	/*
