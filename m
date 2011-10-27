Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1J0P3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:29:48 -0400
Received: from mxout1.idt.com ([157.165.5.25]:58373 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab1J0P3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:29:46 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/5][v2] fsl-rio: Add two ports and rapidio message units support
Date: Thu, 27 Oct 2011 08:26:36 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552023B093B@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <9A1C2A9ACC704641BC472A1588CE164713112C@039-SN1MPN1-005.039d.mgd.msft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/5][v2] fsl-rio: Add two ports and rapidio message units support
Thread-Index: AQHMibHLqLGhzIQ3REujUFCG1TpMXZWEciUAgACLR1CABoY9oIABLj/ggAOfI/A=
References: <1318514922-12672-1-git-send-email-galak@kernel.crashing.org> <1318514922-12672-2-git-send-email-galak@kernel.crashing.org> <1318514922-12672-3-git-send-email-galak@kernel.crashing.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55202367762@CORPEXCH1.na.ads.idt.com> <9A1C2A9ACC704641BC472A1588CE164712E48E@039-SN1MPN1-005.039d.mgd.msft.net> <0CE8B6BE3C4AD74AB97D9D29BD24E55202368098@CORPEXCH1.na.ads.idt.com> <9A1C2A9ACC704641BC472A1588CE164713112C@039-SN1MPN1-005.039d.mgd.msft.net>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Liu Gang-B34182 <B34182@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>, <linuxppc-dev@ozlabs.org>,
        Zang Roy-R61911 <r61911@freescale.com>
CC: Andrew Morton <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 6:40 AM, Liu Gang-B34182 <B34182@freescale.com>
wrote:
> > ... skip ...
> > > +
> > > +      DBELL_TID(dmsg),
> > > +      DBELL_INF(dmsg));
> > > +     break;
> > > +    }
> > >     }
> > >    }
> >
> > Do we need to check for matching DBELL_TID and mport destID here and
> > scan only doorbell list attached to the right port? Otherwise this
> may
> > call service routine associated with doorbell on a wrong port.
> > [Liu Gang-B34182] Do you mean to match DBELL_TID and mport DevID?
> 
> Yes.
> 
> > Usually this is a reliable method, but for the rapidio module of
> > powerpc, will encounter some problem. We set the port's DevID by the
> > register "Base Device ID CSR" defined in Rapidio Specification.
> The
> > rapidio module of powerpc can support two ports but have only one
the
> > Base Device ID CSR. So these two ports will have the same DevID.
> > Although there are two registers "Alternate Device ID CSR" to
> separate
> > deviceIDs for each port, they are specific registers of the
freescale
> > rapidio and can't be accessed by getting the extended
> feature
> > space block offset. For this doobell issue, in order to call a right
> > service routine, perhaps we should ensure that different ports in
> > different "res->start and res->end" configurations.
> 
> This gives us an issue that has to be solved at some point.
> Splitting doorbell resources may be a way in this case but should be
> considered in context of RIO network with different endpoints and
> therefore it will be some device-specific quirk.
> 
> Probably the best approach in this case is to keep doorbell handler as
> it is now (for purpose of this patchset) and address doorbell resource
> assignment during enumeration/discovery. At least this has to be well
> commented.
> [Liu Gang-B34182] I think this is a very complex issue, and could be
> very difficult to be resolved if we can't separate DevIDs for each
> port.
> Based on the current architecture of the RIO driver, the doorbell
> resource will be assigned by the application. For example, RIONET will
> assign the doorbell resource like this:
> 	if ((rc = rio_request_inb_dbell(rnet->mport,
> 					(void *)ndev,
> 					RIONET_DOORBELL_JOIN,
> 					RIONET_DOORBELL_LEAVE,
> 					rionet_dbell_event)) < 0)
> 		goto out;
> The res->start and res->end were defined by RIONET to
> RIONET_DOORBELL_JOIN (0x1000) and RIONET_DOORBELL_LEAVE (0x1001). And
> RIONET will send a doorbell
> package like this:
> 	rio_send_doorbell(peer->rdev, RIONET_DOORBELL_JOIN);
> When the destination port of this doorbell package has been assigned
> the same res->start and res->end, it can work well. But when we try to
> address doorbell resource assignment during enumeration/discovery, and
> give the different doorbell resource to different port, how an
endpoint
> to get the destination port resource it wants to send to a doorbell
> package?
> 
> In fact, I also encountered some other issues due to the two ports
> sharing one CSR. For example the "Host base device ID lock command and
> status register" and "Port General control command and status
> register", these caused some issues when enumeration/discovery, and
> very difficult to be resolved
> based on current RIO architecture.

We need to adjust enumeration/discovery to deal with multi-port
endpoints.
As per RIO spec multi-port device has only one Base Device ID CSR but at
least offers a way to properly identify such capability.
Unfortunately p4080 controller follows older RIO 1.2 spec and does not
implement the multiport bit and CSR 0x14. This will force us to have a
quirk for devices with specific Device Identity CAR values.

One of possible ways for discovery may be ignoring value in reg.0x60 and
use destID set in the routing table of the attached switch (assuming
that
endpoint is capable to accept packets with destIDs other than one
in reg.0x60). But this alone does not guarantee that destIDs assigned to
two different ports will not match. This may force us to consider
additional measures of identification (which may be easier to implement
if 16-bit destIDs are used).

Anyway, we are not in position to resolve this immediately and probably
the best what we can do now is to keep multi-port endpoint specifics
in mind for future extensions. 

I am slowly addressing multiple port support issues in
enumeration/discovery prompted by introduction of tsi721 PCIe-to-SRIO
bridge
and will keep multi-port endpoints in mind (this is different from
multiple
tsi721's on single board). 

Regards,
 
Alex.


