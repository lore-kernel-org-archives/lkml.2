Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0DJRA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 13:00:56 -0400
Received: from cnc.isely.net ([64.81.146.143]:43380 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab0DJRAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 13:00:55 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Apr 2010 13:00:55 EDT
Date: Sat, 10 Apr 2010 11:55:35 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: kernel-janitors@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Matthew Garrett <mjg@redhat.com>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org, platform-driver-x86@vger.kernel.org,
       Mike Isely <isely@isely.net>
Subject: Re: [PATCH] device_attributes: add sysfs_attr_init() for dynamic
 attributes
In-Reply-To: <1269238878-991-1-git-send-email-w.sang@pengutronix.de>
Message-ID: <alpine.DEB.1.10.1004101154480.5518@ivanova.isely.net>
References: <1269238878-991-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-By: Mike Isely <isely@pobox.com>

(in the context of the pvrusb2 driver related changes)

  -Mike

On Mon, 22 Mar 2010, Wolfram Sang wrote:

> Made necessary by 6992f5334995af474c2b58d010d08bc597f0f2fe.
> 
> Found by this semantic patch:
> 
> @ init @
> type T;
> identifier A;
> @@
> 
>         T {
>                 ...
>                 struct device_attribute A;
>                 ...
>         };
> 
> @ main extends init @
> expression E;
> statement S;
> identifier err;
> T *name;
> @@
> 
>         ... when != sysfs_attr_init(&name->A.attr);
> (
> +       sysfs_attr_init(&name->A.attr);
>         if (device_create_file(E, &name->A))
>                 S
> |
> +       sysfs_attr_init(&name->A.attr);
>         err = device_create_file(E, &name->A);
> )
> 
> While reviewing, I put the initialization to apropriate places.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Greg KH <gregkh@suse.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Mike Isely <isely@pobox.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Sujith Thomas <sujith.thomas@intel.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> ---
> 
> The thermal-sys.c-part should fix bugs #15548 and #15584.
> 
>  drivers/macintosh/windfarm_core.c           |    1 +
>  drivers/media/video/pvrusb2/pvrusb2-sysfs.c |    8 ++++++++
>  drivers/platform/x86/intel_menlow.c         |    1 +
>  drivers/thermal/thermal_sys.c               |    1 +
>  drivers/video/fsl-diu-fb.c                  |    1 +
>  5 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/macintosh/windfarm_core.c b/drivers/macintosh/windfarm_core.c
> index 419795f..f447642 100644
> --- a/drivers/macintosh/windfarm_core.c
> +++ b/drivers/macintosh/windfarm_core.c
> @@ -209,6 +209,7 @@ int wf_register_control(struct wf_control *new_ct)
>  	kref_init(&new_ct->ref);
>  	list_add(&new_ct->link, &wf_controls);
>  
> +	sysfs_attr_init(&new_ct->attr.attr);
>  	new_ct->attr.attr.name = new_ct->name;
>  	new_ct->attr.attr.mode = 0644;
>  	new_ct->attr.show = wf_show_control;
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
> index 6c23456..71f5056 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
> @@ -423,10 +423,12 @@ static void pvr2_sysfs_add_debugifc(struct pvr2_sysfs *sfp)
>  
>  	dip = kzalloc(sizeof(*dip),GFP_KERNEL);
>  	if (!dip) return;
> +	sysfs_attr_init(&dip->attr_debugcmd.attr);
>  	dip->attr_debugcmd.attr.name = "debugcmd";
>  	dip->attr_debugcmd.attr.mode = S_IRUGO|S_IWUSR|S_IWGRP;
>  	dip->attr_debugcmd.show = debugcmd_show;
>  	dip->attr_debugcmd.store = debugcmd_store;
> +	sysfs_attr_init(&dip->attr_debuginfo.attr);
>  	dip->attr_debuginfo.attr.name = "debuginfo";
>  	dip->attr_debuginfo.attr.mode = S_IRUGO;
>  	dip->attr_debuginfo.show = debuginfo_show;
> @@ -644,6 +646,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
>  		return;
>  	}
>  
> +	sysfs_attr_init(&sfp->attr_v4l_minor_number.attr);
>  	sfp->attr_v4l_minor_number.attr.name = "v4l_minor_number";
>  	sfp->attr_v4l_minor_number.attr.mode = S_IRUGO;
>  	sfp->attr_v4l_minor_number.show = v4l_minor_number_show;
> @@ -658,6 +661,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
>  		sfp->v4l_minor_number_created_ok = !0;
>  	}
>  
> +	sysfs_attr_init(&sfp->attr_v4l_radio_minor_number.attr);
>  	sfp->attr_v4l_radio_minor_number.attr.name = "v4l_radio_minor_number";
>  	sfp->attr_v4l_radio_minor_number.attr.mode = S_IRUGO;
>  	sfp->attr_v4l_radio_minor_number.show = v4l_radio_minor_number_show;
> @@ -672,6 +676,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
>  		sfp->v4l_radio_minor_number_created_ok = !0;
>  	}
>  
> +	sysfs_attr_init(&sfp->attr_unit_number.attr);
>  	sfp->attr_unit_number.attr.name = "unit_number";
>  	sfp->attr_unit_number.attr.mode = S_IRUGO;
>  	sfp->attr_unit_number.show = unit_number_show;
> @@ -685,6 +690,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
>  		sfp->unit_number_created_ok = !0;
>  	}
>  
> +	sysfs_attr_init(&sfp->attr_bus_info.attr);
>  	sfp->attr_bus_info.attr.name = "bus_info_str";
>  	sfp->attr_bus_info.attr.mode = S_IRUGO;
>  	sfp->attr_bus_info.show = bus_info_show;
> @@ -699,6 +705,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
>  		sfp->bus_info_created_ok = !0;
>  	}
>  
> +	sysfs_attr_init(&sfp->attr_hdw_name.attr);
>  	sfp->attr_hdw_name.attr.name = "device_hardware_type";
>  	sfp->attr_hdw_name.attr.mode = S_IRUGO;
>  	sfp->attr_hdw_name.show = hdw_name_show;
> @@ -713,6 +720,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
>  		sfp->hdw_name_created_ok = !0;
>  	}
>  
> +	sysfs_attr_init(&sfp->attr_hdw_desc.attr);
>  	sfp->attr_hdw_desc.attr.name = "device_hardware_description";
>  	sfp->attr_hdw_desc.attr.mode = S_IRUGO;
>  	sfp->attr_hdw_desc.show = hdw_desc_show;
> diff --git a/drivers/platform/x86/intel_menlow.c b/drivers/platform/x86/intel_menlow.c
> index f0a90a6..90ba5d7 100644
> --- a/drivers/platform/x86/intel_menlow.c
> +++ b/drivers/platform/x86/intel_menlow.c
> @@ -396,6 +396,7 @@ static int intel_menlow_add_one_attribute(char *name, int mode, void *show,
>  	if (!attr)
>  		return -ENOMEM;
>  
> +	sysfs_attr_init(&attr->attr.attr); /* That's consistent naming :D */
>  	attr->attr.attr.name = name;
>  	attr->attr.attr.mode = mode;
>  	attr->attr.show = show;
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 5066de5..d4fec47 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -725,6 +725,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  		goto release_idr;
>  
>  	sprintf(dev->attr_name, "cdev%d_trip_point", dev->id);
> +	sysfs_attr_init(&dev->attr.attr);
>  	dev->attr.attr.name = dev->attr_name;
>  	dev->attr.attr.mode = 0444;
>  	dev->attr.show = thermal_cooling_device_trip_point_show;
> diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
> index 4637bcb..994358a 100644
> --- a/drivers/video/fsl-diu-fb.c
> +++ b/drivers/video/fsl-diu-fb.c
> @@ -1536,6 +1536,7 @@ static int __devinit fsl_diu_probe(struct of_device *ofdev,
>  		goto error;
>  	}
>  
> +	sysfs_attr_init(&machine_data->dev_attr.attr);
>  	machine_data->dev_attr.attr.name = "monitor";
>  	machine_data->dev_attr.attr.mode = S_IRUGO|S_IWUSR;
>  	machine_data->dev_attr.show = show_monitor;
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
