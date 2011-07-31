Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1GaWbM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:31:12 -0400
Received: from mail4.aviatnet.com ([192.147.115.31]:11574 "EHLO
	mail4.aviatnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1GaWbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:31:04 -0400
Subject: Re: [PATCH 2.6.39-rc7] RTC: rtc-ds1307 EEPROM support for ds1388
 chip
From: Austin Boyle <Austin.Boyle@aviatnet.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20110722145451.78390257.akpm@linux-foundation.org>
References: <1306127917.3071.32.camel@pc786-ubu.gnet.global.vpn>
	 <1308024897.2992.39.camel@pc786-ubu.gnet.global.vpn>
	 <20110722145451.78390257.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 1 Aug 2011 10:30:57 +1200
Message-ID: <1312151457.24642.5747.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.1.66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thank you very much for your feedback. I have corrected the issues you raised as follows. 
The updated patch has been appended.

On Fri, 2011-07-22 at 14:54 -0700, Andrew Morton wrote:
> On Tue, 14 Jun 2011 16:14:57 +1200
> Austin Boyle <Austin.Boyle@aviatnet.com> wrote:
> 
> > On Mon, 2011-05-23 at 17:18 +1200, Austin Boyle wrote:
> > > This is my patch which extends the NVRAM access functions in the DS1307
> > > driver to support the 512 bytes of EEPROM on the DS1388 chip. Could you
> > > please review the patch? If there are any problems with the way I have
> > > implemented this or suggested improvements I will gladly modify. Thanks!
> > 
> > This is an updated version of the patch which prints the correct NVRAM
> > size at init. Could someone please give me some feedback?
> > 
> > [PATCH 3.0-rc3] RTC: rtc-ds1307: EEPROM support for ds1388 chip
> > 
> > This patch adds support for different sized NVRAM, such as
> > the 512 bytes of EEPROM on the DS1388 chip.
> 
> The patch is wordwrapped - please fix your email client.
Done.
> 
> The patch makes rather a mess of a decent-looking driver.  Please use
> scripts/checkpatch.pl and review its report.
> 
Fixed all errors and warnings.
> >
> > ...
> >
> > @@ -540,18 +545,39 @@ ds1307_nvram_read(struct file *filp, str
> >  	struct i2c_client	*client;
> >  	struct ds1307		*ds1307;
> >  	int			result;
> > +	unsigned int		addr = 0;
> >  
> >  	client = kobj_to_i2c_client(kobj);
> >  	ds1307 = i2c_get_clientdata(client);
> >  
> > -	if (unlikely(off >= NVRAM_SIZE))
> > +	if (unlikely(off >= ds1307->nvram_size))
> >  		return 0;
> > -	if ((off + count) > NVRAM_SIZE)
> > -		count = NVRAM_SIZE - off;
> > +	if ((off + count) > ds1307->nvram_size)
> > +		count = ds1307->nvram_size - off;
> >  	if (unlikely(!count))
> >  		return count;
> >  
> > -	result = ds1307->read_block_data(client, 8 + off, count, buf);
> > +	if (ds1307->nvram_offset < 0xff) {	/* ds1307, ds1338 */
> > +		result = ds1307->read_block_data(client, ds1307->nvram_offset + off,
> > count, buf);
> > +	} else	{	/* ds1388 */
> > +		if ((off <= 0x00ff) && (off + count > 0x00ff))	{	/* read spans two
> > blocks */
> > +			client = ds1307->client[1];		/* first block */
> > +			addr = (unsigned int)off;
> > +			result = ds1307->read_block_data(client, addr, (0x100-addr), buf);
> 
> Ignores a possible error return value?
Added check.
> 
> > +			client = ds1307->client[2];		/* second block */
> > +			result += ds1307->read_block_data(client, 0x00, (count+addr-0x100),
> > (buf+0x100-addr));
> > +
> > +		} else { 	/* read spans one blocks */
> > +			if (off <= 0x00ff)	{
> > +				client = ds1307->client[1];
> > +				addr = (unsigned int)off;
> > +			} else if (off <= 0x0200)	{
> > +				client = ds1307->client[2];
> > +				addr = (unsigned int)off - 0x100;
> > +			}
> > +			result = ds1307->read_block_data(client, addr, count, buf);
> > +		}
> > +	}
> >  	if (result < 0)
> >  		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
> >  	return result;
> > @@ -565,18 +591,40 @@ ds1307_nvram_write(struct file *filp, st
> >  	struct i2c_client	*client;
> >  	struct ds1307		*ds1307;
> >  	int			result;
> > +	unsigned int		addr = 0;
> >  
> >  	client = kobj_to_i2c_client(kobj);
> >  	ds1307 = i2c_get_clientdata(client);
> >  
> > -	if (unlikely(off >= NVRAM_SIZE))
> > +	if (unlikely(off >= ds1307->nvram_size))
> >  		return -EFBIG;
> > -	if ((off + count) > NVRAM_SIZE)
> > -		count = NVRAM_SIZE - off;
> > +	if ((off + count) > ds1307->nvram_size)
> > +		count = ds1307->nvram_size - off;
> >  	if (unlikely(!count))
> >  		return count;
> >  
> > -	result = ds1307->write_block_data(client, 8 + off, count, buf);
> > +	if (ds1307->nvram_offset < 0xff) {	/* ds1307, ds1338 */
> > +		result = ds1307->write_block_data(client, ds1307->nvram_offset + off,
> > count, buf);
> > +	} else	{	/* ds1388 */
> > +		if ((off <= 0x00ff) && ((off + count) > 0x00ff))	{  /* read spans two
> > blocks */
> > +			client = ds1307->client[1];		/* first block */
> > +			addr = (unsigned int)off;
> > +			result = ds1307->write_block_data(client, addr, (0x100-addr), buf);
> 
> Error checking?
Added.
> 
> > +			client = ds1307->client[2];		/* second block */
> > +			result = ds1307->write_block_data(client, 0x00, (addr+count-0x100),
> > (buf+0x100-addr));
> > +
> > +		} else { /* Device address/offset translation */
> > +			dev_dbg(&client->dev, "Write spans one block\n");
> > +			if (off <= 0x00ff)	{
> 
> A single space before the {
Fixed.
> 
> > +				client = ds1307->client[1];
> > +				addr = (unsigned int)off;
> > +			} else if (off <= 0x0200)	{
> 
> ditto
Fixed.
> 
> > +				client = ds1307->client[2];
> > +				addr = (unsigned int)off - 0x100;
> > +			}
> > +			result = ds1307->write_block_data(client, addr, count, buf);
> > +		}
> > +	}
> >  	if (result < 0) {
> >  		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
> >  		return result;
> >
> > ...
> >
> > @@ -866,16 +923,35 @@ read_rtc:
> >  		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
> >  	}
> >  
> > -	if (chip->nvram56) {
> > +	if (chip->nvram) {
> > +		nvram.size = ds1307->nvram_size;
> >  		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
> >  		if (err == 0) {
> >  			set_bit(HAS_NVRAM, &ds1307->flags);
> > -			dev_info(&client->dev, "56 bytes nvram\n");
> > +			dev_info(&client->dev, "%d bytes nvram\n", nvram.size);
> > +		}
> > +	}
> > +
> > +	/* use dummy devices for multiple address chips */
> > +	for (i = 1; i < ds1307->num_addrs; i++) {
> > +		ds1307->client[i] = i2c_new_dummy(client->adapter, client->addr + i);
> > +		if (!ds1307->client[i]) {
> > +			dev_err(&client->dev, "address 0x%02x unavailable\n",
> > +					client->addr + i);
> > +			err = -EADDRINUSE;
> 
> EADDRINUSE is a networking error code.  Returning that from an
> rtc-related operation might mislead the operator.
Fixed. Now returns -EBUSY, the same as rtc-s35390a does.
> 
> 
> > +			goto err_clients;
> >  		}
> > +		i2c_set_clientdata(ds1307->client[i], ds1307);
> >  	}
> >  
> >  	return 0;
> >  
> > +err_clients:
> > +	for (i = 1; i < ds1307->num_addrs; i++)	{
> > +		if (ds1307->client[i])	{
> > +			i2c_unregister_device(ds1307->client[i]);
> > +		}
> 
> We normally omit braces around a single statement.
Fixed.
> 
> The `if (ds1307->client[i])' test should be unneeded anyway - just
> unregister client[1] though client[i - 1].
> 
> Why isn't client[0] used here btw?
> 
This loop is only unregistering the dummy i2c devices that were created. The same behaviour as rtc-s35390a.

---

[PATCH 3.0] RTC: EEPROM support for DS1388

This patch adds support for different sized NVRAM, such as
the 512 bytes of EEPROM on the DS1388 chip.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Austin Boyle <austin.boyle@aviatnet.com>
---
diff -upNr a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c	2011-06-29 11:59:29.275414436 +1200
+++ b/drivers/rtc/rtc-ds1307.c	2011-08-01 10:17:42.415351158 +1200
@@ -95,15 +95,19 @@ enum ds_type {
 #	define RX8025_BIT_VDET		0x40
 #	define RX8025_BIT_XST		0x20
 
+#define DS1307_MAX_NUM_ADDRS	3
 
 struct ds1307 {
 	u8			offset; /* register's offset */
+	u16			nvram_size;
+	u16			nvram_offset;
+	u8			num_addrs;
 	u8			regs[11];
 	enum ds_type		type;
 	unsigned long		flags;
 #define HAS_NVRAM	0		/* bit 0 == sysfs file active */
 #define HAS_ALARM	1		/* bit 1 == irq claimed */
-	struct i2c_client	*client;
+	struct i2c_client	*client[DS1307_MAX_NUM_ADDRS];
 	struct rtc_device	*rtc;
 	struct work_struct	work;
 	s32 (*read_block_data)(const struct i2c_client *client, u8 command,
@@ -113,23 +117,26 @@ struct ds1307 {
 };
 
 struct chip_desc {
-	unsigned		nvram56:1;
+	unsigned		nvram:1;
 	unsigned		alarm:1;
 };
 
 static const struct chip_desc chips[] = {
 [ds_1307] = {
-	.nvram56	= 1,
+	.nvram		= 1,
 },
 [ds_1337] = {
 	.alarm		= 1,
 },
 [ds_1338] = {
-	.nvram56	= 1,
+	.nvram		= 1,
 },
 [ds_1339] = {
 	.alarm		= 1,
 },
+[ds_1388] = {
+	.nvram		= 1,
+},
 [ds_1340] = {
 },
 [ds_3231] = {
@@ -249,7 +256,7 @@ static void ds1307_work(struct work_stru
 	int			stat, control;
 
 	ds1307 = container_of(work, struct ds1307, work);
-	client = ds1307->client;
+	client = ds1307->client[0];
 	lock = &ds1307->rtc->ops_lock;
 
 	mutex_lock(lock);
@@ -295,7 +302,7 @@ static int ds1307_get_time(struct device
 	int		tmp;
 
 	/* read the RTC date and time registers all at once */
-	tmp = ds1307->read_block_data(ds1307->client,
+	tmp = ds1307->read_block_data(ds1307->client[0],
 		ds1307->offset, 7, ds1307->regs);
 	if (tmp != 7) {
 		dev_err(dev, "%s error %d\n", "read", tmp);
@@ -373,7 +380,7 @@ static int ds1307_set_time(struct device
 		"write", buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6]);
 
-	result = ds1307->write_block_data(ds1307->client,
+	result = ds1307->write_block_data(ds1307->client[0],
 		ds1307->offset, 7, buf);
 	if (result < 0) {
 		dev_err(dev, "%s error %d\n", "write", result);
@@ -531,8 +538,6 @@ static const struct rtc_class_ops ds13xx
 
 /*----------------------------------------------------------------------*/
 
-#define NVRAM_SIZE	56
-
 static ssize_t
 ds1307_nvram_read(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *attr,
@@ -541,19 +546,49 @@ ds1307_nvram_read(struct file *filp, str
 	struct i2c_client	*client;
 	struct ds1307		*ds1307;
 	int			result;
+	unsigned int		addr = 0;
 
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->nvram_size))
 		return 0;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram_size)
+		count = ds1307->nvram_size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->read_block_data(client, 8 + off, count, buf);
-	if (result < 0)
+	if (ds1307->nvram_offset < 0xff) {
+		result = ds1307->read_block_data(client,
+						ds1307->nvram_offset + off,
+						count, buf);
+	} else {
+		/* read spans two blocks */
+		if ((off <= 0x00ff) && (off + count > 0x00ff)) {
+			client = ds1307->client[1];
+			addr = (unsigned int)off;
+			result = ds1307->read_block_data(client, addr,
+							(0x100-addr), buf);
+			if (result < 0)
+				goto err;
+			client = ds1307->client[2];
+			result = ds1307->read_block_data(client, 0x00,
+							(count+addr-0x100),
+							(buf+0x100-addr));
+		/* read spans one blocks */
+		} else {
+			if (off <= 0x00ff) {
+				client = ds1307->client[1];
+				addr = (unsigned int)off;
+			} else if (off <= 0x0200) {
+				client = ds1307->client[2];
+				addr = (unsigned int)off - 0x100;
+			}
+			result = ds1307->read_block_data(client, addr,
+							count, buf);
+		}
+	}
+err:	if (result < 0)
 		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
 	return result;
 }
@@ -566,19 +601,49 @@ ds1307_nvram_write(struct file *filp, st
 	struct i2c_client	*client;
 	struct ds1307		*ds1307;
 	int			result;
+	unsigned int		addr = 0;
 
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->nvram_size))
 		return -EFBIG;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram_size)
+		count = ds1307->nvram_size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->write_block_data(client, 8 + off, count, buf);
-	if (result < 0) {
+	if (ds1307->nvram_offset < 0xff) {
+		result = ds1307->write_block_data(client,
+						ds1307->nvram_offset + off,
+						count, buf);
+	} else {
+		/* read spans two blocks */
+		if ((off <= 0x00ff) && ((off + count) > 0x00ff)) {
+			client = ds1307->client[1];
+			addr = (unsigned int)off;
+			result = ds1307->write_block_data(client, addr,
+							(0x100-addr), buf);
+			if (result < 0)
+				goto err;
+			client = ds1307->client[2];
+			result = ds1307->write_block_data(client, 0x00,
+							(addr+count-0x100),
+							(buf+0x100-addr));
+		/* read spans one blocks */
+		} else {
+			if (off <= 0x00ff) {
+				client = ds1307->client[1];
+				addr = (unsigned int)off;
+			} else if (off <= 0x0200) {
+				client = ds1307->client[2];
+				addr = (unsigned int)off - 0x100;
+			}
+			result = ds1307->write_block_data(client, addr,
+							count, buf);
+		}
+	}
+err:	if (result < 0) {
 		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
 		return result;
 	}
@@ -593,7 +658,6 @@ static struct bin_attribute nvram = {
 
 	.read	= ds1307_nvram_read,
 	.write	= ds1307_nvram_write,
-	.size	= NVRAM_SIZE,
 };
 
 /*----------------------------------------------------------------------*/
@@ -606,6 +670,7 @@ static int __devinit ds1307_probe(struct
 	struct ds1307		*ds1307;
 	int			err = -ENODEV;
 	int			tmp;
+	int			i;
 	const struct chip_desc	*chip = &chips[id->driver_data];
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			want_irq = false;
@@ -625,9 +690,10 @@ static int __devinit ds1307_probe(struct
 
 	i2c_set_clientdata(client, ds1307);
 
-	ds1307->client	= client;
+	ds1307->client[0] = client;
 	ds1307->type	= id->driver_data;
 	ds1307->offset	= 0;
+	ds1307->num_addrs = 1;
 
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
@@ -643,12 +709,12 @@ static int __devinit ds1307_probe(struct
 	case ds_1339:
 	case ds_3231:
 		/* has IRQ? */
-		if (ds1307->client->irq > 0 && chip->alarm) {
+		if (client->irq > 0 && chip->alarm) {
 			INIT_WORK(&ds1307->work, ds1307_work);
 			want_irq = true;
 		}
 		/* get registers that the "rtc" read below won't read... */
-		tmp = ds1307->read_block_data(ds1307->client,
+		tmp = ds1307->read_block_data(client,
 				DS1337_REG_CONTROL, 2, buf);
 		if (tmp != 2) {
 			pr_debug("read error %d\n", tmp);
@@ -682,7 +748,7 @@ static int __devinit ds1307_probe(struct
 		break;
 
 	case rx_8025:
-		tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+		tmp = i2c_smbus_read_i2c_block_data(client,
 				RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
 		if (tmp != 2) {
 			pr_debug("read error %d\n", tmp);
@@ -748,6 +814,14 @@ static int __devinit ds1307_probe(struct
 		break;
 	case ds_1388:
 		ds1307->offset = 1; /* Seconds starts at 1 */
+		ds1307->num_addrs = 3;	/* uses 3 I2C addrs */
+		ds1307->nvram_size = 512; /* 512 bytes EEPROM */
+		ds1307->nvram_offset = 0xff;
+		break;
+	case ds_1307:
+	case ds_1338:
+		ds1307->nvram_size = 56; /* 56 bytes NVRAM */
+		ds1307->nvram_offset = 8;
 		break;
 	default:
 		break;
@@ -755,7 +829,7 @@ static int __devinit ds1307_probe(struct
 
 read_rtc:
 	/* read RTC registers */
-	tmp = ds1307->read_block_data(ds1307->client, ds1307->offset, 8, buf);
+	tmp = ds1307->read_block_data(client, ds1307->offset, 8, buf);
 	if (tmp != 8) {
 		pr_debug("read error %d\n", tmp);
 		err = -EIO;
@@ -867,16 +941,34 @@ read_rtc:
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
 
-	if (chip->nvram56) {
+	if (chip->nvram) {
+		nvram.size = ds1307->nvram_size;
 		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
 		if (err == 0) {
 			set_bit(HAS_NVRAM, &ds1307->flags);
-			dev_info(&client->dev, "56 bytes nvram\n");
+			dev_info(&client->dev, "%d bytes nvram\n", nvram.size);
+		}
+	}
+
+	/* use dummy devices for multiple address chips */
+	for (i = 1; i < ds1307->num_addrs; i++) {
+		ds1307->client[i] = i2c_new_dummy(client->adapter,
+						client->addr + i);
+		if (!ds1307->client[i]) {
+			dev_err(&client->dev, "Address %02x unavailable\n",
+					client->addr + i);
+			err = -EBUSY;
+			goto exit_dummy;
 		}
+		i2c_set_clientdata(ds1307->client[i], ds1307);
 	}
 
 	return 0;
 
+exit_dummy:
+	for (i = 1; i < ds1307->num_addrs; i++)
+		if (ds1307->client[i])
+			i2c_unregister_device(ds1307->client[i]);
 exit_irq:
 	rtc_device_unregister(ds1307->rtc);
 exit_free:


