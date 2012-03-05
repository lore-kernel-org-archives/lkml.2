Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab2CEOVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:21:53 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:17118
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932403Ab2CEOVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:21:51 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz936eK1432N98dK853kzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: [PATCH] powerpc/srio: Fix the compile errors when building
	with 64bit
From: Liu Gang <Gang.Liu@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <r61911@freescale.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
In-Reply-To: <6BFCD6C7-7675-4A99-9C4C-4E86FA5642A4@kernel.crashing.org>
References: <1330672127-22172-1-git-send-email-Gang.Liu@freescale.com>
	 <6BFCD6C7-7675-4A99-9C4C-4E86FA5642A4@kernel.crashing.org>
Content-Type: text/plain
Date: Mon, 5 Mar 2012 22:20:22 +0800
Message-ID: <1330957222.23420.136.camel@10.ap.freescale.net>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kumar,

On Fri, 2012-03-02 at 09:11 -0600, Kumar Gala wrote:
> > diff --git a/arch/powerpc/sysdev/fsl_rmu.c b/arch/powerpc/sysdev/fsl_rmu.c
> > index 1548578..468011e 100644
> > --- a/arch/powerpc/sysdev/fsl_rmu.c
> > +++ b/arch/powerpc/sysdev/fsl_rmu.c
> > @@ -311,8 +311,8 @@ fsl_rio_dbell_handler(int irq, void *dev_instance)
> > 
> > 	/* XXX Need to check/dispatch until queue empty */
> > 	if (dsr & DOORBELL_DSR_DIQI) {
> > -		u32 dmsg =
> > -			(u32) fsl_dbell->dbell_ring.virt +
> > +		unsigned long dmsg =
> > +			(unsigned long) fsl_dbell->dbell_ring.virt +
> > 			(in_be32(&fsl_dbell->dbell_regs->dqdpar) & 0xfff);
> > 		struct rio_dbell *dbell;
> > 		int found = 0;
> > @@ -657,7 +657,8 @@ fsl_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
> > 	int ret = 0;
> > 
> > 	pr_debug("RIO: fsl_add_outb_message(): destid %4.4x mbox %d buffer " \
> > -		 "%8.8x len %8.8x\n", rdev->destid, mbox, (int)buffer, len);
> > +		 "%8.8lx len %8.8zx\n", rdev->destid, mbox,
> > +		(unsigned long)buffer, len);
> > 	if ((len < 8) || (len > RIO_MAX_MSG_SIZE)) {
> > 		ret = -EINVAL;
> > 		goto out;
> 
> For this case it seems as if some cast should be added to DBELL_* macros

Do you mean the DBELL_* macro should be added the cast "u16" and like
this:
#define DBELL_SID(x)    (u16)(*(u16 *)(x + DOORBELL_SID_OFFSET))

> > @@ -972,7 +973,7 @@ out:
> > void *fsl_get_inb_message(struct rio_mport *mport, int mbox)
> > {
> > 	struct fsl_rmu *rmu = GET_RMM_HANDLE(mport);
> > -	u32 phys_buf, virt_buf;
> > +	unsigned long phys_buf, virt_buf;
> 
> Do you really want to change phys_buf to an 'unsigned long'?
> 
> Should virt_buf really be void * here?

I think you are right, the phys_buf should not be changed to 'unsigned
long' and the virt_buf should be void *. I'll correct this in next
version.

> > @@ -982,7 +983,7 @@ void *fsl_get_inb_message(struct rio_mport *mport, int mbox)
> 
> The memcpy later could remove a cast if you make virt_buf a void *.

Thanks a lot, will remove.

Best Regards,

Liu Gang


