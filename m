Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2GYCry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 22:47:54 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:27257
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab2GYCrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 22:47:51 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzzz2dh668h839h944hd25hf0ah107ah)
X-WSS-ID: 0M7P3RJ-01-5FK-02
X-M-MSG: 
Date: Wed, 25 Jul 2012 10:47:38 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Betty Dall <betty.dall@hp.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lin Ming <minggr@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH 5/5] block: genhd: add an interface to set disk's poll
 interval
Message-ID: <20120725024737.GA2395@aarontestpc.amd.com>
References: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
 <1343026180-22236-6-git-send-email-aaron.lu@amd.com>
 <1343069014.25735.28.camel@ejdallLaptop>
 <20120723235211.GB1965@localhost.localdomain>
 <1343156106.25735.59.camel@ejdallLaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1343156106.25735.59.camel@ejdallLaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 25 Jul 2012 02:47:37.0776 (UTC) FILETIME=[D9FAD300:01CD6A0F]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Betty,

On Tue, Jul 24, 2012 at 12:55:06PM -0600, Betty Dall wrote:
> > > > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > > > index 2f159aa..78c4226 100644
> > > > --- a/drivers/scsi/sr.c
> > > > +++ b/drivers/scsi/sr.c
> > > > @@ -869,6 +869,7 @@ static int sr_probe(struct device *dev)
> > > >  	dev_set_drvdata(dev, cd);
> > > >  	disk->flags |= GENHD_FL_REMOVABLE;
> > > >  	add_disk(disk);
> > > > +	disk_events_set_poll_msecs(disk, 2000);
> > > 
> > > Could you check that disk event's poll_msecs is the default (-1) before
> > > setting it to 2s? I am thinking of a case when the probe happens after
> > > the call to disk_events_poll_msecs_store() and this code would overwrite
> > > the user specified value.
> > 
> > The block device sr0 is created by this driver in this probe function,
> > so the user should not be able to set the poll interval before probe,
> > right?
> 
> The add_disk() call happens immediately before the new
> disk_events_set_poll_msecs() call. add_disk() is what eventually creates
> the sysfs files

Right, and it's disk_add_events in add_disk that adds these sysfs files.

> and calls your new disk_events_set_poll_msecs().

No... there is no call to disk_events_set_poll_msecs in add_disk, when
the events for the disk is created by disk_alloc_events, the poll_msecs
of the event is initialized to the default value -1. And then
disk_add_events will create the sysfs files and add_disk will return,
and I'll change the default value of -1 to 2000 with the new function
I've made.

> It makes more sense to me to have the new call to
> disk_events_set_poll_msecs(disk, 2000) before the call to add_disk().

This is too early, since the events of the disk is not allocated yet.

I hope I've explained this clearly, if you see a problem, please let me
know, thanks.

-Aaron


