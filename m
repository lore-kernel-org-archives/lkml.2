Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab2BOGqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 01:46:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:46706 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213Ab2BOGqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 01:46:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117695420"
Subject: Re: [RFC PATCH 6/6] libata: add ZPODD support
From: Lin Ming <ming.m.lin@intel.com>
To: Aaron Lu <aaron.lu@amd.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
In-Reply-To: <CAOzJMDQHbM9Hyx_W=0nhzK+FTk5i5Hvvn00TerYH54-yH1so2A@mail.gmail.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
	 <1329124271-29464-7-git-send-email-ming.m.lin@intel.com>
	 <CAOzJMDQHbM9Hyx_W=0nhzK+FTk5i5Hvvn00TerYH54-yH1so2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Feb 2012 14:46:05 +0800
Message-ID: <1329288365.3104.34.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 14:06 +0800, Aaron Lu wrote:
> Hi,
> 
> Good work, I'm also working on ZPODD for AMD platforms, some comments below.

Great :)

> 
> On Mon, Feb 13, 2012 at 5:11 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > ZPODD(Zero Power Optical Disk Drive) is a new feature in
> > SATA 3.1 specification. It provides a way to power off unused CDROM.
> 
> I don't see anywhere in the sata 3.1 spec mentioned how to power off the
> cdrom, the only relevant content is the newly defined device attention pin,
> which is used to notify the host that this powered off device needs attention.
> Or do I miss something?

You're right.

> 
> >
> > CDROM is powered off by executing ACPI power resource's _OFF method.
> >
> 
> AMD has a different implementation to power off the CDROM, I'll need to
> prepare another patch based on yours.

Could you share AMD's implementation?

> 
> > When CDROM is powered off(D3Cold state), inserting disk will trigger a
> > wakeup event(GPE). GPE AML handler notifies the associated device. Then
> > CDROM is resumed in the notify handler.
> >
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  drivers/ata/libata-acpi.c |   64 +++++++++++++++++++++++++++++++++++++-------
> >  drivers/scsi/sr.c         |   39 +++++++++++++++++++++++++++
> >  drivers/scsi/sr.h         |    3 ++
> >  3 files changed, 95 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > index 5fc97d2..bf4eace 100644
> > --- a/drivers/scsi/sr.c
> > +++ b/drivers/scsi/sr.c
> > @@ -716,6 +752,9 @@ static int sr_probe(struct device *dev)
> >        disk->flags |= GENHD_FL_REMOVABLE;
> >        add_disk(disk);
> >
> > +       if (device_run_wake(dev))
> > +               cd->zpodd = 1;
> > +
> 
> For a cd to support zero power, it has to support device attention pin.
> If it does not support that, once it is powered off, it can't be power up
> back. So I don't think device_run_wake is enough to set the zpodd flag,
> unless your firmware has done the check and created the acpi table
> according to the result. Is it the case?

I should add device attention pin check.

Thanks for the comments.
Lin Ming

> 
> Thanks,
> Aaron


