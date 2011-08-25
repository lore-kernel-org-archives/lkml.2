Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab1HYWOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:14:09 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:53809 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab1HYWOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:14:08 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 12/59] Staging: hv: vmbus: Cleanup vmbus_uevent() code
Thread-Topic: [PATCH 12/59] Staging: hv: vmbus: Cleanup vmbus_uevent() code
Thread-Index: AQHMY0QsFBDYbTkATEaZVywXctrmNJUugpQA//+e4IA=
Date: Thu, 25 Aug 2011 22:14:05 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B356B@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-12-git-send-email-kys@microsoft.com>
 <20110825205930.GA10883@kroah.com>
In-Reply-To: <20110825205930.GA10883@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, August 25, 2011 5:00 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 12/59] Staging: hv: vmbus: Cleanup vmbus_uevent() code
> 
> On Thu, Aug 25, 2011 at 09:48:38AM -0700, K. Y. Srinivasan wrote:
> > Now generate appropriate uevent based on the modalias string. As part of this,
> > cleanup the existing uevent code.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/vmbus_drv.c |   60 ++++++++--------------------------------
> >  1 files changed, 12 insertions(+), 48 deletions(-)
> >
> > diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> > index b651968..a6e7dc5 100644
> > --- a/drivers/staging/hv/vmbus_drv.c
> > +++ b/drivers/staging/hv/vmbus_drv.c
> > @@ -237,58 +237,22 @@ static struct device_attribute vmbus_device_attrs[] =
> {
> >   * This routine is invoked when a device is added or removed on the vmbus to
> >   * generate a uevent to udev in the userspace. The udev will then look at its
> >   * rule and the uevent generated here to load the appropriate driver
> > + *
> > + * The alias string will be of the form vmbus:guid where guid is the string
> > + * representation of the device guid (each byte of the guid will be
> > + * represented with two hex characters.
> >   */
> >  static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
> >  {
> >  	struct hv_device *dev = device_to_hv_device(device);
> > -	int ret;
> > -
> > -	ret = add_uevent_var(env, "VMBUS_DEVICE_CLASS_GUID={"
> > -			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> > -			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
> > -			     dev->dev_type.b[3],
> > -			     dev->dev_type.b[2],
> > -			     dev->dev_type.b[1],
> > -			     dev->dev_type.b[0],
> > -			     dev->dev_type.b[5],
> > -			     dev->dev_type.b[4],
> > -			     dev->dev_type.b[7],
> > -			     dev->dev_type.b[6],
> > -			     dev->dev_type.b[8],
> > -			     dev->dev_type.b[9],
> > -			     dev->dev_type.b[10],
> > -			     dev->dev_type.b[11],
> > -			     dev->dev_type.b[12],
> > -			     dev->dev_type.b[13],
> > -			     dev->dev_type.b[14],
> > -			     dev->dev_type.b[15]);
> > -
> > -	if (ret)
> > -		return ret;
> > +	int i, ret;
> > +	char alias_name[((sizeof(struct hv_vmbus_device_id) + 1)) * 2];
> >
> > -	ret = add_uevent_var(env, "VMBUS_DEVICE_DEVICE_GUID={"
> > -			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> > -			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
> > -			     dev->dev_instance.b[3],
> > -			     dev->dev_instance.b[2],
> > -			     dev->dev_instance.b[1],
> > -			     dev->dev_instance.b[0],
> > -			     dev->dev_instance.b[5],
> > -			     dev->dev_instance.b[4],
> > -			     dev->dev_instance.b[7],
> > -			     dev->dev_instance.b[6],
> > -			     dev->dev_instance.b[8],
> > -			     dev->dev_instance.b[9],
> > -			     dev->dev_instance.b[10],
> > -			     dev->dev_instance.b[11],
> > -			     dev->dev_instance.b[12],
> > -			     dev->dev_instance.b[13],
> > -			     dev->dev_instance.b[14],
> > -			     dev->dev_instance.b[15]);
> > -	if (ret)
> > -		return ret;
> > +	for (i = 0; i < (sizeof(struct hv_vmbus_device_id) * 2); i += 2)
> > +		sprintf(&alias_name[i], "%02x", dev->dev_type.b[i/2]);
> 
> I have to edit this to get it to work properly with the fact that I
> added the driver_data field to hv_vmbus_device_id.
> 
> Arguably, one could say that this patch was always broken as you were
> assuming the size of an individual field was the same size as the whole
> structure, which I don't think is always the case, or at least it's not
> a safe thing to assume :)

Perhaps I could have sized it based on guid size since that is what is going
to be the alias. 

Regards,

K. Y

