Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2FMO5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:57:21 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41165 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab2FMO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:57:05 -0400
Message-ID: <4FD8AA3C.6090100@gmail.com>
Date: Wed, 13 Jun 2012 09:57:00 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v2 0/3] EDAC support for Calxeda Highbank
References: <1339468334-9927-1-git-send-email-robherring2@gmail.com> <4FD7430B.6010005@redhat.com>
In-Reply-To: <4FD7430B.6010005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

On 06/12/2012 08:24 AM, Mauro Carvalho Chehab wrote:
> Hi Rob,
> 
> Em 11-06-2012 23:32, Rob Herring escreveu:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> This series adds EDAC support for Calxeda Highbank platform L2 and
>> memory ECC hardware.
>>
>> This version is rebased current edac next tree for 3.6. Changes in
>> this version are the addition of a common edac debugfs directory and
>> coverting the highbank error injection to use debugfs.
> 
> Thanks for the patches.
> 
> It looks OK on my eyes, with regards to the EDAC API usage. While this patch
> touches at the arm/devicetree stuff, most of the changes belong to EDAC, so
> I'll apply them with my SOB on my tree.
> 

I found a build error when EDAC_DEBUG is turned off. 

drivers/edac/highbank_mc_edac.c: In function 'highbank_mc_probe':
drivers/edac/highbank_mc_edac.c:215:9: error: 'struct mem_ctl_info' has no member named 'debugfs'
drivers/edac/highbank_mc_edac.c:216:50: error: 'struct mem_ctl_info' has no member named 'debugfs'
drivers/edac/highbank_mc_edac.c:218:10: error: 'highbank_mc_debug_inject_fops' undeclared (first use in this function)


Do you prefer I respin the patch or do you want a follow on patch? This
is what the fix looks like:

diff --git a/drivers/edac/highbank_mc_edac.c b/drivers/edac/highbank_mc_edac.c
index d00dc0b..3185961 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -124,6 +124,22 @@ static const struct file_operations highbank_mc_debug_inject_fops = {
        .write = highbank_mc_err_inject_write,
        .llseek = generic_file_llseek,
 };
+
+static int __devinit highbank_mc_create_debugfs_nodes(struct mem_ctl_info *mci)
+{
+       if (!mci->debugfs)
+               return -ENODEV;
+
+       debugfs_create_file("inject_ctrl", S_IWUSR, mci->debugfs, mci,
+                           &highbank_mc_debug_inject_fops);
+
+       return 0;
+}
+#else
+static int __devinit highbank_mc_create_debugfs_nodes(struct mem_ctl_info *mci)
+{
+       return -ENODEV;
+}
 #endif
 
 static int __devinit highbank_mc_probe(struct platform_device *pdev)
@@ -212,10 +228,7 @@ static int __devinit highbank_mc_probe(struct platform_device *pdev)
        if (res < 0)
                goto err;
 
-       if (mci->debugfs)
-               debugfs_create_file("inject_ctrl", S_IWUSR, mci->debugfs,
-                                   mci,
-                                   &highbank_mc_debug_inject_fops);
+       highbank_mc_create_debugfs_nodes(mci);
 
        devres_close_group(&pdev->dev, NULL);
        return 0;


Rob

> Regards,
> Mauro.
>>
>> Rob
>>
>> Rob Herring (3):
>>    edac: create top-level debugfs directory
>>    edac: add support for Calxeda highbank memory controller
>>    edac: add support for Calxeda highbank L2 cache ecc
>>
>>   .../devicetree/bindings/arm/calxeda/l2ecc.txt      |   17 ++
>>   .../devicetree/bindings/arm/calxeda/mem-ctrlr.txt  |   17 ++
>>   arch/arm/boot/dts/highbank.dts                     |   12 +
>>   drivers/edac/Kconfig                               |   16 +-
>>   drivers/edac/Makefile                              |    4 +
>>   drivers/edac/edac_mc_sysfs.c                       |   23 +-
>>   drivers/edac/edac_module.c                         |    3 +
>>   drivers/edac/edac_module.h                         |   14 ++
>>   drivers/edac/highbank_l2_edac.c                    |  149 ++++++++++++
>>   drivers/edac/highbank_mc_edac.c                    |  256 ++++++++++++++++++++
>>   10 files changed, 509 insertions(+), 2 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/arm/calxeda/l2ecc.txt
>>   create mode 100644 Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
>>   create mode 100644 drivers/edac/highbank_l2_edac.c
>>   create mode 100644 drivers/edac/highbank_mc_edac.c
>>
> 
> 

