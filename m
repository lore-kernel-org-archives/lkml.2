Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab1GVVzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:55:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384Ab1GVVzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:55:35 -0400
Date: Fri, 22 Jul 2011 14:54:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.39-rc7] RTC: rtc-ds1307 EEPROM support for ds1388
 chip
Message-Id: <20110722145451.78390257.akpm@linux-foundation.org>
In-Reply-To: <1308024897.2992.39.camel@pc786-ubu.gnet.global.vpn>
References: <1306127917.3071.32.camel@pc786-ubu.gnet.global.vpn>
	<1308024897.2992.39.camel@pc786-ubu.gnet.global.vpn>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011 16:14:57 +1200
Austin Boyle <Austin.Boyle@aviatnet.com> wrote:

> On Mon, 2011-05-23 at 17:18 +1200, Austin Boyle wrote:
> > This is my patch which extends the NVRAM access functions in the DS1307
> > driver to support the 512 bytes of EEPROM on the DS1388 chip. Could you
> > please review the patch? If there are any problems with the way I have
> > implemented this or suggested improvements I will gladly modify. Thanks!
> 
> This is an updated version of the patch which prints the correct NVRAM
> size at init. Could someone please give me some feedback?
> 
> [PATCH 3.0-rc3] RTC: rtc-ds1307: EEPROM support for ds1388 chip
> 
> This patch adds support for different sized NVRAM, such as
> the 512 bytes of EEPROM on the DS1388 chip.

The patch is wordwrapped - please fix your email client.

The patch makes rather a mess of a decent-looking driver.  Please use
scripts/checkpatch.pl and review its report.

>
> ...
>
> @@ -540,18 +545,39 @@ ds1307_nvram_read(struct file *filp, str
>  	struct i2c_client	*client;
>  	struct ds1307		*ds1307;
>  	int			result;
> +	unsigned int		addr = 0;
>  
>  	client = kobj_to_i2c_client(kobj);
>  	ds1307 = i2c_get_clientdata(client);
>  
> -	if (unlikely(off >= NVRAM_SIZE))
> +	if (unlikely(off >= ds1307->nvram_size))
>  		return 0;
> -	if ((off + count) > NVRAM_SIZE)
> -		count = NVRAM_SIZE - off;
> +	if ((off + count) > ds1307->nvram_size)
> +		count = ds1307->nvram_size - off;
>  	if (unlikely(!count))
>  		return count;
>  
> -	result = ds1307->read_block_data(client, 8 + off, count, buf);
> +	if (ds1307->nvram_offset < 0xff) {	/* ds1307, ds1338 */
> +		result = ds1307->read_block_data(client, ds1307->nvram_offset + off,
> count, buf);
> +	} else	{	/* ds1388 */
> +		if ((off <= 0x00ff) && (off + count > 0x00ff))	{	/* read spans two
> blocks */
> +			client = ds1307->client[1];		/* first block */
> +			addr = (unsigned int)off;
> +			result = ds1307->read_block_data(client, addr, (0x100-addr), buf);

Ignores a possible error return value?

> +			client = ds1307->client[2];		/* second block */
> +			result += ds1307->read_block_data(client, 0x00, (count+addr-0x100),
> (buf+0x100-addr));
> +
> +		} else { 	/* read spans one blocks */
> +			if (off <= 0x00ff)	{
> +				client = ds1307->client[1];
> +				addr = (unsigned int)off;
> +			} else if (off <= 0x0200)	{
> +				client = ds1307->client[2];
> +				addr = (unsigned int)off - 0x100;
> +			}
> +			result = ds1307->read_block_data(client, addr, count, buf);
> +		}
> +	}
>  	if (result < 0)
>  		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
>  	return result;
> @@ -565,18 +591,40 @@ ds1307_nvram_write(struct file *filp, st
>  	struct i2c_client	*client;
>  	struct ds1307		*ds1307;
>  	int			result;
> +	unsigned int		addr = 0;
>  
>  	client = kobj_to_i2c_client(kobj);
>  	ds1307 = i2c_get_clientdata(client);
>  
> -	if (unlikely(off >= NVRAM_SIZE))
> +	if (unlikely(off >= ds1307->nvram_size))
>  		return -EFBIG;
> -	if ((off + count) > NVRAM_SIZE)
> -		count = NVRAM_SIZE - off;
> +	if ((off + count) > ds1307->nvram_size)
> +		count = ds1307->nvram_size - off;
>  	if (unlikely(!count))
>  		return count;
>  
> -	result = ds1307->write_block_data(client, 8 + off, count, buf);
> +	if (ds1307->nvram_offset < 0xff) {	/* ds1307, ds1338 */
> +		result = ds1307->write_block_data(client, ds1307->nvram_offset + off,
> count, buf);
> +	} else	{	/* ds1388 */
> +		if ((off <= 0x00ff) && ((off + count) > 0x00ff))	{  /* read spans two
> blocks */
> +			client = ds1307->client[1];		/* first block */
> +			addr = (unsigned int)off;
> +			result = ds1307->write_block_data(client, addr, (0x100-addr), buf);

Error checking?

> +			client = ds1307->client[2];		/* second block */
> +			result = ds1307->write_block_data(client, 0x00, (addr+count-0x100),
> (buf+0x100-addr));
> +
> +		} else { /* Device address/offset translation */
> +			dev_dbg(&client->dev, "Write spans one block\n");
> +			if (off <= 0x00ff)	{

A single space before the {

> +				client = ds1307->client[1];
> +				addr = (unsigned int)off;
> +			} else if (off <= 0x0200)	{

ditto

> +				client = ds1307->client[2];
> +				addr = (unsigned int)off - 0x100;
> +			}
> +			result = ds1307->write_block_data(client, addr, count, buf);
> +		}
> +	}
>  	if (result < 0) {
>  		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
>  		return result;
>
> ...
>
> @@ -866,16 +923,35 @@ read_rtc:
>  		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
>  	}
>  
> -	if (chip->nvram56) {
> +	if (chip->nvram) {
> +		nvram.size = ds1307->nvram_size;
>  		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
>  		if (err == 0) {
>  			set_bit(HAS_NVRAM, &ds1307->flags);
> -			dev_info(&client->dev, "56 bytes nvram\n");
> +			dev_info(&client->dev, "%d bytes nvram\n", nvram.size);
> +		}
> +	}
> +
> +	/* use dummy devices for multiple address chips */
> +	for (i = 1; i < ds1307->num_addrs; i++) {
> +		ds1307->client[i] = i2c_new_dummy(client->adapter, client->addr + i);
> +		if (!ds1307->client[i]) {
> +			dev_err(&client->dev, "address 0x%02x unavailable\n",
> +					client->addr + i);
> +			err = -EADDRINUSE;

EADDRINUSE is a networking error code.  Returning that from an
rtc-related operation might mislead the operator.


> +			goto err_clients;
>  		}
> +		i2c_set_clientdata(ds1307->client[i], ds1307);
>  	}
>  
>  	return 0;
>  
> +err_clients:
> +	for (i = 1; i < ds1307->num_addrs; i++)	{
> +		if (ds1307->client[i])	{
> +			i2c_unregister_device(ds1307->client[i]);
> +		}

We normally omit braces around a single statement.

The `if (ds1307->client[i])' test should be unneeded anyway - just
unregister client[1] though client[i - 1].

Why isn't client[0] used here btw?

> +	}
>  exit_irq:
>  	rtc_device_unregister(ds1307->rtc);
>  exit_free:

