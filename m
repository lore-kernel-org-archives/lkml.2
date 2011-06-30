Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1F3VQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:16:04 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:35943 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1F3VQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:16:01 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 24/40] Staging: hv: storvsc: On I/O get the correct IDE
 device
Thread-Topic: [PATCH 24/40] Staging: hv: storvsc: On I/O get the correct IDE
 device
Thread-Index: AQHMNmgWbGY5kOd/Uk6J+qlCI81qb5TWw8mA//+jQpA=
Date: Thu, 30 Jun 2011 21:15:54 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480816C2CF@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-24-git-send-email-kys@microsoft.com>
 <20110630194055.GC22707@infradead.org>
In-Reply-To: <20110630194055.GC22707@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, June 30, 2011 3:41 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Abhishek Kane (Mindtree Consulting PVT LTD); Hank Janssen
> Subject: Re: [PATCH 24/40] Staging: hv: storvsc: On I/O get the correct IDE device
> 
> On Wed, Jun 29, 2011 at 07:39:21AM -0700, K. Y. Srinivasan wrote:
> > We use the channel number to distinguish an IDE device managed by the
> > storvsc driver from scsi devices. Add code to get the correct
> > device pointer based on the channel number.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > ---
> >  drivers/staging/hv/storvsc_drv.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> > index cf659d7..fcc3f5d 100644
> > --- a/drivers/staging/hv/storvsc_drv.c
> > +++ b/drivers/staging/hv/storvsc_drv.c
> > @@ -517,6 +517,16 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd
> *scmnd,
> >  	unsigned int sg_count = 0;
> >  	struct vmscsi_request *vm_srb;
> >
> > +	if (scmnd->device->channel >= HV_IDE_BASE_CHANNEL) {
> > +		int channel = scmnd->device->channel;
> > +
> > +		/*
> > +		 * This is an IDE device; get the right dev.
> > +		 */
> > +
> > +		dev = ide_devices[channel - HV_IDE_BASE_CHANNEL];
> > +	}
> 
> So instead of playing games about getting the right hv_device here,
> why don't you register one scsi host for each IDE device? libata
> does the same for real ATA devices.
> 
That is what I did initially. Then looking at the way we  were handling scsi devices
where each scsi controller configured for the guest results in an emulated HBA
(scsi host) in the guest and all the block devices under a given controller are
handled through this one host, I decided to mimic a similar structure  - one
scsi host for all the block devices configured as an IDE device.

I can go back to my earlier implementation with one host per disk.

Regards,

K. Y 
