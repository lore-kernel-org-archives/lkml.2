Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1BDXYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 18:24:41 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:47578 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab1BDXYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 18:24:40 -0500
Date: Fri, 4 Feb 2011 15:23:41 -0800
From: Andres Salomon <dilinger@queued.net>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: olpc_dcon: checkpatch.pl fixes for olpc_dcon.c
 file.
Message-ID: <20110204152341.7b869851@debxo>
In-Reply-To: <1296746572-8998-1-git-send-email-marek.belisko@open-nandra.com>
References: <1296746572-8998-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No opinions on this patch (there are some things I'd do differently,
but overall it looks fine).  I'd just like to ensure that if it's
merged, it gets into Linus's tree quickly so that the DCON reworking
that I'm planning to do doesn't get sidetracked by conflicts.



On Thu,  3 Feb 2011 16:22:52 +0100
Marek Belisko <marek.belisko@open-nandra.com> wrote:

> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  drivers/staging/olpc_dcon/olpc_dcon.c |   84
> ++++++++++++++++++--------------- 1 files changed, 46 insertions(+),
> 38 deletions(-)
> 
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c
> b/drivers/staging/olpc_dcon/olpc_dcon.c index 7221bb8..b19cd34 100644
> --- a/drivers/staging/olpc_dcon/olpc_dcon.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon.c
> @@ -24,7 +24,7 @@
>  #include <linux/backlight.h>
>  #include <linux/device.h>
>  #include <linux/notifier.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>  #include <linux/ctype.h>
>  #include <linux/reboot.h>
>  #include <asm/tsc.h>
> @@ -87,14 +87,14 @@ static unsigned short dcon_disp_mode;
>  /* Variables used during switches */
>  static int dcon_switched;
>  static struct timespec dcon_irq_time;
> -static struct timespec dcon_load_time; 
> +static struct timespec dcon_load_time;
>  
>  static DECLARE_WAIT_QUEUE_HEAD(dcon_wait_queue);
>  
>  static unsigned short normal_i2c[] = { 0x0d, I2C_CLIENT_END };
>  
> -#define dcon_write(reg,val)
> i2c_smbus_write_word_data(dcon_client,reg,val) -#define
> dcon_read(reg) i2c_smbus_read_word_data(dcon_client,reg) +#define
> dcon_write(reg, val) i2c_smbus_write_word_data(dcon_client, reg, val)
> +#define dcon_read(reg) i2c_smbus_read_word_data(dcon_client, reg) 
>  /* The current backlight value - this saves us some smbus traffic */
>  static int bl_val = -1;
> @@ -117,7 +117,8 @@ static int dcon_hw_init(struct i2c_client
> *client, int is_init) if (is_init) {
>  		printk(KERN_INFO "olpc-dcon:  Discovered DCON
> version %x\n", ver & 0xFF);
> -		if ((rc = pdata->init()) != 0) {
> +		rc = pdata->init();
> +		if (rc != 0) {
>  			printk(KERN_ERR "olpc-dcon:  Unable to
> init.\n"); goto err;
>  		}
> @@ -133,14 +134,13 @@ static int dcon_hw_init(struct i2c_client
> *client, int is_init) i2c_smbus_write_word_data(client, 0x0b, 0x007a);
>  		i2c_smbus_write_word_data(client, 0x36, 0x025c);
>  		i2c_smbus_write_word_data(client, 0x37, 0x025e);
> -		
> +
>  		/* Initialise SDRAM */
>  
>  		i2c_smbus_write_word_data(client, 0x3b, 0x002b);
>  		i2c_smbus_write_word_data(client, 0x41, 0x0101);
>  		i2c_smbus_write_word_data(client, 0x42, 0x0101);
> -	}
> -	else if (!noinit) {
> +	} else if (!noinit) {
>  		/* SDRAM setup/hold time */
>  		i2c_smbus_write_word_data(client, 0x3a, 0xc040);
>  		i2c_smbus_write_word_data(client, 0x41, 0x0000);
> @@ -181,14 +181,15 @@ static int dcon_bus_stabilize(struct i2c_client
> *client, int is_powered_down) power_up:
>  	if (is_powered_down) {
>  		x = 1;
> -		if ((x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1,
> NULL, 0))) {
> +		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL,
> 0);
> +		if (x) {
>  			printk(KERN_WARNING "olpc-dcon:  unable to
> force dcon " "to power up: %d!\n", x);
>  			return x;
>  		}
>  		msleep(10); /* we'll be conservative */
>  	}
> -	
> +
>  	pdata->bus_stabilize_wiggle();
>  
>  	for (x = -1, timeout = 50; timeout && x < 0; timeout--) {
> @@ -261,8 +262,7 @@ static int dcon_set_output(int arg)
>  	if (arg == DCON_OUTPUT_MONO) {
>  		dcon_disp_mode &= ~(MODE_CSWIZZLE | MODE_COL_AA);
>  		dcon_disp_mode |= MODE_MONO_LUMA;
> -	}
> -	else {
> +	} else {
>  		dcon_disp_mode &= ~(MODE_MONO_LUMA);
>  		dcon_disp_mode |= MODE_CSWIZZLE;
>  		if (useaa)
> @@ -291,18 +291,18 @@ static void dcon_sleep(int state)
>  
>  	if (state == DCON_SLEEP) {
>  		x = 0;
> -		if ((x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1,
> NULL, 0)))
> +		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL,
> 0);
> +		if (x)
>  			printk(KERN_WARNING "olpc-dcon:  unable to
> force dcon " "to power down: %d!\n", x);
>  		else
>  			dcon_sleep_val = state;
> -	}
> -	else {
> +	} else {
>  		/* Only re-enable the backlight if the backlight
> value is set */ if (bl_val != 0)
>  			dcon_disp_mode |= MODE_BL_ENABLE;
> -
> -		if ((x=dcon_bus_stabilize(dcon_client, 1)))
> +		x = dcon_bus_stabilize(dcon_client, 1);
> +		if (x)
>  			printk(KERN_WARNING "olpc-dcon:  unable to
> reinit dcon" " hardware: %d!\n", x);
>  		else
> @@ -316,14 +316,14 @@ static void dcon_sleep(int state)
>  }
>  
>  /* the DCON seems to get confused if we change DCONLOAD too
> - * frequently -- i.e., approximately faster than frame time. 
> + * frequently -- i.e., approximately faster than frame time.
>   * normally we don't change it this fast, so in general we won't
>   * delay here.
>   */
>  void dcon_load_holdoff(void)
>  {
>  	struct timespec delta_t, now;
> -	while(1) {
> +	while (1) {
>  		getnstimeofday(&now);
>  		delta_t = timespec_sub(now, dcon_load_time);
>  		if (delta_t.tv_sec != 0 ||
> @@ -352,10 +352,12 @@ static void dcon_source_switch(struct
> work_struct *work) printk("dcon_source_switch to CPU\n");
>  		/* Enable the scanline interrupt bit */
>  		if (dcon_write(DCON_REG_MODE, dcon_disp_mode |
> MODE_SCAN_INT))
> -			printk(KERN_ERR "olpc-dcon:  couldn't enable
> scanline interrupt!\n");
> +			printk(KERN_ERR
> +			       "olpc-dcon:  couldn't enable scanline
> interrupt!\n"); else {
>  			/* Wait up to one second for the scanline
> interrupt */
> -			wait_event_timeout(dcon_wait_queue,
> dcon_switched == 1, HZ);
> +			wait_event_timeout(dcon_wait_queue,
> +					   dcon_switched == 1, HZ);
>  		}
>  
>  		if (!dcon_switched)
> @@ -396,7 +398,7 @@ static void dcon_source_switch(struct work_struct
> *work) int t;
>  		struct timespec delta_t;
>  
> -		printk("dcon_source_switch to DCON\n");
> +		printk(KERN_INFO "dcon_source_switch to DCON\n");
>  
>  		add_wait_queue(&dcon_wait_queue, &wait);
>  		set_current_state(TASK_UNINTERRUPTIBLE);
> @@ -420,7 +422,7 @@ static void dcon_source_switch(struct work_struct
> *work)
>  			 * the time between asserting DCONLOAD and
> the IRQ --
>  			 * if it's less than 20msec, then the DCON
> couldn't
>  			 * have seen two VSYNC pulses.  in that case
> we
> -			 * deassert and reassert, and hope for the
> best. 
> +			 * deassert and reassert, and hope for the
> best.
>  			 * see http://dev.laptop.org/ticket/9664
>  			 */
>  			delta_t = timespec_sub(dcon_irq_time,
> dcon_load_time); @@ -471,7 +473,8 @@ static void
> dcon_set_source_sync(int arg) flush_scheduled_work();
>  }
>  
> -static int dconbl_set(struct backlight_device *dev) {
> +static int dconbl_set(struct backlight_device *dev)
> +{
>  
>  	int level = dev->props.brightness;
>  
> @@ -482,7 +485,8 @@ static int dconbl_set(struct backlight_device
> *dev) { return 0;
>  }
>  
> -static int dconbl_get(struct backlight_device *dev) {
> +static int dconbl_get(struct backlight_device *dev)
> +{
>  	return dcon_get_backlight();
>  }
>  
> @@ -521,7 +525,7 @@ static int _strtoul(const char *buf, int len,
> unsigned int *val) {
>  
>  	char *endp;
> -	unsigned int output = simple_strtoul(buf, &endp, 0);
> +	unsigned int output = strict_strtoul(buf, &endp, 0);
>  	int size = endp - buf;
>  
>  	if (*endp && isspace(*endp))
> @@ -559,7 +563,7 @@ static ssize_t dcon_freeze_store(struct device
> *dev, if (_strtoul(buf, count, &output))
>  		return -EINVAL;
>  
> -	printk("dcon_freeze_store: %d\n", output);
> +	printk(KERN_INFO "dcon_freeze_store: %d\n", output);
>  
>  	switch (output) {
>  	case 0:
> @@ -568,7 +572,7 @@ static ssize_t dcon_freeze_store(struct device
> *dev, case 1:
>  		dcon_set_source_sync(DCON_SOURCE_DCON);
>  		break;
> -	case 2:  // normally unused
> +	case 2:  /* normally unused */
>  		dcon_set_source(DCON_SOURCE_DCON);
>  		break;
>  	default:
> @@ -620,7 +624,8 @@ static const struct backlight_ops dcon_bl_ops = {
>  };
>  
>  
> -static int dcon_reboot_notify(struct notifier_block *nb, unsigned
> long foo, void *bar) +static int dcon_reboot_notify(struct
> notifier_block *nb,
> +			      unsigned long foo, void *bar)
>  {
>  	if (dcon_client == NULL)
>  		return 0;
> @@ -636,7 +641,8 @@ static struct notifier_block dcon_nb = {
>  	.priority = -1,
>  };
>  
> -static int unfreeze_on_panic(struct notifier_block *nb, unsigned
> long e, void *p) +static int unfreeze_on_panic(struct notifier_block
> *nb,
> +			     unsigned long e, void *p)
>  {
>  	pdata->set_dconload(1);
>  	return NOTIFY_DONE;
> @@ -650,7 +656,8 @@ static struct notifier_block dcon_panic_nb = {
>   * When the framebuffer sleeps due to external sources (e.g. user
> idle), power
>   * down the DCON as well.  Power it back up when the fb comes back
> to life. */
> -static int fb_notifier_callback(struct notifier_block *self,
> unsigned long event, void *data) +static int
> fb_notifier_callback(struct notifier_block *self,
> +				unsigned long event, void *data)
>  {
>  	struct fb_event *evdata = data;
>  	int *blank = (int *) evdata->data;
> @@ -688,19 +695,20 @@ static int dcon_probe(struct i2c_client
> *client, const struct i2c_device_id *id) dcon_device =
> platform_device_alloc("dcon", -1); 
>  	if (dcon_device == NULL) {
> -		printk("dcon:  Unable to create the DCON device\n");
> +		printk(KERN_ERR "dcon:  Unable to create the DCON
> device\n"); rc = -ENOMEM;
>  		goto eirq;
>  	}
>  	/* Place holder...*/
>  	i2c_set_clientdata(client, dcon_device);
> +	rc = platform_device_add(dcon_device);
>  
> -	if ((rc = platform_device_add(dcon_device))) {
> -		printk("dcon:  Unable to add the DCON device\n");
> +	if (rc) {
> +		printk(KERN_ERR "dcon:  Unable to add the DCON
> device\n"); goto edev;
>  	}
>  
> -	for(i = 0; i < ARRAY_SIZE(dcon_device_files); i++) {
> +	for (i = 0; i < ARRAY_SIZE(dcon_device_files); i++) {
>  		rc = device_create_file(&dcon_device->dev,
>  					&dcon_device_files[i]);
>  		if (rc) {
> @@ -717,10 +725,10 @@ static int dcon_probe(struct i2c_client
> *client, const struct i2c_device_id *id) NULL, &dcon_bl_ops, NULL);
>  
>  	if (IS_ERR(dcon_bl_dev)) {
> -		printk("Could not register the backlight device for
> the DCON (%ld)\n", PTR_ERR(dcon_bl_dev));
> +		printk(KERN_ERR "Cannot register the backlight
> device (%ld)\n",
> +		       PTR_ERR(dcon_bl_dev));
>  		dcon_bl_dev = NULL;
> -	}
> -	else {
> +	} else {
>  		dcon_bl_dev->props.max_brightness = 15;
>  		dcon_bl_dev->props.power = FB_BLANK_UNBLANK;
>  		dcon_bl_dev->props.brightness = dcon_get_backlight();

