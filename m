Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0HYLbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 07:31:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55556 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab0HYLbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 07:31:02 -0400
Message-ID: <4C74FEEE.2090300@ti.com>
Date: Wed, 25 Aug 2010 13:30:54 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Basak, Partha" <p-basak2@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Varadarajan, Charulatha" <charu@ti.com>,
        "Nayak, Rajendra" <rnayak@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] OMAP: HWMOD: Handle opt clocks using clk_add_alias
References: <1282578269-8835-1-git-send-email-p-basak2@ti.com> <4C72D6AC.3060509@ti.com> <B85A65D85D7EB246BE421B3FB0FBB59301E83DC40B@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301E83DC40B@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/25/2010 12:45 PM, Basak, Partha wrote:
>
>> From: Cousson, Benoit
>> Sent: Tuesday, August 24, 2010 1:45 AM
>>
>> Hi Partha,
>>
>> On 8/23/2010 5:44 PM, Basak, Partha wrote:
>>> From: Basak, Partha<p-basak2@ti.com>
>>>
>>> For every optional clock present per hwmod per omap-device, this
>> function
>>> adds an entry in the clocks list of the form<dev-id=dev_name, con-
>> id=role>,
>>> if an entry is already present in the list of the form<dev-id=NULL, con-
>> id=role>.
>>>
>>> The function is called from within the framework inside
>> omap_device_build_ss(),
>>> after omap_device_register.
>>>
>>> This allows drivers to get a pointer to its optional clocks based on its
>> role
>>> by calling clk_get(<dev*>,<role>).
>>>
>>> Link to discussions related to this patch:
>>> http://www.spinics.net/lists/linux-omap/msg34809.html
>>>
>>> Signed-off-by: Charulatha V<charu@ti.com>
>>> Signed-off-by: Basak, Partha<p-basak2@ti.com>
>>> Signed-off-by: Benoit Cousson<b-cousson@ti.com>
>>> Signed-off-by: Rajendra Nayak<rnayak@ti.com>
>>>
>>> Cc: Paul Walmsley<paul@pwsan.com>
>>> Cc: Kevin Hilman<khilman@deeprootsystems.com>
>>> ---
>>>    arch/arm/plat-omap/omap_device.c |   31
>> ++++++++++++++++++++++++++++++-
>>>    1 files changed, 30 insertions(+), 1 deletions(-)
>>>
>>> Index: linux-omap-pm/arch/arm/plat-omap/omap_device.c
>>> ===================================================================
>>> --- linux-omap-pm.orig/arch/arm/plat-omap/omap_device.c	2010-08-18
>> 02:48:30.789079550 +0530
>>> +++ linux-omap-pm/arch/arm/plat-omap/omap_device.c	2010-08-24
>> 07:19:43.637080138 +0530
>>> @@ -82,6 +82,7 @@
>>>    #include<linux/slab.h>
>>>    #include<linux/err.h>
>>>    #include<linux/io.h>
>>> +#include<linux/clk.h>
>>>
>>>    #include<plat/omap_device.h>
>>>    #include<plat/omap_hwmod.h>
>>> @@ -243,7 +244,6 @@ static inline struct omap_device *_find_
>>>    	return container_of(pdev, struct omap_device, pdev);
>>>    }
>>>
>>> -
>>
>> That fix is not related to the patch subject.
>>
>>>    /* Public functions for use by core code */
>>>
>>>    /**
>>> @@ -271,6 +271,47 @@ int omap_device_count_resources(struct o
>>>    }
>>
>> This is not a public function, so you should move it before the /*
>> Public functions for use by core code */
>>
> OK
>>>    /**
>>> + * omap_device_add_opt_clk_alias - Add alias for optional clocks in the
>>> + * clocks list.
>>> + *
>>> + * @od: struct omap_device *od
>>> + *
>>> + * For every optional clock present per hwmod per omap-device, this
>> function
>>> + * adds an entry in the clocks list of the form<dev-id=dev_name, con-
>> id=role>
>>> + * if an entry is already present in it with the form<dev-id=NULL,con-
>> id=role>
>>> + *
>>> + * The function is called from inside omap_device_build_ss(),
>>> + * after omap_device_register.
>>> + *
>>> + * This allows drivers to get a pointer to its optional clocks based on
>> its role
>>> + * by calling clk_get(<dev*>,<role>).
>>> + */
>>> +
>>> +static void omap_device_add_opt_clk_alias(struct omap_device *od)
>>> +{
>>> +	int i, j;
>>> +	struct omap_hwmod_opt_clk *oc;
>>> +	struct omap_hwmod *oh;
>>> +
>>> +	for (i = 0, oh = *od->hwmods; i<   od->hwmods_cnt; i++, oh++)
>>
>> You can avoid that iteration and the extra level of indentation by
>> re-using the iteration done before the call to that function.
>>
>>> +		/* Add Clock alias for all optional clocks*/
>>> +		for (j = oh->opt_clks_cnt, oc = oh->opt_clks;
>>> +			j>   0; j--, oc++) {
>>> +			if ((oc->_clk)&&
>>> +			(IS_ERR(clk_get(&od->pdev.dev, oc->role)))) {
>>> +				int ret;
>>
> Not clear on your comment, wanted to take care of the scenario where a device is having multiple hwmods

Which one? the one below or before? These comments are just about the 
readability of this patch.

>> You can avoid the indentation by returning in case of error.
>> You can avoid as well 2 pairs of parens.
>>
>>> +
>>> +				ret = clk_add_alias(oc->role,
>>> +					dev_name(&od->pdev.dev),
>>> +					(char *)oc->clk, NULL);
>>
>> The indentation is not align with the inner parameters... which is not
>> easy in your case due to the too many indentation level you have in this
>> function.
>>
>>> +				if (ret)
>>> +					dev_err(&od->pdev.dev, "omap_device:\
>>
>> This is not correct way of splitting long string, use "omap_device:"
>> instead.
>>
> Agreed
>
>> Even if dev_err is usable because you have the dev pointer, it is in
>> fact an error from the omap_device code code, so using pr_err is
>> probably more appropriate (TBC).
>>
>>> +					clk_add_alias for %s failed\n",
>>> +					oc->role);
>>> +			}
>>> +		}
>>> +}
>>> +/**
>>>     * omap_device_fill_resources - fill in array of struct resource
>>>     * @od: struct omap_device *
>>>     * @res: pointer to an array of struct resource to be filled in
>>> @@ -424,6 +465,12 @@ struct omap_device *omap_device_build_ss
>>>    	for (i = 0; i<   oh_cnt; i++)
>>>    		hwmods[i]->od = od;
>>
>> You can call a per hwmod API here in order to avoid the iteration inside
>> the function.
>
> I see your point, but most of the functions in this layer are having omap_device * as the parameter, so I maintained consistency

Since your function is anyway a private function, I don't see any reason 
to do that.

FYI, I joined an updated version.

Regards,
Benoit

---
 From d8a374c679b7f26229cf054520deb0ac416b7f4c Mon Sep 17 00:00:00 2001
From: Basak, Partha <p-basak2@ti.com>
Date: Mon, 23 Aug 2010 21:14:29 +0530
Subject: [PATCH] OMAP: hwmod: handle opt clocks node using clk_add_alias

For every optional clock present per hwmod per omap-device, this function
adds an entry in the clocks list of the form <dev-id=dev_name, con-id=role>,
if an entry is already present in the list of the form <dev-id=NULL, 
con-id=role>.

The function is called from within the framework inside 
omap_device_build_ss(),
after omap_device_register.

This allows drivers to get a pointer to its optional clocks based on its 
role
by calling clk_get(<dev*>, <role>).

Link to discussions related to this patch:
http://www.spinics.net/lists/linux-omap/msg34809.html

Signed-off-by: Charulatha V <charu@ti.com>
Signed-off-by: Basak, Partha <p-basak2@ti.com>
Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
---
  arch/arm/plat-omap/omap_device.c |   39 
+++++++++++++++++++++++++++++++++++++-
  1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/omap_device.c 
b/arch/arm/plat-omap/omap_device.c
index d2b1609..d876cec 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -82,6 +82,7 @@
  #include <linux/slab.h>
  #include <linux/err.h>
  #include <linux/io.h>
+#include <linux/clk.h>

  #include <plat/omap_device.h>
  #include <plat/omap_hwmod.h>
@@ -243,6 +244,40 @@ static inline struct omap_device 
*_find_by_pdev(struct platform_device *pdev)
  	return container_of(pdev, struct omap_device, pdev);
  }

+/**
+ * _add_optional_clock_alias - Add clock alias for hwmod optional clocks
+ * @od: struct omap_device *od
+ *
+ * For every optional clock present per hwmod per omap_device, this 
function
+ * adds an entry in the clocks list of the form <dev-id=dev_name, 
con-id=role>
+ * if an entry is already present in it with the form <dev-id=NULL, 
con-id=role>
+ *
+ * The function is called from inside omap_device_build_ss(), after
+ * omap_device_register.
+ *
+ * This allows drivers to get a pointer to its optional clocks based on 
its role
+ * by calling clk_get(<dev*>, <role>).
+ */
+static void _add_optional_clock_alias(struct omap_device *od,
+				      struct omap_hwmod *oh)
+{
+	int i;
+	struct omap_hwmod_opt_clk *oc;
+
+	for (i = oh->opt_clks_cnt, oc = oh->opt_clks; i > 0; i--, oc++) {
+		int ret;
+
+		if (!oc->_clk || !IS_ERR(clk_get(&od->pdev.dev, oc->role)))
+			return;
+
+		ret = clk_add_alias(oc->role, dev_name(&od->pdev.dev),
+				    (char *)oc->clk, NULL);
+		if (ret)
+			pr_err("omap_device: clk_add_alias for %s failed\n",
+			       oc->role);
+	}
+}
+

  /* Public functions for use by core code */

@@ -421,8 +456,10 @@ struct omap_device *omap_device_build_ss(const char 
*pdev_name, int pdev_id,
  	else
  		ret = omap_device_register(od);

-	for (i = 0; i < oh_cnt; i++)
+	for (i = 0; i < oh_cnt; i++) {
  		hwmods[i]->od = od;
+		_add_optional_clock_alias(od, hwmods[i]);
+	}

  	if (ret)
  		goto odbs_exit4;
-- 
1.6.0.4




