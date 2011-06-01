Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1FASDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:03:08 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:30683 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab1FASDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:03:06 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Andre Bartke <andre.bartke@googlemail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging/hv: Fix memory leak of storvsc_dev_add()
Thread-Topic: [PATCH] staging/hv: Fix memory leak of storvsc_dev_add()
Thread-Index: AQHMH9xSg+d0MDS0BU6LVitfjOnOf5SniZ5wgAGe6gD//5zGAA==
Date: Wed, 1 Jun 2011 18:03:03 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480813C9E0@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1306878352-14450-1-git-send-email-andre.bartke@gmail.com>
	<6E21E5352C11B742B20C142EB499E0480813C89C@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20110601183210.1a4d3296@kvasir>
In-Reply-To: <20110601183210.1a4d3296@kvasir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andre Bartke [mailto:andre.bartke@googlemail.com]
> Sent: Wednesday, June 01, 2011 12:32 PM
> To: KY Srinivasan
> Cc: Andre Bartke; gregkh@suse.de; devel@driverdev.osuosl.org; Haiyang Zhang;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] staging/hv: Fix memory leak of storvsc_dev_add()
> 
> On Wed, 1 Jun 2011 12:28:40 +0000
> KY Srinivasan <kys@microsoft.com> wrote:
> 
> >
> >
> > > -----Original Message-----
> > > From: devel-bounces@linuxdriverproject.org [mailto:devel-
> > > bounces@linuxdriverproject.org] On Behalf Of Andre Bartke
> > > Sent: Tuesday, May 31, 2011 5:46 PM
> > > To: gregkh@suse.de
> > > Cc: devel@driverdev.osuosl.org; Andre Bartke; Haiyang Zhang; linux-
> > > kernel@vger.kernel.org
> > > Subject: [PATCH] staging/hv: Fix memory leak of storvsc_dev_add()
> > >
> > > stor_device is not freed in storvsc_dev_add()
> > > causing a memory leak in case of an allocation error.
> > >
> > > Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
> > > ---
> > >  drivers/staging/hv/storvsc.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/staging/hv/storvsc.c
> > > b/drivers/staging/hv/storvsc.c index 06cd327..92b44f4 100644
> > > --- a/drivers/staging/hv/storvsc.c
> > > +++ b/drivers/staging/hv/storvsc.c
> > > @@ -414,6 +414,7 @@ int storvsc_dev_add(struct hv_device *device,
> > >  	device_info->target_id = stor_device->target_id;
> > >
> > >  cleanup:
> > > +	free_stor_device(stor_device);
> > >  	return ret;
> >
> > Was this patch tested? Even the normal path falls through the cleanup
> > label and obviously you should not be freeing the stor_device in that
> > case. I have patches queued up to cleanup some of the unnecessary
> > labels and meaningless return values that I will be sending soon.
> >
> > Regards,
> >
> > K. Y
> >
> >
> >
> 
> Right, I really messed up there, here is how it was supposed to be
> 
> From 5fe8c601bae555b03257d0e7ea57e42a99c5e634 Mon Sep 17 00:00:00 2001
> From: Andre Bartke <andre.bartke@gmail.com>
> Date: Wed, 1 Jun 2011 18:18:58 +0200
> Subject: [PATCH] staging/hv: Fix memory leak of storvsc_dev_add()
> 
> stor_device is not freed in storvsc_dev_add()
> causing a memory leak in case of an allocation error.
> 
> Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
> ---
>  drivers/staging/hv/storvsc.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
> index 06cd327..3d77c82 100644
> --- a/drivers/staging/hv/storvsc.c
> +++ b/drivers/staging/hv/storvsc.c
> @@ -392,10 +392,8 @@ int storvsc_dev_add(struct hv_device *device,
> 
>  	device_info = (struct storvsc_device_info *)additional_info;
>  	stor_device = alloc_stor_device(device);
> -	if (!stor_device) {
> -		ret = -1;
> -		goto cleanup;
> -	}
> +	if (!stor_device)
> +		goto err;
> 
>  	/* Save the channel properties to our storvsc channel */
> 
> @@ -413,6 +411,12 @@ int storvsc_dev_add(struct hv_device *device,
>  	device_info->path_id = stor_device->path_id;
>  	device_info->target_id = stor_device->target_id;
> 
> +	goto cleanup;
> +
> +err:
> +	ret = -1;
> +	free_stor_device(stor_device);
> +
>  cleanup:
>  	return ret;
>  }
> --
> 1.7.5.2
> 
This could be cleaned up much better; we don't need to additional labels. As I said,
earlier, I have patches queued up for this and a whole lot more. I will add your name to
the patch that fixes this issue.

Regards,

K. Y
