Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934618Ab1ESUMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:12:17 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:49211 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933670Ab1ESUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:12:15 -0400
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt
	merge
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rmda <linux-rdma@vger.kernel.org>, Vu Pham <vu@mellanox.com>,
        David Dillow <dillowda@ornl.gov>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
In-Reply-To: <BANLkTi=Xb-ypQNa3=MmwiLeE4Q9FWHnZXg@mail.gmail.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
	 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
	 <20110518170556.GB2595@obsidianresearch.com>
	 <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com>
	 <BANLkTi==bZ0h3o5FNrg8PSJFp6F-zh5hTA@mail.gmail.com>
	 <1305778694.2856.533.camel@haakon2.linux-iscsi.org>
	 <BANLkTi=Xb-ypQNa3=MmwiLeE4Q9FWHnZXg@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 19 May 2011 13:03:39 -0700
Message-Id: <1305835419.32066.20.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 12:40 +0200, Bart Van Assche wrote:
> On Thu, May 19, 2011 at 6:18 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > The srpt_port->port_wwn patch in question does
> > current ensure that sport->enabled has been set via an configfs
> > attribute at:
> >
> >   /sys/kernel/config/target/srpt/$IB_PORT_GUID/tpgt_1/enable
> >
> > and will reject all SRP login attempts to an individual struct srpt_port
> > until the attribute has been explictly triggered.
> >
> > This allows ib_srpt to follow what is expected by rtsadmin-v2 +
> > lio-utils, and used to generate /etc/target/srpt_start.sh used to save
> > persistent fabric configuration.  Currently other fabrics like
> > iscsi-target and tcm_qla2xxx expect to be able to reject fabric login
> > requests before the full set of WWPN endpoints, LUNs, NodeACLs +
> > MappedLUNs have been recreated during an typical init.d/target start
> > operation.
> >
> > I think it makes sense to do the same for the SRPT control plane on an
> > individual HCA port GUID basis as long as there are no underlying fabric
> > issues, and that Roland is happy.  In terms of supporting more than one
> > type of /sys/kernel/config/target/srpt/$WWPN/$TPGT/ layout, I would
> > really like to avoid this for mainline code unless there is a really
> > good reason..
> 
> I'm still wondering whether it was a good idea to switch from ib<n>
> style names to port GIDs. Not only will that make it hard for users to
> match the ib<n> names already assigned to InfiniBand HCAs with target
> port names but this also deviates from the naming scheme used for any
> other Linux device. Ethernet devices e.g. appear as eth<n> in /dev
> instead of a MAC address like 00:1a:64:10:18:6f.
> 

So from the user perspective in rtsadmin/rtslib, the Port GUIDs are
automatically presented in long-form after being extracted and parsed
from /sys/class/infiniband/*/ports/*/gids/0 input via ib_srpt.spec here:

http://www.linux-iscsi.org/wiki/SCSI_RDMA_Protocol/RTSadmin#Specification_file

The available IB Port GUIs appear as <TAB> completable input
in /ib_srpt/ during a 'create wwn=' operation shown here:

http://www.linux-iscsi.org/wiki/SCSI_RDMA_Protocol/RTSadmin#Configuration

There is no reason why we can't present a more verbose informational
display based on individual available HW fabric WWPNs. Eg: things like
HW port status information, driver, firmware rev, etc..

So aside from the user side of things, I think using a IB Port GUID
makes more sense to ensure that /sys/kernel/config/target/srpt/
configuration does not depend upon the ordering of symbolic HCA names
in /sys/class/infiniband/, which AFAIK are not guarenteed to be
persistent as HCAs are added/removed from the system.

Ensuring that we can reference target fabric WWPNs using an underlying
HW reference instead of a symbolic name is important for this reason,
and is currently how other HW target mode drivers including
tcm_fc(openfcoe) currently function.

Thanks,

--nab

