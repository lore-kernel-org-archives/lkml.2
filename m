Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab2EBV6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:58:51 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45426 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473Ab2EBV6r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:58:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120502201832.GA19349@andi>
References: <1335967293-7728-1-git-send-email-peter.huewe@infineon.com>
	<1335967416-7564-1-git-send-email-peter.huewe@infineon.com>
	<20120502151734.GD16981@andi>
	<CAEYUcX0jBHasvcdLefR0fOGrVPaDw3pqzfQ_8_JGXHSPQHW7Ew@mail.gmail.com>
	<20120502181435.GF16981@andi>
	<CAEYUcX06hvTb1YP=9vCpK9Z19dtZgNTjUcSRnrUvjc3bu-D--Q@mail.gmail.com>
	<20120502201832.GA19349@andi>
Date: Wed, 2 May 2012 14:58:45 -0700
X-Google-Sender-Auth: 42LKJh9ipNQeWwnPny00FAVNuLI
Message-ID: <CAEYUcX2==8fTwzj7yCdkMhVy0aRiY1K_-HbzMNYfzCE1RhRELA@mail.gmail.com>
Subject: Re: [PATCH] CHROMIUM: tpm: tpm_tis_i2c: Lock the I2C adapter for a
 sequence of requests.
From: Bryan Freed <bfreed@chromium.org>
To: Bryan Freed <bfreed@chromium.org>, Peter Huewe <peter.huewe@infineon.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>, tpmdd@selhorst.net,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Luigi Semenzato <semenzato@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, May 2, 2012 at 1:18 PM, Andi Shyti <andi.shyti@gmail.com> wrote:
> Hi,
>
> On Wed, May 02, 2012 at 12:06:14PM -0700, Bryan Freed wrote:
>> Hi Andi,
>>
>> On Wed, May 2, 2012 at 11:14 AM, Andi Shyti <andi.shyti@gmail.com> wrote:
>> > Hi Bryan,
>> >
>> >> > try to have a look to the i2c_smbus* function, you could avoid
>> >> > lot of code
>> > On Wed, May 02, 2012 at 10:25:09AM -0700, Bryan Freed wrote:
>> >> (Sorry for resending...)
>> >>
>> >> Andi, it is not clear what i2c_smbus_* functions in particular will
>> >> improve upon this change.
>> >>
>> >> All i2c_smbus_* functions go through i2c_smbus_xfer() which at some
>> >> point will i2c_lock_adapter() for each request.
>> >> This is true for adapters that support SMBUS (where the lock occurs
>> >> directly in i2c_smbus_xfer()) or just I2C (where the lock occurs in
>> >> i2c_transfer() called through i2c_smbus_xfer_emulated()).
>> >>
>> >> The goal of this change is for the tpm_tis_i2c driver to be able to
>> >> lock an adapter over the duration of several I2C requests.
>> >> Presumably, that is why i2c_lock_adapter() is exported.
>> >
>> > the i2c_smbus_* functions will not improve anything to the
>> > driver, it will increase the readability and it will allow you to
>> > do the same stuff with less code.
>>
>> I think I see what you are saying.
>> We could (in the unmodified version of this driver) replace all the
>> iic_tpm_read() calls of one byte (which sends an address byte before
>> reading a data byte) with an i2c_smbus_read_byte_command() call which
>> does the same thing.
>> Switching to the SMBUS calls in this driver will still work on
>> adapters that only support I2C because of i2c_smbus_xfer_emulated().
>> Right?
>> > All the i2c communication implementation you wrote here, is
>> > already written in the i2c-core.c file.
>>
>> Right.  Unfortunately, we cannot use any of the i2c_smbus_* functions
>> in this driver.  The device will fail because the adapter lock is not
>> held long enough to prevent I2C traffic going to other devices on the
>> same bus.  That other traffic to other devices confuses the i2c core
>> in this device.  Our only driver solution is to lock the adapter for a
>> longer duration.
>>
>> Yes, the code we have here is copied from the i2c-core.c file.  In
>> fact, we comment this with, "Copy i2c-core:i2c_transfer() as close as
>> possible without the adapter locks
>> and algorithm check".
>>
>> And that really is the problem with using the i2c-core.c calls.  This
>> driver needs to lock the adapter for an extended duration.
>
> mmhhh... you still haven't convinced me. I always thought that
> every dublicated code is useless.

Hey, I agree with you on that point.  Duplicated code has its own problems.
A better solution would require i2c-core.c mods, mainly:

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index e9c1893..64cb9c2 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1346,17 +1346,8 @@ int i2c_transfer(struct i2c_adapter *adap,
struct i2c_msg *msgs, int num)
                        i2c_lock_adapter(adap);
                }

-               /* Retry automatically on arbitration loss */
-               orig_jiffies = jiffies;
-               for (ret = 0, try = 0; try <= adap->retries; try++) {
-                       ret = adap->algo->master_xfer(adap, msgs, num);
-                       if (ret != -EAGAIN)
-                               break;
-                       if (time_after(jiffies, orig_jiffies + adap->timeout))
-                               break;
-               }
+               ret = i2c_transfer_nolock(&adap-, msgs, num);
                i2c_unlock_adapter(adap);
-
                return ret;
        } else {
                dev_dbg(&adap->dev, "I2C level transfers not supported\n");
@@ -1365,6 +1356,25 @@ int i2c_transfer(struct i2c_adapter *adap,
struct i2c_msg *msgs, int num)
 }
 EXPORT_SYMBOL(i2c_transfer);

+int i2c_transfer_nolock(struct i2c_adapter *adap, struct i2c_msg
*msgs, int num)
+{
+       unsigned long orig_jiffies;
+       int ret, try;
+
+       /* Retry automatically on arbitration loss */
+       orig_jiffies = jiffies;
+       for (ret = 0, try = 0; try <= adap->retries; try++) {
+               ret = adap->algo->master_xfer(adap, msgs, num);
+               if (ret != -EAGAIN)
+                       break;
+               if (time_after(jiffies, orig_jiffies + adap->timeout))
+                       break;
+       }
+
+       return ret;
+}
+EXPORT_SYMBOL(i2c_transfer_nolock);
+

Then I would not need my own copy of i2c_transfer_nolock().
But making these ugly changes in the driver for one buggy device is
easier/safer than making it in the general I2C code.

bryan.

> You may have good reasons to do that, but I could still try to
> find out a way on how to simplify it.
>
> Thanks for the explanation,
> Andi
