Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1LLKrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:47:06 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:48151 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab1LLKrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:47:03 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 12 Dec 2011 11:46:50 +0100
Subject: RE: [PATCHv2 07/10] xshm: XSHM Configuration data handling
Thread-Topic: [PATCHv2 07/10] xshm: XSHM Configuration data handling
Thread-Index: Acy2hJjiJa6WovcaRUuJuQm1isI6MQCNpE7w
Message-ID: <81C3A93C17462B4BBD7E272753C105791FB0D6BBD0@EXDCVYMBSTM005.EQ1STM.local>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
 <1323439648-22697-8-git-send-email-sjur.brandeland@stericsson.com>
 <201112091509.41123.arnd@arndb.de>
In-Reply-To: <201112091509.41123.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBCAlDb9018108

Hi Arnd,

>> This patch implements the configuration handling:
>> - reception of gen-netlink requests from user-space.
>> - calculating address of where to put information in shared memory, i.e
>>   the offset of: IPC-TOC, channel-descriptors, read/write indexes for each
>>   directional channel, and data area of each channel.
>> - formatting of the shared memory area, so modem can read out configuration
>>   data.
>> - Creation of configuration data given to the XSHM drivers: xshm_chr and
>>   caif_xshm.
> 
> Hmm, from what I read here, you rely on the user to create the channels
> that correspond to the ones that the modem side has configured.

Yes, the modem firmware has build-in knowledge of the number and order of the
channels of each type, but it's clue-less about the channel configuration.

The configuration of each channel is provided from user-space via 
netlink. When all channel configuration has been provided, user-space sends
a "commit" command. This triggers calculation of the channel layout, i.e the
offset of channel data area for RX/TX and the channel descriptors. The "commit"
command triggers the writing of a "Table of Content" into shared memory, so the 
modem can read out the details of the channel configuration at startup.

> Why is that? Can't you query from the modem what channels it needs and
> then automatically create those?

The modem isn't running at the time the channels are created. The
channels are used for transferring the boot images.

> > +static bool config_error;
> > +static bool commited;
> > +static bool registered;
> > +static bool addr_set;
> > +static u32 modem_bootimg_size;
> > +static void *shm_start;
> > +static u32 xshm_channels;
> > +static struct xshm_dev *xshmdevs[XSHM_MAX_CHANNELS + 1];
> > +static struct xshm_ipctoc *ipctoc;
> 
> Global variables like this are a bit problematic. What would happen if
> you ever get a system that has access to two devices?
 
Hm, M7400 in this particular configuration is a RAM-less with
Chip-to-Chip memory. I really don't think we'll ever see a setup with 
two RAM-less modems for one Linux host.

> I think you can remove most of these easily. Anything that is specific to the xshm
> modem should just go into the device private data of the modem.

Yes, I guess I can move all these static declarations into a struct anyway.
I'll have a go at this and see what it looks like..


> Do not hold your own list of devices, that's what the generic device
> handling is for. You can e.g. use device_for_each_child on the
> modem device to iterate the channels.

We have a chicken-and-egg problem here. The offset of the
channel descriptors and data buffers cannot be calculated before all
of the channels has been defined. When user space has sent all channels
over netlink, it sends a "commit" command. At this point the addresses of
channel descriptors and buffers are calculated, and this is when
we have the final configuration data available for the devices.

If we register the devices before the "commit", the drivers would
not receive complete configuration data. 

I guess there are a couple of options here: I could register the
devices without a complete configuration and do a re-probe (or similar)
later. The drivers could then ignore the initial registration when the
configuration is not complete. This seems like the most sensible option.

Alternatively I could instead store only the configuration data instead
of the device structure in the array, but this wouldn't actually simplify
the code, so I guess this won't be the best option.

> > +static unsigned long xshm_start;
> > +module_param(xshm_start, ulong, S_IRUGO | S_IWUSR);
> > +MODULE_PARM_DESC(xshm_start, "Address for memory shared by
> host/modem.");
> > +
> > +static unsigned long xshm_c2c_bootaddr;
> > +module_param(xshm_c2c_bootaddr, ulong, S_IRUGO | S_IWUSR);
> > +MODULE_PARM_DESC(xshm_c2c_bootaddr, "Address given to modem (through
> GENI register)");
> > +
> > +static long xshm_size;
> > +module_param(xshm_size, long, S_IRUGO | S_IWUSR);
> > +MODULE_PARM_DESC(xshm_size, "Size of SHM area");
> 
> That looks fragile, you should never have addresses as module arguments.
> Either the kernel should be free to pick a reasonable address and tell
> it to the modem, or the modem should pick an address and then the kernel
> needs a reliable way to find out what it is.

I'll have get back to you about this issue later.

> > +/* sysfs: Write the modem firmware including TOC */
> > +static ssize_t modemfw_write(struct file *f, struct kobject *kobj,
> > +			struct bin_attribute *attr,
> > +			char *buf, loff_t off, size_t count)
> > +{
> > +	if (commited)
> > +		return -EBUSY;
> > +
> > +	if (off + count > xshm_size)
> > +		return -ENOSPC;
> > +	memcpy(shm_start + off, buf, count);
> > +	modem_bootimg_size = off + count;
> > +	return count;
> > +}
> > +
> > +/* sysfs: Modem firmware attribute */
> > +static struct bin_attribute modemfw_attr = {
> > +	.attr = {
> > +		 .name = "bootimg",
> > +		 .mode = S_IRUGO | S_IWUSR,
> > +		 },
> > +	.size = IMG_MAX_SZ,
> > +	.read = modemfw_read,
> > +	.write = modemfw_write
> > +};
> 
> Why don't you use the regular request_firmware() function here?

Sure, I'll look into this.

Regards,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
