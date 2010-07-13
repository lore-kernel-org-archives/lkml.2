Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0GMOJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:09:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44467 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756774Ab0GMOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:09:22 -0400
Date: Tue, 13 Jul 2010 10:09:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: storage: optional SCSI WRITE FUA bit
In-Reply-To: <1279010209-31337-1-git-send-email-ext-andriy.shevchenko@nokia.com>
Message-ID: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Andy Shevchenko wrote:

> MS Windows mounts removable storage in "Removal optimized mode" by
> default. All the writes to the media are synchronous which is achieved
> by setting FUA (Force Unit Access) bit in SCSI WRITE(10,12) commands.
> This prevents I/O requests aggregation in block layer dramatically
> decreasing performance.
> 
> This patch brings an option to accept or ignore mentioned bit
>  a) via specifying module parameter "fua", or
>  b) through sysfs entry
> 	/sys/devices/platform/musb_hdrc/gadget/gadget-lun-N/fua

...

> @@ -111,11 +113,11 @@
>   *					PAGE_CACHE_SIZE)
>   *
>   * If CONFIG_USB_FILE_STORAGE_TEST is not set, only the "file", "ro",
> - * "removable", "luns", "stall", and "cdrom" options are available; default
> + * "removable", "luns", "fua", "stall", and "cdrom" options are available; default
>   * values are used for everything else.
>   *
>   * The pathnames of the backing files and the ro settings are available in
> - * the attribute files "file" and "ro" in the lun<n> subdirectory of the
> + * the attribute files "file", "fua", and "ro" in the lun<n> subdirectory of the
>   * gadget's sysfs directory.  If the "removable" option is set, writing to
>   * these files will simulate ejecting/loading the medium (writing an empty
>   * line means eject) and adjusting a write-enable tab.  Changes to the ro

Please do not create lines longer than 80 columns.  Reflow the text.

> @@ -307,6 +309,7 @@ static struct {
>  
>  	int		removable;
>  	int		can_stall;
> +	int		fua;
>  	int		cdrom;
>  
>  	char		*transport_parm;
> @@ -326,6 +329,7 @@ static struct {
>  	.protocol_parm		= "SCSI",
>  	.removable		= 0,
>  	.can_stall		= 1,
> +	.fua			= 1,
>  	.cdrom			= 0,
>  	.vendor			= FSG_VENDOR_ID,
>  	.product		= FSG_PRODUCT_ID,
> @@ -350,6 +354,9 @@ MODULE_PARM_DESC(removable, "true to simulate removable media");
>  module_param_named(stall, mod_data.can_stall, bool, S_IRUGO);
>  MODULE_PARM_DESC(stall, "false to prevent bulk stalls");
>  
> +module_param_named(fua, mod_data.fua, bool, S_IRUGO);
> +MODULE_PARM_DESC(fua, "true to obey SCSI WRITE(6,10,12) FUA bit");
> +
>  module_param_named(cdrom, mod_data.cdrom, bool, S_IRUGO);
>  MODULE_PARM_DESC(cdrom, "true to emulate cdrom instead of disk");

This implementation is wrong.  If "fua" is supposed to be per-lun 
then the module parameter needs to accept an array of values, like the 
"file" and "ro" parameters.

Alan Stern

