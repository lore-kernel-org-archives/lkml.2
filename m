Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab1ESE02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 00:26:28 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:57328 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1ESE01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 00:26:27 -0400
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt
	merge
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Roland Dreier <roland@purestorage.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rmda <linux-rdma@vger.kernel.org>, Vu Pham <vu@mellanox.com>,
        David Dillow <dillowda@ornl.gov>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
In-Reply-To: <BANLkTi==bZ0h3o5FNrg8PSJFp6F-zh5hTA@mail.gmail.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
	 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
	 <20110518170556.GB2595@obsidianresearch.com>
	 <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com>
	 <BANLkTi==bZ0h3o5FNrg8PSJFp6F-zh5hTA@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 18 May 2011 21:18:14 -0700
Message-Id: <1305778694.2856.533.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 12:17 -0700, Roland Dreier wrote:
> On Wed, May 18, 2011 at 11:02 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> > Thanks for the feedback. I'm still wondering though about the
> > usefulness of disabling / enabling SRPT per HCA port. For the use
> > cases I know about SRP communication over all target ports will be
> > enabled as soon as target configuration has finished and more
> > fine-grained access configuration will occur by allowing/disallowing
> > certain initiators to log in.
> 
> I definitely think that allowing the flexibility to configure ports individually
> is required.  It's easy to imagine a case with a separate front-end and
> back-end networks on the two HCA ports (this would be a pretty normal
> ethernet config), where only one port should be a target port.
> 
> It may not be how people do things now but it should at least be possible.
> 

Hey guys,

Apologies for the slightly delay response here..  Just to clarify on
Bart's point above.  The srpt_port->port_wwn patch in question does
current ensure that sport->enabled has been set via an configfs
attribute at:

   /sys/kernel/config/target/srpt/$IB_PORT_GUID/tpgt_1/enable

and will reject all SRP login attempts to an individual struct srpt_port
until the attribute has been explictly triggered.

This allows ib_srpt to follow what is expected by rtsadmin-v2 +
lio-utils, and used to generate /etc/target/srpt_start.sh used to save
persistent fabric configuration.  Currently other fabrics like
iscsi-target and tcm_qla2xxx expect to be able to reject fabric login
requests before the full set of WWPN endpoints, LUNs, NodeACLs +
MappedLUNs have been recreated during an typical init.d/target start
operation.

I think it makes sense to do the same for the SRPT control plane on an
individual HCA port GUID basis as long as there are no underlying fabric
issues, and that Roland is happy.  In terms of supporting more than one
type of /sys/kernel/config/target/srpt/$WWPN/$TPGT/ layout, I would
really like to avoid this for mainline code unless there is a really
good reason..

Also, I think ib_srpt needs to properly support 'demo-mode' operation
in /var/target/fabric/ib_srpt.spec as this is very useful for testing
and development purposes.  I go ahead and get this added to upstream LIO
v4.1 in the next days and respin for mainline with Hch's review + Bart's
changes.

Thanks folks,

--nab

