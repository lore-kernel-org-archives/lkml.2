Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0IVBDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 21:03:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63893 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab0IVBDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 21:03:04 -0400
Message-ID: <4C9955C2.8050909@criticallink.com>
Date: Tue, 21 Sep 2010 21:02:58 -0400
From: Michael Williamson <michael.williamson@criticallink.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Ben Dooks <ben-i2c@fluff.org>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org, khilman@deeprootsystems.com, chaithrika@ti.com,
        pjohn@in.mvista.com, nageswari@ti.com, dirk.behme@gmail.com
Subject: Re: [PATCH] i2c-davinci: Fix use of default platform data if none
 supplied.
References: <1283616468-6344-1-git-send-email-michael.williamson@criticallink.com> <20100922002442.GJ7494@trinity.fluff.org>
In-Reply-To: <20100922002442.GJ7494@trinity.fluff.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 08:24 PM, Ben Dooks wrote:
> On Sat, Sep 04, 2010 at 12:07:48PM -0400, Michael Williamson wrote:
>> There is a bug in the i2c-davinci device init routine that attempts
>> to use default platform data if none is supplied (e.g., is NULL).
>> This patch fixes the bug.
>>
>> Signed-off-by: Michael Williamson <michael.williamson@criticallink.com>
>> ---
>>  drivers/i2c/busses/i2c-davinci.c |    8 +++++---
>>  1 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
>> index 2222c87..6d4eeeb 100644
>> --- a/drivers/i2c/busses/i2c-davinci.c
>> +++ b/drivers/i2c/busses/i2c-davinci.c
>> @@ -235,10 +235,12 @@ static void i2c_davinci_calc_clk_dividers(struct davinci_i2c_dev *dev)
>>   */
>>  static int i2c_davinci_init(struct davinci_i2c_dev *dev)
>>  {
>> -	struct davinci_i2c_platform_data *pdata = dev->dev->platform_data;
>> +	struct davinci_i2c_platform_data *pdata;
>>  
>> -	if (!pdata)
>> -		pdata = &davinci_i2c_platform_data_default;
>> +	if (!dev->dev->platform_data)
>> +		dev->dev->platform_data = &davinci_i2c_platform_data_default;
>> +
>> +	pdata = dev->dev->platform_data;
> 
> At first glance this looks like a code shift, however is the platform
> data used later in the driver by referencing the device.platform_data
> field?
> 

Yes. The problem call is i2c_davinci_calc_clk_dividers(), which is called 
pretty early in the i2c_davinci_init() routine.  There is a reference to 
pdata->bus_freq without a check to see if pdata is valid.  I think my proposed
fix is not the right approach as you have pointed out.

Perhaps a better patch would be (?):

---
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 2222c87..15d0cea 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -195,6 +195,9 @@ static void i2c_davinci_calc_clk_dividers(struct davinci_i2c_dev *dev)
 	u32 clkl;
 	u32 input_clock = clk_get_rate(dev->clk);
 
+	if (!pdata)
+		pdata = &davinci_i2c_platform_data_default;
+
 	/* NOTE: I2C Clock divider programming info
 	 * As per I2C specs the following formulas provide prescaler
 	 * and low/high divider values
---

> Could you rewrite the header to show this, and if possible note any
> actual oops report that has been seen with this.
> 

I found this because I was told (while proposing a new platform) to use NULL
as platform data as the parameters I was using matched the default data.  I 
didn't get an oops, it just hung (it's pretty early in the board init).  
Our boot strapper/load resets the DDR where the kernel buffer is, so getting
any oops info is a bit time consuming.  The above three lines (and the original
patch) resolved the problem.

I can update the header to indicate a default parameter set if you like.  New patch OK?

-Mike 
