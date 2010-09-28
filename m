Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab0I1X0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 19:26:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42664 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab0I1X0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 19:26:53 -0400
MIME-Version: 1.0
In-Reply-To: <20100928232147.GR21564@trinity.fluff.org>
References: <20100924221313.28357.61419.stgit@angua> <20100928232147.GR21564@trinity.fluff.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Sep 2010 08:26:03 +0900
X-Google-Sender-Auth: C6X1FMuYu5XxYdlIN1mnAHnFJ-M
Message-ID: <AANLkTimB1dACK0QdnJk-Ry0hPpUO7eKv3n_GSBJTttCx@mail.gmail.com>
Subject: Re: [PATCH (Option 1)] of/i2c: fix module load order issue caused by of_i2c.c
To: Ben Dooks <ben-i2c@fluff.org>
Cc: khali@linux-fr.org, mikpe@it.uu.se, rdunlap@xenotime.net,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 8:21 AM, Ben Dooks <ben-i2c@fluff.org> wrote:
> On Fri, Sep 24, 2010 at 04:14:53PM -0600, Grant Likely wrote:
>> Commit 959e85f7, "i2c: add OF-style registration and binding" caused a
>> module dependency loop where of_i2c.c calls functions in i2c-core, and
>> i2c-core calls of_i2c_register_devices() in of_i2c.  This means that
>> when i2c support is built as a module when CONFIG_OF is set, then
>> neither i2c_core nor of_i2c are able to be loaded.
>>
>> This patch fixes the problem by moving the of_i2c_register_devices()
>> function into the body of i2c_core and renaming it to
>> i2c_scan_of_devices (of_i2c_register_devices is analogous to the
>> existing i2c_scan_static_board_info function and so should be named
>> similarly).  This function isn't called by any code outside of
>> i2c_core, and it must always be present when CONFIG_OF is selected, so
>> it makes sense to locate it there.  When CONFIG_OF is not selected,
>> of_i2c_register_devices() becomes a no-op.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  drivers/i2c/i2c-core.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++--
>>  drivers/of/of_i2c.c    |   57 ---------------------------------------------
>>  include/linux/of_i2c.h |    7 ------
>>  3 files changed, 59 insertions(+), 66 deletions(-)
>>
>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> index 6649176..64a261b 100644
>> --- a/drivers/i2c/i2c-core.c
>> +++ b/drivers/i2c/i2c-core.c
>> @@ -32,8 +32,8 @@
>>  #include <linux/init.h>
>>  #include <linux/idr.h>
>>  #include <linux/mutex.h>
>> -#include <linux/of_i2c.h>
>>  #include <linux/of_device.h>
>> +#include <linux/of_irq.h>
>>  #include <linux/completion.h>
>>  #include <linux/hardirq.h>
>>  #include <linux/irqflags.h>
>> @@ -818,6 +818,63 @@ static void i2c_scan_static_board_info(struct i2c_adapter *adapter)
>>       up_read(&__i2c_board_lock);
>>  }
>>
>> +#ifdef CONFIG_OF
>> +void i2c_scan_of_devices(struct i2c_adapter *adap)
>> +{
>> +     void *result;
>> +     struct device_node *node;
>> +
>> +     /* Only register child devices if the adapter has a node pointer set */
>> +     if (!adap->dev.of_node)
>> +             return;
>> +
>> +     for_each_child_of_node(adap->dev.of_node, node) {
>> +             struct i2c_board_info info = {};
>> +             struct dev_archdata dev_ad = {};
>> +             const __be32 *addr;
>> +             int len;
>> +
>> +             dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
>> +             if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
>> +                     dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
>> +                             node->full_name);
>> +                     continue;
>> +             }
>> +
>> +             addr = of_get_property(node, "reg", &len);
>> +             if (!addr || (len < sizeof(int))) {
>> +                     dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
>> +                             node->full_name);
>> +                     continue;
>> +             }
>> +
>> +             info.addr = be32_to_cpup(addr);
>> +             if (info.addr > (1 << 10) - 1) {
>> +                     dev_err(&adap->dev, "of_i2c: invalid addr=%x on %s\n",
>> +                             info.addr, node->full_name);
>> +                     continue;
>> +             }
>> +
>> +             info.irq = irq_of_parse_and_map(node, 0);
>> +             info.of_node = of_node_get(node);
>> +             info.archdata = &dev_ad;
>> +
>> +             request_module("%s", info.type);
>> +
>> +             result = i2c_new_device(adap, &info);
>> +             if (result == NULL) {
>> +                     dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
>> +                             node->full_name);
>> +                     of_node_put(node);
>> +                     irq_dispose_mapping(info.irq);
>> +                     continue;
>> +             }
>> +     }
>> +}
>> +#else
>> +static inline void i2c_scan_of_devices(struct i2c_adapter *adap) { }
>> +#endif
>
> Is there any advantage to just making the definition in the header
> file a static inline and removing the #else part of this?

I'm not sure what you mean.  This particular patch makes
i2c_scan_of_devices() completely internal to i2c-core.c so that there
is no need to expose it in the header file at all.

g.

>
> --
> Ben
>
> Q:      What's a light-year?
> A:      One-third less calories than a regular year.
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
