Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab2EBRZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:25:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47040 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab2EBRZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120502151734.GD16981@andi>
References: <1335967293-7728-1-git-send-email-peter.huewe@infineon.com>
	<1335967416-7564-1-git-send-email-peter.huewe@infineon.com>
	<20120502151734.GD16981@andi>
Date: Wed, 2 May 2012 10:25:09 -0700
X-Google-Sender-Auth: onyZqG_GPc0TVfmumWNW7mgzQ6U
Message-ID: <CAEYUcX0jBHasvcdLefR0fOGrVPaDw3pqzfQ_8_JGXHSPQHW7Ew@mail.gmail.com>
Subject: Re: [PATCH] CHROMIUM: tpm: tpm_tis_i2c: Lock the I2C adapter for a
 sequence of requests.
From: Bryan Freed <bfreed@chromium.org>
To: Peter Huewe <peter.huewe@infineon.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>, tpmdd@selhorst.net,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Luigi Semenzato <semenzato@google.com>,
        Bryan Freed <bfreed@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for resending...)

Andi, it is not clear what i2c_smbus_* functions in particular will
improve upon this change.

All i2c_smbus_* functions go through i2c_smbus_xfer() which at some
point will i2c_lock_adapter() for each request.
This is true for adapters that support SMBUS (where the lock occurs
directly in i2c_smbus_xfer()) or just I2C (where the lock occurs in
i2c_transfer() called through i2c_smbus_xfer_emulated()).

The goal of this change is for the tpm_tis_i2c driver to be able to
lock an adapter over the duration of several I2C requests.
Presumably, that is why i2c_lock_adapter() is exported.

bryan.

On Wed, May 2, 2012 at 8:17 AM, Andi Shyti <andi.shyti@gmail.com> wrote:
> Hi again :),
>
> On Wed, May 02, 2012 at 04:03:36PM +0200, Peter Huewe wrote:
>> From: Bryan Freed <bfreed@chromium.org>
>>
>> This is derived from Peter Huewe's recommended fix:
>>
>> On some ChromeOS systems, a TPM sharing the I2C bus with another device
>> gets confused when it sees I2C requests to that other device.
>> This change locks the I2C adapter for the duration of the full sequence
>> of I2C requests the TPM needs to complete.
>>
>> smbus_xfer is not supported, but SMBUS is not supported by the original
>> driver, either.
>>
>> Signed-off-by: Bryan Freed <bfreed@chromium.org>
>> Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
>> ---
>>  drivers/char/tpm/tpm_tis_i2c.c |   42 ++++++++++++++++++++++++++++++++++++---
>>  1 files changed, 38 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm_tis_i2c.c b/drivers/char/tpm/tpm_tis_i2c.c
>> index 8975abf..e68f209 100644
>> --- a/drivers/char/tpm/tpm_tis_i2c.c
>> +++ b/drivers/char/tpm/tpm_tis_i2c.c
>> @@ -61,6 +61,28 @@ static struct tpm_inf_dev tpm_dev;
>>
>>
>>  /*
>> + * Copy i2c-core:i2c_transfer() as close as possible without the adapter locks
>> + * and algorithm check.  These are done by the caller for atomicity.
>> + */
>> +static int i2c_transfer_nolock(struct i2c_adapter *adap, struct i2c_msg *msgs,
>> +                            int num)
>> +{
>> +     unsigned long orig_jiffies;
>> +     int ret, try;
>> +
>> +     /* Retry automatically on arbitration loss */
>> +     orig_jiffies = jiffies;
>> +     for (ret = 0, try = 0; try <= adap->retries; try++) {
>> +             ret = adap->algo->master_xfer(adap, msgs, num);
>> +             if (ret != -EAGAIN)
>> +                     break;
>> +             if (time_after(jiffies, orig_jiffies + adap->timeout))
>> +                     break;
>> +     }
>> +     return ret;
>> +}
>> +
>> +/*
>>   * iic_tpm_read() - read from TPM register
>>   * @addr: register address to read from
>>   * @buffer: provided by caller
>> @@ -83,8 +105,13 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
>>       int rc;
>>       int count;
>>
>> +     /* Lock the adapter for the duration of the whole sequence. */
>> +     if (!tpm_dev.client->adapter->algo->master_xfer)
>> +             return -EOPNOTSUPP;
>> +     i2c_lock_adapter(tpm_dev.client->adapter);
>> +
>>       for (count = 0; count < MAX_COUNT; count++) {
>> -             rc = i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
>> +             rc = i2c_transfer_nolock(tpm_dev.client->adapter, &msg1, 1);
>>               if (rc > 0)
>>                       break; /* break here to skip sleep */
>>
>> @@ -92,19 +119,21 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
>>       }
>>
>>       if (rc <= 0)
>> -             return -EIO;
>> +             goto out;
>>
>>       /* After the TPM has successfully received the register address it needs
>>        * some time, thus we're sleeping here again, before retrieving the data
>>        */
>>       for (count = 0; count < MAX_COUNT; count++) {
>>               usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
>> -             rc = i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
>> +             rc = i2c_transfer_nolock(tpm_dev.client->adapter, &msg2, 1);
>>               if (rc > 0)
>>                       break;
>>
>>       }
>>
>> +out:
>> +     i2c_unlock_adapter(tpm_dev.client->adapter);
>>       if (rc <= 0)
>>               return -EIO;
>>
>> @@ -121,17 +150,22 @@ static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
>>
>>       struct i2c_msg msg1 = { tpm_dev.client->addr, 0, len + 1, tpm_dev.buf };
>>
>> +     if (!tpm_dev.client->adapter->algo->master_xfer)
>> +             return -EOPNOTSUPP;
>> +     i2c_lock_adapter(tpm_dev.client->adapter);
>> +
>>       tpm_dev.buf[0] = addr;
>>       memcpy(&(tpm_dev.buf[1]), buffer, len);
>>
>>       for (count = 0; count < max_count; count++) {
>> -             rc = i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
>> +             rc = i2c_transfer_nolock(tpm_dev.client->adapter, &msg1, 1);
>>               if (rc > 0)
>>                       break;
>>
>>               usleep_range(sleep_low, sleep_hi);
>>       }
>>
>> +     i2c_unlock_adapter(tpm_dev.client->adapter);
>>       if (rc <= 0)
>>               return -EIO;
>>
>
>
>
> try to have a look to the i2c_smbus* function, you could avoid
> lot of code
>
> Andi
>
>> --
>> 1.7.6.msysgit.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
