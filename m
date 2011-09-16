Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1IPTQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 15:16:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:57558 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab1IPTP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 15:15:59 -0400
Date: Fri, 16 Sep 2011 15:15:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: axboe@kernel.dk, xen-devel@lists.xensource.com,
        jeremy.fitzhardinge@citrix.com, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH 3/3] xen-blkfront: If no barrier or flush
 is supported, use invalid operation.
Message-ID: <20110916191514.GA31818@phenom.oracle.com>
References: <1315593060-20031-1-git-send-email-konrad.wilk@oracle.com>
 <1315593060-20031-3-git-send-email-konrad.wilk@oracle.com>
 <4E6DD8750200007800055ADA@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6DD8750200007800055ADA@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E73A04A.00D3:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 09:01:25AM +0100, Jan Beulich wrote:
> >>> On 09.09.11 at 20:31, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > By default we would set the info->flush_op=0, and zero maps
> > to BLKIF_OP_READ request code. So if the backend did not support
> > either barrier ('feature-barrier') or flush ('feature-flush-cache')
> > we would end up using that opcode for the flush/barrier request, meaning
> > we actually do a READ request. Fortunatly for us, __generic_make_request
> > checks q->flush_flags and realizes that we don't do FLUSH and removes
> > the REQ_FLUSH | REQ_FUA so we never end up issuing a READ request
> > for a flush request. However, other third party implementations of
> > __make_request might not be so smart, so lets fix this up.
> 
> Wouldn't it be better to simply have blkif_queue_request() fail in that
> case (and then it doesn't matter whether flush_op is set to 0 or -1)?
> Not the least because older (forward-port) backends stall the incoming
> queue and are possibly verbose for invalid requests seen.

So like this:


diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 468bfec..e9d301c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -380,7 +380,9 @@ static void do_blkif_request(struct request_queue *rq)
 
 		blk_start_request(req);
 
-		if (req->cmd_type != REQ_TYPE_FS) {
+		if ((req->cmd_type != REQ_TYPE_FS) ||
+		    ((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
+		    !info->flush_op)) {
 			__blk_end_request_all(req, -EIO);
 			continue;
 		}
