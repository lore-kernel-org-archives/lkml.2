Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab2F1Hv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 03:51:58 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45351 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab2F1Hv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 03:51:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120627180724.762f854a@endymion.delvare>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
 <1340805255-8041-4-git-send-email-djkurtz@chromium.org> <20120627180724.762f854a@endymion.delvare>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 28 Jun 2012 15:51:34 +0800
X-Google-Sender-Auth: lCsGQgsICYmq7DECI35jnPiBoyE
Message-ID: <CAGS+omCoto4djKuZUooeD2A-szjrH4e9=YJCptR_raOdQ8g3-A@mail.gmail.com>
Subject: Re: [PATCH 3/8 v3] i2c: i801: check INTR after every transaction
To: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 12:07 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Wed, 27 Jun 2012 21:54:10 +0800, Daniel Kurtz wrote:
>> Per ICH10 datasheet [1] pg. 711, after completing a block transaction,
>> INTR should be checked & cleared separately, only after BYTE_DONE is
>> first cleared:
>>
>>   When the last byte of a block message is received, the host controller
>> sets DS. However, it does not set the INTR bit (and generate another
>> interrupt) until DS is cleared. Thus, for a block message of n bytes,
>> the ICH10 will generate n+1 interrupts.
>>
>> [1] http://www.intel.com/content/dam/doc/datasheet/io-controller-hub-10-family-datasheet.pdf
>>
>> Currently, the INTR bit was only checked & cleared separately if the PEC
>> was used.
>> This patch checks and clears INTR at the very end of every successful
>> transaction, regardless of whether the PEC is used.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> ---
>>  drivers/i2c/busses/i2c-i801.c |   46 ++++++++++++++++++++--------------------
>>  1 files changed, 23 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
>> index 8b74e1e..6a53338 100644
>> --- a/drivers/i2c/busses/i2c-i801.c
>> +++ b/drivers/i2c/busses/i2c-i801.c
>> @@ -257,6 +257,24 @@ static int i801_check_post(struct i801_priv *priv, int status, int timeout)
>>       return result;
>>  }
>>
>> +/* wait for INTR bit as advised by Intel */
>> +static void i801_wait_intr(struct i801_priv *priv)
>> +{
>> +     int timeout = 0;
>> +     int status;
>> +
>> +     status = inb_p(SMBHSTSTS(priv));
>> +     while ((!(status & SMBHSTSTS_INTR)) && (timeout++ < MAX_RETRIES)) {
>> +             usleep_range(250, 500);
>> +             status = inb_p(SMBHSTSTS(priv));
>> +     }
>
> Per my comment on previous patch, I've swapped the logic here to be in
> line with what we had before. I have no objection to trying this change
> again, but later, and only if you have actual numbers to back it up.
>
>> +
>> +     if (timeout > MAX_RETRIES)
>> +             dev_dbg(&priv->pci_dev->dev, "INTR Timeout!\n");
>> +
>> +     outb_p(status, SMBHSTSTS(priv));
>
> Wouldn't it be more correct to only write the INTR bit? Writing back
> the whole 8 bits frightens me a little especially because of bit
> INUSE_STS. If we ever want to support this feature, I think we have to
> first ban writing back the whole status to register HST_STS. And this
> is the only place where we still do AFAICS.

It looks like the current code does it this way to clear any error
bits that may be set in the timeout case (errors set, but no INTR).
For example, if there was a bus / arbitration error while waiting for
PEC.

Perhaps we can split the difference (I tested this and it has no
obvious regression):

+     /* Clear INTR, or in case of timeout, any other status bits. */
+     outb_p(status & STATUS_FLAGS, SMBHSTSTS(priv));

But in a separate patch...

>
> (This isn't a regression from your patch, the old code was already
> doing that, but it might be the opportunity to fix it.)
>
> --
> Jean Delvare
