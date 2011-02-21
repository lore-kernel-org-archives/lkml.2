Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1BUAEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 19:04:32 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:33215 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753864Ab1BUAEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 19:04:31 -0500
Message-ID: <4D61AC33.3070409@bluewatersys.com>
Date: Mon, 21 Feb 2011 13:05:07 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux kernel <linux-kernel@vger.kernel.org>, hvr@gnu.org
Subject: Re: [REPOST PATCH] rtc-isl1208: Add alarm support
References: <4D6183E6.1030706@bluewatersys.com> <alpine.LNX.2.00.1102210043310.20470@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102210043310.20470@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 12:52 PM, Jesper Juhl wrote:
> On Mon, 21 Feb 2011, Ryan Mallon wrote:
> 
>> Add alarm/wakeup support to rtc isl1208 driver
>>
> 
> A few (very minor) comments below.

Hi Jepser. Thanks for the review. See answers below.

I'm unsure where this patch is meant to be applied. There is a list and
a maintainer (but no git tree?) for the rtc subsystem, but there doesn't
seem to be much activity from either lately?

> 
> 
>> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
>> ---
>>
>> diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
>>  static int
>> +isl1208_rtc_toggle_alarm(struct i2c_client *client, int enable)
>> +{
>> +	int icr;
>> +
>> +	icr = i2c_smbus_read_byte_data(client, ISL1208_REG_INT);
> 
> int icr = i2c_smbus_read_byte_data(client, ISL1208_REG_INT);
> 
> ??
> 
> No functional change, but cuts down on source size.

Sure, I can change this.

>> +static int
>>  isl1208_rtc_proc(struct device *dev, struct seq_file *seq)
>>  {
>>  	struct i2c_client *const client = to_i2c_client(dev);
>> @@ -288,7 +315,7 @@ isl1208_i2c_read_alarm(struct i2c_client *client, struct rtc_wkalrm *alarm)
>>  {
>>  	struct rtc_time *const tm = &alarm->time;
>>  	u8 regs[ISL1208_ALARM_SECTION_LEN] = { 0, };
>> -	int sr;
>> +	int icr, yr, sr;
>>  
>>  	sr = isl1208_i2c_get_sr(client);
> 
> Maybe it's just me, but I'd have written this as
> 
> int icr, yr;
> int sr = isl1208_i2c_get_sr(client);

Same here. I'm not hugely fussed either way.

>> @@ -514,6 +677,9 @@ isl1208_probe(struct i2c_client *client, const struct i2c_device_id *id)
>>  
>>  exit_unregister:
>>  	rtc_device_unregister(rtc);
>> +exit_free_irq:
>> +	if (client->irq)
>> +		free_irq(client->irq, client);
> 
> I didn't dig deep into this, but from a cursory look it seems that 
> free_irq() should be fine being handed NULL. If that's right, then the 
> condifional "if" is not needed here..

I think having the if is a bit clearer, since it will only try and free
the irq in the case where we have actually allocated it. This is on the
error exit path so performance is not exactly critical.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
