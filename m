Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab2IRNQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:16:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44385 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab2IRNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:16:17 -0400
Date: Tue, 18 Sep 2012 16:15:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navinp@cdac.in>
Cc: gregkh@linuxfoundation.org, mfm@muteddisk.com, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of
 usbip_host
Message-ID: <20120918131542.GR13767@mwanda>
References: <1347940806-4653-1-git-send-email-navinp@cdac.in>
 <20120918074053.GL4587@mwanda>
 <CAPV97yda9d6yVbTfmET0Rj+xrRDniKzucfKCy=8gUbCDFYR5jg@mail.gmail.com>
 <20120918093619.GO13767@mwanda>
 <CAPV97yfRd_1Ak+DniNyg+vhg1bkOPqzGwRu-LSKXkpW2=_xw+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPV97yfRd_1Ak+DniNyg+vhg1bkOPqzGwRu-LSKXkpW2=_xw+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 05:14:41PM +0530, navin patidar wrote:
> for usbip_host  event_handler()   handles following events.  defined
> in "usbip_common.h"
> 
>  1. SDEV_EVENT_REMOVED   (USBIP_EH_SHUTDOWN | USBIP_EH_RESET | USBIP_EH_BYE)
>  2. SDEV_EVENT_DOWN		(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
>  3. SDEV_EVENT_ERROR_TCP	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
>  4. SDEV_EVENT_ERROR_SUBMIT	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
>  5. VDEV_EVENT_ERROR_MALLOC (USBIP_EH_SHUTDOWN | USBIP_EH_UNUSABLE)
> 
> In case of events(1,2,3,4),  stub_shoutdown_connection() gets executed
> first and than stub_device_reset() .
> 
> In case of event 5, stub_shoutdown_connection()  kills kernel threads
> and stub_device_unusable()   changes devices status to
> "SDEV_ST_ERROR"(fatal error).
> 

It's case #5 which I would be worried about.  Where did the original
Oops happen?  I feel like it really would be helpful to see it.  I
don't see which check for ->status != SDEV_ST_AVAILABLE you're
talking about here which prevents the pointers from being reused...

>  thus stub_device_reset() can't  be called without
> stub_shutdown_connection(), so there is no problem of resource leak .

Except in the case of #5 obviously.

> you are also right, i could have set pointers to  NULL in
> stub_shutdown_connection() but i used  stub_device_reset() which is
> intended to reset usbip_device stuct member variables.
> 
> i'll resend patches, if maintainer ask for that.
> thanks
> 

Generally, that's normal.  If you want to ensure that a pointer
isn't used again then you clear it immediately.

I'm honestly just trying to figure this out.  When I saw that the
patch, I immediately thought *resource leak*.  I'm sorry that to
take your time up, but it shouldn't be that complicated that I have
to go tracking through the whole driver to understand this.

regards,
dan carpenter
