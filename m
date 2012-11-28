Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2K1UAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:00:43 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44362 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754448Ab2K1UAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:00:41 -0500
Date: Wed, 28 Nov 2012 22:00:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v3 9/9] davinci: vpfe: Add documentation and TODO
Message-ID: <20121128200034.GF31879@valkosipuli.retiisi.org.uk>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
 <1354099329-20722-10-git-send-email-prabhakar.lad@ti.com>
 <20121128092213.4bd0870f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128092213.4bd0870f@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Wed, Nov 28, 2012 at 09:22:13AM -0200, Mauro Carvalho Chehab wrote:
> Hi Prabhakar,
> 
> Em Wed, 28 Nov 2012 16:12:09 +0530
> Prabhakar Lad <prabhakar.csengg@gmail.com> escreveu:
> 
> > +Introduction
> > +============
> > +
> > +This file documents the Texas Instruments Davinci Video processing Front End
> > +(VPFE) driver located under drivers/media/platform/davinci. The original driver
> > +exists for Davinci VPFE, which is now being changed to Media Controller
> > +Framework.
> 
> Hmm... please correct me if I'm wrong, but are you wanting to replace an existing
> driver at drivers/media/platform/davinci, by another one at staging that has
> lots of known issues, as pointed at your TODO????

This driver going to staging is not going to replace anything as such.

The reason to put the driver to staging is simply that it'd be part of the
kernel source so people can use it effortlessly, just as any other driver
that's in staging. If you compare this to them, I think you will find it for
this driver's favour. Reading the Barcelona mini-summit report, isn't the
only requirement for staging drivers that they compile? I think this driver
passes that requiremnt with flying colours.

The driver that's currently in drivers/media/platform/davinci is a) serves a
small subset of potential use cases and b) lacks most features the hardware
can offer. This new driver that's intended for staging, is more generic,
feature-rich and supports standard APIs such as V4L2 subdev and Media
controller which the old driver does not do at all.

The TODO file exists to document what needs to be done to this driver to get
it out of staging. After this is done, its APIs and functionality is similar
to that offered by the OMAP 3 ISP driver.

> If so, please don't do that. Replacing a driver by some other one is generally
> a very bad idea, especially in this case, where the new driver has clearly several
> issues, the main one being to define its own proprietary and undocumented API:

What's currently is in mainline more closely resembles what the OMAP 3 ISP
driver used to be in the end of 2008. The code quality is better and it
contains less hacks, but still that is the case. At the time me and Laurent
decided that we didn't want to push it to staging, but instead continue
developing it out-of-tree.

> > +As of now since the interface will undergo few changes all the include
> > +files are present in staging itself, to build for dm365 follow below steps,
> > +
> > +- copy vpfe.h from drivers/staging/media/davinci_vpfe/ to
> > +  include/media/davinci/ folder for building the uImage.
> > +- copy davinci_vpfe_user.h from drivers/staging/media/davinci_vpfe/ to
> > +  include/uapi/linux/davinci_vpfe.h, and add a entry in Kbuild (required
> > +  for building application).
> > +- copy dm365_ipipeif_user.h from drivers/staging/media/davinci_vpfe/ to
> > +  include/uapi/linux/dm365_ipipeif.h and a entry in Kbuild (required
> > +  for building application).
> 
> Among other things, with those ugly and very likely mandatory API calls:
> 
> >+/*
> >+ * Private IOCTL
> >+ * VIDIOC_VPFE_IPIPEIF_S_CONFIG: Set IPIEIF configuration
> >+ * VIDIOC_VPFE_IPIPEIF_G_CONFIG: Get IPIEIF configuration
> >+ */
> >+#define VIDIOC_VPFE_IPIPEIF_S_CONFIG \
> >+	_IOWR('I', BASE_VIDIOC_PRIVATE + 1, struct ipipeif_params)
> >+#define VIDIOC_VPFE_IPIPEIF_G_CONFIG \
> >+	_IOWR('I', BASE_VIDIOC_PRIVATE + 2, struct ipipeif_params)
> >+
> >+#endif	
> 
> I remember we rejected already drivers like that with obscure "S_CONFIG"
> private ioctl that were suspect to send a big initialization undocumented
> blob to the driver, as only the vendor's application would be able to use
> such driver.

We know this is bad, and it's not going to stay. Improving the user space
API is mentioned in the TODO file. Also, much of this configuration is for
parts that weren't supported by the old driver to begin with.

> So, instead, of submitting it to staging, you should be sending incremental
> patches for the existing driver, adding newer functionality there, and 
> using the proper V4L2 API, with makes life easier for reviewers and
> application developers.

If you're looking to see API compatibility between the two, you will not be
able to get it: the old driver simply implements a different profile (which
should be defined but that's a separate issue). This is a new driver and
deserves to be treated that way.

If someone depends on the old driver currently, we should keep that old
driver in the tree and eventually remove it once users have moved to use the
new one. That requires resolving the issues listed in the TODO file and
accepting the driver as part of the media tree.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
