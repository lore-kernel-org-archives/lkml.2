Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2EHR3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:29:51 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53959 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2EHR3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:29:50 -0400
X-IronPort-AV: E=Sophos;i="4.75,552,1330905600"; 
   d="scan'208";a="12362280"
Date: Tue, 8 May 2012 18:29:32 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v3] xen-blkfront: set pages are FOREIGN_FRAME
 when sharing them
In-Reply-To: <20120507212536.GA24344@andromeda.dapyr.net>
Message-ID: <alpine.DEB.2.00.1205081826300.26786@kaball-desktop>
References: <1334075119-25102-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120416195258.GA14982@phenom.dumpdata.com> <alpine.DEB.2.00.1204171138020.26786@kaball-desktop> <20120507212536.GA24344@andromeda.dapyr.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 17, 2012 at 11:58:58AM +0100, Stefano Stabellini wrote:
> > On Mon, 16 Apr 2012, Konrad Rzeszutek Wilk wrote:
> > > On Tue, Apr 10, 2012 at 05:25:19PM +0100, Stefano Stabellini wrote:
> > > > Set pages as FOREIGN_FRAME whenever blkfront shares them with another
> > > > domain. Then when blkfront un-share them, also removes the
> > > > FOREIGN_FRAME_BIT from the p2m.
> > > >
> > > > We do it so that when the source and the destination domain are the same
> > > > (blkfront connected to blkback in the same domain) we can more easily
> 
> So I've been testing it with my mini config and it worked great. But
> when I started using a distro .config it blew up. I am not really
> sure why it does that, but here is the dmesg and .config.
> 
> Nothing fancy with the guest config:
> 
> cat /crash.xm  | grep -v \#
> memory = 4096
> name = "OL6_X86_64_PVHVM"
> vcpus=12
> vif = [ 'mac=00:0f:4b:00:00:72,bridge=switch' ]
> disk= ['phy:/dev/guests/OL6_X86_64_PVHVM,hda,w']
> vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1']
> vnc=1
> vnclisten="0.0.0.0"
> hvm_loader="/usr/bin/pygrub"
> 
> 
> This is the #testing branch, but just using my #linux-next along
> with stable/for-jens-3.5 should reproduce this.
> 
> I added a bit of debug statement and found that 0xffffffffffffffff
> was passed in as a PFN in the set_phys_to_machine.

I have been unable to reproduce this problem (I haven't given up yet)
but I bet that the following patch fixes it:


diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index e3a9945..88e9304 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -333,7 +333,7 @@ static int blkif_queue_request(struct request *req)
 					buffer_mfn,
 					rq_data_dir(req));
 
-			info->shadow[id].frame[i] = mfn_to_pfn(buffer_mfn);
+			info->shadow[id].frame[i] = buffer_pfn;
 			ring_req->u.rw.seg[i] =
 					(struct blkif_request_segment) {
 						.gref       = ref,


The idea is that the request contains a page for which

pfn->mfn->pfn == 0xffffffffffffffff

I am not sure exactly how it could be possible to get into this state in
blkfront, I hope that some more tracing and code reading will be able to
shed some lights on the issue.
