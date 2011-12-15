Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab1LOJVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:21:01 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54390 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab1LOJU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:20:59 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-10-4ee9bbf9bcfd
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, greg@kroah.com, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com
Subject: [PATCH] misc: max8997-muic: remove sysfs attribute
Date: Thu, 15 Dec 2011 18:20:47 +0900
Message-id: <1323940847-31340-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'switch' sysfs attribute is used for
showing and setting the switch state of the device.
However, setting it from the userspace focibly is not appropriate.
And showing the state can be handled from
other places (e.g. external connector) in a unified manner.
This patch removes the sysfs attribute.
Plus, uevent messages for interrupts are also removed.

The initial max8997-muic driver is merged at:
git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/misc/max8997-muic.c |  137 +-----------------------------------------
 1 files changed, 4 insertions(+), 133 deletions(-)

diff --git a/drivers/misc/max8997-muic.c b/drivers/misc/max8997-muic.c
index 74a9448..d74ef41 100644
--- a/drivers/misc/max8997-muic.c
+++ b/drivers/misc/max8997-muic.c
@@ -307,11 +307,8 @@ static void max8997_muic_irq_work(struct work_struct *work)
 			struct max8997_muic_info, irq_work);
 	struct max8997_platform_data *pdata =
 				dev_get_platdata(info->iodev->dev);
-	char env_name_str[30], env_state_str[15];
-	char *envp[] = { env_name_str, env_state_str, NULL };
 	u8 status[3];
-	u8 adc, adc_low, adc_err;
-	u8 vb_volt, db_chg, dcd_tmr, cdr, chg_type, ovp;
+	u8 adc, chg_type;
 
 	int irq_type = info->irq - pdata->irq_base;
 	int ret;
@@ -330,72 +327,24 @@ static void max8997_muic_irq_work(struct work_struct *work)
 			status[0], status[1]);
 
 	switch (irq_type) {
-	case MAX8997_MUICIRQ_ADCError:
-		adc_err = status[0] & STATUS1_ADCERR_MASK;
-		adc_err >>= STATUS1_ADCERR_SHIFT;
-		sprintf(env_name_str, "IRQ=%s", "ADC_Error");
-		sprintf(env_state_str, "STATE=%d", adc_err);
-		break;
-	case MAX8997_MUICIRQ_ADCLow:
-		adc_low = status[0] & STATUS1_ADCLOW_MASK;
-		adc_low >>= STATUS1_ADCLOW_SHIFT;
-		sprintf(env_name_str, "IRQ=%s", "ADC_Low");
-		sprintf(env_state_str, "STATE=%d", adc_low);
-		break;
 	case MAX8997_MUICIRQ_ADC:
 		adc = status[0] & STATUS1_ADC_MASK;
 		adc >>= STATUS1_ADC_SHIFT;
 
 		max8997_muic_handle_adc(info, adc);
-
-		sprintf(env_name_str, "IRQ=%s", "ADC");
-		sprintf(env_state_str, "STATE=%d", adc);
-		break;
-	case MAX8997_MUICIRQ_VBVolt:
-		vb_volt = status[1] & STATUS2_VBVOLT_MASK;
-		vb_volt >>= STATUS2_VBVOLT_SHIFT;
-		sprintf(env_name_str, "IRQ=%s", "VB_Volt");
-		sprintf(env_state_str, "STATE=%d", vb_volt);
-		break;
-	case MAX8997_MUICIRQ_DBChg:
-		db_chg = status[1] & STATUS2_DBCHG_MASK;
-		db_chg >>= STATUS2_DBCHG_SHIFT;
-		sprintf(env_name_str, "IRQ=%s", "DB_CHARGER");
-		sprintf(env_state_str, "STATE=%d", db_chg);
-		break;
-	case MAX8997_MUICIRQ_DCDTmr:
-		dcd_tmr = status[1] & STATUS2_DCDTMR_MASK;
-		dcd_tmr >>= STATUS2_DCDTMR_SHIFT;
-		sprintf(env_name_str, "IRQ=%s", "DCD_TIMER");
-		sprintf(env_state_str, "STATE=%d", dcd_tmr);
-		break;
-	case MAX8997_MUICIRQ_ChgDetRun:
-		cdr = status[1] & STATUS2_CHGDETRUN_MASK;
-		cdr >>= STATUS2_CHGDETRUN_SHIFT;
-		sprintf(env_name_str, "IRQ=%s", "CHG_DET_RUN");
-		sprintf(env_state_str, "STATE=%d", cdr);
 		break;
 	case MAX8997_MUICIRQ_ChgTyp:
 		chg_type = status[1] & STATUS2_CHGTYP_MASK;
 		chg_type >>= STATUS2_CHGTYP_SHIFT;
 
 		max8997_muic_handle_charger_type(info, chg_type);
-
-		sprintf(env_name_str, "IRQ=%s", "CHARGER_TYPE");
-		sprintf(env_state_str, "STATE=%d", chg_type);
-		break;
-	case MAX8997_MUICIRQ_OVP:
-		ovp = status[2] & STATUS3_OVP_MASK;
-		ovp >>= STATUS3_OVP_SHIFT;
-		sprintf(env_name_str, "IRQ=%s", "OVER-VOLTAGE");
-		sprintf(env_state_str, "STATE=%d", ovp);
 		break;
 	default:
+		dev_info(info->dev, "misc interrupt: %s occurred\n",
+			 muic_irqs[irq_type].name);
 		break;
 	}
 
-	kobject_uevent_env(&info->dev->kobj, KOBJ_CHANGE, envp);
-
 	mutex_unlock(&info->mutex);
 
 	return;
@@ -438,74 +387,6 @@ static void max8997_muic_detect_dev(struct max8997_muic_info *info)
 	max8997_muic_handle_charger_type(info, chg_type);
 }
 
-static ssize_t max8997_muic_show_manualsw(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct max8997_muic_info *info = dev_get_drvdata(dev);
-	int ret;
-	u8 value, manual_switch;
-
-	ret = max8997_read_reg(info->muic, MAX8997_MUIC_REG_CONTROL1, &value);
-	if (ret) {
-		dev_err(info->dev, "failed to read muic register\n");
-		return sprintf(buf, "UNKNOWN\n");
-	}
-
-	manual_switch = value & (COMN1SW_MASK | COMP2SW_MASK);
-
-	switch (manual_switch) {
-	case MAX8997_SW_USB:
-		return sprintf(buf, "USB\n");
-	case MAX8997_SW_AUDIO:
-		return sprintf(buf, "AUDIO\n");
-	case MAX8997_SW_UART:
-		return sprintf(buf, "UART\n");
-	default:
-		return sprintf(buf, "OPEN\n");
-	}
-}
-
-static ssize_t max8997_muic_store_manualsw(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t count)
-{
-	struct max8997_muic_info *info = dev_get_drvdata(dev);
-	int ret;
-	u8 manual_switch;
-
-	if (!strncmp(buf, "USB", 3)) {
-		manual_switch = MAX8997_SW_USB;
-	} else if (!strncmp(buf, "AUDIO", 5)) {
-		manual_switch = MAX8997_SW_AUDIO;
-	} else if (!strncmp(buf, "UART", 4)) {
-		manual_switch = MAX8997_SW_UART;
-	} else if (!strncmp(buf, "OPEN", 4)) {
-		manual_switch = MAX8997_SW_OPEN;
-	} else {
-		dev_err(info->dev, "invalid parameter\n");
-		goto out;
-	}
-
-	ret = max8997_update_reg(info->muic, MAX8997_MUIC_REG_CONTROL1,
-			manual_switch, SW_MASK);
-	if (ret)
-		dev_err(info->dev, "failed to update muic register\n");
-out:
-	return count;
-}
-
-static DEVICE_ATTR(switch, S_IRUGO | S_IWUSR,
-		max8997_muic_show_manualsw, max8997_muic_store_manualsw);
-
-static struct attribute *max8997_muic_attributes[] = {
-	&dev_attr_switch.attr,
-	NULL
-};
-
-static const struct attribute_group max8997_muic_group = {
-	.attrs = max8997_muic_attributes,
-};
-
 static void max8997_initialize_device(struct max8997_muic_info *info)
 {
 	struct max8997_muic_platform_data *mdata = info->muic_pdata;
@@ -545,13 +426,6 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, info);
 	mutex_init(&info->mutex);
 
-	ret = sysfs_create_group(&pdev->dev.kobj, &max8997_muic_group);
-	if (ret) {
-		dev_err(&pdev->dev,
-			"failed to create max8997 muic attribute group\n");
-		goto err_sysfs;
-	}
-
 	INIT_WORK(&info->irq_work, max8997_muic_irq_work);
 
 	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++) {
@@ -583,8 +457,6 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 	return ret;
 
 err_irq:
-	sysfs_remove_group(&pdev->dev.kobj, &max8997_muic_group);
-err_sysfs:
 err_pdata:
 	kfree(info);
 err_kfree:
@@ -598,10 +470,9 @@ static int __devexit max8997_muic_remove(struct platform_device *pdev)
 				dev_get_platdata(info->iodev->dev);
 	int i;
 
-	sysfs_remove_group(&pdev->dev.kobj, &max8997_muic_group);
-
 	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
 		free_irq(pdata->irq_base + muic_irqs[i].irq, info);
+	cancel_work_sync(&info->irq_work);
 
 	kfree(info);
 
-- 
1.7.4.1

