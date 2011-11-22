Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1KVWgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:36:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab1KVWg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:36:27 -0500
Date: Tue, 22 Nov 2011 14:18:39 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] samsung-laptop: put all local variables in a
 single structure
Message-ID: <20111122221839.GC24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
 <1321999366-23784-2-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321999366-23784-2-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:02:32PM +0100, Corentin Chary wrote:
> Even if this driver can only be loaded once, it is still a good
> idea to create some kind of context structure.
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>


> ---
>  drivers/platform/x86/samsung-laptop.c |  291 +++++++++++++++++++--------------
>  1 files changed, 170 insertions(+), 121 deletions(-)
> 
> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
> index 09e26bf..c502252 100644
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -217,16 +217,23 @@ static const struct sabi_config sabi_configs[] = {
>  	{ },
>  };
>  
> -static const struct sabi_config *sabi_config;
> +struct samsung_laptop {
> +	const struct sabi_config *config;
>  
> -static void __iomem *sabi;
> -static void __iomem *sabi_iface;
> -static void __iomem *f0000_segment;
> -static struct backlight_device *backlight_device;
> -static struct mutex sabi_mutex;
> -static struct platform_device *sdev;
> -static struct rfkill *rfk;
> -static bool has_stepping_quirk;
> +	void __iomem *sabi;
> +	void __iomem *sabi_iface;
> +	void __iomem *f0000_segment;
> +
> +	struct mutex sabi_mutex;
> +
> +	struct platform_device *pdev;
> +	struct backlight_device *backlight_device;
> +	struct rfkill *rfk;
> +
> +	bool has_stepping_quirk;
> +};
> +
> +static struct samsung_laptop *samsung;
>  
>  static int force;
>  module_param(force, bool, 0);
> @@ -239,27 +246,28 @@ MODULE_PARM_DESC(debug, "Debug enabled or not");
>  
>  static int sabi_get_command(u8 command, struct sabi_retval *sretval)
>  {
> +	const struct sabi_config *config = samsung->config;
>  	int retval = 0;
> -	u16 port = readw(sabi + sabi_config->header_offsets.port);
> +	u16 port = readw(samsung->sabi + config->header_offsets.port);
>  	u8 complete, iface_data;
>  
> -	mutex_lock(&sabi_mutex);
> +	mutex_lock(&samsung->sabi_mutex);
>  
>  	/* enable memory to be able to write to it */
> -	outb(readb(sabi + sabi_config->header_offsets.en_mem), port);
> +	outb(readb(samsung->sabi + config->header_offsets.en_mem), port);
>  
>  	/* write out the command */
> -	writew(sabi_config->main_function, sabi_iface + SABI_IFACE_MAIN);
> -	writew(command, sabi_iface + SABI_IFACE_SUB);
> -	writeb(0, sabi_iface + SABI_IFACE_COMPLETE);
> -	outb(readb(sabi + sabi_config->header_offsets.iface_func), port);
> +	writew(config->main_function, samsung->sabi_iface + SABI_IFACE_MAIN);
> +	writew(command, samsung->sabi_iface + SABI_IFACE_SUB);
> +	writeb(0, samsung->sabi_iface + SABI_IFACE_COMPLETE);
> +	outb(readb(samsung->sabi + config->header_offsets.iface_func), port);
>  
>  	/* write protect memory to make it safe */
> -	outb(readb(sabi + sabi_config->header_offsets.re_mem), port);
> +	outb(readb(samsung->sabi + config->header_offsets.re_mem), port);
>  
>  	/* see if the command actually succeeded */
> -	complete = readb(sabi_iface + SABI_IFACE_COMPLETE);
> -	iface_data = readb(sabi_iface + SABI_IFACE_DATA);
> +	complete = readb(samsung->sabi_iface + SABI_IFACE_COMPLETE);
> +	iface_data = readb(samsung->sabi_iface + SABI_IFACE_DATA);
>  	if (complete != 0xaa || iface_data == 0xff) {
>  		pr_warn("SABI get command 0x%02x failed with completion flag 0x%02x and data 0x%02x\n",
>  		        command, complete, iface_data);
> @@ -272,107 +280,112 @@ static int sabi_get_command(u8 command, struct sabi_retval *sretval)
>  	 * There are commands that need more, but not for the ones we
>  	 * currently care about.
>  	 */
> -	sretval->retval[0] = readb(sabi_iface + SABI_IFACE_DATA);
> -	sretval->retval[1] = readb(sabi_iface + SABI_IFACE_DATA + 1);
> -	sretval->retval[2] = readb(sabi_iface + SABI_IFACE_DATA + 2);
> -	sretval->retval[3] = readb(sabi_iface + SABI_IFACE_DATA + 3);
> +	sretval->retval[0] = readb(samsung->sabi_iface + SABI_IFACE_DATA);
> +	sretval->retval[1] = readb(samsung->sabi_iface + SABI_IFACE_DATA + 1);
> +	sretval->retval[2] = readb(samsung->sabi_iface + SABI_IFACE_DATA + 2);
> +	sretval->retval[3] = readb(samsung->sabi_iface + SABI_IFACE_DATA + 3);
>  
>  exit:
> -	mutex_unlock(&sabi_mutex);
> +	mutex_unlock(&samsung->sabi_mutex);
>  	return retval;
>  
>  }
>  
>  static int sabi_set_command(u8 command, u8 data)
>  {
> +	const struct sabi_config *config = samsung->config;
>  	int retval = 0;
> -	u16 port = readw(sabi + sabi_config->header_offsets.port);
> +	u16 port = readw(samsung->sabi + config->header_offsets.port);
>  	u8 complete, iface_data;
>  
> -	mutex_lock(&sabi_mutex);
> +	mutex_lock(&samsung->sabi_mutex);
>  
>  	/* enable memory to be able to write to it */
> -	outb(readb(sabi + sabi_config->header_offsets.en_mem), port);
> +	outb(readb(samsung->sabi + config->header_offsets.en_mem), port);
>  
>  	/* write out the command */
> -	writew(sabi_config->main_function, sabi_iface + SABI_IFACE_MAIN);
> -	writew(command, sabi_iface + SABI_IFACE_SUB);
> -	writeb(0, sabi_iface + SABI_IFACE_COMPLETE);
> -	writeb(data, sabi_iface + SABI_IFACE_DATA);
> -	outb(readb(sabi + sabi_config->header_offsets.iface_func), port);
> +	writew(config->main_function, samsung->sabi_iface + SABI_IFACE_MAIN);
> +	writew(command, samsung->sabi_iface + SABI_IFACE_SUB);
> +	writeb(0, samsung->sabi_iface + SABI_IFACE_COMPLETE);
> +	writeb(data, samsung->sabi_iface + SABI_IFACE_DATA);
> +	outb(readb(samsung->sabi + config->header_offsets.iface_func), port);
>  
>  	/* write protect memory to make it safe */
> -	outb(readb(sabi + sabi_config->header_offsets.re_mem), port);
> +	outb(readb(samsung->sabi + config->header_offsets.re_mem), port);
>  
>  	/* see if the command actually succeeded */
> -	complete = readb(sabi_iface + SABI_IFACE_COMPLETE);
> -	iface_data = readb(sabi_iface + SABI_IFACE_DATA);
> +	complete = readb(samsung->sabi_iface + SABI_IFACE_COMPLETE);
> +	iface_data = readb(samsung->sabi_iface + SABI_IFACE_DATA);
>  	if (complete != 0xaa || iface_data == 0xff) {
>  		pr_warn("SABI set command 0x%02x failed with completion flag 0x%02x and data 0x%02x\n",
>  		       command, complete, iface_data);
>  		retval = -EINVAL;
>  	}
>  
> -	mutex_unlock(&sabi_mutex);
> +	mutex_unlock(&samsung->sabi_mutex);
>  	return retval;
>  }
>  
>  static void test_backlight(void)
>  {
> +	const struct sabi_commands *commands = &samsung->config->commands;
>  	struct sabi_retval sretval;
>  
> -	sabi_get_command(sabi_config->commands.get_backlight, &sretval);
> +	sabi_get_command(commands->get_backlight, &sretval);
>  	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.retval[0]);
>  
> -	sabi_set_command(sabi_config->commands.set_backlight, 0);
> +	sabi_set_command(commands->set_backlight, 0);
>  	printk(KERN_DEBUG "backlight should be off\n");
>  
> -	sabi_get_command(sabi_config->commands.get_backlight, &sretval);
> +	sabi_get_command(commands->get_backlight, &sretval);
>  	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.retval[0]);
>  
>  	msleep(1000);
>  
> -	sabi_set_command(sabi_config->commands.set_backlight, 1);
> +	sabi_set_command(commands->set_backlight, 1);
>  	printk(KERN_DEBUG "backlight should be on\n");
>  
> -	sabi_get_command(sabi_config->commands.get_backlight, &sretval);
> +	sabi_get_command(commands->get_backlight, &sretval);
>  	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.retval[0]);
>  }
>  
>  static void test_wireless(void)
>  {
> +	const struct sabi_commands *commands = &samsung->config->commands;
>  	struct sabi_retval sretval;
>  
> -	sabi_get_command(sabi_config->commands.get_wireless_button, &sretval);
> +	sabi_get_command(commands->get_wireless_button, &sretval);
>  	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.retval[0]);
>  
> -	sabi_set_command(sabi_config->commands.set_wireless_button, 0);
> +	sabi_set_command(commands->set_wireless_button, 0);
>  	printk(KERN_DEBUG "wireless led should be off\n");
>  
> -	sabi_get_command(sabi_config->commands.get_wireless_button, &sretval);
> +	sabi_get_command(commands->get_wireless_button, &sretval);
>  	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.retval[0]);
>  
>  	msleep(1000);
>  
> -	sabi_set_command(sabi_config->commands.set_wireless_button, 1);
> +	sabi_set_command(commands->set_wireless_button, 1);
>  	printk(KERN_DEBUG "wireless led should be on\n");
>  
> -	sabi_get_command(sabi_config->commands.get_wireless_button, &sretval);
> +	sabi_get_command(commands->get_wireless_button, &sretval);
>  	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.retval[0]);
>  }
>  
>  static u8 read_brightness(void)
>  {
> +	const struct sabi_config *config = samsung->config;
> +	const struct sabi_commands *commands = &samsung->config->commands;
>  	struct sabi_retval sretval;
>  	int user_brightness = 0;
>  	int retval;
>  
> -	retval = sabi_get_command(sabi_config->commands.get_brightness,
> +	retval = sabi_get_command(commands->get_brightness,
>  				  &sretval);
>  	if (!retval) {
>  		user_brightness = sretval.retval[0];
> -		if (user_brightness > sabi_config->min_brightness)
> -			user_brightness -= sabi_config->min_brightness;
> +		if (user_brightness > config->min_brightness)
> +			user_brightness -= config->min_brightness;
>  		else
>  			user_brightness = 0;
>  	}
> @@ -381,9 +394,11 @@ static u8 read_brightness(void)
>  
>  static void set_brightness(u8 user_brightness)
>  {
> -	u8 user_level = user_brightness + sabi_config->min_brightness;
> +	const struct sabi_config *config = samsung->config;
> +	const struct sabi_commands *commands = &samsung->config->commands;
> +	u8 user_level = user_brightness + config->min_brightness;
>  
> -	if (has_stepping_quirk && user_level != 0) {
> +	if (samsung->has_stepping_quirk && user_level != 0) {
>  		/*
>  		 * short circuit if the specified level is what's already set
>  		 * to prevent the screen from flickering needlessly
> @@ -391,10 +406,10 @@ static void set_brightness(u8 user_brightness)
>  		if (user_brightness == read_brightness())
>  			return;
>  
> -		sabi_set_command(sabi_config->commands.set_brightness, 0);
> +		sabi_set_command(commands->set_brightness, 0);
>  	}
>  
> -	sabi_set_command(sabi_config->commands.set_brightness, user_level);
> +	sabi_set_command(commands->set_brightness, user_level);
>  }
>  
>  static int get_brightness(struct backlight_device *bd)
> @@ -425,11 +440,11 @@ static void check_for_stepping_quirk(void)
>  	else
>  		check_level = initial_level - 2;
>  
> -	has_stepping_quirk = false;
> +	samsung->has_stepping_quirk = false;
>  	set_brightness(check_level);
>  
>  	if (read_brightness() != check_level) {
> -		has_stepping_quirk = true;
> +		samsung->has_stepping_quirk = true;
>  		pr_info("enabled workaround for brightness stepping quirk\n");
>  	}
>  
> @@ -438,12 +453,14 @@ static void check_for_stepping_quirk(void)
>  
>  static int update_status(struct backlight_device *bd)
>  {
> +	const struct sabi_commands *commands = &samsung->config->commands;
> +
>  	set_brightness(bd->props.brightness);
>  
>  	if (bd->props.power == FB_BLANK_UNBLANK)
> -		sabi_set_command(sabi_config->commands.set_backlight, 1);
> +		sabi_set_command(commands->set_backlight, 1);
>  	else
> -		sabi_set_command(sabi_config->commands.set_backlight, 0);
> +		sabi_set_command(commands->set_backlight, 0);
>  	return 0;
>  }
>  
> @@ -454,15 +471,17 @@ static const struct backlight_ops backlight_ops = {
>  
>  static int rfkill_set(void *data, bool blocked)
>  {
> +	const struct sabi_commands *commands = &samsung->config->commands;
> +
>  	/* Do something with blocked...*/
>  	/*
>  	 * blocked == false is on
>  	 * blocked == true is off
>  	 */
>  	if (blocked)
> -		sabi_set_command(sabi_config->commands.set_wireless_button, 0);
> +		sabi_set_command(commands->set_wireless_button, 0);
>  	else
> -		sabi_set_command(sabi_config->commands.set_wireless_button, 1);
> +		sabi_set_command(commands->set_wireless_button, 1);
>  
>  	return 0;
>  }
> @@ -471,18 +490,18 @@ static struct rfkill_ops rfkill_ops = {
>  	.set_block = rfkill_set,
>  };
>  
> -static int init_wireless(struct platform_device *sdev)
> +static int init_wireless(struct platform_device *pdev)
>  {
>  	int retval;
>  
> -	rfk = rfkill_alloc("samsung-wifi", &sdev->dev, RFKILL_TYPE_WLAN,
> -			   &rfkill_ops, NULL);
> -	if (!rfk)
> +	samsung->rfk = rfkill_alloc("samsung-wifi", &samsung->pdev->dev, RFKILL_TYPE_WLAN,
> +				    &rfkill_ops, NULL);
> +	if (!samsung->rfk)
>  		return -ENOMEM;
>  
> -	retval = rfkill_register(rfk);
> +	retval = rfkill_register(samsung->rfk);
>  	if (retval) {
> -		rfkill_destroy(rfk);
> +		rfkill_destroy(samsung->rfk);
>  		return -ENODEV;
>  	}
>  
> @@ -491,27 +510,28 @@ static int init_wireless(struct platform_device *sdev)
>  
>  static void destroy_wireless(void)
>  {
> -	rfkill_unregister(rfk);
> -	rfkill_destroy(rfk);
> +	rfkill_unregister(samsung->rfk);
> +	rfkill_destroy(samsung->rfk);
>  }
>  
>  static ssize_t get_performance_level(struct device *dev,
>  				     struct device_attribute *attr, char *buf)
>  {
> +	const struct sabi_config *config = samsung->config;
>  	struct sabi_retval sretval;
>  	int retval;
>  	int i;
>  
>  	/* Read the state */
> -	retval = sabi_get_command(sabi_config->commands.get_performance_level,
> +	retval = sabi_get_command(config->commands.get_performance_level,
>  				  &sretval);
>  	if (retval)
>  		return retval;
>  
>  	/* The logic is backwards, yeah, lots of fun... */
> -	for (i = 0; sabi_config->performance_levels[i].name; ++i) {
> -		if (sretval.retval[0] == sabi_config->performance_levels[i].value)
> -			return sprintf(buf, "%s\n", sabi_config->performance_levels[i].name);
> +	for (i = 0; config->performance_levels[i].name; ++i) {
> +		if (sretval.retval[0] == config->performance_levels[i].value)
> +			return sprintf(buf, "%s\n", config->performance_levels[i].name);
>  	}
>  	return sprintf(buf, "%s\n", "unknown");
>  }
> @@ -520,18 +540,20 @@ static ssize_t set_performance_level(struct device *dev,
>  				struct device_attribute *attr, const char *buf,
>  				size_t count)
>  {
> +	const struct sabi_config *config = samsung->config;
> +
>  	if (count >= 1) {
>  		int i;
> -		for (i = 0; sabi_config->performance_levels[i].name; ++i) {
> +		for (i = 0; config->performance_levels[i].name; ++i) {
>  			const struct sabi_performance_level *level =
> -				&sabi_config->performance_levels[i];
> +				&config->performance_levels[i];
>  			if (!strncasecmp(level->name, buf, strlen(level->name))) {
> -				sabi_set_command(sabi_config->commands.set_performance_level,
> +				sabi_set_command(config->commands.set_performance_level,
>  						 level->value);
>  				break;
>  			}
>  		}
> -		if (!sabi_config->performance_levels[i].name)
> +		if (!config->performance_levels[i].name)
>  			return -EINVAL;
>  	}
>  	return count;
> @@ -805,6 +827,9 @@ static int find_signature(void __iomem *memcheck, const char *testStr)
>  
>  static int __init samsung_init(void)
>  {
> +	const struct sabi_config *config = NULL;
> +	const struct sabi_commands *commands;
> +	struct backlight_device *bd;
>  	struct backlight_properties props;
>  	struct sabi_retval sretval;
>  	unsigned int ifaceP;
> @@ -812,21 +837,26 @@ static int __init samsung_init(void)
>  	int loca;
>  	int retval;
>  
> -	mutex_init(&sabi_mutex);
> -
>  	if (!force && !dmi_check_system(samsung_dmi_table))
>  		return -ENODEV;
>  
> -	f0000_segment = ioremap_nocache(0xf0000, 0xffff);
> -	if (!f0000_segment) {
> +	samsung = kzalloc(sizeof(*samsung), GFP_KERNEL);
> +	if (!samsung)
> +		return -ENOMEM;
> +
> +	mutex_init(&samsung->sabi_mutex);
> +
> +	samsung->f0000_segment = ioremap_nocache(0xf0000, 0xffff);
> +	if (!samsung->f0000_segment) {
>  		pr_err("Can't map the segment at 0xf0000\n");
> -		return -EINVAL;
> +		goto error_cant_map;
>  	}
>  
>  	/* Try to find one of the signatures in memory to find the header */
>  	for (i = 0; sabi_configs[i].test_string != 0; ++i) {
> -		sabi_config = &sabi_configs[i];
> -		loca = find_signature(f0000_segment, sabi_config->test_string);
> +		samsung->config = &sabi_configs[i];
> +		loca = find_signature(samsung->f0000_segment,
> +				      samsung->config->test_string);
>  		if (loca != 0xffff)
>  			break;
>  	}
> @@ -836,51 +866,60 @@ static int __init samsung_init(void)
>  		goto error_no_signature;
>  	}
>  
> +	config = samsung->config;
> +	commands = &config->commands;
> +
>  	/* point to the SMI port Number */
>  	loca += 1;
> -	sabi = (f0000_segment + loca);
> +	samsung->sabi = (samsung->f0000_segment + loca);
>  
>  	if (debug) {
>  		printk(KERN_DEBUG "This computer supports SABI==%x\n",
>  			loca + 0xf0000 - 6);
>  		printk(KERN_DEBUG "SABI header:\n");
>  		printk(KERN_DEBUG " SMI Port Number = 0x%04x\n",
> -			readw(sabi + sabi_config->header_offsets.port));
> +		       readw(samsung->sabi +
> +			     config->header_offsets.port));
>  		printk(KERN_DEBUG " SMI Interface Function = 0x%02x\n",
> -			readb(sabi + sabi_config->header_offsets.iface_func));
> +		       readb(samsung->sabi +
> +			     config->header_offsets.iface_func));
>  		printk(KERN_DEBUG " SMI enable memory buffer = 0x%02x\n",
> -			readb(sabi + sabi_config->header_offsets.en_mem));
> +		       readb(samsung->sabi +
> +			     config->header_offsets.en_mem));
>  		printk(KERN_DEBUG " SMI restore memory buffer = 0x%02x\n",
> -			readb(sabi + sabi_config->header_offsets.re_mem));
> +		       readb(samsung->sabi +
> +			     config->header_offsets.re_mem));
>  		printk(KERN_DEBUG " SABI data offset = 0x%04x\n",
> -			readw(sabi + sabi_config->header_offsets.data_offset));
> +		       readw(samsung->sabi +
> +			     config->header_offsets.data_offset));
>  		printk(KERN_DEBUG " SABI data segment = 0x%04x\n",
> -			readw(sabi + sabi_config->header_offsets.data_segment));
> +		       readw(samsung->sabi +
> +			     config->header_offsets.data_segment));
>  	}
>  
>  	/* Get a pointer to the SABI Interface */
> -	ifaceP = (readw(sabi + sabi_config->header_offsets.data_segment) & 0x0ffff) << 4;
> -	ifaceP += readw(sabi + sabi_config->header_offsets.data_offset) & 0x0ffff;
> -	sabi_iface = ioremap_nocache(ifaceP, 16);
> -	if (!sabi_iface) {
> +	ifaceP = (readw(samsung->sabi + config->header_offsets.data_segment) & 0x0ffff) << 4;
> +	ifaceP += readw(samsung->sabi + config->header_offsets.data_offset) & 0x0ffff;
> +	samsung->sabi_iface = ioremap_nocache(ifaceP, 16);
> +	if (!samsung->sabi_iface) {
>  		pr_err("Can't remap %x\n", ifaceP);
>  		goto error_no_signature;
>  	}
>  	if (debug) {
>  		printk(KERN_DEBUG "ifaceP = 0x%08x\n", ifaceP);
> -		printk(KERN_DEBUG "sabi_iface = %p\n", sabi_iface);
> +		printk(KERN_DEBUG "sabi_iface = %p\n", samsung->sabi_iface);
>  
>  		test_backlight();
>  		test_wireless();
>  
> -		retval = sabi_get_command(sabi_config->commands.get_brightness,
> +		retval = sabi_get_command(commands->get_brightness,
>  					  &sretval);
>  		printk(KERN_DEBUG "brightness = 0x%02x\n", sretval.retval[0]);
>  	}
>  
>  	/* Turn on "Linux" mode in the BIOS */
> -	if (sabi_config->commands.set_linux != 0xff) {
> -		retval = sabi_set_command(sabi_config->commands.set_linux,
> +	if (commands->set_linux != 0xff) {
> +		retval = sabi_set_command(commands->set_linux,
>  					  0x81);
>  		if (retval) {
>  			pr_warn("Linux mode was not set!\n");
> @@ -892,30 +931,32 @@ static int __init samsung_init(void)
>  	check_for_stepping_quirk();
>  
>  	/* knock up a platform device to hang stuff off of */
> -	sdev = platform_device_register_simple("samsung", -1, NULL, 0);
> -	if (IS_ERR(sdev))
> +	samsung->pdev = platform_device_register_simple("samsung", -1, NULL, 0);
> +	if (IS_ERR(samsung->pdev))
>  		goto error_no_platform;
>  
>  	/* create a backlight device to talk to this one */
>  	memset(&props, 0, sizeof(struct backlight_properties));
>  	props.type = BACKLIGHT_PLATFORM;
> -	props.max_brightness = sabi_config->max_brightness -
> -				sabi_config->min_brightness;
> -	backlight_device = backlight_device_register("samsung", &sdev->dev,
> -						     NULL, &backlight_ops,
> -						     &props);
> -	if (IS_ERR(backlight_device))
> +	props.max_brightness = config->max_brightness -
> +				config->min_brightness;
> +	bd = backlight_device_register("samsung", &samsung->pdev->dev,
> +				       NULL, &backlight_ops,
> +				       &props);
> +	if (IS_ERR(bd))
>  		goto error_no_backlight;
>  
> -	backlight_device->props.brightness = read_brightness();
> -	backlight_device->props.power = FB_BLANK_UNBLANK;
> -	backlight_update_status(backlight_device);
> +	samsung->backlight_device = bd;
> +	samsung->backlight_device->props.brightness = read_brightness();
> +	samsung->backlight_device->props.power = FB_BLANK_UNBLANK;
> +	backlight_update_status(samsung->backlight_device);
>  
> -	retval = init_wireless(sdev);
> +	retval = init_wireless(samsung->pdev);
>  	if (retval)
>  		goto error_no_rfk;
>  
> -	retval = device_create_file(&sdev->dev, &dev_attr_performance_level);
> +	retval = device_create_file(&samsung->pdev->dev,
> +				    &dev_attr_performance_level);
>  	if (retval)
>  		goto error_file_create;
>  
> @@ -925,31 +966,39 @@ error_file_create:
>  	destroy_wireless();
>  
>  error_no_rfk:
> -	backlight_device_unregister(backlight_device);
> +	backlight_device_unregister(samsung->backlight_device);
>  
>  error_no_backlight:
> -	platform_device_unregister(sdev);
> +	platform_device_unregister(samsung->pdev);
>  
>  error_no_platform:
> -	iounmap(sabi_iface);
> +	iounmap(samsung->sabi_iface);
>  
>  error_no_signature:
> -	iounmap(f0000_segment);
> +	iounmap(samsung->f0000_segment);
> +
> +error_cant_map:
> +	kfree(samsung);
> +	samsung = NULL;
>  	return -EINVAL;
>  }
>  
>  static void __exit samsung_exit(void)
>  {
> +	const struct sabi_commands *commands = &samsung->config->commands;
> +
>  	/* Turn off "Linux" mode in the BIOS */
> -	if (sabi_config->commands.set_linux != 0xff)
> -		sabi_set_command(sabi_config->commands.set_linux, 0x80);
> +	if (commands->set_linux != 0xff)
> +		sabi_set_command(commands->set_linux, 0x80);
>  
> -	device_remove_file(&sdev->dev, &dev_attr_performance_level);
> -	backlight_device_unregister(backlight_device);
> +	device_remove_file(&samsung->pdev->dev, &dev_attr_performance_level);
> +	backlight_device_unregister(samsung->backlight_device);
>  	destroy_wireless();
> -	iounmap(sabi_iface);
> -	iounmap(f0000_segment);
> -	platform_device_unregister(sdev);
> +	iounmap(samsung->sabi_iface);
> +	iounmap(samsung->f0000_segment);
> +	platform_device_unregister(samsung->pdev);
> +	kfree(samsung);
> +	samsung = NULL;
>  }
>  
>  module_init(samsung_init);
> -- 
> 1.7.5.4
