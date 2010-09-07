Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab0IGJOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:14:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5348 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab0IGJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:14:30 -0400
Date: Tue, 7 Sep 2010 11:14:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Eric Piel <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3: Add axes module parameter for custom axis-mapping
Message-ID: <20100907111415.520aaa24@hyperion.delvare>
In-Reply-To: <s5haanuvypc.wl%tiwai@suse.de>
References: <s5htymla56q.wl%tiwai@suse.de>
	<s5haanuvypc.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Tue, 07 Sep 2010 08:45:35 +0200, Takashi Iwai wrote:
> At Mon, 23 Aug 2010 14:23:25 +0200,
> Takashi Iwai wrote:
> > 
> > The axis-mapping of lis3dev device on many (rather most) HP machines
> > doesn't follow the standard.  When each new model appears, users need
> > to adjust again.  Testing this requires the rebuild of kernel, thus
> > it's not trivial for end-users.
> > 
> > This patch adds a module parameter "axes" to allow a custom
> > axis-mapping without patching and recompiling the kernel driver.
> > User can pass the parameter such as axes=3,2,1.  Also it can be
> > changed via sysfs.
> > 
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> Can anyone review / take this?
> Jean, should it be through hwmon tree? 

Not really. The lis3lv02d driver shouldn't be in the hwmon directory to
start with, its features aren't ones I am familiar with, so it makes
little sense for me to pick patches. Better get it merged by Andrew.

At some point we will really have to move all these accelerometer
drivers to a different directory to avoid the confusion.

> > ---
> >  drivers/hwmon/hp_accel.c  |    5 ++++-
> >  drivers/hwmon/lis3lv02d.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 49 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
> > index 7580f55..3462a5d 100644
> > --- a/drivers/hwmon/hp_accel.c
> > +++ b/drivers/hwmon/hp_accel.c
> > @@ -297,7 +297,10 @@ static int lis3lv02d_add(struct acpi_device *device)
> >  	lis3lv02d_enum_resources(device);
> >  
> >  	/* If possible use a "standard" axes order */
> > -	if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
> > +	if (lis3_dev.ac.x && lis3_dev.ac.y && lis3_dev.ac.z) {
> > +		printk(KERN_INFO DRIVER_NAME ": Using custom axes %d,%d,%d\n",
> > +		       lis3_dev.ac.x, lis3_dev.ac.y, lis3_dev.ac.z);
> > +	} else if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
> >  		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
> >  				 "using default axes configuration\n");
> >  		lis3_dev.ac = lis3lv02d_axis_normal;
> > diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> > index 6138f03..4b179d5 100644
> > --- a/drivers/hwmon/lis3lv02d.c
> > +++ b/drivers/hwmon/lis3lv02d.c
> > @@ -75,6 +75,51 @@ struct lis3lv02d lis3_dev = {
> >  
> >  EXPORT_SYMBOL_GPL(lis3_dev);
> >  
> > +static int axis_array[3];
> > +static void copy_to_axis_array(void)
> > +{
> > +	axis_array[0] = lis3_dev.ac.x;
> > +	axis_array[1] = lis3_dev.ac.y;
> > +	axis_array[2] = lis3_dev.ac.z;
> > +}
> > +
> > +static void copy_from_axis_array(void)
> > +{
> > +	lis3_dev.ac.x = axis_array[0];
> > +	lis3_dev.ac.y = axis_array[1];
> > +	lis3_dev.ac.z = axis_array[2];
> > +}
> > +
> > +static int param_set_axis(const char *val, const struct kernel_param *kp)
> > +{
> > +	int ret;
> > +	copy_to_axis_array();
> > +	ret = param_set_int(val, kp);
> > +	if (!ret) {
> > +		int val = *(int *)kp->arg;
> > +		if (val < 0)
> > +			val = -val;
> > +		if (!val || val > 3)
> > +			return -EINVAL;
> > +		copy_from_axis_array();
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int param_get_axis(char *buffer, const struct kernel_param *kp)
> > +{
> > +	copy_to_axis_array();
> > +	return param_get_int(buffer, kp);
> > +}
> > +
> > +static struct kernel_param_ops param_ops_axis = {
> > +	.set = param_set_axis,
> > +	.get = param_get_axis,
> > +};
> > +
> > +module_param_array_named(axes, axis_array, axis, NULL, 0644);
> > +MODULE_PARM_DESC(axes, "Axis-mapping for x,y,z directions");
> > +
> >  static s16 lis3lv02d_read_8(struct lis3lv02d *lis3, int reg)
> >  {
> >  	s8 lo;

I'm not familiar with kernel_param_ops, but the code looks sane to me.

Reviewed-by: Jean Delvare <khali@linux-fr.org>


-- 
Jean Delvare
