Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1JLKa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 06:30:28 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:13712 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1JLKa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 06:30:27 -0400
X-IronPort-AV: E=Sophos;i="4.69,333,1315180800"; 
   d="scan'208";a="8344372"
Subject: Re: [Xen-devel] Re: [PATCH 2/3] xen/blkback: Fix the inhibition to
 map pages when discarding sector ranges.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Li Dongyang <lidongyang@novell.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Dong Yang Li <lidongyang@suse.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Date: Wed, 12 Oct 2011 11:30:25 +0100
In-Reply-To: <20111011205035.GA22668@phenom.oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
	 <1318260494-27985-3-git-send-email-konrad.wilk@oracle.com>
	 <4E940B99020000780005AA12@victor.provo.novell.com>
	 <CAKH3R4-HJZBE-yWk=Dwkuwy13z1vdUrgEoJ9zFhTJgXgYfHHfA@mail.gmail.com>
	 <20111011183909.GA2357@phenom.oracle.com>
	 <20111011205035.GA22668@phenom.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318415425.21903.652.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 21:50 +0100, Konrad Rzeszutek Wilk wrote:
> On Tue, Oct 11, 2011 at 02:39:09PM -0400, Konrad Rzeszutek Wilk wrote:
> > On Tue, Oct 11, 2011 at 03:33:11PM +0800, Li Dongyang wrote:
> > > On Tue, Oct 11, 2011 at 3:25 PM, Jan Beulich <JBeulich@suse.com> wrote:
> > > >>>> On 10.10.11 at 17:28, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > > >> The 'operation' parameters are the ones provided to the bio layer while
> > > >> the req->operation are the ones passed in between the backend and
> > > >> frontend. We used the wrong 'operation' value to squash the
> > > >> call to map pages when processing the discard operation resulting
> > > >> in mapping the pages unnecessarily.
> > > >>
> > > >> CC: Li Dongyang <lidongyang@novell.com>
> > > >> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > >> ---
> > > >>  drivers/block/xen-blkback/blkback.c |    2 +-
> > > >>  1 files changed, 1 insertions(+), 1 deletions(-)
> > > >>
> > > >> diff --git a/drivers/block/xen-blkback/blkback.c
> > > >> b/drivers/block/xen-blkback/blkback.c
> > > >> index 184b133..3da9a40 100644
> > > >> --- a/drivers/block/xen-blkback/blkback.c
> > > >> +++ b/drivers/block/xen-blkback/blkback.c
> > > >> @@ -707,7 +707,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> > > >>        * the hypercall to unmap the grants - that is all done in
> > > >>        * xen_blkbk_unmap.
> > > >>        */
> > > >> -     if (operation != BLKIF_OP_DISCARD &&
> > > >> +     if (operation != REQ_DISCARD &&
> > > >
> > > > Why is that check necessary in the first place? xen_blkbk_map() doesn't
> > > > do any harm when req->nr_segments is zero (as could also be the case
> > > > on WRITE_FLUSH ones).
> > > >
> > > Ah, you are right, we could remove this check then, Thanks
> > 
> > Except that req->nr_segments for blkif__request_discard is actually
> > the reserved field.

Either this field is nr_segments for op==DISCARD or it is not.

If it is then it should be named nr_segments and treated as such.

If it is not then it is a bug for anything to look at those bits in
memory and treat them as nr_segments.

There was a patch (from Own Smith) at one point to use a union in the
blkif request data type, would doing that help to make it clear which
fields overlap and which do not?

> > See:
> > 
> > struct blkif_request {
> >     uint8_t        operation;    /* BLKIF_OP_???                         */
> >     uint8_t        nr_segments;  /* number of segments                   */
> >     blkif_vdev_t   handle;       /* only for read/write requests         */
> > .. snip..
> > 
> > and:
> > struct blkif_request_discard {
> >     uint8_t        operation;    /* BLKIF_OP_DISCARD                     */
> >                                  /* ignored if 'discard-secure=0'        */
> > #define BLKIF_OP_DISCARD_FLAG_SECURE (1<<0)
> >     uint8_t        flag;         /* BLKIF_OP_DISCARD_FLAG_SECURE or 0    */
> >     blkif_vdev_t   handle;       /* same as for read/write requests      */
> > 
> > which will throw off the logic for nr_segments all wrong since for some
> > discard operations it would read the nr_segments as 1.

> > 
> > So we do need some logic in there to work with this.
> 
> 
> So a patch like this (and there is another on top that moves the setting
> of nseg) should do it.
> 
> 
> commit 12679b29b2f828454f833e17e9090ed576c63afc
> Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date:   Mon Oct 10 00:47:49 2011 -0400
> 
>     xen/blkback: Fix the inhibition to map pages when discarding sector ranges.
>     
>     The 'operation' parameters are the ones provided to the bio layer while
>     the req->operation are the ones passed in between the backend and
>     frontend. We used the wrong 'operation' value to squash the
>     call to map pages when processing the discard operation resulting
>     in an hypercall that did nothing. Lets guard against going in the
>     mapping function by checking for the amount of segments.
>     
>     CC: Li Dongyang <lidongyang@novell.com>
>     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index c15c559..94e659d 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -707,8 +707,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  	 * the hypercall to unmap the grants - that is all done in
>  	 * xen_blkbk_unmap.
>  	 */
> -	if (operation != BLKIF_OP_DISCARD &&
> -			xen_blkbk_map(req, pending_req, seg))
> +	if (nseg && xen_blkbk_map(req, pending_req, seg))

nseg == reg->nr_segments, so as above either referencing nseg when
operation == BLKIF_OP_DISCARD is a bug or the field is badly named.

Ian.

>  		goto fail_flush;
>  
>  	/*
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel


