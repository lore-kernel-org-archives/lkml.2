Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab1FVPpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:45:50 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:43578 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab1FVPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:45:49 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E02100C.2000408@cam.ac.uk>
Date: Wed, 22 Jun 2011 16:53:48 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Bryan Freed <bfreed@chromium.org>, linux-kernel@vger.kernel.org,
        jbrenner@taosinc.com, gregkh@suse.de, arnd@arndb.de,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [PATCH 1/3] light sensor: Add SMBUS support to the tsl2563 driver.
References: <1308696897-25161-1-git-send-email-bfreed@chromium.org>	<4E01B068.3090102@cam.ac.uk> <20110622161035.5bfe2a73@endymion.delvare>
In-Reply-To: <20110622161035.5bfe2a73@endymion.delvare>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/11 15:10, Jean Delvare wrote:
> On Wed, 22 Jun 2011 10:05:44 +0100, Jonathan Cameron wrote:
>> On 06/21/11 23:54, Bryan Freed wrote:
>>> This is so we can support it on x86 SMBUS adapters.
>> Hi Brian,
>>
>> Please cc linux-iio@vger.kernel.org for iio patches.  Also this driver has fairly
>> clear authorship at the top, so more for your cc list. (added)
>>>
>>> Signed-off-by: Bryan Freed <bfreed@chromium.org>
>>> ---
>>>  drivers/staging/iio/light/tsl2563.c |   29 ++++++++++++++++++++++++++++-
>>>  1 files changed, 28 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
>>> index 9cffa2e..04aa155 100644
>>> --- a/drivers/staging/iio/light/tsl2563.c
>>> +++ b/drivers/staging/iio/light/tsl2563.c
>>> @@ -137,6 +137,8 @@ struct tsl2563_chip {
>>>  	u32			data1;
>>>  };
>>>  
>>> +static int use_smbus;
> 
> Global variables are bad.
+1
> 
>>> +
>>>  static int tsl2563_write(struct i2c_client *client, u8 reg, u8 value)
>>>  {
>>>  	int ret;
>>> @@ -145,15 +147,35 @@ static int tsl2563_write(struct i2c_client *client, u8 reg, u8 value)
>>>  	buf[0] = TSL2563_CMD | reg;
>>>  	buf[1] = value;
>>>  
>>> +	if (use_smbus) {
>>> +		ret = i2c_smbus_write_byte_data(client, buf[0], value);
>>> +		return ret;
>>> +	}
>>> +
>> Here I'd prefer to see this in an else block to make the program flow clear. Same with the others.
>> Actually, is there any reason we can't use the smbus_write_byte_data for all cases?  I 'think'
>> it's emulated via i2c if that is available and smbus is not? (cc'd Jean to confirm this - though
>> a quick code browse of i2c-core.c looks promising.)
>>
>> If smbus_xfer is not supplied by the adapter, i2c_smbus_xfer_emulated is called. 
> 
> You are totally right. Just use smbus all the time and be done with it.
> 
>> The only possible issue I can think of is that a device supports full i2c + a partial smbus
>> support. (rather odd!)
> 
> That would be up to the underlying I2C bus driver to handle, not the
> I2C device drivers individually.
Cool. Good to have that confirmed.
> 
>>>  	ret = i2c_master_send(client, buf, sizeof(buf));
>>>  	return (ret == sizeof(buf)) ? 0 : ret;
>>>  }
>>>  
>>> -static int tsl2563_read(struct i2c_client *client, u8 reg, void *buf, int len)
>>> +static int tsl2563_read(struct i2c_client *client, u8 reg, u8 *buf, int len)
>>>  {
>>>  	int ret;
>>>  	u8 cmd = TSL2563_CMD | reg;
>>>  
>>> +	if (use_smbus) {
>>> +		if (len == 1) {
>>> +			ret = i2c_smbus_read_byte_data(client, cmd);
>>> +			buf[0] = ret & 0xff;
>>> +		} else if (len == 2) {
>>> +			ret = i2c_smbus_read_word_data(client, cmd);
>>> +			buf[0] = ret & 0xff;
>>> +			buf[1] = (ret >> 8) & 0xff;
> 
> swab16 is your friend (and the bogus SMBus byte order convention be
> damned.)
I would imagine the be16_to_cpu etc is even better as we don't know the
cpu endianess. 
> 
>>> +		} else
>>> +			ret = -1;
>> If we hit this something has gone hideously wrong.  Hence please
>> audit the driver to be sure this doesn't happen and don't bother
>> with this extra option.
> 
> +1 In fact the whole tsl2563_read interface should be revisited.
> Passing the length as a parameter makes no sense when using the SMBus
> API. Just have tsl2563_read8() which reads a byte and tsl2563_read16()
> which reads a word, this will be much more efficient, and you get
> proper type checking for free.
Agreed.
> 
>>> +		if (ret < 0)
>>> +			return 0; /* failure */
>> Please return the error, not 0 in event of failure.
>>> +		return len; /* success */
>>> +	}
>>> +
>>>  	ret = i2c_master_send(client, &cmd, sizeof(cmd));
>>>  	if (ret != sizeof(cmd))
>>>  		return ret;
>>> @@ -712,6 +734,11 @@ static int __devinit tsl2563_probe(struct i2c_client *client,
>>>  	int err = 0;
>>>  	int ret;
>>>  	u8 id;
>>> +	u32 smbus_func = I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA;
>> Can this be const?  Oddly, the answer looks to be no.  Given its an inline
> 
> I see no reason why not.
oops. as below, I was clearly asleep this morning...
> 
>> in i2c.h, can't see why this one isn't const.  Jean, am I missing something
>> or wouldn't:
>> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
>> index a6c652e..be5515d 100644
>> --- a/include/linux/i2c.h
>> +++ b/include/linux/i2c.h
>> @@ -458,7 +458,7 @@ static inline u32 i2c_get_functionality(struct i2c_adapter *adap)
>>  }
>>  
>>  /* Return 1 if adapter supports everything we need, 0 if not. */
>> -static inline int i2c_check_functionality(struct i2c_adapter *adap, u32 func)
>> +static inline int i2c_check_functionality(struct i2c_adapter *adap, const u32 func)
>>  {
>>         return (func & i2c_get_functionality(adap)) == func;
>>  }
>>
>> Be a sensible change?
> 
> This is technically correct, as the function doesn't modify the
> parameter, however this change has no effect on the caller. func is
> passed by value, not address, so the caller doesn't care at all whether
> i2c_check_functionality modifies it locally or not.
Doh. I'm half asleep today and failed to notice it wasn't a pointer.
> 
> There are a lot of places where such by-value parameters could be made
> const, however nobody bothers, because it makes the function
> declarations harder to read for virtually no benefit (as opposed to
> const pointers, which do have value for the caller.)
> 
>> For that matter, this code should probably just have that
>> value inline in the function call as it isn't used anywhere else.
> 
> +1
> 
>>
>>> +	/* We support both I2C and SMBUS adapter interfaces. */
>>> +	if (i2c_check_functionality(client->adapter, smbus_func))
>>> +		use_smbus = 1;
>>>  
>>>  	indio_dev = iio_allocate_device(sizeof(*chip));
>>>  	if (!indio_dev)
>>
> 
> 

