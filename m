Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1F3Vih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:38:37 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:31533 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1F3Vig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:38:36 -0400
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
Subject: RE: [PATCH 23/40] Staging: hv: storvsc: Introduce code to manage
 IDE devices using storvsc HBA
Thread-Topic: [PATCH 23/40] Staging: hv: storvsc: Introduce code to manage
 IDE devices using storvsc HBA
Thread-Index: AQHMNmgKdeOmyOturE6EI9v+VpMfjpTWwyyA//+l6xA=
Date: Thu, 30 Jun 2011 21:38:34 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480816C2EF@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-23-git-send-email-kys@microsoft.com>
 <20110630193843.GB22707@infradead.org>
In-Reply-To: <20110630193843.GB22707@infradead.org>
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
> Sent: Thursday, June 30, 2011 3:39 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Abhishek Kane (Mindtree Consulting PVT LTD); Hank Janssen
> Subject: Re: [PATCH 23/40] Staging: hv: storvsc: Introduce code to manage IDE
> devices using storvsc HBA
> 
> > +/*
> > + * We want to manage the IDE devices using standard Linux SCSI drivers
> > + * using the storvsc driver.
> > + * Define special channels to support this.
> > + */
> > +
> > +#define HV_MAX_IDE_DEVICES	4
> > +#define HV_IDE_BASE_CHANNEL	10
> > +#define HV_IDE0_DEV1		HV_IDE_BASE_CHANNEL
> > +#define HV_IDE0_DEV2		(HV_IDE_BASE_CHANNEL + 1)
> > +#define HV_IDE1_DEV1		(HV_IDE_BASE_CHANNEL + 2)
> > +#define HV_IDE1_DEV2		(HV_IDE_BASE_CHANNEL + 3)
> 
> This at last needs a good explanation of why these devices are called
> IDE if they actually aren't.  I know you've explained the reason to me
> before, but it should also be in the code.

These devices are configured as IDE devices for the guest. The current
emulator supports 2 IDE controllers for a total of potentially 4 devices.
I did this to support all these 4 devices under one scsi host and used the
channel information to get at the correct device in the I/O path.
So, if you go to a model with one host per device, this would not be required.
 
> 
> The HV_IDE1_DEVn defines don't seem to useful to me.  They are just
> used in one place, and doing an opencoded HV_IDE_BASE_CHANNEL +
> channel_nr would seem a lot easier to understand to me.
> 
> > +static struct  Scsi_Host *storvsc_host;
> > +
> > +/*
> > + * State to manage IDE devices that register with the storvsc driver.
> > + *
> > + */
> > +static struct hv_device *ide_devices[HV_MAX_IDE_DEVICES];
> > +
> > +static void storvsc_get_ide_info(struct hv_device *dev, int *target, int *path)
> > +{
> > +	*target =
> > +	dev->dev_instance.data[5] << 8 | dev->dev_instance.data[4];
> > +
> > +	*path =
> > +	dev->dev_instance.data[3] << 24 | dev->dev_instance.data[2] << 16 |
> > +	dev->dev_instance.data[1] << 8  | dev->dev_instance.data[0];
> 
> Pretty odd formatting, I'd rather do it as:
> 
> 	*target =
> 		dev->dev_instance.data[5] << 8 |
> 		dev->dev_instance.data[4];
> 
> but more importanly what does path actually stand for here?  Opencoding
> this into the caller and adding proper comments explaining the scheme
> might be more readable.

In the blkvsc driver, the path/target info was used to properly identify the 
device - (a) the device was under the first or second IDE controller and (b)
whether it is the first or second device under the controller. 

Regards,

K. Y

.


