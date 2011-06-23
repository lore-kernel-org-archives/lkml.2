Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1FWFwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 01:52:46 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44984 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1FWFwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 01:52:45 -0400
Message-ID: <4E02D4A5.6080408@canonical.com>
Date: Thu, 23 Jun 2011 13:52:37 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        corentin.chary@gmail.com, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 3/3] ideapad: add backlight driver
References: <1308729781-2590-1-git-send-email-ike.pan@canonical.com> <1308730058-2703-1-git-send-email-ike.pan@canonical.com> <20110622194049.GB8861@srcf.ucam.org>
In-Reply-To: <20110622194049.GB8861@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 03:40 AM, Matthew Garrett wrote:
>> -static void __devexit ideapad_unregister_rfkill(struct acpi_device *adevice,
>> -						int dev)
>> +static void ideapad_unregister_rfkill(struct acpi_device *adevice, int dev)
> 
> This also seems unrelated.
> 

This is because ideapad_unregister_rfkill is called in ideapad_acpi_add
which has markup __devinit, so I get warning when building.



@@ -456,10 +548,19 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 		else
 			priv->rfk[i] = NULL;
 	}
-	ideapad_sync_rfk_state(adevice);
+	ideapad_sync_rfk_state(priv);
+
+	if (!acpi_video_backlight_support()) {
+		ret = ideapad_backlight_init(priv);
+		if (ret && ret != -ENODEV)
+			goto backlight_failed;
+	}
 
 	return 0;
 
+backlight_failed:
+	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
+		ideapad_unregister_rfkill(adevice, i);
 input_failed:
 	ideapad_platform_exit(priv);
 platform_failed:
