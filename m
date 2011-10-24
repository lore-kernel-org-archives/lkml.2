Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab1JXNyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:54:44 -0400
Received: from mxout1.idt.com ([157.165.5.25]:55502 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab1JXNyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:54:43 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/5][v2] fsl-rio: Add two ports and rapidio message units support
Date: Mon, 24 Oct 2011 06:51:13 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202368098@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <9A1C2A9ACC704641BC472A1588CE164712E48E@039-SN1MPN1-005.039d.mgd.msft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/5][v2] fsl-rio: Add two ports and rapidio message units support
Thread-Index: AQHMibHLqLGhzIQ3REujUFCG1TpMXZWEciUAgACLR1CABoY9oA==
References: <1318514922-12672-1-git-send-email-galak@kernel.crashing.org> <1318514922-12672-2-git-send-email-galak@kernel.crashing.org> <1318514922-12672-3-git-send-email-galak@kernel.crashing.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55202367762@CORPEXCH1.na.ads.idt.com> <9A1C2A9ACC704641BC472A1588CE164712E48E@039-SN1MPN1-005.039d.mgd.msft.net>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Liu Gang-B34182 <B34182@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>, <linuxppc-dev@ozlabs.org>,
        Zang Roy-R61911 <r61911@freescale.com>
CC: Andrew Morton <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 1:15 AM, Liu Gang-B34182 <B34182@freescale.com>
wrote:
> 
> From: Bounine, Alexandre [mailto:Alexandre.Bounine@idt.com]
> Sent: Thursday, October 20, 2011 3:54 AM
> To: Kumar Gala; linuxppc-dev@ozlabs.org
> Cc: Andrew Morton; Liu Gang-B34182; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 3/5][v2] fsl-rio: Add two ports and rapidio
message
> units support
> 
> On Thu, Oct 13, 2011 at 10:09 AM, Kumar Gala wrote:
> >
> > From: Liu Gang <Gang.Liu@freescale.com>
> >
> > Usually, freescale rapidio endpoint can support one 1X or two 4X LP-
> > Serial link interfaces, and rapidio message transactions can be
> > implemented
> by
> > two
> 
> Is the number of 1x ports described correctly?
> Can we have two 1x ports as well?
> [Liu Gang-B34182] Yes you are right. endpoint can also have two 1x
> ports. I'll correct it.
> 
> > message units. This patch adds the support of two rapidio ports and
> > initializes message unit 0 and message unit 1. And these ports and
> > message
> ... skip ...
> > +
> > +  /* Probe the master port phy type */
> > +  ccsr = in_be32(priv->regs_win + RIO_CCSR + i*0x20);
> > +  port->phy_type = (ccsr & 1) ? RIO_PHY_SERIAL :
> > RIO_PHY_PARALLEL;
> > +  dev_info(&dev->dev, "RapidIO PHY type: %s\n",
> > +    (port->phy_type == RIO_PHY_PARALLEL) ?
> > +    "parallel" :
> > +    ((port->phy_type == RIO_PHY_SERIAL) ?
> "serial"
> > :
> > +     "unknown"));
> > +  /* Checking the port training status */
> > +  if (in_be32((priv->regs_win + RIO_ESCSR + i*0x20)) & 1)
> {
> > +   dev_err(&dev->dev, "Port %d is not ready. "
> > +    "Try to restart connection...\n", i);
> > +   switch (port->phy_type) {
> > +   case RIO_PHY_SERIAL:
> > +    /* Disable ports */
> > +    out_be32(priv->regs_win
> > +     + RIO_CCSR + i*0x20, 0);
> > +    /* Set 1x lane */
> > +    setbits32(priv->regs_win
> > +     + RIO_CCSR + i*0x20,
> 0x02000000);
> > +    /* Enable ports */
> > +    setbits32(priv->regs_win
> > +     + RIO_CCSR + i*0x20,
> 0x00600000);
> > +    break;
> > +   case RIO_PHY_PARALLEL:
> > +    /* Disable ports */
> > +    out_be32(priv->regs_win
> > +     + RIO_CCSR + i*0x20,
> 0x22000000);
> > +    /* Enable ports */
> > +    out_be32(priv->regs_win
> > +     + RIO_CCSR + i*0x20,
> 0x44000000);
> > +    break;
> > +   }
> 
> Probably this may be a good moment to drop the support for parallel
> link.
> Especially after you renamed controller to "srio" in the device tree.
> [Liu Gang-B34182] I'm also considering if we should drop the parallel
> link support and doorbell outbound ATMU configuration.
> I found some older powerpc chips support parallel link, like mpc8540
> and so on. But DTS files of these chips do not support
> Rapidio nodes. For example we can't find rapidio node in
> arch/powerpc/boot/dts/mpc8540ads.dts file. So can we conclude that
> these chips with parallel rapidio link do not need the support for
> rapidio module and the code for parallel link can be removed?

We are not aware about any use of tsi500 P-RIO switches.
I would consider parallel implementation as an early stage
of RapidIO development which may be safely dropped.
I will keep P-RIO related definitions only because they are part of
the spec. I consider removing tsi500 switch driver as well.

> 
> > +   msleep(100);
... skip ...

> 
> >
> > @@ -340,35 +327,45 @@ fsl_rio_dbell_handler(int irq, void
> > *dev_instance)
> >     " sid %2.2x tid %2.2x info %4.4x\n",
> >     DBELL_SID(dmsg), DBELL_TID(dmsg),
> DBELL_INF(dmsg));
> >
> > -  list_for_each_entry(dbell, &port->dbells, node) {
> > -   if ((dbell->res->start <= DBELL_INF(dmsg)) &&
> > -    (dbell->res->end >= DBELL_INF(dmsg))) {
> > -    found = 1;
> > -    break;
> > +  for (i = 0; i < MAX_PORT_NUM; i++) {
> > +   if (fsl_dbell->mport[i]) {
> > +    list_for_each_entry(dbell,
> > +     &fsl_dbell->mport[i]->dbells,
> node) {
> > +     if ((dbell->res->start
> > +      <= DBELL_INF(dmsg))
> > +      && (dbell->res->end
> > +      >= DBELL_INF(dmsg))) {
> > +      found = 1;
> > +      break;
> > +     }
> > +    }
> > +    if (found && dbell->dinb) {
> > +     dbell->dinb(fsl_dbell->mport[i],
> > +      dbell->dev_id,
> DBELL_SID(dmsg),
> > +      DBELL_TID(dmsg),
> > +      DBELL_INF(dmsg));
> > +     break;
> > +    }
> >     }
> >    }
> 
> Do we need to check for matching DBELL_TID and mport destID here and
> scan only doorbell list attached to the right port? Otherwise this may
> call service routine associated with doorbell on a wrong port.
> [Liu Gang-B34182] Do you mean to match DBELL_TID and mport DevID?


Yes.

> Usually this is a reliable method, but for the rapidio module of
> powerpc, will encounter some problem. We set the port's DevID by
> the register "Base Device ID CSR" defined in Rapidio Specification.
The
> rapidio module of powerpc can support two ports but have only one the
> Base Device ID CSR. So these two ports will have the same
> DevID. Although there are two registers "Alternate Device ID CSR" to
> separate deviceIDs for each port, they are specific registers of the
> freescale rapidio and can't be accessed by getting the extended
feature
> space block offset. For this doobell issue, in order to call a right
> service routine, perhaps we should ensure that different ports in
> different "res->start and res->end" configurations.

This gives us an issue that has to be solved at some point.
Splitting doorbell resources may be a way in this case but should be
considered in context of RIO network with different endpoints and
therefore
it will be some device-specific quirk.

Probably the best approach in this case is to keep doorbell handler as
it is now (for purpose of this patchset) and address doorbell resource
assignment during enumeration/discovery. At least this has to be well
commented. 

> 
> > -  if (found) {
> > -   dbell->dinb(port, dbell->dev_id,
> > -     DBELL_SID(dmsg),
> > -     DBELL_TID(dmsg),
> DBELL_INF(dmsg));
> > -  } else {
> > +
> > +  if (!found) {
> >     pr_debug
> >      ("RIO: spurious doorbell,"
> >      " sid %2.2x tid %2.2x info %4.4x\n",
> >      DBELL_SID(dmsg), DBELL_TID(dmsg),
> >      DBELL_INF(dmsg));
> >    }
> > -  setbits32(&rmu->msg_regs->dmr, DOORBELL_DMR_DI);
> > -  out_be32(&rmu->msg_regs->dsr, DOORBELL_DSR_DIQI);
> > +  setbits32(&fsl_dbell->dbell_regs->dmr, DOORBELL_DMR_DI);
> > +  out_be32(&fsl_dbell->dbell_regs->dsr,
> DOORBELL_DSR_DIQI);
> >   }
> >
> >  out:
> >   return IRQ_HANDLED;
> >  }
> >
... skip ...
 
Regards,

Alex.
