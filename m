Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab2EKDv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:51:28 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:56540 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756Ab2EKDv0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:51:26 -0400
MIME-Version: 1.0
In-Reply-To: <44C9A5C2B412554B8C50A260EB4EF32703971E34@DFLE32.ent.ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<1335462041-4949-8-git-send-email-j-keerthy@ti.com>
	<44C9A5C2B412554B8C50A260EB4EF32703971E34@DFLE32.ent.ti.com>
Date: Fri, 11 May 2012 09:21:24 +0530
Message-ID: <CAJ6a13akLHpBi5HrA__j8oV09R_eLrsrw2gju-H3j7fQ46o0qw@mail.gmail.com>
Subject: Re: [PATCH V3 07/10] ARM: OMAP2+: SmartReflex: Use per-OPP data structure
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "Guyotte, Greg" <gguyotte@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>, Paul Walmsley <paul@pwsan.com>,
        "Gopinath, Thara" <thara@ti.com>, "Menon, Nishanth" <nm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for reviewing.

On Fri, May 11, 2012 at 12:41 AM, Guyotte, Greg <gguyotte@ti.com> wrote:
> Hi Jean,
>
>> -----Original Message-----
>> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>> owner@vger.kernel.org] On Behalf Of J, KEERTHY
>> Sent: Thursday, April 26, 2012 12:41 PM
>> To: linux-omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>> Hilman, Kevin; rjw@sisk.pl; linux-kernel@vger.kernel.org; linux-
>> pm@lists.linux-foundation.org
>> Cc: Pihet-XID, Jean; J, KEERTHY; Paul Walmsley; Gopinath, Thara; Menon,
>> Nishanth
>> Subject: [PATCH V3 07/10] ARM: OMAP2+: SmartReflex: Use per-OPP data
>> structure
>>
>> From: Jean Pihet <j-pihet@ti.com>
>>
>> The SmartReflex driver incorrectly treats some per-OPP data as data
>> common to all OPPs (e.g., ERRMINLIMIT).  Move this data into a per-OPP
>> data structure.
>>
>> Furthermore, in order to make the SmartReflex implementation ready for
>> the move to drivers/, remove the dependency from the SR driver code
>> to the voltage layer by querying the data tables only from the SR device
>> init code.
>>
>> Based on Paul's original code for the SmartReflex driver conversion.
>>
>> Signed-off-by: Jean Pihet <j-pihet@ti.com>
>> Signed-off-by: J Keerthy <j-keerthy@ti.com>
>> Cc: Paul Walmsley <paul@pwsan.com>
>> Cc: Thara Gopinath <thara@ti.com>
>> Cc: Nishanth Menon <nm@ti.com>
>> Cc: Kevin Hilman <khilman@ti.com>
>> ---
>>  arch/arm/mach-omap2/smartreflex.c |   38 +++++++++++++++++---------------
>> ----
>>  arch/arm/mach-omap2/sr_device.c   |   36 +++++++++++++++++++++++++++++---
>> --
>>  include/linux/power/smartreflex.h |    8 +++++-
>>  3 files changed, 54 insertions(+), 28 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-
>> omap2/smartreflex.c
>> index acef08d..20075de 100644
>> --- a/arch/arm/mach-omap2/smartreflex.c
>> +++ b/arch/arm/mach-omap2/smartreflex.c
>> @@ -347,22 +347,23 @@ static void sr_v2_disable(struct omap_sr *sr)
>>       sr_write_reg(sr, IRQSTATUS, IRQSTATUS_MCUDISABLEACKINT);
>>  }
>>
>> -static u32 sr_retrieve_nvalue(struct omap_sr *sr, u32 efuse_offs)
>> +static struct omap_sr_nvalue_table *sr_retrieve_nvalue_row(
>> +                             struct omap_sr *sr, u32 efuse_offs)
>>  {
>>       int i;
>>
>>       if (!sr->nvalue_table) {
>>               dev_warn(&sr->pdev->dev, "%s: Missing ntarget value table\n",
>>                       __func__);
>> -             return 0;
>> +             return NULL;
>>       }
>>
>>       for (i = 0; i < sr->nvalue_count; i++) {
>>               if (sr->nvalue_table[i].efuse_offs == efuse_offs)
>> -                     return sr->nvalue_table[i].nvalue;
>> +                     return &sr->nvalue_table[i];
>>       }
>>
>> -     return 0;
>> +     return NULL;
>>  }
>>
>>  /* Public Functions */
>> @@ -586,7 +587,7 @@ int sr_enable(struct voltagedomain *voltdm, unsigned
>> long volt)
>>  {
>>       struct omap_volt_data *volt_data;
>>       struct omap_sr *sr = _sr_lookup(voltdm);
>> -     u32 nvalue_reciprocal;
>> +     struct omap_sr_nvalue_table *nvalue_row;
>>       int ret;
>>
>>       if (IS_ERR(sr)) {
>> @@ -602,16 +603,16 @@ int sr_enable(struct voltagedomain *voltdm, unsigned
>> long volt)
>>               return PTR_ERR(volt_data);
>>       }
>>
>> -     nvalue_reciprocal = sr_retrieve_nvalue(sr, volt_data-
>> >sr_efuse_offs);
>> +     nvalue_row = sr_retrieve_nvalue_row(sr, volt_data->sr_efuse_offs);
>>
>> -     if (!nvalue_reciprocal) {
>> -             dev_warn(&sr->pdev->dev, "%s: NVALUE = 0 at voltage %ld\n",
>> -                     __func__, volt);
>> +     if (!nvalue_row) {
>> +             dev_warn(&sr->pdev->dev, "%s: failure getting SR data for this
>> voltage %ld\n",
>> +                      __func__, volt);
>>               return -ENODATA;
>>       }
>>
>>       /* errminlimit is opp dependent and hence linked to voltage */
>> -     sr->err_minlimit = volt_data->sr_errminlimit;
>> +     sr->err_minlimit = nvalue_row->errminlimit;
>>
>>       pm_runtime_get_sync(&sr->pdev->dev);
>>
>> @@ -624,7 +625,7 @@ int sr_enable(struct voltagedomain *voltdm, unsigned
>> long volt)
>>       if (ret)
>>               return ret;
>>
>> -     sr_write_reg(sr, NVALUERECIPROCAL, nvalue_reciprocal);
>> +     sr_write_reg(sr, NVALUERECIPROCAL, nvalue_row->nvalue);
>>
>>       /* SRCONFIG - enable SR */
>>       sr_modify_reg(sr, SRCONFIG, SRCONFIG_SRENABLE, SRCONFIG_SRENABLE);
>> @@ -872,7 +873,6 @@ static int __init omap_sr_probe(struct platform_device
>> *pdev)
>>       struct omap_sr_data *pdata = pdev->dev.platform_data;
>>       struct resource *mem, *irq;
>>       struct dentry *nvalue_dir;
>> -     struct omap_volt_data *volt_data;
>>       int i, ret = 0;
>>
>>       sr_info = kzalloc(sizeof(struct omap_sr), GFP_KERNEL);
>> @@ -990,12 +990,10 @@ static int __init omap_sr_probe(struct
>> platform_device *pdev)
>>               goto err_debugfs;
>>       }
>>
>> -     omap_voltage_get_volttable(sr_info->voltdm, &volt_data);
>> -     if (!volt_data) {
>> -             dev_warn(&pdev->dev, "%s: %s: No Voltage table for the"
>> -                     " corresponding vdd. Cannot create debugfs"
>> -                     "entries for n-values\n",
>> -                     __func__, sr_info->name);
>> +     if (sr_info->nvalue_count == 0 || !sr_info->nvalue_table) {
>> +             dev_warn(&pdev->dev, "%s: %s: No Voltage table for the
>> corresponding vdd. Cannot create debugfs entries for n-values\n",
>> +                      __func__, sr_info->name);
>> +
>>               ret = -ENODATA;
>>               goto err_debugfs;
>>       }
>> @@ -1003,8 +1001,8 @@ static int __init omap_sr_probe(struct
>> platform_device *pdev)
>>       for (i = 0; i < sr_info->nvalue_count; i++) {
>>               char name[NVALUE_NAME_LEN + 1];
>>
>> -             snprintf(name, sizeof(name), "volt_%d",
>> -                      volt_data[i].volt_nominal);
>> +             snprintf(name, sizeof(name), "volt_%lu",
>> +                             sr_info->nvalue_table[i].volt_nominal);
>>               (void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
>>                               &(sr_info->nvalue_table[i].nvalue));
>>       }
>> diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-
>> omap2/sr_device.c
>> index e081174..e107e39 100644
>> --- a/arch/arm/mach-omap2/sr_device.c
>> +++ b/arch/arm/mach-omap2/sr_device.c
>> @@ -36,7 +36,10 @@ static void __init sr_set_nvalues(struct omap_volt_data
>> *volt_data,
>>                               struct omap_sr_data *sr_data)
>>  {
>>       struct omap_sr_nvalue_table *nvalue_table;
>> -     int i, count = 0;
>> +     int i, j, count = 0;
>> +
>> +     sr_data->nvalue_count = 0;
>> +     sr_data->nvalue_table = NULL;
>>
>>       while (volt_data[count].volt_nominal)
>>               count++;
>> @@ -44,8 +47,14 @@ static void __init sr_set_nvalues(struct omap_volt_data
>> *volt_data,
>>       nvalue_table = kzalloc(sizeof(struct omap_sr_nvalue_table)*count,
>>                       GFP_KERNEL);
>>
>> -     for (i = 0; i < count; i++) {
>> +     if (!nvalue_table) {
>> +             pr_err("OMAP: SmartReflex: cannot allocate memory for n-value
>> table\n");
>> +             return;
>> +     }
>> +
>> +     for (i = 0, j = 0; i < count; i++) {
>>               u32 v;
>> +
>>               /*
>>                * In OMAP4 the efuse registers are 24 bit aligned.
>>                * A __raw_readl will fail for non-32 bit aligned address
>> @@ -58,15 +67,30 @@ static void __init sr_set_nvalues(struct
>> omap_volt_data *volt_data,
>>                               omap_ctrl_readb(offset + 1) << 8 |
>>                               omap_ctrl_readb(offset + 2) << 16;
>>               } else {
>> -                      v = omap_ctrl_readl(volt_data[i].sr_efuse_offs);
>> +                     v = omap_ctrl_readl(volt_data[i].sr_efuse_offs);
>>               }
>>
>> -             nvalue_table[i].efuse_offs = volt_data[i].sr_efuse_offs;
>> -             nvalue_table[i].nvalue = v;
>> +             /*
>> +              * Many OMAP SoCs don't have the eFuse values set.
>> +              * For example, pretty much all OMAP3xxx before
>> +              * ES3.something.
>> +              *
>> +              * XXX There needs to be some way for board files or
>> +              * userspace to add these in.
>> +              */
>> +             if (v == 0)
>> +                     continue;
>> +
>> +             nvalue_table[j].nvalue = v;
>> +             nvalue_table[j].efuse_offs = volt_data[i].sr_efuse_offs;
>> +             nvalue_table[j].errminlimit = volt_data[i].sr_errminlimit;
>> +             nvalue_table[j].volt_nominal = volt_data[i].volt_nominal;
>> +
>> +             j++;
>>       }
>>
>>       sr_data->nvalue_table = nvalue_table;
>> -     sr_data->nvalue_count = count;
>> +     sr_data->nvalue_count = j;
>>  }
>>
>>  static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
>> diff --git a/include/linux/power/smartreflex.h
>> b/include/linux/power/smartreflex.h
>> index 78b795e..222f901 100644
>> --- a/include/linux/power/smartreflex.h
>> +++ b/include/linux/power/smartreflex.h
>> @@ -243,12 +243,16 @@ struct omap_sr_class_data {
>>  /**
>>   * struct omap_sr_nvalue_table       - Smartreflex n-target value info
>>   *
>> - * @efuse_offs:      The offset of the efuse where n-target values are stored.
>> - * @nvalue:  The n-target value.
>> + * @efuse_offs:        The offset of the efuse where n-target values are
>> stored.
>> + * @nvalue:    The n-target value.
>> + * @errminlimit:  The value of the ERRMINLIMIT bitfield for this n-target
>> + * @volt_nominal: microvolts DC that the VDD is initially programmed to
>>   */
>>  struct omap_sr_nvalue_table {
>>       u32 efuse_offs;
>>       u32 nvalue;
>> +     u32 errminlimit;
>> +     unsigned long volt_nominal;
>
> [GG] I would suggest that we also need to add errmaxlimit and errweight fields to this structure.  These are very much possible to change per OPP, though it hasn't been common in implementations up to now.

Ok. Since this patch set is focussed on minimal clean up and moving the code
from mach-omap to drivers this is not addressed. I will sure take this up once
this is moved.

>
>>  };
>>
>>  /**
>> --
>> 1.7.5.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards and Thanks,
Keerthy
