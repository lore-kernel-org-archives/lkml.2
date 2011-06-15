Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1FOMzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 08:55:00 -0400
Received: from d1.icnet.pl ([212.160.220.21]:50414 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab1FOMy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:54:59 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: balbi@ti.com
Subject: Re: [PATCH 3.0-rc2] OMAP: ams-delta: fix broken uevent sysfs entries
Date: Wed, 15 Jun 2011 14:53:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; i686; ; )
Cc: Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201106070316.41099.jkrzyszt@tis.icnet.pl> <20110614114848.GS3352@atomide.com> <20110614115959.GI2353@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110614115959.GI2353@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201106151453.07945.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14 Jun 2011 at 14:00:00 Felipe Balbi wrote:
> On Tue, Jun 14, 2011 at 04:48:48AM -0700, Tony Lindgren wrote:
> > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [110606 18:15]:
> > > Removing __initdata tags, introduced by commit
> > > bdc58fb950a3a1b0bc3cbd8e23d21ecdde2ac9a2, "arm: omap1: fix a
> > > bunch of section mismatches", from corresponding platform_device
> > > structures declared in arch/arm/mach-omap1/board-ams-delta.c,
> > > corrects the problem for me, which may indicate that their
> > > members (.name ?) are still referred to during runtime so they
> > > shouldn't be freed after boot.
> > 
> > Sounds like this needs a bit more research where this initdata
> > gets used?

Not that I didn't do any research before, now I think that not only 
platform_device.name is required. See below.

> to me it sounds like missing __init/__exit annotations on the driver.
> See ams-delta-leds for instance:
> 
> static int ams_delta_led_probe(struct platform_device *pdev)
> static int ams_delta_led_remove(struct platform_device *pdev)
> 
> which means those drivers will have probe sitting outside or
> .init.text and trying to reference name which sits in .init.text ???
> Could that be the case here ?

Missing or not, addig them didn't help.

> But it could also be that the platform_device shouldn't be marked
> __initdata.

After either reverting one of commits mentioned, or applying my patch, 
a read from /sys/devices/platform/ams-delta-led/uevent, for example, 
returns:

DRIVER=ams-delta-led
MODALIAS=platform:ams-delta-led

The code responsible for returning these strings can be found in 
drivers/base/core.c:

static int dev_uevent(struct kset *kset, struct kobject *kobj,
		struct kobj_uevent_env *env)
{
	struct device *dev = to_dev(kobj);
...
	if (dev->driver)
		add_uevent_var(env, "DRIVER=%s", dev->driver->name);

	/* have the bus specific function add its stuff */
	if (dev->bus && dev->bus->uevent) {
                retval = dev->bus->uevent(dev, env);
...

The dev->bus->uevent for a platform device happens to sit in 
drivers/base/platform.c:

static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
{
	struct platform_device  *pdev = to_platform_device(dev);
...
	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
...

For me, it looks like struct kobject, pointed to by kobj, being a member 
of struct device, which in turn happens to be a member of struct 
platform_device.

AFAICU, there exist two sorts of platform devices from memory allocation 
point of view: those created with platform_device_alloc(), which 
allocates a memory where struct platform_device is kept, and those 
created with platfrom_device_add(), which is provided with a pointer to 
an already allocated platform device structure.

I can't find any piece of code which makes a copy of a platfrom deivce 
structure content pointed to while platform_device_add() is called from 
a board or machine file, either directly or indirectly via 
platform_device_register() or platform_add_devices().
Why should it be actually copied after all?.

Searching for an example usage of _initdata similiar to that introduced 
by commit bdc58fb950a3a1b0bc3cbd8e23d21ecdde2ac9a2, "arm: omap1: fix a 
bunch of section mismatches", I can find the following:

$ grep -r "struct .* platform_device .* = {" .|grep "__initdata"|grep -v '*'
./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams_delta_kp_device __initdata = {
./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams_delta_lcd_device __initdata = {
./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams_delta_led_device __initdata = {
./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams_delta_camera_device __initdata = {
./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_mpu_gpio = {
./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio1 = {
./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio2 = {
./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio3 = {
./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio4 = {
./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio5 = {
./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio6 = {
./arch/arm/mach-omap1/gpio15xx.c:static struct __initdata platform_device omap15xx_mpu_gpio = {
./arch/arm/mach-omap1/gpio15xx.c:static struct __initdata platform_device omap15xx_gpio = {
./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device omap16xx_mpu_gpio = {
./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device omap16xx_gpio1 = {
./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device omap16xx_gpio2 = {
./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device omap16xx_gpio3 = {
./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device omap16xx_gpio4 = {
./arch/arm/mach-omap2/board-rx51-peripherals.c:static struct platform_device rx51_si4713_dev __initdata_or_module = {

So, there is no single exact pattern found in the whole tree, and a few 
instances of similiar patterns of two kinds found only inside omap. If I 
follow any of the two, either moving '__initdata' in front of 
'platform_device' or using '__initdata_or_module' instead, the problem 
no longer hits me (using my custom defconfig). However, the former seems 
not conformant to what one can learn from include/linux/init.h, so I 
suspect that placing __initdata like this can be a noop, while the 
latter means "can be init if no module support", which would probably 
still exhibit the problem if so configured.

How would you like to have this corrected then?

Thanks,
Janusz
