Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1HYRwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:52:14 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:41490 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab1HYRwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:52:13 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 06/59] Staging: hv: blkvsc: Use the newly introduced
 vmbus ID in the blockvsc driver
Thread-Topic: [PATCH 06/59] Staging: hv: blkvsc: Use the newly introduced
 vmbus ID in the blockvsc driver
Thread-Index: AQHMY0RPhcQQ8+NwTU64LG+F0dvlDZUuSdUA//+OjgA=
Date: Thu, 25 Aug 2011 17:52:10 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B339F@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-6-git-send-email-kys@microsoft.com>
 <20110825173624.GA21334@kroah.com>
In-Reply-To: <20110825173624.GA21334@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.79]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, August 25, 2011 1:36 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 06/59] Staging: hv: blkvsc: Use the newly introduced vmbus
> ID in the blockvsc driver
> 
> On Thu, Aug 25, 2011 at 09:48:32AM -0700, K. Y. Srinivasan wrote:
> > Use the newly introduced vmbus ID in the blockvsc driver. Also, do
> > the associated cleanup.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/blkvsc_drv.c |   23 ++++++++++++++---------
> >  1 files changed, 14 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> > index 018b293..9b99387 100644
> > --- a/drivers/staging/hv/blkvsc_drv.c
> > +++ b/drivers/staging/hv/blkvsc_drv.c
> > @@ -111,14 +111,6 @@ struct block_device_context {
> >
> >  static const char *drv_name = "blkvsc";
> >
> > -/* {32412632-86cb-44a2-9b5c-50d1417354f5} */
> > -static const uuid_le dev_type = {
> > -	.b = {
> > -		0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> > -		0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
> > -	}
> > -};
> > -
> >  /*
> >   * There is a circular dependency involving blkvsc_request_completion()
> >   * and blkvsc_do_request().
> > @@ -802,10 +794,24 @@ static void blkvsc_request(struct request_queue
> *queue)
> >  	}
> >  }
> >
> > +static const struct hv_vmbus_device_id id_table[] = {
> > +	{
> > +		/* IDE guid */
> > +		.guid = {
> > +			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> > +			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
> > +		}
> > +	},
> > +	{
> > +		.guid = { }
> > +	},
> > +};
> 
> Ah, so close, and yet, not quite :(
> 
> This should look like:
> 
> static const struct hv_vmbus_device_id id_table[] = {
> 	{
> 		/* IDE guid */
> 		.guid = {
> 			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> 			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
> 		}
> 	},
> 	{ },
> };
> 
> No need to set the field name to nothing.
> 
> Hm, this could all be made even smaller with something like the
> USB_DEVICE() macro.  How about this instead:
> 
> /* IDE guid */
> static const struct hv_vmbus_device_id id_table[] = {
> 	{ VMBUS_DEVICE(0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> 		       0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5) },
> 	{ },
> };
> 
> That would be easier to read and understand, right?  Half the number of
> lines as well, which is always nice.
> 
> If so, I'll go make that change here so you don't have to respin these.

Looks great Greg. So you are going to add the VMBUS_DEVICE() macro?
Thanks for doing this.

Regards,

K. Y

