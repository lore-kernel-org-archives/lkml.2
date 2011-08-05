Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1HEXQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 19:16:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51314 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab1HEXQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 19:16:02 -0400
Message-ID: <4E3C79AF.80901@gmail.com>
Date: Fri, 05 Aug 2011 18:15:59 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 2/3] i2c: move OF i2c related functions into i2c core
References: <1312579468-19365-1-git-send-email-robherring2@gmail.com> <1312579468-19365-3-git-send-email-robherring2@gmail.com> <20110805225637.GB6404@ponder.secretlab.ca>
In-Reply-To: <20110805225637.GB6404@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On 08/05/2011 05:56 PM, Grant Likely wrote:
> On Fri, Aug 05, 2011 at 04:24:27PM -0500, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> This simplifies i2c drivers by removing calls to of_i2c_register_devices
>> and resolves a module circular dependency between i2c-core and of_i2c.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Jean Delvare <khali@linux-fr.org>
>> Cc: Ben Dooks <ben-linux@fluff.org>
>> Cc: linux-i2c@vger.kernel.org
>> ---
>>  arch/powerpc/platforms/44x/warp.c |    1 -
>>  drivers/i2c/i2c-core.c            |   85 +++++++++++++++++++++++++++++++-
>>  drivers/of/Makefile               |    1 -
>>  drivers/of/of_i2c.c               |   97 -------------------------------------
>>  include/linux/i2c.h               |    4 ++
>>  include/linux/of_i2c.h            |   30 -----------
>>  6 files changed, 87 insertions(+), 131 deletions(-)
>>  delete mode 100644 drivers/of/of_i2c.c
>>  delete mode 100644 include/linux/of_i2c.h
>>
>> diff --git a/arch/powerpc/platforms/44x/warp.c b/arch/powerpc/platforms/44x/warp.c
>> index 8f77139..9327ccf 100644
>> --- a/arch/powerpc/platforms/44x/warp.c
>> +++ b/arch/powerpc/platforms/44x/warp.c
>> @@ -16,7 +16,6 @@
>>  #include <linux/interrupt.h>
>>  #include <linux/delay.h>
>>  #include <linux/of_gpio.h>
>> -#include <linux/of_i2c.h>
>>  #include <linux/slab.h>
>>  
>>  #include <asm/machdep.h>
>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> index 011e195..478c7f2 100644
>> --- a/drivers/i2c/i2c-core.c
>> +++ b/drivers/i2c/i2c-core.c
>> @@ -22,7 +22,10 @@
>>     SMBus 2.0 support by Mark Studebaker <mdsxyz123@yahoo.com> and
>>     Jean Delvare <khali@linux-fr.org>
>>     Mux support by Rodolfo Giometti <giometti@enneenne.com> and
>> -   Michael Lawnick <michael.lawnick.ext@nsn.com> */
>> +   Michael Lawnick <michael.lawnick.ext@nsn.com>
>> +   OF support by Jochen Friedrich <jochen@scram.de> and
>> +   Jon Smirl <jonsmirl@gmail.com>
>> +   */
>>  
>>  #include <linux/module.h>
>>  #include <linux/kernel.h>
>> @@ -32,7 +35,6 @@
>>  #include <linux/init.h>
>>  #include <linux/idr.h>
>>  #include <linux/mutex.h>
>> -#include <linux/of_i2c.h>
>>  #include <linux/of_device.h>
>>  #include <linux/completion.h>
>>  #include <linux/hardirq.h>
>> @@ -790,6 +792,85 @@ static void i2c_scan_static_board_info(struct i2c_adapter *adapter)
>>  	up_read(&__i2c_board_lock);
>>  }
>>  
>> +#ifdef CONFIG_OF_I2C
> 
> I think this becomes simply "#ifdef CONFIG_OF" since CONFIG_I2C is implied at this point.

I was going to remove CONFIG_OF_I2C altogether, but it depends on !SPARC
so I thought it should be kept.

> 
>> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
>> index a6c652e..830397b 100644
>> --- a/include/linux/i2c.h
>> +++ b/include/linux/i2c.h
>> @@ -468,6 +468,10 @@ static inline int i2c_adapter_id(struct i2c_adapter *adap)
>>  {
>>  	return adap->nr;
>>  }
>> +
>> +/* must call put_device() when done with returned i2c_client device */
>> +extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
>> +
> 
> This shouldn't be defined if !CONFIG_OF

There is no empty version today and externs don't need to be ifdef'ed in
that case.

Rob

