Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0IPQHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:07:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0IPQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:07:50 -0400
X-Authority-Analysis: v=1.1 cv=8l6A00wGdfxWf8DimOOtudg6dZOi9rXZmlWhmOLJpog= c=1 sm=0 a=MyfHXT5GpaUA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=dRyNUfIVAE1akBsrmUIA:9 a=mxeHl28Mf2i2LuSbHSAA:7 a=GKCk2wTLM8w0grWQl4DupwQ4NdYA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=MSl-tDqOz04A:10 wl=env:18 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 16 Sep 2010 12:07:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: JosephChan@via.com.tw, ScottFang@viatech.com.cn,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org, stable@kernel.org
Subject: Re: [PATCH] drivers/video/via/ioctl.c: prevent reading
 uninitialized stack memory
Message-ID: <20100916160745.GC14318@home.goodmis.org>
References: <1284587059.6275.101.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284587059.6275.101.camel@dan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 05:44:19PM -0400, Dan Rosenberg wrote:
> The VIAFB_GET_INFO device ioctl allows unprivileged users to read 1968
> bytes of uninitialized stack memory, because the "reserved" member of
> the viafb_ioctl_info struct declared on the stack is not altered or
> zeroed before being copied back to the user.  This patch takes care of
> it.
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> 
> --- linux-2.6.35.4.orig/drivers/video/via/ioctl.c	2010-08-26 19:47:12.000000000 -0400
> +++ linux-2.6.35.4/drivers/video/via/ioctl.c	2010-09-15 11:53:29.997375748 -0400
> @@ -25,6 +25,8 @@ int viafb_ioctl_get_viafb_info(u_long ar
>  {
>  	struct viafb_ioctl_info viainfo;
>  
> +	memset(&viainfo, 0, sizeof(struct viafb_ioctl));
> +

Again, this could probably be better off as:

-  	struct viafb_ioctl_info viainfo;
+  	struct viafb_ioctl_info viainfo = {
+  		.viafb_id = VIAID,
+ 		.vendor_id = PCI_VIA_VENDOR_ID,
+	};

-  	viainfo.viafb_id = VIAID;
-  	viainfo.vendor_id = PCI_VIA_VENDOR_ID;

-- Steve

>  	viainfo.viafb_id = VIAID;
>  	viainfo.vendor_id = PCI_VIA_VENDOR_ID;
>  
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
