Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1D0CLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:11:51 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:43974 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab1D0CLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:11:50 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 12/25] Staging: hv: Cleanup error handling in
 vmbus_child_device_register()
Thread-Topic: [PATCH 12/25] Staging: hv: Cleanup error handling in
 vmbus_child_device_register()
Thread-Index: AQHMBCwlB/WUls5NAEKxQl46vg3XoJRxNdKA//++lhA=
Date: Wed, 27 Apr 2011 02:11:48 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DD1AF@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-12-git-send-email-kys@microsoft.com>
 <20110426225059.GA12897@kroah.com>
In-Reply-To: <20110426225059.GA12897@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, April 26, 2011 6:51 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Abhishek Kane (Mindtree Consulting PVT LTD)
> Subject: Re: [PATCH 12/25] Staging: hv: Cleanup error handling in
> vmbus_child_device_register()
> 
> On Tue, Apr 26, 2011 at 09:20:29AM -0700, K. Y. Srinivasan wrote:
> > Cleanup error handling in vmbus_child_device_register().
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > ---
> >  drivers/staging/hv/vmbus_drv.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> > index d597dd4..4d569ad 100644
> > --- a/drivers/staging/hv/vmbus_drv.c
> > +++ b/drivers/staging/hv/vmbus_drv.c
> > @@ -720,11 +720,16 @@ int vmbus_child_device_register(struct hv_device
> *child_device_obj)
> >  	 */
> >  	ret = device_register(&child_device_obj->device);
> >
> > +	if (ret)
> > +		return ret;
> > +
> >  	/* vmbus_probe() error does not get propergate to device_register(). */
> >  	ret = child_device_obj->probe_error;
> 
> Wait, why not?  Why is the probe_error have to be saved off like this?
> That seems like something is wrong here, this patch should not be
> needed.
> 
> Well, you should check the return value of device_register, that is
> needed, but this seems broken somehow.

The current code had comments claiming that the probe error was not
correctly propagated. Looking at the kernel side of the code, it was not clear
if device_register() could succeed while the probe might fail. In any event,
if you can guarantee that device_register() can return any probe related 
errors, I agree with you that saving the probe error is an overkill. The current code
saved the probe error and with new check I added with regards to the return 
value of device_register, there is no correctness issue with this patch.
> 
> >
> > -	if (ret)
> > +	if (ret) {
> >  		pr_err("Unable to register child device\n");
> > +		device_unregister(&child_device_obj->device);
> > +	}
> >  	else
> 
> 	} else
> is the preferred way.
> 
> Care to send a fixup patch to remove the probe_error field and fix this
> formatting error up?

I will fix up the formatting issue.

Regards,

K. Y
