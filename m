Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab1JZMzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:55:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58364 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917Ab1JZMzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <4EA7C782.205@cam.ac.uk>
References: <1319596228-23318-1-git-send-email-gardner.ben@gmail.com>
	<4EA7C782.205@cam.ac.uk>
Date: Wed, 26 Oct 2011 07:55:22 -0500
Message-ID: <CAE7DoPZCC5H3C_5BP2f9PDEXgEqga2pqcVR5ANrRF=NpPQo3Ug@mail.gmail.com>
Subject: Re: [PATCH] rtc-isl1208: Use SMBus functions if I2C isn't available
From: Ben Gardner <gardner.ben@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Thanks for the review.

On Wed, Oct 26, 2011 at 3:40 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> On 10/26/11 03:30, Ben Gardner wrote:
>> The rtc-isl1208 driver currently depends on raw I2C functionality.
>> This patch adds a fall-back to SMBus functions so that the driver can be
>> used on a SMBus-only platforms, such as i2c-isch.
>>
> Perhaps a summary of how bad things would be if smbus were all that is used?
> Afterall it is emulated on i2c buses if they don't support it directly.

Read and writes to the RTC chip should be a very rare thing, so saving
a few cycles by using the native I2C block read/write seems less
important than being compatible.
Perhaps I should just switch it to using SMBus functions and eliminate
the I2C block ops altogether?

Anyone else have an opinion on this?

>> -     ret = i2c_transfer(client->adapter, msgs, 2);
>> -     if (ret > 0)
>> -             ret = 0;
> It's a bit early in the morning, but at least at first glance I think
> this is an i2c_smbus_i2c_read_block_data reimplementation?

Do you mean i2c_smbus_read_i2c_block_data()?
That function is a bit different - it uses i2c_transfer() to emulate
the SMBus block read.
I'm not aware of any SMBus emulation of a I2C block read.

>> +     if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
>> +             u8 reg_addr[1] = { reg };
>> +             struct i2c_msg msgs[2] = {
>> +                     {client->addr, 0, sizeof(reg_addr), reg_addr}
>> +                     ,
> Odd spacing.

Sure is. It was that way in the original, but I guess I'll fix it. Or
eliminate it, if I remove I2C ops in the next version.

I'll await further comments and then repost in a day or so.

Thanks,
Ben
