Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0ISQr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 12:47:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39116 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754925Ab0ISQr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 12:47:26 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19kdUc7K/xktXV+Lqg6lYfAsFEAi13xwg3w+WAiv2
	UHLnCXkpsqfL8R
Message-ID: <4C963E99.9080207@gmx.de>
Date: Sun, 19 Sep 2010 18:47:21 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
References: <20100919172833.14bf291e@neptune.home>
In-Reply-To: <20100919172833.14bf291e@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bruno Prémont schrieb:
> For USB-attached (or other hot-(un)pluggable) framebuffers the current
> fbdev infrastructure is not very helpful. Each such driver currently
> needs to perform the ref-counting on its own in .fbops.fb_open and
> .fbops.fb_release callbacks.

I agree. This is a great idea even for non-hot-(un)pluggable framebuffers.

> This patch moves the ref-counting in fbdev infrastructure.
> (drivers have not been adjusted, all those releasing fb_info in
>  .fbops.fb_destroy will not work -- patch for those will follow
>  later on, all the others will continue to work fine)
> 
> API-wise the following changes are done:
> - num_registered_fb and registered_fb variables are no more exported.
>   New functions fb_get_registered() and fb_is_registered() replace
>   them.
>   The only know user of those was fbcon, thus the large diff on fbcon.c
> 
>   Note: the accesses to registered_fb and num_registered_fb look racy
>   as there was not protection at all around them, potentially letting
>   register_framebuffer() register two framebuffers on the same minor
>   concurrently, fbcon access should have been safe by combination of
>   its use of console_semaphore and reaction to events.
>   In this patch I combined most of fbcon's accesses to registered_fb
>   and num_registered_fb into fb_is_registered(), though I'm not sure
>   if the num-check optimization is worth to keep or its check should
>   be put into a separate function.
> 
> - framebuffer_release() is mapped to fb_put() but will go away
>   when converting drivers
> 
> Reference count for fb_info can be increased with fb_get(fb_info) and
> later released with fb_put(fb_info).
> 
> 
> If you have concerns regarding the API changes, please let me know.

Uhm, I'm not really happy with what we count. With the old method you mentioned 
we ref-counted framebuffer users, after your patch it's more counting users + 
uses. This might be okay as we usually are interested whether the ref_count is 0 
or not but it doesn't look right if we modify the refcount during nearly every 
framebuffer operation. Wouldn't it be sufficient to do the refcounting in 
fb_open & fb_release operation + in fbcon where open&release are done?

> diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
> index 0a08f13..be5f342 100644
> --- a/drivers/video/fbsysfs.c
> +++ b/drivers/video/fbsysfs.c
> @@ -58,6 +58,7 @@ struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
>  		info->par = p + fb_info_size;
>  
>  	info->device = dev;
> +	kref_init(&info->refcount);

As far as I know there exist framebuffer drivers which do not call 
framebuffer_alloc but contain their own fb_info. I guess these would be broken 
as well.


Thanks,

Florian Tobias Schandinat
