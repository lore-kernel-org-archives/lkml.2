Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2KGEWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 23:22:11 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33761 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2KGEWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 23:22:09 -0500
MIME-Version: 1.0
In-Reply-To: <50991C41.50705@gmail.com>
References: <64c5278ebdec503f83e9b7002bf13affb7f3260f.1351225085.git.viresh.kumar@linaro.org>
	<50991C41.50705@gmail.com>
Date: Wed, 7 Nov 2012 09:52:05 +0530
X-Google-Sender-Auth: aav8_QFrP-7XSqVZ080uyG2b-2M
Message-ID: <CAOh2x==LNuSFftB1r8cyJ6TOqOVJfExMTUVxKZnS16wL4B8eBA@mail.gmail.com>
Subject: Re: [PATCH Resend V2] dt: add helper function to read u8 & u16
 variables & arrays
From: viresh kumar <viresh.kumar@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linaro-dev@lists.linaro.org, andriy.shevchenko@intel.com,
        patches@linaro.org, devicetree-discuss@lists.ozlabs.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 7:48 PM, Rob Herring <robherring2@gmail.com> wrote:
>> +#define of_property_read_array(_np, _pname, _out, _sz)                       \

>> +     while (_sz--)                                                   \
>> +             *_out++ = (typeof(*_out))be32_to_cpup(_val++);          \

> This will not work. You are incrementing _out by 1, 2, or 4 bytes, but
> _val is always incremented by 4 bytes.
>
> According to the dtc commit adding this feature, the values are packed:
>
> With this patch the following property assignment:
>
>     property = /bits/ 16 <0x1234 0x5678 0x0 0xffff>;
>
> is equivalent to:
>
>     property = <0x12345678 0x0000ffff>;

I thought of it a bit more and wasn't actually aligned with your explanation :(

If that is the case, how will current implementation of u32 array will work
if we pass something like: 0x88 0x84000000 0x5890 from DT?

So, i did a dummy test of my current implementation, with following changes
in one of my drivers:

dts changes:

                cluster0: cluster@0 {
+                       data1 = <0x50 0x60 0x70>;
+                       data2 = <0x5000 0x6000 0x7000>;
+                       data3 = <0x50000000 0x60000000 0x70000000>;
               }

driver changes:

+void test(struct device_node *cluster)
+{
+       u8 data1[3];
+       u16 data2[3];
+       u32 data3[3], i;
+
+       of_property_read_u8_array(cluster, "data1", data1, 3);
+       of_property_read_u16_array(cluster, "data2", data2, 3);
+       of_property_read_u32_array(cluster, "data3", data3, 3);
+
+       for (i = 0; i < 3; i++) {
+               printk(KERN_INFO "u8 %d: %x\n", i, data1[i]);
+               printk(KERN_INFO "u16 %d: %x\n", i, data2[i]);
+               printk(KERN_INFO "u32 %d: %x\n", i, data3[i]);
+       }
+}

And following is the output

[    4.087205] u8 0: 50
[    4.093746] u16 0: 5000
[    4.101067] u32 0: 50000000
[    4.109512] u8 1: 60
[    4.116036] u16 1: 6000
[    4.123357] u32 1: 60000000
[    4.131718] u8 2: 70
[    4.138241] u16 2: 7000
[    4.145573] u32 2: 70000000

which looks to be what we were looking for, isn't it?

Following is fixup for the doc comment missing:

commit 00803aed0781de451048df0d15a3e8c814a343c8
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Wed Nov 7 09:48:46 2012 +0530

    fixup! dt: add helper function to read u8 & u16 variables & arrays
---
 drivers/of/base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index fbb634b..4a6632e 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -669,6 +669,7 @@ EXPORT_SYMBOL(of_find_node_by_phandle);
  * @np:                device node from which the property value is to be read.
  * @propname:  name of the property to be searched.
  * @out_value: pointer to return value, modified only if return value is 0.
+ * @sz:                number of array elements to read
  *
  * Search for a property in a device node and read 8-bit value(s) from
  * it. Returns 0 on success, -EINVAL if the property does not exist,
@@ -690,6 +691,7 @@ EXPORT_SYMBOL_GPL(of_property_read_u8_array);
  * @np:                device node from which the property value is to be read.
  * @propname:  name of the property to be searched.
  * @out_value: pointer to return value, modified only if return value is 0.
+ * @sz:                number of array elements to read
  *
  * Search for a property in a device node and read 16-bit value(s) from
  * it. Returns 0 on success, -EINVAL if the property does not exist,
@@ -712,6 +714,7 @@ EXPORT_SYMBOL_GPL(of_property_read_u16_array);
  * @np:                device node from which the property value is to be read.
  * @propname:  name of the property to be searched.
  * @out_value: pointer to return value, modified only if return value is 0.
+ * @sz:                number of array elements to read
  *
  * Search for a property in a device node and read 32-bit value(s) from
  * it. Returns 0 on success, -EINVAL if the property does not exist,
