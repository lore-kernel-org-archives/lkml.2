Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0IWTXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:23:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756222Ab0IWTXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:23:15 -0400
Date: Thu, 23 Sep 2010 12:23:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: =?ISO-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resent] lis3: Add axes module parameter for custom
 axis-mapping
Message-Id: <20100923122308.49c64e37.akpm@linux-foundation.org>
In-Reply-To: <s5hwrqe816g.wl%tiwai@suse.de>
References: <s5hwrqe816g.wl%tiwai@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 13:31:19 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> The axis-mapping of lis3dev device on many (rather most) HP machines
> doesn't follow the standard.  When each new model appears, users need
> to adjust again.  Testing this requires the rebuild of kernel, thus
> it's not trivial for end-users.
> 
> This patch adds a module parameter "axes" to allow a custom
> axis-mapping without patching and recompiling the kernel driver.
> User can pass the parameter such as axes=3,2,1.  Also it can be
> changed via sysfs.

Is the sysfs interface documented anywhere?

> --- a/drivers/hwmon/hp_accel.c
> +++ b/drivers/hwmon/hp_accel.c
> @@ -146,7 +146,8 @@ int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
>  
>  static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
>  {
> -	lis3_dev.ac = *((struct axis_conversion *)dmi->driver_data);
> +	memcpy(lis3_dev.axis_map, (int *)dmi->driver_data,
> +	       sizeof(lis3_dev.axis_map));

It's unobvious why the (nice) three-member struct was converted to a
(nasty) three-element array?  All those typesafe struct assignments
were turned into non-typesafe memcpys?

> +module_param_array_named(axes, lis3_dev.axis_map, axis, NULL, 0644);

Just to support module_param_array_named()?  If so, could have used a
union?

union axis_conversion {	/* should be called lis3_axis_conversion! */
	struct {
		int x;
		int y;
		int z;
	};
	int as_array[3];
};

or use a tyecast in the module_param_array_named() statement, perhaps?
