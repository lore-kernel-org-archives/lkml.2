Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab1BYNQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 08:16:42 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:49012 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab1BYNQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 08:16:40 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D67ABD4.1020007@cam.ac.uk>
Date: Fri, 25 Feb 2011 13:17:08 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Jon Brenner <jbrenner@TAOSinc.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH: 2.6.37 1/1] TAOS 258x: Device Driver
References: <1298596149.2200.50.camel@jonz-ubuntu> <4D679AFE.3000002@cam.ac.uk>
In-Reply-To: <4D679AFE.3000002@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/11 12:05, Jonathan Cameron wrote:
> 
> Lots of cc's added. Note that a driver like this that touches a number
> of subsystems needs to also go to their individual mailing lists as
> not everyone monitors lkml very closely.
> 
>> From: J. August Brenner <jbrenner@taosinc.com>
>>
Hi Jon,

Various comments inline.  Note quite a few are general patch submission
issues that imply you haven't read the stuff on submitting patches under
Documenation in the kernel tree.  Please do so. Lots of trivial cleanup
needed as well. In particular please check your comments....

There's quite a bit here, so I'd imagine we'll need to go through a couple
of iterations.  Please look at a few other in kernel drivers.  Tsl2563 is
reasonably clean and will show what we would normally expect wrt to i2c
registration etc.  There is one registered in arch/arm/mach-pxa/imote2.c 
that should show how the board file should interact with the device
driver.

>> This driver supports the TAOS tsl258x family of ALS sensors.
>> This driver provides ALS data (lux), and device configuration via ioctl,
>> input_event, sysfs/iio methods.  These methods are provided to support
>> varied access requirements and integrated into a single driver.
I'll be interested to hear what other peoples view is on this...

Even if the rest is fine, that IOCTL interface indicates to me that
there are defficiencies in the other interfaces (i.e. they don't support
something you need in their interfaces). If that is the case please
identify what additions are needed to them rather than providing yet
another control method.

Thus, a fair bit to do to clean this driver up, but it's a good
start and it will be good to expand a range of als drivers in tree.

Thanks,

Jonathan

>> Thus, adverting the need for multiple releases of similar code.
>> More significantly, this driver provides the capability to be fed 'glass
>> coefficients' to accommodate varying system designs (bezels, faceplates,
>> etc.).
>>
>> Signed-off-by: Jon August Brenner <jbrenner@taosinc.com>
>>
Please add stats (--with-stats for git format-patch).  Gives an idea
of where things are to everyone.
>> ---
>> diff -Naurp drivers-orig/Kconfig drivers/Kconfig
>> --- drivers-orig/Kconfig	2011-01-04 18:50:19.000000000 -0600
>> +++ drivers/Kconfig	2011-02-24 16:03:53.536188000 -0600
Diffs should be wrt to whole kernel tree rather than somewhere inside it.
Makes them easier to apply.  I'm guessing this in drivers/staging/iio/light
given the other stuff present but that isn't clear from the patch.
>> @@ -13,6 +13,13 @@ config SENSORS_TSL2563
>>  	 This driver can also be built as a module.  If so, the module
>>  	 will be called tsl2563.
>>  
>> +config TAOS_258x
>> +	tristate "TAOS TSL258x device driver"
>> +	default m
>> +	help
>> +	  Provides support for the TAOS tsl258x family of devices.
>> +	  Access ALS data via iio, sysfs, input_event, and ioctl methods.
>> +
>>  config SENSORS_ISL29018
>>          tristate "ISL 29018 light and proximity sensor"
>>          depends on I2C
>> diff -Naurp drivers-orig/Makefile drivers/Makefile
>> --- drivers-orig/Makefile	2011-01-04 18:50:19.000000000 -0600
>> +++ drivers/Makefile	2011-02-24 16:04:31.701642000 -0600
>> @@ -3,4 +3,5 @@
>>  #
>>  
>>  obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
>> +obj-$(CONFIG_TAOS_258x)	+= tsl258x.o
>>  obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
>> diff -Naurp drivers-orig/tsl258x.c drivers/tsl258x.c
>> --- drivers-orig/tsl258x.c	1969-12-31 18:00:00.000000000 -0600
>> +++ drivers/tsl258x.c	2011-02-24 14:07:43.416960000 -0600
>> @@ -0,0 +1,2055 @@
>> +/*
>> + * Device driver for monitoring ambient light intensity (lux)
>> + * within the TAOS tsl258x family of devices
>> + *
>> + * Copyright (c) 2011, TAOS Corporation.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
>> or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>> License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> along
>> + * with this program; if not, write to the Free Software Foundation,
>> Inc.,
>> + * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
>> + */
>> +
>> +#include <linux/mutex.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/wait.h>
>> +#include <linux/kernel.h>
>> +#include <linux/fs.h>
>> +#include <linux/cdev.h>
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/slab.h>
>> +#include <linux/i2c.h>
>> +#include <linux/hwmon.h>
>> +#include <linux/timer.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/errno.h>
>> +#include <linux/delay.h>
>> +#include <linux/irq.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/gpio.h>
>> +#include <linux/proc_fs.h>
>> +#include <linux/ioport.h>
>> +#include <linux/serial_core.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/firmware.h>
>> +#include <linux/string.h>
>> +#include <linux/kmod.h>
>> +#include <linux/ctype.h>
>> +#include <linux/input.h>
>> +#include <linux/time.h>
>> +#include <linux/jiffies.h>

That's an awful lot of headers. I can't see any use of ioport.h for
starters. Please verify which ones are actually needed and get rid
of the rest.
>> +#include "../iio.h"
>> +
Comment lines like this just tend to break up the code without adding anything.
Probably best to clean them out.
>> +/*........................................................................*/
>> +#define DRIVER_VERSION_ID	"3.9"
The problem with having version numbers in driver is that they tend not to be
kept up to date.  Once a driver merges it's api is maintained pretty much for
ever anyway.  I guess this is because you have legacy userspace code to support?
>> +
Err. This is one of the stranger defines I've seen. Definitely needs explanation
if you keep it!
>> +#define TAOS258x		2
>> +
>> +/* This build will be for..*/
>> +#define DRIVER_TYPE		TAOS258x
Mysterious and seems to be unusued. Please get rid of this.
>> +
>> +/*........................................................................*/
>> +/*Debug related*/
Please use standard kernel interfaces for debugging log messages etc.
This approach obviously makes a log of sense when developing drivers, but
for something that is going for a merge they need to go away.
>> +#define TAOS_DEBUG			1
>> +/*#define TAOS_DEBUG_SMBUS		1	*/
>> +#define TAOS_IRQ_DEBUG			1
>> +/*........................................................................*/
>> +/*User notification method*/
>> +/*#define ASYNC_NOTIFY			1	*/
>> +#define EVENT_NOTIFY			1
>> +/*........................................................................*/
>> +/*Module defines*/
>> +/* Device name/id/address */
I've litle idea what is going on here, but I doubt this makes sense in a
driver submitted for mainline inclusion...

>> +#define DEVICE_NAME			"taos"
That's hardly an informative name for the device...  Seeing
as it's fixed (I think) please also encode a better name directly
where it is used.
>> +#ifdef TAOS258x
>> +#define DEVICE_ID			"skateFN"
>> +#else
>> +#define DEVICE_ID			"tritonFN"
>> +#endif
>> +
>> +#define ID_NAME_SIZE			10
>> +#define DEVICE_ADDR1			0x29
>> +#define DEVICE_ADDR2			0x39
>> +#define DEVICE_ADDR3			0x49
>> +#define MAX_NUM_DEVICES			3
>> +#define MAX_DEVICE_REGS			32
>> +#define I2C_MAX_ADAPTERS		8
Does this driver include both the taos and an i2c adapter for it?
If so they should be separate drivers....
>> +
>> +/* Triton register offsets */
>> +#ifdef TAOS258x
>> +#define	TAOS_REG_MAX	8
>> +#else
>> +#define	TAOS_REG_MAX	16
>> +#endif
>> +
Don't define these if you aren't going to have any implementation.
>> +/* Power management */
>> +#define taos_suspend			NULL
>> +#define taos_shutdown			NULL
>> +#define taos_resume			NULL
>> +
Never do this...  It just obscures what is going on for
no benefit.
>> +#define TRUE				1
>> +#define FALSE				0
>> +

No idea what this is, so probably needs a more descriptive
name.
>> +#define	MAXI2C	32

None of these are used so get rid of them.
>> +#define	CMD_ADDRESS	0x80
>> +#define	TAOS_ERROR	-1
>> +#define TAOS_SUCCESS	0
>> +
>> +#define	MAX_SAMPLES_CAL	200
>> +

Somewhat cryptic...
>> +#define LUX_UPDATE_PERIOD	(HZ/2)
>> +
On is clearly 1 and off clearly 0 so don't do this.
>> +/* power control */
>> +#define ON              1
>> +#define OFF		0
>> +
>> +
>> +/* sensor type */
add a prefix to these names to avoid possible clashes.
>> +#define LIGHT		1
>> +#define PROXIMITY	2
>> +#define ALL			3
>> +
>> +struct taos_als_info {
>> +	u16 als_ch0;
>> +	u16 als_ch1;
>> +	u16 lux;
>> +};
>> +
>> +struct taos_settings {
>> +	int	als_time;
>> +	int	als_gain;
>> +	int	als_gain_trim;
>> +	int	als_cal_target;
>> +	int	interrupts_enabled;

Odd spacing issue here, please make it consistent.
>> +	int als_thresh_low;
>> +	int als_thresh_high;
>> +	char als_persistence;
>> +};
>> +
As stated above.  The need for this interface implies deficiencies
in the other subystems. Lets fix them rather than having this ioctl
stuff working around them...
>> +/* ioctl numbers */
>> +#define TAOS_IOCTL_MAGIC		0XCF
>> +#define TAOS_IOCTL_ALS_ON		_IO(TAOS_IOCTL_MAGIC,  1)
>> +#define TAOS_IOCTL_ALS_OFF		_IO(TAOS_IOCTL_MAGIC,  2)
>> +#define TAOS_IOCTL_ALS_DATA		_IOR(TAOS_IOCTL_MAGIC, 3, short)
>> +#define TAOS_IOCTL_ALS_CALIBRATE	_IO(TAOS_IOCTL_MAGIC,  4)
>> +#define TAOS_IOCTL_CONFIG_GET		_IOR(TAOS_IOCTL_MAGIC, 5,\
>> +		struct taos_settings)
>> +#define TAOS_IOCTL_CONFIG_SET		_IOW(TAOS_IOCTL_MAGIC, 6, \
>> +		struct taos_settings)
>> +#define TAOS_IOCTL_LUX_TABLE_GET	_IOR(TAOS_IOCTL_MAGIC, 7, \
>> +		struct taos_lux)
>> +#define TAOS_IOCTL_LUX_TABLE_SET	_IOW(TAOS_IOCTL_MAGIC, 8, \
>> +		struct taos_lux)
>> +#define TAOS_IOCTL_ID			_IOR(TAOS_IOCTL_MAGIC, 12, char*)
>> +#define TAOS_IOCTL_SET_GAIN		_IOW(TAOS_IOCTL_MAGIC, 15, int)
>> +#define TAOS_IOCTL_GET_ALS		_IOR(TAOS_IOCTL_MAGIC, 16, \
>> +		struct taos_als_info)
>> +#define TAOS_IOCTL_INT_SET		_IOW(TAOS_IOCTL_MAGIC, 17, int)
>> +

Better to name these all with a PREFIX of say TAOS_258X as then
you avoid any accidental name clashes...
>> +/*Device Registers and Masks*/
>> +#define CNTRL				0x00
>> +#define STATUS				0x00
>> +#define ALS_TIME			0X01
>> +#define INTERRUPT			0x02
>> +#define ALS_MINTHRESHLO		0X03
>> +#define ALS_MINTHRESHHI		0X04
>> +#define ALS_MAXTHRESHLO		0X05
>> +#define ALS_MAXTHRESHHI		0X06
>> +#define GAIN				0x07
>> +#define REVID				0x11
>> +#define CHIPID				0x12
>> +#define SMB_4				0x13
>> +#define ALS_CHAN0LO			0x14
>> +#define ALS_CHAN0HI			0x15
>> +#define ALS_CHAN1LO			0x16
>> +#define ALS_CHAN1HI			0x17
>> +#define TMR_LO				0x18
>> +#define TMR_HI				0x19
>> +
>> +/* Skate cmd reg masks */
>> +#define CMD_REG				0x80
>> +#define CMD_BYTE_RW			0x00
>> +#define CMD_WORD_BLK_RW		0x20
>> +#define CMD_SPL_FN			0x60
>> +#define CMD_ALS_INTCLR		0X01
>> +
>> +/* Skate cntrl reg masks */
>> +#define CNTL_REG_CLEAR		0x00
>> +#define CNTL_ALS_INT_ENBL	0x10
>> +#define CNTL_WAIT_TMR_ENBL	0x08
>> +#define CNTL_ADC_ENBL		0x02
>> +#define CNTL_PWRON			0x01
>> +#define CNTL_ALSPON_ENBL	0x03
>> +#define CNTL_INTALSPON_ENBL	0x13
>> +
>> +/* Skate status reg masks */
>> +#define STA_ADCVALID		0x01
>> +#define STA_ALSINTR			0x10
>> +#define STA_ADCINTR			0x10
>> +
>> +/* Lux constants */
>> +#define	MAX_LUX				65535
>> +
>> +/* Thresholds */
>> +#define ALS_THRESHOLD_LO_LIMIT		0x0010
>> +#define ALS_THRESHOLD_HI_LIMIT		0xFFFF
>> +
>> +/* Device default configuration */
>> +#define ALS_TIME_PARAM			100
>> +#define SCALE_FACTOR_PARAM		1
>> +#define GAIN_TRIM_PARAM			512
>> +#define GAIN_PARAM			1
>> +#define ALS_THRSH_HI_PARAM		0xFFFF
>> +#define ALS_THRSH_LO_PARAM		0
>> +
>> +
>> +/* Prototypes */
>> +static void taos_defaults(void);
>> +static int taos_chip_on(void);
>> +static int taos_chip_off(void);
>> +static int taos_get_lux(void);
>> +
>> +struct i2c_adapter *i2c_get_adapter(int id);
>> +
>> +static int taos_probe(struct i2c_client *clientp,
>> +    const struct i2c_device_id *idp);
>> +static int taos_remove(struct i2c_client *client);
>> +static int taos_open(struct inode *inode, struct file *file);
>> +static int taos_release(struct inode *inode, struct file *file);
>> +static int taos_ioctl(struct inode *inode, struct file *file, unsigned
>> int cmd,
>> +    unsigned long arg);
>> +static int taos_read(struct file *file, char *buf, size_t count, loff_t
>> *ppos);
>> +static int taos_write(struct file *file, const char *buf, size_t count,
>> +    loff_t *ppos);
>> +static loff_t taos_llseek(struct file *file, loff_t offset, int orig);
>> +static int taos_fasync(int fd, struct file *file, int mode);
>> +static int taos_device_name(unsigned char *bufp, char **device_name);
>> +static int taos_als_calibrate(unsigned long als_cal_target);
>> +static void taos_als_auto_update(struct work_struct *update);
Could avoid most of this by a spot of reordering of the code. Only have function
prototypes if you absolutely need them. It just makes code reading a tiny
bit harder.


>> +
>> +/*........................................................................*/
>> +/* Various /misc. emun*/
>> +enum {
>> +	TAOS_CHIP_UNKNOWN = 0, TAOS_CHIP_WORKING = 1, TAOS_CHIP_SLEEP = 2
>> +} TAOS_CHIP_WORKING_STATUS;
>> +
>> +/*........................................................................*/
>> +
As stated above, you'll need to justify this thoroughly or get rid of it.
Version numbers almost always rot as people don't remember to update them.

>> +char driver_version_id[] = DRIVER_VERSION_ID;
>> +
>> +/*........................................................................*/
>> +
>> +/* First device number */
>> +static dev_t taos_dev_number;
>> +
>> +/* Class structure for this device */
>> +static struct class *taos_class;
>> +
>> +/* Module device table */
>> +static struct i2c_device_id taos_idtable[] = {
>> +	{ DEVICE_ID, 0 },
>> +	{ } };
>> +MODULE_DEVICE_TABLE(i2c, taos_idtable);
>> +
>> +/* Board and address info */
>> +static struct i2c_board_info taos_board_info[] = {
>> +	{ I2C_BOARD_INFO(DEVICE_ID, DEVICE_ADDR1), },
>> +	{ I2C_BOARD_INFO(DEVICE_ID, DEVICE_ADDR2), },
>> +	{ I2C_BOARD_INFO(DEVICE_ID, DEVICE_ADDR3), }, };
>> +
So you have the board info inside the driver?  Please explain.
The driver should handle the device alone, not any information
on a particular implementation on a particular i2c bus...

>> +static unsigned short const taos_addr_list[4] = {
>> +	DEVICE_ADDR1,
>> +	DEVICE_ADDR2,
>> +    DEVICE_ADDR3,
>> +    I2C_CLIENT_END };
>> +
>> +/* Client and device */
>> +static struct i2c_client *client;
>> +static struct device *devp;
>> +static struct i2c_client *bad_clientp[MAX_NUM_DEVICES];
>> +static int device_found;
>> +
>> +/* Driver definition */
>> +static struct i2c_driver taos_driver = {
>> +	.driver = {
>> +	.owner = THIS_MODULE,
>> +    .name = DEVICE_NAME, },
>> +    .id_table = taos_idtable,
>> +    .probe = taos_probe,
>> +    .remove = __devexit_p(taos_remove),
>> +    .suspend = taos_suspend,
>> +    .shutdown = taos_shutdown,
>> +    .resume = taos_resume, };
>> +
>> +/* Per-device data */
>> +static struct tsl258x_chip {
>> +	struct i2c_client *client;
>> +	struct iio_dev *iio_dev;
>> +	struct delayed_work update_lux;
>> +	struct work_struct work_thresh;
>> +	s64 event_timestamp;
>> +	struct cdev cdev;
>> +	struct fasync_struct *async_queue;
>> +	unsigned int addr;
>> +	char taos_id;
>> +	char taos_name[ID_NAME_SIZE];
>> +	char valid;
>> +	unsigned long last_updated;
>> +
>> +} *chip;
>> +
>> +/* File operations */
>> +static const struct file_operations taos_fops = {
>> +	.owner = THIS_MODULE,
>> +	.open =	taos_open,
>> +	.release = taos_release,
>> +	.read = taos_read,
>> +	.write = taos_write,
>> +	.llseek = taos_llseek,
>> +	.fasync = taos_fasync,
>> +	.ioctl = taos_ioctl, };
>> +
>> +/* ................ Als info ..................*/
>> +struct taos_als_info als_cur_info;
>> +EXPORT_SYMBOL(als_cur_info);
>> +
>> +/*Next two vars are also used to determine irq type - in lieu status
>> info*/
>> +bool als_on = FALSE;
>> +
What are these doing global within the driver?
>> +static int device_released = 0x0000;
>> +static unsigned int irqnum = 0x0000;
>> +static DECLARE_WAIT_QUEUE_HEAD(taos_int_wait);
>> +
>> +/* Lux time scale */
>> +struct time_scale_factor {
>> +	unsigned int numerator;
>> +	unsigned int denominator;
>> +	unsigned int saturation;
>> +};
>> +
That name is almost guaranteed to clash at some point!
Why not put this in your nice tsl258x_chip structure above?
>> +/* ------ Mutex ------*/
>> +DEFINE_MUTEX(als_mutex);
>> +
>> +/*Structs & vars*/
>> +int taos_chip_status = TAOS_CHIP_UNKNOWN; /*Unknown = uninitialized to
>> start*/
>> +int taos_cycle_type; /* what is the type of cycle being run: ALS, PROX,
>> or BOTH
>> + */
>> +struct taos_settings taos_settings;
>> +EXPORT_SYMBOL(taos_settings);
This seems to restrict you to only one such sensor....
>> +
>> +/* Device configuration */
>> +#define MAX_SETTING_MEMBERS	6
Unused...

>> +static struct taos_settings *taos_settingsP; /*Pointer Needed for
>> ioctl(s)*/
>> +
>> +/*More Prototypes*/
>> +static int taos_i2c_read(u8 reg, u8 *val, unsigned int len);
>> +static int taos_i2c_write(u8 reg, u8 *val);
>> +static int taos_i2c_write_command(u8 reg);
Bit of code reordering an you won't need these.
>> +
>> +/*   Work Queues used for bottom halves of self poll/push & IRQs  */
>> +static struct workqueue_struct *taos_wq0;
Should be in an instance specific structure (along with a lot
of other stuff that I haven't commented on).  A driver should
allow for multiple taos258x chips wired to a given machine.
>> +
>> +struct delayed_work *luxUd;
>> +/*........................................................................*/
>> +/*
>> + Initial values for device - this values can/will be changed by driver.
>> + and applications as needed.
>> + These values are dynamic.
>> + */
>> +u8 taos_config[8] = { 0x00, 0xee, 0x00, 0x03, 0x00, 0xFF, 0xFF, 0x00 };
>> +/*	                  cntrl atime intC  Athl0 Athl1 Athh0 Athh1 gain*/
static const please
>> +
>> +/*
>> + This structure is intentionally large to accommodate updates via
>> + ioctl and proc input methods.
>> + */
>> +struct taos_lux {
>> +	unsigned int ratio;
>> +	unsigned int ch0;
>> +	unsigned int ch1;
Can just define the size and specify
initial elements. c99 means the rest will be
zero initialized anyway iirc.
>> +} taos_device_lux[] = {
>> +	{ 9830, 8520, 15729 },
>> +	{ 12452, 10807, 23344 },
>> +	{14746, 6383, 11705 },
>> +	{ 17695, 4063, 6554 },
>> +	{ 0, 0, 0 },
>> +	{ 0, 0, 0 },
>> +	{ 0, 0, 0 },
>> +	{ 0, 0, 0 },
>> +	{ 0, 0, 0 },
>> +	{ 0, 0, 0 },
>> +	{ 0, 0, 0 } };
>> +
>> +struct taos_lux taos_lux;
>> +EXPORT_SYMBOL(taos_lux);
Why export?  Who else needs to know?
>> +
>> +int als_time_scale; /*computed, ratios lux due to als integration
>> time*/
>> +int als_saturation; /*computed, set to 90% of full scale of als
>> integration*/
Again, in device instance specific structure.
>> +
>> +/*Index = (0 - 3) Used to validate the gain selection index*/
>> +#define MAX_GAIN_STAGES	4
>> +struct gainadj {
>> +	s16 ch0;
>> +	s16 ch1;
>> +} gainadj[] = {
>> +	{ 1, 1 },
>> +	{ 8, 8 },
>> +	{ 16, 16 },
>> +	{ 107, 115 } };
static const again. Please run sparse and checkpatch against this driver.
It'll show up a lot of this sort of thing for you...
>> +
>> +struct taos_lux *taos_device_luxP;
>> +
>> +/*Input_dev*/
>> +static struct input_dev *taos_dev;
Again in device instance specific structure.
>> +
>> +/*sysfs - interface functions*/
Definitely don't need to have prototypes for these. Just reorder the
code so they aren't needed.
>> +static ssize_t taos_device_id(struct device *dev,
>> +    struct device_attribute *attr, char *buf);
>> +static DEVICE_ATTR(device_id, S_IRUGO, taos_device_id, NULL);
>> +
>> +static ssize_t taos_power_state_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf);
>> +static ssize_t taos_power_state_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len);
>> +static DEVICE_ATTR(device_state, S_IRUGO | S_IWUSR,
>> +		taos_power_state_show,
>> +		taos_power_state_store);
>> +
>> +static ssize_t taos_gain_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf);
>> +static ssize_t taos_gain_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len);
>> +static DEVICE_ATTR(als_gain, S_IRUGO | S_IWUSR,
>> +		taos_gain_show,
>> +		taos_gain_store);
>> +
>> +static ssize_t taos_interrupt_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf);
>> +static ssize_t taos_interrupt_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len);
>> +static DEVICE_ATTR(als_interrupt, S_IRUGO | S_IWUSR,
>> +		taos_interrupt_show,
>> +		taos_interrupt_store);
>> +
>> +static ssize_t taos_als_time_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf);
>> +static ssize_t taos_als_time_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len);
>> +static DEVICE_ATTR(als_time, S_IRUGO | S_IWUSR,
>> +		taos_als_time_show,
>> +		taos_als_time_store);
>> +
>> +static ssize_t taos_als_trim_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf);
>> +static ssize_t taos_als_trim_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len);
>> +static DEVICE_ATTR(als_trim, S_IRUGO | S_IWUSR,
>> +		taos_als_trim_show,
>> +		taos_als_trim_store);
>> +
>> +static ssize_t taos_als_persistence_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf);
>> +static ssize_t taos_als_persistence_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len);
>> +static DEVICE_ATTR(als_persistence, S_IRUGO | S_IWUSR,
>> +		taos_als_persistence_show,
>> +		taos_als_persistence_store);
>> +
>> +static ssize_t taos_als_cal_target_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf);
>> +static ssize_t taos_als_cal_target_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len);
>> +static DEVICE_ATTR(als_target, S_IRUGO | S_IWUSR,
>> +		taos_als_cal_target_show,
>> +		taos_als_cal_target_store);
>> +
>> +static ssize_t taos_lux_show(struct device *dev, struct
>> device_attribute *attr,
>> +    char *buf);
>> +static DEVICE_ATTR(lux, S_IRUGO, taos_lux_show, NULL);
>> +
>> +static ssize_t taos_do_calibrate(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len);
>> +static DEVICE_ATTR(calibrate, S_IWUSR, NULL, taos_do_calibrate);
>> +
>> +static ssize_t taos_als_thresh_low_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf);
>> +static ssize_t taos_als_thresh_low_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len);
>> +static DEVICE_ATTR(als_lowT, S_IRUGO | S_IWUSR,
>> +		taos_als_thresh_low_show,
>> +		taos_als_thresh_low_store);
>> +
>> +static ssize_t taos_als_thresh_high_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf);
>> +static ssize_t taos_als_thresh_high_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len);
>> +static DEVICE_ATTR(als_highT, S_IRUGO | S_IWUSR,
>> +	taos_als_thresh_high_show,
>> +	taos_als_thresh_high_store);
>> +
>> +
>> +static struct attribute *sysfs_attrs_ctrl[] = {

There are a number of 'new' abi elements here.  Remotely general ones
need full documentation in staging/iio/Documentation/sysfs-bus-iio-light
Note some relevant elemetns are in sysfs-bus-iio as they are more general...
>> +	&dev_attr_device_id.attr,
>> +    &dev_attr_device_state.attr,
>> +    &dev_attr_als_gain.attr,
>> +    &dev_attr_als_interrupt.attr,
What's this for example?

>> +    &dev_attr_als_time.attr,
>> +    &dev_attr_als_trim.attr,
Again, what's this?  I'd imagine Trim corresponds to
als_calibbias...

>> +    &dev_attr_als_persistence.attr,
>> +    &dev_attr_als_target.attr,
>> +    &dev_attr_lux.attr,
>> +    &dev_attr_calibrate.attr,
>> +    &dev_attr_als_lowT.attr,
These almost certainly have well defined abi elements in IIO, but without
a close read I'm not sure what they do... Our events interface is pretty
thorough so if we have missed a case someone needs then I want to know!

>> +    &dev_attr_als_highT.attr,
>> +    NULL };
>> +
>> +static struct attribute_group tsl258x_attribute_group[] = {
>> +	{ .attrs = sysfs_attrs_ctrl }, };
Only one group, so don't make an array of them...
>> +
>> +
>> +/*===========================================================================*/
>> +/*
>> +
>> + FUNCTIONS BEGIN HERE
To much information ;)  We can see that.  Problem with standard templates is that
they tend to have comments that you really want to get rid of for final code!
>> +
>> + */
>> +/*===========================================================================*/
>> +
>> +/*===========================================================================*/
>> +/**@defgroup Initialization Driver Initialization
>> + * The sections applies to functions for driver initialization,
>> instantiation,
>> + * _exit, \n
new lines in a comment?
>> + * and user-land application invoking (ie. open).\n
>> + * Also included in this section is the initial interrupt handler
>> (handler
>> + * bottom halves are in the respective
>> + * sections).
>> + * @{
>> + */
>> +
>> +/*........................................................................*/
>> +/** Driver initialization - device probe is initiated here, to identify
>> + * a valid device if present on any of the i2c buses and at any
>> address.
This is non standard.  Please do your registration the same way pretty much
every other i2c device does it, via a board file.
Or if you really can't do this you'll need to explain in some detail why not.
I'm not going to even attempt to figure out what this is doing...

If documenting, please stick to kerneldoc format (not quite sure what format this is in...)
>> + * \param  none
>> + * \return: int (0 = OK)
>> + * \note  	H/W Interrupt are device/product dependent.
>> + * Attention is required to the definition and configuration.
>> + */
>> +/*........................................................................*/
>> +static int __init taos_init(void)
>> +{
>> +	u32 err;
>> +	int i, j, k, ret = 0;
>> +	struct i2c_adapter *my_adap;
>> +	static int num_bad = 0x0000;
>> +
>> +#ifdef TAOS_DEBUG
>> +	printk(KERN_ERR "Loading TAOS Driver\n");
>> +	printk(KERN_INFO "\nRequesting a GPIO for irq\n");
>> +#endif
>> +/*......................................................................*/
>> +	/*Create the work queue and allocate kernel memory for the
>> +	 * scheduled workers*/
>> +	taos_wq0 = create_workqueue("taos_work_queue");
>> +	if (taos_wq0)
>> +		luxUd = kmalloc(sizeof(struct delayed_work), GFP_KERNEL);
Just put the delayed work struct in the device instance specific data structure
you are going to add and all will be simpler. In that case, the vast majority
of what is here needs to be in probe (as it depends on an instance) rather than
in the driver init function.
>> +
>> +	/*Make sure we have what we need */
>> +	if ((!taos_wq0) || (!luxUd))
>> +		return -ENOMEM;
>> +
>> +/*.....................................................................*/
>> +	ret = alloc_chrdev_region(&taos_dev_number, 0, MAX_NUM_DEVICES,
>> +		DEVICE_NAME);
>> +	if (ret < 0) {
>> +		dev_err(devp, "taos_device_drvr: alloc_chrdev_region()"
>> +			"failed in taos_init()\n");
>> +		return ret;
>> +	}
>> +	taos_class = class_create(THIS_MODULE, DEVICE_NAME);
>> +	chip = kmalloc(sizeof(struct tsl258x_chip), GFP_KERNEL);
>> +	if (!chip) {
>> +		dev_err(devp, "taos_device_drvr: kmalloc for "
>> +			"struct tsl258x_chip failed in taos_init()\n");
>> +		ret = -ENOMEM;
>> +		goto exit_3;
>> +	}
>> +	memset(chip, 0, sizeof(struct tsl258x_chip));
>> +	cdev_init(&chip->cdev, &taos_fops);
>> +	chip->cdev.owner = THIS_MODULE;
>> +
>> +	ret = cdev_add(&chip->cdev, taos_dev_number, 1);
>> +	if (ret < 0) {
>> +		dev_err(devp, "taos_device_drvr: cdev_add() failed in "
>> +				"taos_init()\n");
>> +		goto exit_2;
>> +	}
>> +	device_create(taos_class, NULL, MKDEV(MAJOR(taos_dev_number), 0),
>> +			&taos_driver , DEVICE_NAME);
>> +	ret = i2c_add_driver(&taos_driver);
>> +	if (ret < 0) {
>> +		dev_err(devp, "taos_device_drvr: i2c_add_driver() failed in "
>> +				"taos_init()\n");
>> +		goto exit_1;
>> +	}
>> +	device_found = 0;
>> +	for (i = 0; i < I2C_MAX_ADAPTERS; i++) {
>> +		my_adap = i2c_get_adapter(i);
>> +		if (my_adap == NULL)
>> +			break;
>> +		for (j = 0; j < MAX_NUM_DEVICES; j++) {
>> +			client = i2c_new_probed_device(my_adap,
>> +					&taos_board_info[j], taos_addr_list);
>> +			if ((client) && (!device_found)) {
>> +				bad_clientp[num_bad] = client;
>> +				num_bad++;
>> +			}
>> +			if (device_found)
>> +				break;
>> +		}
>> +		if (num_bad) {
>> +			for (k = 0; k < num_bad; k++)
>> +				i2c_unregister_device(bad_clientp[k]);
>> +			num_bad = 0;
>> +		}
>> +		if (device_found)
>> +			break;
>> +	}
>> +	if (device_found) {
>> +		devp = &client->dev;
>> +		goto exit_4;
>> +	} else {
>> +		if (client)
>> +			i2c_unregister_device(client);
>> +		i2c_del_driver(&taos_driver);
>> +		device_destroy(taos_class, MKDEV(MAJOR(taos_dev_number), 0));
>> +		cdev_del(&chip->cdev);
>> +		kfree(chip);
>> +		class_destroy(taos_class);
>> +		unregister_chrdev_region(taos_dev_number, MAX_NUM_DEVICES);
>> +		printk(KERN_ERR "taos_device_drvr: taos_init() found no device\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +exit_1: device_destroy(taos_class, MKDEV(MAJOR(taos_dev_number), 0));
>> +exit_2: cdev_del(&chip->cdev);
>> +	kfree(chip);
>> +exit_3: class_destroy(taos_class);
>> +	unregister_chrdev_region(taos_dev_number, MAX_NUM_DEVICES);
>> +
Flow in this function probably wants rethinking... Its very confusing...
>> +exit_4:
>> +
Should see this sort of explicit formatting.  One newline
at the end of a printk is quite enough!
>> +	printk(KERN_INFO "\n\nallocating iio device\n");
>> +	chip->iio_dev = iio_allocate_device();
>> +	if (!chip->iio_dev)
>> +		printk(KERN_INFO "iio allocation failed\n");
>> +
>> +	chip->iio_dev->attrs =
The type cast here is a little disturbing and correctly shows that your taking
the address of the address of a struct attribute_group is a bug... It might
evaluate to the same value, but it definitely isn't the right way to use it.

>> +			(struct attribute_group *)&tsl258x_attribute_group;
>> +	chip->iio_dev->dev.parent = &client->dev;
>> +	chip->iio_dev->dev_data = (void *)(chip);
>> +	chip->iio_dev->driver_module = THIS_MODULE;
>> +	chip->iio_dev->modes = INDIO_DIRECT_MODE;
>> +	err = iio_device_register(chip->iio_dev);
>> +
>> +	if (err)
>> +		printk(KERN_INFO "iio registration failed\n");
>> +
>> +	/*Make sure the chip is off*/
>> +	taos_chip_off();
>> +	/*Load up the V2 defaults (these are hard coded defaults for now)*/
>> +	taos_defaults();
>> +	/*Set any other defaults that are needed to initialize
>> +	 * (such as taos_cycle_type).
>> +	 Note: these settings can/will be changed based on user
>> requirements.*/
>> +	taos_cycle_type = LIGHT;
>> +	/*Initialize the work queues*/
>> +
>> +	INIT_DELAYED_WORK(luxUd, taos_als_auto_update);
>> +
>> +	/*...................................................................*/
>> +	/*This section populates the input structure and registers the
>> device*/
>> +#ifdef EVENT_NOTIFY
>> +	taos_dev = input_allocate_device();
>> +	if (!taos_dev) {
>> +		printk(KERN_ERR "__init: Not enough memory for input_dev\n");
>> +		return ret;
>> +	}
>> +
>> +	/*Since we now have the struct, populate.*/
>> +	taos_dev->name = DEVICE_ID;
>> +	taos_dev->id.bustype = BUS_I2C;
>> +	taos_dev->id.vendor = 0x0089;
>> +	taos_dev->id.product = 0x2581;
>> +	taos_dev->id.version = 3;
>> +	taos_dev->phys = "/dev/taos";
>> +
>> +	/*This device one value (LUX)
>> +	 Other devices may have LUX and PROX.
>> +	 Thus we use the ABS_X so ABS_Y is logically available.*/
>> +	set_bit(EV_ABS, taos_dev->evbit);
>> +	set_bit(ABS_X, taos_dev->absbit);
>> +
>> +	/*Only returns only positive LUX values
>> +	 No noise filter, no flat level*/
>> +	taos_dev->absmin[ABS_X] = 0;
>> +	taos_dev->absmax[ABS_X] = MAX_LUX;
>> +	taos_dev->absfuzz[ABS_X] = 0;
>> +	taos_dev->absflat[ABS_X] = 0;
>> +
>> +	/*And register..*/
>> +	ret = input_register_device(taos_dev);
>> +	if (ret) {
>> +		printk(KERN_ERR "button.c: Failed to register input_dev\n");
>> +		goto err_free_dev;
>> +	}
>> +#endif	/*End of input_event*/
>> +
>> +
>> +	/*invoke sysfs
>> +	 invoke iio subsystem*/
>> +
>> +	err = sysfs_create_group(&chip->client->dev.kobj,
>> +			tsl258x_attribute_group);
>> +	if (err < 0) {
>> +		dev_err(&chip->client->dev, "Sysfs registration failed\n");
>> +		goto err_free_dev;
>> +	}
>> +
>> +	if (taos_wq0)
>> +		ret = queue_delayed_work(taos_wq0, luxUd, LUX_UPDATE_PERIOD);
>> +	else
>> +		printk(KERN_INFO "\nNO taos_wq0 for luxUd\n\n");
>> +
>> +	return ret; /*Normal return*/
>> +
>> +/*In the event we had a problem REGISTERING the device for
>> input_events*/
>> +err_free_dev:
>> +	input_free_device(taos_dev);
>> +	return ret;
>> +}
>> +
>> +/**
>> + * Driver exit
>> + */
>> +static void __exit taos_exit(void)
>> +{
>> +	printk(KERN_INFO "TAOS driver __exit\n");
>> +
>> +	if (taos_wq0) {
>> +		flush_workqueue(taos_wq0);
>> +		destroy_workqueue(taos_wq0);
>> +	}
>> +
>> +	input_free_device(taos_dev);
>> +
>> +	if (client)
>> +		i2c_unregister_device(client);
>> +	i2c_del_driver(&taos_driver);
>> +	device_destroy(taos_class, MKDEV(MAJOR(taos_dev_number), 0));
>> +	cdev_del(&chip->cdev);
>> +	kfree(chip);
>> +	class_destroy(taos_class);
>> +	unregister_chrdev_region(taos_dev_number, MAX_NUM_DEVICES);
>> +
>> +}
>> +
>> +/**
>> + * Client probe function - When a valid device is found, the driver's
>> device
>> + * data structure is updated, and initialization completes
>> successfully.
>> + */
>> +static int taos_probe(struct i2c_client *clientp,
>> +    const struct i2c_device_id *idp) {
>> +	int i, ret = 0;
>> +	unsigned char buf[MAX_DEVICE_REGS];
>> +	char *device_name;
>> +
>> +	if (device_found)
>> +		return -ENODEV;
>> +	if (!i2c_check_functionality(clientp->adapter,
>> +		I2C_FUNC_SMBUS_BYTE_DATA)) {
>> +		dev_err(&clientp->dev,
>> +			"taos_probe() - i2c smbus byte data "
>> +			"functions unsupported\n");
>> +		return -EOPNOTSUPP;
>> +	}
>> +	if (!i2c_check_functionality(clientp->adapter,
>> +		I2C_FUNC_SMBUS_WORD_DATA)) {
>> +		dev_warn(&clientp->dev,
>> +			"taos_probe() - i2c smbus word data "
>> +			"functions unsupported\n");
>> +	}
>> +	if (!i2c_check_functionality(clientp->adapter,
>> +		I2C_FUNC_SMBUS_BLOCK_DATA)) {
>> +		dev_err(&clientp->dev,
>> +			"taos_probe() - i2c smbus block data "
>> +			"functions unsupported\n");
>> +	}
>> +	chip->client = clientp;
>> +	i2c_set_clientdata(clientp, chip);
>> +	for (i = 0; i < MAX_DEVICE_REGS; i++) {
>> +		ret = i2c_smbus_write_byte(clientp, (CMD_REG | (CNTRL + i)));
>> +		if (ret < 0) {
>> +			dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd "
>> +				"reg failed in taos_probe(), err = %d\n", ret);
>> +			return ret;
>> +		}
>> +		buf[i] = i2c_smbus_read_byte(clientp);
>> +	}
>> +	ret = taos_device_name(buf, &device_name);
>> +	if (ret < 0) {
>> +		dev_info(&clientp->dev, "i2c device found - does not match "
>> +			"expected id in taos_probe() 1\n");
>> +	}
>> +	if (strcmp(device_name, DEVICE_ID)) {
>> +		dev_info(&clientp->dev, "i2c device found - does not match "
>> +			"expected id in taos_probe()2\n");
>> +	} else {
>> +		dev_info(&clientp->dev, "i2c device found - matches expected "
>> +			"id of %s in taos_probe()\n", device_name);
>> +		device_found = 1;
>> +	}
>> +	ret = i2c_smbus_write_byte(clientp, (CMD_REG | CNTRL));
>> +	if (ret < 0) {
>> +		dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd reg "
>> +			"failed in taos_probe(), err = %d\n", ret);
>> +		return ret;
>> +	}
>> +	strlcpy(clientp->name, DEVICE_ID, I2C_NAME_SIZE);
>> +	strlcpy(chip->taos_name, DEVICE_ID, ID_NAME_SIZE);
>> +	chip->valid = 0;
>> +
>> +	taos_settingsP = kmalloc(sizeof(struct taos_settings), GFP_KERNEL);
>> +	if (!(taos_settingsP)) {
>> +		dev_err(&clientp->dev,
>> +		"kmalloc for struct taos_settings failed in taos_probe()\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +/**
>> + * Client remove
>> + */
>> +static int __devexit taos_remove(struct i2c_client *client)
>> +{
>> +	return 0;
>> +}
>> +
>> +/**
>> + * Device open function
>> + */
>> +static int taos_open(struct inode *inode, struct file *file)
>> +{
>> +	int ret = 0;
>> +	struct tsl258x_chip *chip;
>> +
>> +
>> +	/*For debug - Make it ez to c on the console*/
This certainly should have gone from the code before submission. Don't want this
in any production system kernel log!
>> +#ifdef TAOS_DEBUG
>> +	printk(KERN_INFO "***************************************************
>> \n");
>> +	printk(KERN_INFO "*                                                 *
>> \n");
>> +	printk(KERN_INFO "*                  TAOS DEVICE                    *
>> \n");
>> +	printk(KERN_INFO "*                    DRIVER                       *
>> \n");
>> +	printk(KERN_INFO "*                     OPEN                        *
>> \n");
>> +	printk(KERN_INFO "***************************************************
>> \n");
>> +#endif
>> +
>> +	chip = container_of(inode->i_cdev, struct tsl258x_chip, cdev);
>> +	if (strcmp(chip->taos_name, DEVICE_ID) != 0) {
>> +		dev_err(devp, "device name error in taos_open(), shows %s\n",
>> +		    chip->taos_name);
>> +		return -ENODEV;
>> +	}
>> +
>> +	device_released = 0;
>> +	return ret;
>> +}
>> +
>> +/**
>> + * Device release
>> + */
>> +static int taos_release(struct inode *inode, struct file *file)
>> +{
>> +	int ret = 0;
>> +	struct tsl258x_chip *chip;
>> +
>> +	device_released = 1;
>> +	chip = container_of(inode->i_cdev, struct tsl258x_chip, cdev);
>> +	if (strcmp(chip->taos_name, DEVICE_ID) != 0) {
>> +		dev_err(devp, "device id incorrect in taos_release(), shows "
>> +			"%s\n", chip->taos_name);
>> +		ret = -ENODEV;
>> +	}
>> +	taos_fasync(-1, file, 0);
>> +	free_irq(irqnum, chip);
>> +	return ret;
>> +}
>> +
>> +/**
>> + * Name verification - uses default register values to identify the
>> Taos device
>> + */
>> +static int taos_device_name(unsigned char *bufp, char **device_name)
>> +{
>> +	if (((bufp[0x12] & 0xf0) == 0x00) || (bufp[0x12] == 0x08)) {
Are these internal names?  If so please use part numbers instead. Much easier
for everyone else!
>> +		*device_name = "tritonFN";
>> +		return 1;
>> +	} else if (((bufp[0x12] & 0xf0) == 0x90)) {
>> +		*device_name = "skateFN";
>> +		return 1;
>> +	}
>> +	*device_name = "unknown";
That's probably a very bad sign...
>> +	printk(KERN_INFO "Identified %s\n", *device_name);
>> +	return 0;
>> +}
>> +
>> +/**
>> + * Device read - reads are permitted only within the range of the
>> accessible
>> + * registers of the device. The data read is copied safely to user
>> space.
>> + */
>> +static int taos_read(struct file *file, char *buf, size_t count, loff_t
>> *ppos)
>> +{
>> +	int ret = 0;
>> +	struct tsl258x_chip *chip;
>> +	u8 my_buf[MAX_DEVICE_REGS];
>> +	u8 reg, i = 0, xfrd = 0;
>> +
>> +
>> +	/*Make sure we not in the middle of accessing the device*/
>> +	if (mutex_trylock(&als_mutex) == 0) {
>> +		printk(KERN_INFO "Can't get ALS mutex\n");
>> +		return -1; /*busy, so return LAST VALUE*/
>> +	}
>> +
>> +	if ((*ppos < 0) || (*ppos >= MAX_DEVICE_REGS) || ((*ppos + count)
>> +			> MAX_DEVICE_REGS)) {
>> +		dev_err(devp, "reg limit check failed in taos_read()\n");
>> +		mutex_unlock(&als_mutex);
>> +		return -EINVAL;
>> +	}
>> +	reg = (u8) *ppos;
>> +	chip = container_of(file->f_dentry->d_inode->i_cdev,
>> +			struct tsl258x_chip, cdev);
>> +	while (xfrd < count) {
>> +		ret = i2c_smbus_write_byte(chip->client, (CMD_REG | reg));
>> +		if (ret < 0) {
>> +			dev_err(devp, "i2c_smbus_write_byte to cmd reg failed "
>> +				"in taos_read(), err = %d\n", ret);
>> +			mutex_unlock(&als_mutex);
>> +			return ret;
>> +		}
>> +		my_buf[i++] = i2c_smbus_read_byte(chip->client);
>> +		reg++;
>> +		xfrd++;
>> +	}
>> +	ret = copy_to_user(buf, my_buf, xfrd);
>> +	if (ret) {
>> +		dev_err(devp, "copy_to_user failed in taos_read()\n");
>> +		mutex_unlock(&als_mutex);
>> +		return -ENODATA;
>> +	}
>> +
>> +	mutex_unlock(&als_mutex);
>> +	return (int) xfrd;
>> +}
>> +
>> +/**
>> + * Device write - writes are permitted only within the range of the
>> accessible
>> + * registers of the device. The data written is copied safely from user
>> space.
>> + */
>> +static int taos_write(struct file *file, const char *buf, size_t count,
>> +    loff_t *ppos)
>> +{
>> +	int ret = 0;
>> +	struct tsl258x_chip *chip;
>> +	u8 my_buf[MAX_DEVICE_REGS];
>> +	u8 reg, i = 0, xfrd = 0;
>> +
>> +	if (mutex_trylock(&als_mutex) == 0) {
>> +		printk(KERN_INFO "Can't get ALS mutex\n");
>> +		return -1; /*busy, so return LAST VALUE*/
>> +	}
>> +
>> +	if ((*ppos < 0) || (*ppos >= MAX_DEVICE_REGS) || ((*ppos + count)
>> +			> MAX_DEVICE_REGS)) {
>> +		dev_err(devp, "reg limit check failed in taos_write()\n");
>> +		mutex_unlock(&als_mutex);
>> +		return -EINVAL;
>> +	}
>> +	reg = (u8) *ppos;
>> +	ret = copy_from_user(my_buf, buf, count);
>> +	if (ret) {
>> +		dev_err(devp, "copy_from_user failed in taos_write()\n");
>> +		mutex_unlock(&als_mutex);
>> +		return -ENODATA;
>> +		}
>> +	chip = container_of(file->f_dentry->d_inode->i_cdev,
>> +		struct tsl258x_chip, cdev);
>> +	while (xfrd < count) {
>> +		ret = i2c_smbus_write_byte_data(chip->client, (CMD_REG | reg),
>> +		    my_buf[i++]);
>> +		if (ret < 0) {
>> +			dev_err(devp, "i2c_smbus_write_byte_data failed in "
>> +				"taos_write()\n");
>> +			mutex_unlock(&als_mutex);
>> +			return ret;
>> +		}
>> +		reg++;
>> +		xfrd++;
>> +	}
>> +
>> +	mutex_unlock(&als_mutex);
>> +	return (int) xfrd;
>> +}
>> +
>> +/**
>> + * Device seek - seeks are permitted only within the range of the
>> accessible
>> + * registers of the device. The new offset is returned.
>> + */
>> +static loff_t taos_llseek(struct file *file, loff_t offset, int orig)
>> +{
>> +	loff_t new_pos;
>> +
>> +	if ((offset >= MAX_DEVICE_REGS) || (orig < 0) || (orig > 1)) {
>> +		dev_err(devp, "offset param limit or whence limit check failed "
>> +			"in taos_llseek()\n");
>> +		return -EINVAL;
>> +	}
>> +	switch (orig) {
>> +	case 0:
>> +		new_pos = offset;
>> +		break;
>> +	case 1:
>> +		new_pos = file->f_pos + offset;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +		break;
>> +	}
>> +	if ((new_pos < 0) || (new_pos >= MAX_DEVICE_REGS)) {
>> +		dev_err(devp, "new offset check failed in taos_llseek()\n");
>> +		return -EINVAL;
>> +	}
>> +	file->f_pos = new_pos;
>> +	return new_pos;
>> +}
>> +
>> +/**
>> + * Fasync function - called when the FASYNC flag in the file descriptor
>> of the
>> + * device indicates that a new user program wants to be added to the
>> wait queue
>> + * of the device - calls fasync_helper() to add the new entry to the
>> queue.
>> + */
>> +static int taos_fasync(int fd, struct file *file, int mode)
>> +{
>> +	chip = container_of(file->f_dentry->d_inode->i_cdev, struct
>> +			tsl258x_chip, cdev);
>> +	return fasync_helper(fd, file, mode, &chip->async_queue);
>> +}
>> +
>> +/**
>> + * Provides initial operational parameter defaults.\n
>> + * These defaults may be changed by the following:\n
>> + * - system deamon
>> + * - user application (via ioctl)
>> + * - directly writing to the taos procfs file
There's a procfs file?  That's not going to go down well these days...

>> + * - external kernel level modules / applications
>> + */
>> +static void taos_defaults()
>> +{
>> +	/*Operational parameters*/
>> +	taos_cycle_type = LIGHT;
>> +	/*default is ALS only*/
>> +	taos_settings.als_time = 100;
>> +	/*must be a multiple of 50mS*/
>> +	taos_settings.als_gain = 0;
>> +	/*this is actually an index into the gain table*/
>> +	/*assume clear glass as default*/
>> +	taos_settings.als_gain_trim = 1000;
>> +	/*default gain trim to account for aperture effects*/
>> +	taos_settings.als_persistence = 0;
>> +	/*default number of 'out of bounds' b4 interrupt*/
>> +	taos_settings.als_cal_target = 130;
>> +	/*Known external ALS reading used for calibration*/
>> +	taos_settings.interrupts_enabled = 0;
>> +	/*Interrupts enabled (ALS) 0 = none*/
>> +
>> +	/*Initialize ALS data to defaults*/
>> +	als_cur_info.als_ch0 = 0;
>> +	als_cur_info.als_ch1 = 0;
>> +	als_cur_info.lux = 0;
>> +
>> +	taos_settings.als_thresh_high = ALS_THRESHOLD_HI_LIMIT;
>> +	taos_settings.als_thresh_low = ALS_THRESHOLD_LO_LIMIT;
>> +
>> +
>> +#ifdef TAOS_DEBUG
>> +printk(KERN_INFO "\nDEFAULTS LOADED\n");
>> +#endif
>> +}
>> +EXPORT_SYMBOL(taos_defaults);
Why export?
>> +/*........................................................................*/
>> +/*@}	End of Initial*/
>> +
>> +
>> +/*===========================================================================*/
>> +/**@defgroup IOCTL User ioctl Functions
>> + * The section applies to 'ioctl' calls used primarily to support
>> user-land applications.\n
>> + * @{
>> + */
>> +/**
>> + * Ioctl functions - each one is documented below.
>> + */
>> +static int taos_ioctl(struct inode *inode, struct file *file, unsigned
>> int cmd,
>> +    unsigned long arg) {
>> +	int ret = 0;
>> +	struct tsl258x_chip *chip;
>> +	int tmp;
>> +	/*u8 reg_val;*/
>> +
>> +	chip = container_of(inode->i_cdev, struct tsl258x_chip, cdev);
>> +	switch (cmd) {
>> +	/**
>> +	 * - ALS_ON - called to set the device in ambient light sense mode.
>> +	 * configured values of light integration time, initial interrupt
>> +	 * filter, gain, and interrupt thresholds (if interrupt driven) are
>> +	 * initialized. Then power, adc, (and interrupt if needed) are
>> enabled.
>> +	 */
>> +	case TAOS_IOCTL_ALS_ON:
>> +	  taos_cycle_type = LIGHT;
>> +	  printk(KERN_INFO "ALS On\n");
>> +	  return taos_chip_on();
>> +	break;
>> +	/**
>> +	* - ALS_OFF - called to stop ambient light sense mode of operation.
>> +	* Clears the filter history, and clears the control register.
>> +	*/
>> +	case TAOS_IOCTL_ALS_OFF:
>> +		taos_chip_off();
>> +		break;
>> +	/**
>> +	* - ALS_DATA - request for current ambient light data. If correctly
>> +	* enabled and valid data is available at the device, the function
>> +	* for lux conversion is called, and the result returned if valid.
>> +	*/
>> +	case TAOS_IOCTL_ALS_DATA:
>> +		/*Are we actively updating the struct?*/
>> +		if ((taos_settings.interrupts_enabled
>> +				& CNTL_ALS_INT_ENBL) == 0x00)
>> +			return taos_get_lux(); /*No - so get fresh data*/
>> +		else
>> +			return als_cur_info.lux;
>> +			/*Yes - data is fresh as last change*/
>> +		break;
>> +
>> +	/**
>> +	* - ALS_CALIBRATE - called to run one calibration cycle, during
>> assembly.
>> +	* The lux value under a known intensity light source is used to obtain
>> +	* a "gain trim" multiplier which is to be used to normalize subsequent
>> +	* lux data read from the device, after the calibration is completed.
>> +	* This 'known intensity should be the value of als_cal_target.
>> +	* If not - make is so!
>> +	*/
>> +	case TAOS_IOCTL_ALS_CALIBRATE:
>> +		return taos_als_calibrate(taos_settings.als_cal_target);
>> +		break;
>> +	/**
>> +	* - CONFIG-GET - returns the current device configuration values to
>> the
>> +	* caller. The user mode application can display or store configuration
>> +	* values, for future reconfiguration of the device, as needed.
>> +	* Refer to structure "taos_settings" in '.h' file.
>> +	*/
>> +	case TAOS_IOCTL_CONFIG_GET:
>> +		ret = copy_to_user((struct taos_settings *) arg, &taos_settings,
>> +			sizeof(struct taos_settings));
>> +		if (ret) {
>> +			dev_err(devp,
>> +				"copy_to_user() failed in ioctl config_get\n");
>> +			return -ENODATA;
>> +		}
>> +		return ret;
>> +		break;
>> +	/**
>> +	* - GET_ALS - returns the current ALS structure values to the
>> +	* caller. The values returned represent the last call to
>> +	* taos_get_lux().  This ioctl can be used when the driver
>> +	* is operating in the interrupt mode.
>> +	* Refer to structure "als_cur_info" in '.h' file.
>> +	*/
>> +	case TAOS_IOCTL_GET_ALS:
>> +		ret = copy_to_user((struct taos_als_info *) arg,
>> +			&als_cur_info,
>> +			sizeof(struct taos_als_info));
>> +		if (ret) {
>> +			dev_err(devp,
>> +			"copy_to_user() failed in ioctl to get "
>> +				"taos_als_info\n");
>> +			return -ENODATA;
>> +			}
>> +		return ret;
>> +		break;
>> +	/**
>> +	* - CONFIG-SET - used by a user mode application to set the desired
>> +	* values in the driver's in memory copy of the device configuration
>> +	* data. Light integration times are aligned optimally, and driver
>> +	* global variables dependent on configured values are updated here.
>> +	* Refer to structure "taos_settings" in '.h' file.
>> +	*/
>> +	case TAOS_IOCTL_CONFIG_SET:
>> +		ret = copy_from_user(&taos_settings,
>> +			(struct taos_settings *) arg,
>> +			sizeof(struct taos_settings));
>> +		if (ret) {
>> +			dev_err(devp,
>> +			"copy_from_user() failed in ioctl config_set\n");
>> +			return -ENODATA;
>> +			}
>> +		return ret;
>> +		break;
>> +	/**
>> +	* - LUX_TABLE-GET - returns the current LUX coefficients table to the
>> +	* caller. The user mode application can display or store the table
>> +	* values, for future re-calibration of the device, as needed.
>> +	* Refer to structure "taos_lux" in '.h' file.
>> +	*/
>> +	case TAOS_IOCTL_LUX_TABLE_GET:
>> +		ret = copy_to_user((struct taos_lux *) arg,
>> +			&taos_device_lux,
>> +			sizeof(taos_device_lux));
>> +		if (ret) {
>> +			dev_err(devp,
>> +			"copy_to_user() failed in ioctl "
>> +			"TAOS_IOCTL_LUX_TABLE_GET\n");
>> +			return -ENODATA;
>> +			}
>> +		return ret;
>> +		break;
>> +	/**
>> +	* - LUX TABLE-SET - used by a user mode application to set the desired
>> +	* LUX table values in the driver's in memory copy of the lux table
>> +	* Refer to structure "taos_lux" in '.h' file.
>> +	*/
>> +	case TAOS_IOCTL_LUX_TABLE_SET:
>> +		ret = copy_from_user(&taos_lux,
>> +			(struct taos_lux *) arg,
>> +			sizeof(taos_device_lux));
>> +		if (ret) {
>> +			dev_err(devp, "copy_from_user() failed in ioctl "
>> +				"TAOS_IOCTL_LUX_TABLE_SET\n");
>> +			return -ENODATA;
>> +			}
>> +#ifdef ASYNC_NOTIFY
>> +		/*Notify the user-land app (if any)*/
>> +		if (chip->async_queue)
>> +			kill_fasync(&chip->async_queue, SIGIO, POLL_IN);
>> +#endif
>> +
>> +
>> +		return ret;
>> +		break;
>> +	/**
>> +	* - TAOS_IOCTL_ID - used to query driver name & version
>> +	*/
>> +	case TAOS_IOCTL_ID:
>> +		ret = copy_to_user((char *) arg,
>> +			&driver_version_id,
>> +			sizeof(driver_version_id));
>> +		dev_info(devp, "%s\n", DRIVER_VERSION_ID);
>> +		return ret;
>> +		break;
>> +	/*
>> +	* - TAOS_IOCTL_SET_GAIN - used to set/change the device analog gain.
>> +	* The value passed into here from the user is the index into the
>> table.
>> +	* Index = (0 - 3) Used to validate the gain selection index
>> +	*/
>> +	case TAOS_IOCTL_SET_GAIN:
>> +		get_user(tmp, (int *)arg);
>> +		if (tmp > MAX_GAIN_STAGES)
>> +			return -1;
>> +		taos_settings.als_gain = tmp;
>> +		ret = taos_i2c_write(CMD_REG|GAIN, (u8 *)&tmp);
>> +		if (ret < 0) {
>> +			dev_err(devp, "taos_i2c_write to turn on device "
>> +				"failed in taos_chip_on.\n");
>> +			return -1;
>> +			}
>> +		return ret;
>> +		break;
>> +
>> +	default:
>> +		return -EINVAL;
>> +		break;
>> +		}
>> +
>> +		return ret;
>> +
>> +	}
>> +/*........................................................................*/
>> +/*@}	end of IOCTL section*/
>> +
>> +
Wrong comment format and lots of obvious info.  Please remove!
>> +/*===========================================================================*/
>> +/**@defgroup ALS Ambient Light Sense (ALS)
>> + * The section applies to the ALS related functions.\n
>> + * Other ALS releated functions may appear elsewhere in the code.\n
>> + * @{
>> + */
>> +
>> +/*........................................................................*/
>> +
>> +/**
>> + * Reads and calculates current lux value.
>> + * The raw ch0 and ch1 values of the ambient light sensed in the last
>> + * integration cycle are read from the device.
>> + * Time scale factor array values are adjusted based on the integration
>> time.
>> + * The raw values are multiplied by a scale factor, and device gain is
>> obtained
>> + * using gain index. Limit checks are done next, then the ratio of a
>> multiple
>> + * of ch1 value, to the ch0 value, is calculated. The array
>> taos_device_luxP[]
>> + * declared above is then scanned to find the first ratio value that is
>> just
>> + * above the ratio we just calculated. The ch0 and ch1 multiplier
>> constants in
>> + * the array are then used along with the time scale factor array
>> values, to
>> + * calculate the lux.
>> + *
>> + *	\param 	none
>> + *	\return int	-1 = Failure, Lux Value = success
>> + */
>> +static int taos_get_lux(void)
>> +{
>> +	u32 ch0, ch1; /* separated ch0/ch1 data from device */
>> +	u32 lux; /* raw lux calculated from device data */
>> +	u32 ratio;
>> +	u8 buf[5];
>> +	struct taos_lux *p;
>> +
>> +	int i, ret;
>> +
= 0; will do the job just as well.
>> +	u32 ch0lux = 0x0000;
>> +	u32 ch1lux = 0x0000;
>> +
>> +	if (mutex_trylock(&als_mutex) == 0) {
>> +		printk(KERN_INFO "Can't get ALS mutex\n");
>> +		return als_cur_info.lux; /*busy, so return LAST VALUE*/
>> +	}
>> +
>> +	if (taos_chip_status != TAOS_CHIP_WORKING) {
>> +		/*device is not enabled*/
>> +		printk(KERN_INFO "device is not enabled\n");
>> +		mutex_unlock(&als_mutex);
>> +		return -1;
>> +	}
>> +
>> +	if ((taos_cycle_type & LIGHT) == 0) {
>> +		/*device not in ALS mode*/
>> +		printk(KERN_INFO "device not in ALS mode\n");
>> +		mutex_unlock(&als_mutex);
>> +		return -1;
>> +	}
>> +
>> +	ret = taos_i2c_read((CMD_REG), &buf[0], 1);
>> +	if (ret < 0) {
>> +		printk(KERN_INFO "taos_i2c_read() to CMD_REG reg failed in "
>> +		"taos_get_lux()\n");
>> +		mutex_unlock(&als_mutex);
>> +		return -1;
>> +	}
>> +	/* is data new & valid */
>> +	if (!(buf[0] & STA_ADCINTR)) {
>> +		printk(KERN_INFO "Data not valid, so return LAST VALUE\n");
>> +		mutex_unlock(&als_mutex);
>> +		return als_cur_info.lux; /*have no data, so return LAST VALUE*/
>> +	}
>> +
>> +	for (i = 0; i < 4; i++) {
>> +		ret = taos_i2c_read((CMD_REG | (ALS_CHAN0LO + i)), &buf[i], 1);
>> +		if (ret < 0) {
>> +			dev_err(devp,
>> +			"taos_i2c_read() to (ALS_CHAN0LO + i) failed in "
>> +			"taos_get_lux()\n");
>> +			mutex_unlock(&als_mutex);
>> +			return -1;
>> +		}
>> +	}
>> +
>> +	/* clear status, really interrupt status (interrupts are off), but
>> +	 *  we use the bit anyway */
>> +	ret = taos_i2c_write_command(CMD_REG | CMD_SPL_FN | CMD_ALS_INTCLR);
>> +	if (ret < 0) {
>> +		dev_err(devp,
>> +		"taos_i2c_write_command failed in "
>> +		"taos_chip_on, err = %d\n", ret);
>> +		mutex_unlock(&als_mutex);
>> +		return -1; /*have no data, so return fail*/
>> +	}
>> +
>> +	/* extract ALS/lux data */
>> +	ch0 = (buf[1] << 8) | buf[0];
>> +	ch1 = (buf[3] << 8) | buf[2];
>> +
>> +	als_cur_info.als_ch0 = ch0;
>> +	als_cur_info.als_ch1 = ch1;
>> +
>> +
>> +#ifdef TAOS_DEBUG
>> +	printk(KERN_INFO " ch0=%d/0x%x ch1=%d/0x%x\n", ch0, ch0, ch1, ch1);
>> +#endif
>> +
>> +	if ((ch0 >= als_saturation) || (ch1 >= als_saturation)) {
>> +return_max:
>> +		als_cur_info.lux = MAX_LUX;
>> +		mutex_unlock(&als_mutex);
>> +		return als_cur_info.lux;
>> +	}
>> +
>> +	if (ch0 == 0) {
>> +		als_cur_info.lux = 0;
>> +#ifdef TAOS_DEBUG
>> +		printk(KERN_INFO "ch0==0\n");
>> +#endif
>> +		mutex_unlock(&als_mutex);
>> +
>> +		return als_cur_info.lux;
>> +		/*have no data, so return LAST VALUE*/
>> +	}
>> +	/* calculate ratio */
>> +	ratio = (ch1 << 15) / ch0;
>> +	/* convert to unscaled lux using the pointer to the table */
>> +	for (p = (struct taos_lux *) taos_device_lux;
>> +			p->ratio != 0 && p->ratio < ratio; p++)
>> +		;
>> +
>> +	if (p->ratio == 0) {
>> +#ifdef TAOS_DEBUG
>> +		dev_info(devp, "ratio = %04x   p->ratio = %04x\n",
>> +			ratio, p->ratio);
>> +#endif
>> +		lux = 0;
>> +	} else {
>> +		ch0lux = ((ch0 * p->ch0) +
>> +				(gainadj[taos_settings.als_gain].ch0 >> 1))
>> +				/ gainadj[taos_settings.als_gain].ch0;
>> +		ch1lux = ((ch1 * p->ch1) +
>> +				(gainadj[taos_settings.als_gain].ch1 >> 1))
>> +				/ gainadj[taos_settings.als_gain].ch1;
>> +		lux = ch0lux - ch1lux;
>> +	}
>> +
>> +	/* note: lux is 31 bit max at this point */
>> +	if (ch1lux > ch0lux) {
>> +		printk(KERN_INFO "No Data - Return last value\n");
>> +		als_cur_info.lux = 0;
>> +		mutex_unlock(&als_mutex);
>> +		return als_cur_info.lux; /*have no data, so return LAST VALUE*/
>> +	}
>> +	/* adjust for active time scale */
>> +	lux = (lux + (als_time_scale >> 1)) / als_time_scale;
>> +	/* adjust for active gain scale */
>> +	lux >>= 13; /* tables have factor of 8192 builtin for accuracy */
>> +
>> +	lux = (lux * taos_settings.als_gain_trim + 500) / 1000;
>> +
>> +
>> +#ifdef TAOS_DEBUG
>> +	printk(KERN_INFO "lux=%d\n", lux);
>> +#endif
>> +	if (lux > MAX_LUX) /* check for overflow */
>> +		goto return_max;
>> +
>> +	als_cur_info.lux = lux;
>> +	/*Update the structure with the latest VALID lux.*/
>> +
>> +	mutex_unlock(&als_mutex);
>> +	return lux;
>> +}
>> +EXPORT_SYMBOL(taos_get_lux);
>> +
>> +/**
>> + * Obtain single reading and calculate the als_gain_trim (later used to
>> derive actual lux)
>> + *\param   ulong	als_cal_target	ALS target (real world)
>> + *\return  int		updated gain_trim value
>> + */
>> +int taos_als_calibrate(unsigned long als_cal_target)
>> +{
>> +	u8 reg_val;
>> +	unsigned int gain_trim_val;
>> +	int ret;
>> +	int lux_val;
>> +
>> +
>> +	/*This may seem redundant but..
>> +	 We need this next line in case we call this function from an
>> +	 external application who has a different target value than
>> +	 our defaults.
>> +	 In which case, make 'that' our new default/settings.*/
Comment certainly makes me doubt this should be in a merged driver!

>> +	taos_settings.als_cal_target = als_cal_target;
>> +
>> +	ret = i2c_smbus_write_byte(chip->client, (CMD_REG | CNTRL));
>> +	if (ret < 0) {
>> +		dev_err(devp,
>> +		"i2c_smbus_write_byte to cmd reg failed in "
>> +		"ioctl als_calibrate\n");
>> +		return ret;
>> +	}
>> +	reg_val = i2c_smbus_read_byte(chip->client);
>> +
>> +	if ((reg_val & (CNTL_ADC_ENBL | CNTL_PWRON))
>> +			!= (CNTL_ADC_ENBL | CNTL_PWRON)) {
>> +		dev_err(devp,
>> +		"reg_val & (CNTL_ADC_ENBL | CNTL_PWRON)) "
>> +		"!= (CNTL_ADC_ENBL | CNTL_PWRON) in ioctl als_calibrate\n");
>> +		return -ENODATA;
>> +	}
>> +
>> +	ret = i2c_smbus_write_byte(chip->client, (CMD_REG | STATUS));
>> +	if (ret < 0) {
>> +		dev_err(devp,
>> +		"i2c_smbus_write_byte to cmd reg failed in "
>> +		"ioctl als_calibrate\n");
>> +		return ret;
>> +	}
>> +	reg_val = i2c_smbus_read_byte(chip->client);
>> +
>> +	if ((reg_val & STA_ADCVALID) != STA_ADCVALID) {
>> +		dev_err(devp,
>> +		"(reg_val & STA_ADCVALID) != STA_ADCVALID in "
>> +		"ioctl als_calibrate\n");
>> +		return -ENODATA;
>> +	}
>> +	lux_val = taos_get_lux();
>> +	if (lux_val < 0) {
>> +		dev_err(devp,
>> +		"taos_get_lux() returned bad value %d in "
>> +		"ioctl als_calibrate\n",
>> +		    lux_val);
>> +		return lux_val;
>> +	}
>> +	gain_trim_val = (unsigned int) (((taos_settings.als_cal_target)
>> +			* taos_settings.als_gain_trim) / lux_val);
>> +
>> +	dev_info(devp, "\n\ntaos_settings.als_cal_target = %d\n"
>> +		"taos_settings.als_gain_trim = %d\nlux_val = %d\n",
>> +		taos_settings.als_cal_target,
>> +		taos_settings.als_gain_trim,
>> +		lux_val);
>> +
>> +	if ((gain_trim_val < 250) || (gain_trim_val > 4000)) {
>> +		dev_err(devp,
>> +		"ALS calibrate result %d out of range "
>> +		"in ioctl als_calibrate\n",
>> +		    gain_trim_val);
>> +		return -ENODATA;
>> +	}
>> +	taos_settings.als_gain_trim = (int) gain_trim_val;
>> +
>> +	return (int) gain_trim_val;
>> +}
>> +EXPORT_SYMBOL(taos_als_calibrate);
>> +
>> +/*........................................................................*/
>> +/*@} End of ALS section*/
>> +
>> +/*===========================================================================*/
>> +/**@defgroup DEV_CTRL Device Control Functions
>> + * @{
>> + */
>> +
>> +/*........................................................................*/
>> +/**
>> + * Turn the device on.
>> + * Configuration and taos_cycle_type must be set before calling this
>> function.
>> + * \param 	none.
>> + * \return 	int	0 = success, < 0 = failure
>> + */
>> +static int taos_chip_on()
>> +{
>> +	int i;
>> +	int ret = 0;
>> +	u8 *uP;
>> +	u8 utmp;
>> +	int als_count;
>> +	int als_time;
>> +
>> +
>> +	/*make sure taos_cycle_type is set.*/
>> +	if ((taos_cycle_type != LIGHT))
>> +		return -1;
>> +
>> +	/*and make sure we're not already on*/
>> +	if (taos_chip_status == TAOS_CHIP_WORKING) {
>> +		/*if forcing a register update - turn off, then on*/
>> +		printk(KERN_INFO "device is already enabled\n");
>> +		return -1;
>> +	}
>> +
>> +	/* . . . . . . . . SHADOW REGISTER
>> INITIALIZATION . . . . . . . . . . .
>> +	 Note:
>> +	 If interrupts are enabled, keeping persist at 0 should prime the
>> pump.
>> +	 So don't set persist in shadow register. Just enable if required.*/
>> +	taos_config[INTERRUPT] = (taos_settings.interrupts_enabled & 0xF0);
>> +
>> +
>> +	/*determine als integration regster*/
>> +	als_count = (taos_settings.als_time * 100 + 135) / 270;
>> +	if (als_count == 0)
>> +		als_count = 1; /*ensure at least one cycle*/
>> +
>> +
>> +	/*convert back to time (encompasses overrides)*/
>> +	if (taos_cycle_type & LIGHT) {
>> +		als_time = (als_count * 27 + 5) / 10;
>> +		taos_config[ALS_TIME] = 256 - als_count;
>> +	} else
>> +		taos_config[ALS_TIME] = 0xff;
>> +
>> +
>> +	/*Set the gain based on taos_settings struct*/
>> +	taos_config[GAIN] = taos_settings.als_gain;
>> +
>> +
>> +	/*set globals re scaling and saturation*/
>> +	als_saturation = als_count * 922; /*90% of full scale*/
>> +	als_time_scale = (als_time + 25) / 50;
>> +
>> +
>> +	/* . . . . . . . . . . . . .  . . . . .  . . . . . . . . . . .
>> +	 SKATE Specific power-on / adc enable sequence
>> +	 Power on the device 1st.*/
>> +	utmp = CNTL_PWRON;
>> +	ret = taos_i2c_write(CMD_REG | CNTRL, &utmp);
>> +	if (ret < 0) {
>> +		dev_err(devp,
>> +		"taos_i2c_write to turn on device failed in "
>> +		"taos_chip_on.\n");
>> +		return -1;
>> +	}
>> +
>> +	/*User the following shadow copy for our delay before enabling ADC
>> +	 Write ALL THE REGISTERS*/
>> +	for (i = 0, uP = taos_config; i < TAOS_REG_MAX; i++) {
>> +		ret = taos_i2c_write(CMD_REG + i, uP++);
>> +		if (ret < 0) {
>> +			dev_err(devp,
>> +			"taos_i2c_write to reg %d failed in "
>> +			"taos_chip_on.\n", i);
>> +			return -1;
>> +		}
>> +	}
>> +
>> +	mdelay(3);
>> +	/*NOW enable the ADC
>> +	 initialize the desired mode of operation*/
>> +	utmp = CNTL_PWRON | CNTL_ADC_ENBL;
>> +	ret = taos_i2c_write(CMD_REG | CNTRL, &utmp);
>> +	if (ret < 0) {
>> +		dev_err(devp,
>> +		"taos_i2c_write to turn on device failed in "
>> +		"taos_chip_on.\n");
>> +		return -1;
>> +	}
>> +	taos_chip_status = TAOS_CHIP_WORKING;
>> +
>> +#ifdef TAOS_DEBUG
>> +	dev_info(devp, "chip_on() called\n\n");
>> +#endif
>> +
>> +	return ret; /*returns result of last i2cwrite*/
>> +}
>> +EXPORT_SYMBOL(taos_chip_on);
>> +
>> +/*........................................................................*/
>> +/**
>> + * Turn the device OFF.
>> + * \param	none.
>> + * \return	int	0 = success, < 0 = failure
>> + */
>> +static int taos_chip_off()
>> +{
>> +	int ret;
>> +	u8 utmp;
>> +
>> +
>> +	/*turn device off*/
>> +	taos_chip_status = TAOS_CHIP_SLEEP;
>> +	utmp = 0x00;
>> +	ret = taos_i2c_write(CMD_REG | CNTRL, &utmp);
>> +	als_on = FALSE;
>> +	/*init_done = 0x00; *//*used by ALS irq as one/first shot*/
>> +#ifdef TAOS_DEBUG
>> +	printk(KERN_INFO "chip_off() called\n");
>> +#endif
>> +
>> +	return ret;
>> +
>> +}
>> +EXPORT_SYMBOL(taos_chip_off);
>> +/*........................................................................*/
>> +/*@} End of Device Control Section*/
>> +
>> +/*===========================================================================*/
>> +
>> +/*===========================================================================*/
>> +/**@defgroup I2C-HAL I2C/SMBus Communication Functions
>> + * The sections pertains to the driver/device communication functions\n
>> + * facilitated via SMBus in an I2C manner.\n
>> + * These functions represent several layers of abstraction.
>> + * Also note, some i2c controllers do not support block read/write.
>> + * @{
>> + */
>> +
>> +/**
>> + * Read a number of bytes starting at register (reg) location.
>> + *
>> + * \param 	unsigned char 	reg - device register
>> + * \param 	unsigned char	*val - location to store results
>> + * \param 	unsigned int 	number of bytes to read
>> + * \return	TAOS_SUCCESS, or i2c_smbus_write_byte ERROR code
>> + *
>> + */
>> +static int taos_i2c_read(u8 reg, u8 *val, unsigned int len)
>> +{
>> +	int result;
>> +	int i;
>> +
>> +	if (len > MAXI2C)
>> +		len = MAXI2C;
>> +	for (i = 0; i < len; i++) {
>> +		/* select register to write */
>> +		if (reg >= 0) {
>> +			result = i2c_smbus_write_byte(chip->client,
>> +				(CMD_REG | (reg + i)));
>> +
>> +			if (result < 0) {
>> +				dev_err(devp,
>> +				"FAILED: i2c_smbus_write_byte_data in "
>> +				"taos_io_read()\n");
>> +				return result;
>> +			}
>> +			/* read the data */
>> +			*val = i2c_smbus_read_byte(chip->client);
>> +#ifdef TAOS_DEBUG_SMBUS
Use debug macros found in kernel for this rather than defining your
own.
>> +			dev_info(devp,
>> +				"READ FROM REGISTER [%02X] -->%02x<--\n",
>> +				(CMD_REG | (reg + i)) , *data);
>> +#endif
>> +			val++;
>> +		}
>> +	}
>> +	return TAOS_SUCCESS;
>> +}
>> +
>> +/**
>> + * This function is used to send a an register address followed by a
>> data value
>> + * When calling this function remember to set the register MSBit
>> + * (if applicable).
>> + * \param  unsigned char register
>> + * \param  unsigned char * pointer to data value(s) to be written
>> + * \return TAOS_SUCCESS, or i2c_smbus_write_byte error code.
>> + */
Don't do this.  Just call the i2c_smbus_write inline within your code.
The wrapper doesn't add any real value.

>> +static int taos_i2c_write(u8 reg, u8 *val)
>> +{
>> +	int retval;
>> +	retval = i2c_smbus_write_byte_data(chip->client, reg, (*val));
>> +	if (retval < 0) {
>> +		dev_err(devp, "FAILED: i2c_smbus_write_byte_data\n");
>> +		return retval;
>> +	}
>> +
>> +	return TAOS_SUCCESS;
>> +}
>> +
>> +/**
>> + * This function is used to send a command to device command/control
>> register
>> + * All bytes sent using this command have their MSBit set - it's a
>> command!
>> + * \param  unsigned char register to write
>> + * \return TAOS_SUCCESS, or i2c_smbus_write_byte error code.
>> + */
>> +static int taos_i2c_write_command(u8 reg)
>> +{
>> +	int result;
>> +	u8 *p;
>> +	u8 buf;
>> +
>> +	p = &buf;
>> +	*p = reg |= CMD_REG;
>> +	/*write the data*/
>> +	result = i2c_smbus_write_byte(chip->client, (*p));
>> +	if (result < 0) {
>> +		dev_err(devp, "FAILED: i2c_smbus_write_byte\n");
>> +		return result;
>> +	}
>> +	return TAOS_SUCCESS;
>> +}
>> +
>> +/*........................................................................*/
>> +/*@}	//end of I2C-HAL section*/
>> +
>> +
>> +/**@defgroup group6 Sysfs Interface Functions
>> + * The following functions are for access via the sysfs style
>> interface.\n
>> + * Use 'cat' to read, 'echo >' to write\n
>> + * @{
>> + */
>> +
>> +/*........................................................................*/
>> +/*sysfs interface functions begin here*/
>> +
>> +static ssize_t taos_device_id(struct device *dev,
>> +    struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%s %s\n", DEVICE_ID, DRIVER_VERSION_ID);
>> +}
>> +
Ideally this would use runtime pm to handle things rather than doing
it explicitly, but this might be acceptable in the meantime...
>> +static ssize_t taos_power_state_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%d\n", taos_chip_status);
>> +	return 0;
>> +}
>> +
>> +static ssize_t taos_power_state_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +	unsigned long value;
>> +
>> +	if (strict_strtoul(buf, 0, &value))
>> +		return -EINVAL;
>> +
>> +	if (value == 1)
>> +		taos_chip_on();
>> +	else
>> +		taos_chip_off();
>> +
>> +	return len;
>> +}
>> +
>> +static ssize_t taos_gain_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%d\n", taos_settings.als_gain);
>> +	return 0;
>> +}
>> +
>> +static ssize_t taos_gain_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +	unsigned long value;
>> +	if (strict_strtoul(buf, 0, &value))
>> +		return -EINVAL;
>> +	if (value) {
>> +		if (value > 4) {
>> +			printk(KERN_INFO "Invalid Gain Index\n");
>> +			return -1;
>> +		} else {
>> +			taos_settings.als_gain = value;
>> +		}
>> +	}
>> +	return len;
>> +}
>> +
>> +static ssize_t taos_interrupt_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%d\n", taos_settings.interrupts_enabled);
>> +	return 0;
>> +}
>> +
>> +static ssize_t taos_interrupt_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +	unsigned long value;
>> +	if (strict_strtoul(buf, 0, &value))
>> +		return -EINVAL;
>> +
>> +	if (value) {
>> +		if (value > 1) {
>> +			printk(KERN_INFO "Invalid: 0 or 1\n");
>> +			return -1;
>> +		} else {
>> +			taos_settings.interrupts_enabled = CNTL_ALS_INT_ENBL;
>> +		}
>> +	}
>> +	return len;
>> +}
>> +
>> +static ssize_t taos_als_time_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%d\n", taos_settings.als_time);
>> +	return 0;
>> +}
>> +
>> +static ssize_t taos_als_time_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +	unsigned long value;
>> +	if (strict_strtoul(buf, 0, &value))
>> +		return -EINVAL;
>> +
>> +	if (value)
>> +		taos_settings.als_time = value;
>> +
>> +	return len;
>> +}
>> +
>> +static ssize_t taos_als_trim_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%d\n", taos_settings.als_gain_trim);
>> +	return 0;
>> +}
>> +
>> +static ssize_t taos_als_trim_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +	unsigned long value;
>> +	if (strict_strtoul(buf, 0, &value))
>> +		return -EINVAL;
>> +
>> +	if (value)
>> +		taos_settings.als_gain_trim = value;
>> +
>> +	return len;
>> +}
>> +
>> +static ssize_t taos_als_persistence_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%d\n", taos_settings.als_persistence);
>> +	return 0;
>> +}
>> +
>> +static ssize_t taos_als_persistence_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +	unsigned long value;
>> +	if (strict_strtoul(buf, 0, &value))
>> +		return -EINVAL;
>> +
>> +	if (value)
>> +		taos_settings.als_persistence = value;
>> +
>> +	return len;
>> +}
>> +
>> +static ssize_t taos_als_cal_target_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%d\n", taos_settings.als_cal_target);
>> +	return 0;
>> +}
>> +
>> +static ssize_t taos_als_cal_target_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +	unsigned long value;
>> +	if (strict_strtoul(buf, 0, &value))
>> +		return -EINVAL;
>> +
>> +	if (value)
>> +		taos_settings.als_cal_target = value;
>> +
>> +	return len;
>> +}
>> +
>> +static ssize_t taos_lux_show(struct device *dev, struct
>> device_attribute *attr,
>> +    char *buf)
>> +{
>> +	int lux = 0;
>> +	if ((taos_settings.interrupts_enabled & CNTL_ALS_INT_ENBL) == 0x00)
>> +		lux = taos_get_lux(); /*get fresh data*/
>> +	else
>> +		lux = als_cur_info.lux; /*data is fresh as last change*/
>> +
>> +	return sprintf(buf, "%d\n", lux);
>> +	return 0;
>> +}
>> +
>> +static ssize_t taos_do_calibrate(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +	unsigned long value;
>> +	if (strict_strtoul(buf, 0, &value))
>> +		return -EINVAL;
>> +
>> +	if (value == 1)
>> +		taos_als_calibrate(taos_settings.als_cal_target);
>> +
>> +	return len;
>> +}
>> +
>> +static ssize_t taos_als_thresh_low_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%d\n", taos_settings.als_thresh_low);
>> +	return 0;
>> +}
>> +
>> +static ssize_t taos_als_thresh_low_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +	unsigned long value;
>> +	if (strict_strtoul(buf, 0, &value))
>> +		return -EINVAL;
>> +
>> +	if (value)
>> +		taos_settings.als_thresh_low = value;
>> +
>> +	return len;
>> +}
>> +
>> +static ssize_t taos_als_thresh_high_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%d\n", taos_settings.als_thresh_high);
>> +	return 0;
>> +}
>> +
>> +static ssize_t taos_als_thresh_high_store(struct device *dev,
>> +    struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +	unsigned long value;
>> +	if (strict_strtoul(buf, 0, &value))
>> +		return -EINVAL;
>> +
>> +	if (value)
>> +		taos_settings.als_thresh_high = value;
>> +
>> +	return len;
>> +}
>> +
Irrelevant and cryptic comment. Please remove.
>> +/*@}	End of Sysfs Interface Functions - gp6*/
>> +/*===========================================================================*/
>> +
>> +static void taos_als_auto_update(struct work_struct *update)
>> +{
>> +	if (taos_chip_status != TAOS_CHIP_WORKING) {
>> +		taos_chip_on();
>> +		mdelay(100);
>> +	}
>> +	taos_get_lux();
>> +	input_report_abs(taos_dev, ABS_X, als_cur_info.lux);
>> +	input_sync(taos_dev);
>> +
>> +	queue_delayed_work(taos_wq0, luxUd, LUX_UPDATE_PERIOD);
>> +
Bonus white line.
>> +}
>> +
>> +
>> +
>> +MODULE_AUTHOR("J. August Brenner<jbrenner@taosinc.com>");
>> +MODULE_DESCRIPTION("TAOS 258x ambient light sensor driver");
>> +MODULE_LICENSE("GPL");
>> +
These shoule be under the actual functions rather than stuck at the end
like this.  As a generaly rule, those two would be the last functions in the
file as thats where everyone expects to find them.

>> +module_init(taos_init);
>> +module_exit(taos_exit);
>> +
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

