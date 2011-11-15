Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1KOCmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:42:35 -0500
Received: from nm20-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.21]:21098 "HELO
	nm20-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755196Ab1KOCmd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:42:33 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 927650.48433.bm@omp1029.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=VfH51qM4LSMM5mjIslpymzlQpH5Oxx2vGWfo3CgfYqcLqG6I4dPhhryxHPo2CyYj6JINzEf5PZyupiLV9yOsBvI8XcJcBxFwtjDdmDSTWCOaAlZqCJmrqg53b1weDMjlfW5+tMwaRixuBVUZJq7FiERHx8dAnPuTIoV41/tl6Y8=;
X-YMail-OSG: jlyw00sVM1lZIE9u0O09dOD9Vp2Oj.O1juzYoGF1aWeoOa6
 dhIkZd1pJG_MsIVrzV6MeqKvwrJgFEKlcYwUDG06ZpaYT.pHuljNaVjs7WDw
 SqWRmli9R8HEcZ0GK00dmTzXsTCEySwecnVaQ10AyA27Ul53fnTQ0WY1FrCe
 bMA1.8oAoKwKSXo_6Kzxmr4CId5LaKzUYmK8oqPQVMAX4lG3KhFkYGez7i6S
 JkxXq24OIUPufzuo70eZgWjmddn95rQE9Lj7Pind3STnWpRmPlePn4GN.OMG
 vJNuNpJyJvurTI2wPOB3a10x61qmLovtg9NA0ZpdLOCZfv2iT2RpwlEqnb6d
 5racYIqQqCprCRhCWtRoh8SbtjTnZFUPPiebA26LCC.0UGAcXi_2HuVPLwo9
 CqLckXk_rYFlX9A0PvRg8liEqJgg6m1pUT9cglQfe_9bgyFrnj.xFdhttMX9
 Olr7VZtcg9.PxfV_QKOu9nuiAPP.H41E0yoalxKBQJqRV4Hp15BsKbkAtBNw
 ZJM.SXCFK.vGpKp_2m0N6Db63ptuBbUQH1sPS6wXnXdBSQEwupAcu3oPm27E
 7qFl2J1P_uPyMkGbqdkoqRE.PFn09K.q5k8WLQ7wXgoRi9TfVl0gnx7Kt.p0
 FPLziJGnAWg1rpzWjY3BlAuxKI.W30BfA
X-Mailer: YahooMailWebService/0.8.115.325013
Message-ID: <1321324952.13838.YahooMailNeo@web130105.mail.mud.yahoo.com>
Date: Mon, 14 Nov 2011 18:42:32 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: [PATCH] i915: Fix bug where screen brightness is not restored
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Davis<alex14641@yahoo.com>

This patch fixes an issue where the screen would remain dark when

a key was pressed when the laptop lid was reopened or after the
laptop had gone into power-save mode.

It seems that there are a number of people with different machines
that have this problem:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/872652
https://launchpad.net/~kamalmostafa/+archive/stuck-backlight
and https://bugs.freedesktop.org/show_bug.cgi?id=41926

This patch is against Linux 3.1

Putting printk's in ./drivers/gpu/drm/i915/intel_panel.c showed that 
intel_get_brightness was being called after the panel was disabled,
which caused a 0 to be saved as the value to restore the brightness. 
intel_panel_disable_backlight merely sets the brightness to 0. Commenting
out this call allows the correct brightness value to be saved.

Signed-off-by: Alex Davis <alex14641@yahoo.com>
Tested-by: Kamal Mostafa <kamal@canonical.com>
-----
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index a9e0c7b..6f56676 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -262,8 +262,6 @@ void intel_panel_disable_backlight(struct drm_device *dev)
                dev_priv->backlight_level = intel_panel_get_backlight(dev);
                dev_priv->backlight_enabled = false;
        }
-
-       intel_panel_set_backlight(dev, 0);
 }

 void intel_panel_enable_backlight(struct drm_device *dev)

 

I code, therefore I am
