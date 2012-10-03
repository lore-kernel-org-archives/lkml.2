Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab2JCPNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:13:39 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34671 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab2JCPNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <87ehlgmevy.fsf@emc.com.tw>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
	<87ehlgmevy.fsf@emc.com.tw>
Date: Wed, 3 Oct 2012 17:13:33 +0200
Message-ID: <CAN+gG=GmcYpj=V+VMFB4hDapoj9xaapBm9=x5rvaN3nBTx-8Fw@mail.gmail.com>
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification implementation
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jian-Jhong Ding <jj_ding@emc.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JJ,

On Wed, Oct 3, 2012 at 5:08 AM, Jian-Jhong Ding <jj_ding@emc.com.tw> wrote:
> Hi Benjamin,
>
> I have one little question about __i2chid_command(), please see below.
>
> "benjamin.tissoires" <benjamin.tissoires@gmail.com> writes:
>> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>>
>> Microsoft published the protocol specification of HID over i2c:
>> http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
>>
>> This patch introduces an implementation of this protocol.
>>
>> This implementation does not includes the ACPI part of the specification.
>> This will come when ACPI 5.0 devices will be available.
>>
>> Once the ACPI part will be done, OEM will not have to declare HID over I2C
>> devices in their platform specific driver.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>>
[...] snipped
>> +     if (wait) {
>> +             spin_lock_irq(&ihid->flock);
>> +             set_bit(I2C_HID_RESET_PENDING, &ihid->flags);
>> +             spin_unlock_irq(&ihid->flock);
>> +     }
>> +
>> +     do {
>> +             ret = i2c_transfer(client->adapter, msg, msg_num);
>> +             if (ret > 0)
>> +                     break;
>> +             tries--;
>> +             dev_dbg(&client->dev, "retrying i2chid_command:%d (%d)\n",
>> +                     command, tries);
>> +     } while (tries > 0);
>
> Do we have to do this retry here?  In i2c_transfer() it already does
> retry automatically on arbitration loss (please see __i2c_transfer() in
> drivers/i2c/i2c-core.c) that's defined by individual bus driver.  Maybe
> we don't have to retry here and make the code a bit simpler.
>

Indeed, this retry is not necessary. I'll remove it in v2.
Thanks for the review.

Cheers,
Benjamin

>> +     if (wait && ret > 0) {
>> +             if (debug)
>> +                     dev_err(&client->dev, "%s: waiting....\n", __func__);
>> +             if (!wait_event_timeout(ihid->wait,
>> +                             !test_bit(I2C_HID_RESET_PENDING, &ihid->flags),
>> +                             msecs_to_jiffies(5000)))
>> +                     ret = -ENODATA;
>> +             if (debug)
>> +                     dev_err(&client->dev, "%s: finished.\n", __func__);
>> +     }
>> +
>> +     kfree(cmd);
>> +
>> +     return ret > 0 ? ret != msg_num : ret;
>> +}
>> +
>> +static int i2chid_command(struct i2c_client *client, int command,
>> +             unsigned char *buf_recv, int data_len)
>> +{
>> +     return __i2chid_command(client, command, 0, 0, NULL, 0,
>> +                             buf_recv, data_len);
>> +}
