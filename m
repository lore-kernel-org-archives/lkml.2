Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab2AYHjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 02:39:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43701 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2AYHjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 02:39:36 -0500
MIME-Version: 1.0
Date: Wed, 25 Jan 2012 08:39:35 +0100
Message-ID: <CADkCAutiOaeJitJ-8xCWRJGaxD=m7a+2oNc-xqKJu9t+JdZYQw@mail.gmail.com>
Subject: Add NULL pointer checks to regulator_enable() et. al?
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-kernel@vger.kernel.org
Cc: lrg@slimlogic.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys:


(Please CC me on replies).


I have this pattern coming up a LOT in my code:

   struct regulator *reg;

   /* probe() */
   reg = regulator_get(dev, "VLOGIC");

   /* elsewhere() */
   if (!IS_ERR_OR_NULL(reg))
     ret = regulator_enable(reg);

   /* remove() */
   if (!IS_ERR_OR_NULL(reg))
      regulator_put(reg);

It comes up particularly often in drivers that are doing aggressive
runtime power management.

Unlike other kernel API, a NULL pointer from regulator_get() isn't a
true "error": it just means that there is no regulator associated with
the requested pin and device.  It seems natural, therefore, for
regulator_enable() and friends to not consider a NULL regulator
pointer to be an error--- and definitely not something OOPS-worthy.
But if I forget even ONE check in the above code, that's exactly what
I get: an OOPS.  But all those checks seem to be just tedium and noise
in this case.

Is there something truly objectionable in the following patch?  If
not, then I'm happy to post a more complete one.

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5b2328d..b6e303a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1482,9 +1482,16 @@ static int _regulator_enable(struct regulator_dev *rdev)
  */
 int regulator_enable(struct regulator *regulator)
 {
-	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *rdev;
 	int ret = 0;

+	if (unlikely(!regulator))
+		return 0;
+	if (unlikely(IS_ERR(regulator)))
+		return PTR_ERR(regulator);
+
+	rdev = regulator->rdev;
+
 	mutex_lock(&rdev->mutex);

 	if (!regulator_check_voltage_update(rdev)) {


Note that I'm not arguing for such treatment all over the kernel---
just certain places in the regulator framework!


Kindest regards,


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
