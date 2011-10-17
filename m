Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1JQQud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:50:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37270 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1JQQuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:50:32 -0400
Date: Mon, 17 Oct 2011 12:50:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: hch@infradead.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] xen/blkback: Support 'feature-barrier' aka old-style
 BARRIER requests.
Message-ID: <20111017165011.GA19724@phenom.dumpdata.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-2-git-send-email-konrad.wilk@oracle.com>
 <4E9C2F52020000780005BA4C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C2F52020000780005BA4C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4E9C5CCD.00CD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 12:36:18PM +0100, Jan Beulich wrote:
> >>> On 10.10.11 at 17:28, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > @@ -481,6 +503,10 @@ static void __end_block_io_op(struct pending_req 
> > *pending_req, int error)
> >  			      pending_req->operation, pending_req->status);
> >  		xen_blkif_put(pending_req->blkif);
> >  		free_req(pending_req);
> > +		if (atomic_read(&pending_req->blkif->refcnt) <= 2) {
> > +			if (atomic_read(&pending_req->blkif->drain))
> > +				complete(&pending_req->blkif->drain_complete);
> > +		}
> 
> Shouldn't this be done *before* the call the free_req()? Or

Yes, otherwise we could referencing somebody's else blkif->refcnt.

Thanks for spotting that.
> alternatively a local copy of pending_req->blkif be obtained before
> freeing pending_req (which could be used in a couple more places
> in this function)?
> 
> Jan
