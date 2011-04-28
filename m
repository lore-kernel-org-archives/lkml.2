Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab1D1Ig2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:36:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49933 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab1D1IgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:36:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rI4VYAhgPU2TivJndg9KKfOAfqr2xMPrKiGap4PLihOe2oLesUx6RiGiMx24SIHUVr
         uUuP0DLBEh7TTOdGB6HW/oeGSJrFoffghZoMyVdzaMztrezNjFqab3pXP8nFeSpitOpp
         W+tMUHT9TKoRK1GNZnBEsioiv3xiForDXt06I=
MIME-Version: 1.0
In-Reply-To: <20110428102212.2d8d607c@endymion.delvare>
References: <1303963358-4652-1-git-send-email-haojian.zhuang@gmail.com> <20110428102212.2d8d607c@endymion.delvare>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 28 Apr 2011 16:36:02 +0800
Message-ID: <BANLkTin6jguQue_0Y74jGPnmhCcvWLBjHg@mail.gmail.com>
Subject: Re: [PATCH 1/3] i2c: append hardware lock with bus lock
To: Jean Delvare <khali@linux-fr.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 4:22 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Haojian,
>
> On Thu, 28 Apr 2011 12:02:36 +0800, Haojian Zhuang wrote:
>> Both AP and CP are contained in Marvell PXA910 silicon. These two ARM
>> cores are sharing one pair of I2C pins.
>>
>> In order to keep I2C transaction operated with atomic, hardware lock
>> (RIPC) is required. Because of this, bus lock in AP side can't afford
>> this requirement. Now hardware lock is appended.
>
> I have no objection to the idea, but one question: when using the
> hardware lock, isn't the software mutex redundant? I would expect that
> you call the hardware_lock/unlock functions _instead_ of
> rt_mutex_lock/unlock, rather than in addition to it. Or do you still
> need the rt_mutex to prevent priority inversion?
>

Jean,

It's actually not redundant. The hardware lock is used to protect
access to the same register regions between two processors (AP
and CP so called), while the software lock is used to protect
access from within the AP side.

>>
>> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
>> Cc: Ben Dooks <ben-linux@fluff.org>
>> ---
>>  drivers/i2c/i2c-core.c |   22 ++++++++++++++++++----
>>  include/linux/i2c.h    |    3 +++
>>  2 files changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> index 045ba6e..412c7a5 100644
>> --- a/drivers/i2c/i2c-core.c
>> +++ b/drivers/i2c/i2c-core.c
>> @@ -448,8 +448,11 @@ void i2c_lock_adapter(struct i2c_adapter *adapter)
>>
>>       if (parent)
>>               i2c_lock_adapter(parent);
>> -     else
>> +     else {
>>               rt_mutex_lock(&adapter->bus_lock);
>> +             if (adapter->hardware_lock)
>> +                     adapter->hardware_lock();
>> +     }
>>  }
>>  EXPORT_SYMBOL_GPL(i2c_lock_adapter);
>>
>> @@ -460,11 +463,19 @@ EXPORT_SYMBOL_GPL(i2c_lock_adapter);
>>  static int i2c_trylock_adapter(struct i2c_adapter *adapter)
>>  {
>>       struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
>> +     int ret = 0;
>>
>>       if (parent)
>>               return i2c_trylock_adapter(parent);
>> -     else
>> -             return rt_mutex_trylock(&adapter->bus_lock);
>> +     else {
>> +             ret = rt_mutex_trylock(&adapter->bus_lock);
>> +             if (ret && adapter->hardware_trylock) {
>> +                     ret = adapter->hardware_trylock();
>> +                     if (!ret)
>> +                             i2c_unlock_adapter(adapter);
>> +             }
>> +             return ret;
>> +     }
>>  }
>>
>>  /**
>> @@ -477,8 +488,11 @@ void i2c_unlock_adapter(struct i2c_adapter *adapter)
>>
>>       if (parent)
>>               i2c_unlock_adapter(parent);
>> -     else
>> +     else {
>> +             if (adapter->hardware_unlock)
>> +                     adapter->hardware_unlock();
>>               rt_mutex_unlock(&adapter->bus_lock);
>> +     }
>>  }
>>  EXPORT_SYMBOL_GPL(i2c_unlock_adapter);
>>
>> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
>> index 06a8d9c..b283b4e 100644
>> --- a/include/linux/i2c.h
>> +++ b/include/linux/i2c.h
>> @@ -361,6 +361,9 @@ struct i2c_adapter {
>>
>>       /* data fields that are valid for all devices   */
>>       struct rt_mutex bus_lock;
>> +     void (*hardware_lock)(void);
>> +     void (*hardware_unlock)(void);
>> +     int (*hardware_trylock)(void);
>>
>>       int timeout;                    /* in jiffies */
>>       int retries;
>
>
> --
> Jean Delvare
>
