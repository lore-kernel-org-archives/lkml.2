Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab1KCOin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:38:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:30158 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab1KCOil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:38:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,450,1315206000"; 
   d="scan'208";a="70169633"
Subject: Re: [PATCH 2/3] scsi: add hooks for host runtime power management
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@Parallels.com>, Tejun Heo <tj@kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
In-Reply-To: <Pine.LNX.4.44L0.1111031019250.2136-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1111031019250.2136-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 03 Nov 2011 22:37:43 +0800
Message-ID: <1320331063.2813.78.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 22:22 +0800, Alan Stern wrote:
> On Thu, 3 Nov 2011, Lin Ming wrote:
> 
> > I realize that this is not the natural way to do ata port runtime pm.
> > Hooking it to scsi host runtime pm is not good. It does not deal with
> > the races with system suspend/resume of host controller.
> > 
> > How about making ata port as the parent device of scsi host?
> > Then, for example, the runtime suspend happens as below,
> > 
> > disk suspend --> scsi target suspend --> scsi host suspend --> ata port
> > suspend.
> > 
> > Current device tree is:
> > /sys/devices/pci0000:00/0000:00:1f.2/
> > |-- ata1
> > |-- host0
> > 
> > After the change, the tree will become as:
> > /sys/devices/pci0000:00/0000:00:1f.2/ata1/
> > |-- host0
> 
> I don't know enough about the ATA subsystem to say much, except that 
> this looks more logical.
> 
> > The tricky part is ata port(parent device) suspend need to schedule scsi
> > EH which will resume scsi host(child device). Then the child device
> > resume will in turn make parent device resume first. This is kind of
> > recursive.
> > 
> > We can fix this by adding a flag somewhere to tell scsi EH don't resume
> > the host in ata port pm request handling case.
> > 
> > What do you think?
> 
> Yes, it is a problem.  But it looks like the underlying issue is that
> you're using the SCSI error handler to do something it was not intended
> for.  Can't you suspend and resume the ATA port without using the error
> handler?

The system suspend and resume of the ATA port uses the error handler.
I think the runtime suspend and resume should use the error handler too.

Tejun,

Could you comment more on this?

Thanks.

> 
> Alan Stern
> 


