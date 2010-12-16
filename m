Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0LPS1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:27:04 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:53835 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab0LPS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:26:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=i6i2XyQNvz+pOjdWpFmi5s8I/sMaRtAitmZnyFcGRGPeCGO2msm2jtscxgW4xwobYS
         pz+Ds3mI1x9VyS/gcdDtZPrl0PCCgpJZBPr8fbodvZ/UAJcsOjbaSgdHnTzs7A/OhpHh
         bVZnO1WLHQzvYtIvAOdd9xa3BmtpuZUjnVa0M=
MIME-Version: 1.0
Date: Thu, 16 Dec 2010 23:56:57 +0530
X-Google-Sender-Auth: GNbfq7wAeAZrNFdTNrTTFhDxCN4
Message-ID: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
Subject: platform/i2c busses: pm runtime and system sleep
From: Rabin Vincent <rabin@rab.in>
To: rjw@sisk.pl, stern@rowland.harvard.edu
Cc: linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There seem to be some differences between the generic ops and the i2c
and platform busses' implementations of the interaction between runtime
PM and system sleep:

  (1) The platform bus does not implement the
      don't-call-pm->suspend()-if pm_runtime_suspended()-returns-true
      functionality implemented by the generic ops and i2c.

  (2) Both I2C and platform do not set the device as active when a
      pm->resume callback exists and it succeeds.

      This seems to have been done in i2c until recently, but has been
      removed by 753419f59e ("i2c: Fix for suspend/resume issue").  It
      seems to me that this removal is incorrect, and instead the real
      problem with the implementation was that it set the device as
      active even if no resume callback existed, whereas it should only
      do so when it exists and returns zero, like the generic ops.

Are these divergences from the generic ops to be considered as bugs?
Atleast (2) will cause devices which use UNIVERSAL_DEV_PM_OPS to have
incorrect runtime pm state after a resume from system sleep.

If so, before I send patches to fix them: can it be assumed that only
drivers using dev_pm_ops (and not the legacy ops of these busses) will
need the interactions between runtime PM and system sleep as done in the
generic ops?  This would mean that simple busses could simply use the
generic ops like below instead of duplicating their behaviour:

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 6b4cc56..46117e0 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -212,7 +212,7 @@ static int i2c_device_pm_resume(struct device *dev)
 	int ret;

 	if (pm)
-		ret = pm->resume ? pm->resume(dev) : 0;
+		ret = pm_generic_resume(dev);
 	else
 		ret = i2c_legacy_resume(dev);

 thanks,
 Rabin
