Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2EJQTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:19:54 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24195 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2EJQTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:19:53 -0400
Date: Thu, 10 May 2012 12:12:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v3] xen-blkfront: set pages are FOREIGN_FRAME
 when sharing them
Message-ID: <20120510161240.GA3215@phenom.dumpdata.com>
References: <1334075119-25102-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120416195258.GA14982@phenom.dumpdata.com>
 <alpine.DEB.2.00.1204171138020.26786@kaball-desktop>
 <20120507212536.GA24344@andromeda.dapyr.net>
 <alpine.DEB.2.00.1205081826300.26786@kaball-desktop>
 <alpine.DEB.2.00.1205091849580.26786@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205091849580.26786@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 07:42:33PM +0100, Stefano Stabellini wrote:
> On Tue, 8 May 2012, Stefano Stabellini wrote:
> > I have been unable to reproduce this problem (I haven't given up yet)
> > but I bet that the following patch fixes it:
> > 
> > 
> > diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> > index e3a9945..88e9304 100644
> > --- a/drivers/block/xen-blkfront.c
> > +++ b/drivers/block/xen-blkfront.c
> > @@ -333,7 +333,7 @@ static int blkif_queue_request(struct request *req)
> >  					buffer_mfn,
> >  					rq_data_dir(req));
> >  
> > -			info->shadow[id].frame[i] = mfn_to_pfn(buffer_mfn);
> > +			info->shadow[id].frame[i] = buffer_pfn;
> >  			ring_req->u.rw.seg[i] =
> >  					(struct blkif_request_segment) {
> >  						.gref       = ref,
> > 
> > 
> > The idea is that the request contains a page for which
> > 
> > pfn->mfn->pfn == 0xffffffffffffffff
> > 
> > I am not sure exactly how it could be possible to get into this state in
> > blkfront, I hope that some more tracing and code reading will be able to
> > shed some lights on the issue.
> 
> The one line patch fixes the issue: when using LVM in the guest the same
> page can be used in two different requests (in blkif_queue_request)
> before being unmapped.
> The second time mfn_to_pfn is going to return ~0 because buffer_mfn has
> the FOREIGN_FRAME_BIT set.
> But actually we don't need to call mfn_to_pfn at all because we already
> know the pfn value, that is stored in buffer_pfn.
> 
> However the real problem remains at the time of blkif_completion: we
> will remove the FOREIGN_FRAME_BIT before the other requests have been
> completed.
> 
> If sharing the same page twice (or more) is a normal condition then I
> might have to revisit this patch completely and choose another
> strategy...

Ok, will wait for that and in the meantime drop the patch so I can
send a git pull to Jens.
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
