Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1CJWg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:36:59 -0500
Received: from mail3.microsoft.com ([131.107.115.214]:11769 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1CJWg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:36:58 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 11/21] Staging: hv: Make vmbus driver a platform pci
 driver
Thread-Topic: [PATCH 11/21] Staging: hv: Make vmbus driver a platform pci
 driver
Thread-Index: AQHL325beDuENri3oES+5wMXWQ0GNpQnqf4A//969sCAAIh/AP//ekkg
Date: Thu, 10 Mar 2011 22:36:57 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048018ACF@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1299794912-1233-1-git-send-email-kys@microsoft.com>
 <20110310222034.GA19323@suse.de>
 <6E21E5352C11B742B20C142EB499E048018AA3@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110310223256.GA8669@suse.de>
In-Reply-To: <20110310223256.GA8669@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Thursday, March 10, 2011 5:33 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang; Mike Sterling; Abhishek Kane
> (Mindtree Consulting PVT LTD); Hank Janssen
> Subject: Re: [PATCH 11/21] Staging: hv: Make vmbus driver a platform pci driver
> 
> On Thu, Mar 10, 2011 at 10:28:27PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@suse.de]
> > > Sent: Thursday, March 10, 2011 5:21 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > virtualization@lists.osdl.org; Haiyang Zhang; Mike Sterling; Abhishek Kane
> > > (Mindtree Consulting PVT LTD); Hank Janssen
> > > Subject: Re: [PATCH 11/21] Staging: hv: Make vmbus driver a platform pci
> driver
> > >
> > > On Thu, Mar 10, 2011 at 02:08:32PM -0800, K. Y. Srinivasan wrote:
> > > > Make vmbus driver a platform pci driver. This is
> > > > in preparation to cleaning up irq allocation for this
> > > > driver.
> > >
> > > The idea is nice, but the nameing is a bit confusing.
> > >
> > > We have "platform drivers" which are much different from what you are
> > > doing here, you are just creating a "normal" pci driver.
> > >
> > > Very minor comments below.
> > >
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
> > > > Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> > > > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > > > ---
> > > >  drivers/staging/hv/vmbus_drv.c |   63 +++++++++++++++++++++++--------
> -----
> > > ----
> > > >  1 files changed, 36 insertions(+), 27 deletions(-)
> > > >
> > > > diff --git a/drivers/staging/hv/vmbus_drv.c
> b/drivers/staging/hv/vmbus_drv.c
> > > > index 8b9394a..e4855ac 100644
> > > > --- a/drivers/staging/hv/vmbus_drv.c
> > > > +++ b/drivers/staging/hv/vmbus_drv.c
> > > > @@ -43,6 +43,8 @@
> > > >
> > > >  static struct device *root_dev; /* Root device */
> > > >
> > > > +struct pci_dev *hv_pci_dev;
> > > > +
> > > >  /* Main vmbus driver data structure */
> > > >  struct vmbus_driver_context {
> > > >
> > > > @@ -887,36 +889,24 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
> > > >  	}
> > > >  }
> > > >
> > > > -static struct dmi_system_id __initdata microsoft_hv_dmi_table[] = {
> > > > -	{
> > > > -		.ident = "Hyper-V",
> > > > -		.matches = {
> > > > -			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft
> > > Corporation"),
> > > > -			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
> > > > -			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
> > > > -		},
> > > > -	},
> > > > -	{ },
> > > > -};
> > > > -MODULE_DEVICE_TABLE(dmi, microsoft_hv_dmi_table);
> > >
> > > You're sure it's safe to delete this now and just rely on the PCI ids,
> > > right?  For some wierd reason I thought we needed both to catch all
> > > types of systems, but I can't remember why.
> > I have tested this; I don't think we need the dmi table.
> 
> Ok, if you are sure, that's fine with me.
> 
> > > How about "hv_bus" as a name, as that's what this really is.  It's a
> > > "bus adapter", like USB, Firewire, and all sorts of other bus
> > > controllers.
> >
> > Sure; I will make these changes. Would you mind if I submit these name
> changes as a separate patch.
> 
> How about just redo this patch?  I haven't reviewed the others yet, so
> you might want to wait a day to see if I don't like any of them either
> :)

Ok; I will wait for the reviews.

Regards,

K. Y

