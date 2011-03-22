Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1CVWbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:31:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55551 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752338Ab1CVWbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:31:45 -0400
Date: Tue, 22 Mar 2011 22:31:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Deadlock scenario in regulator core
Message-ID: <20110322223156.GA10782@opensource.wolfsonmicro.com>
References: <4D891C59.1030009@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D891C59.1030009@codeaurora.org>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 03:02:01PM -0700, David Collins wrote:

> The locks for S1 and L2 are taken in opposite orders in the two threads;
> therefore, it is possible to achieve deadlock.  I am not sure about the
> best way to resolve this situation.  Is there a correctness requirement
> that regulator_enable holds the child regulator's lock when it attempts to
> enable the parent regulator?  Likewise, is the lock around
> _notifier_call_chain required?

No need to hold the child lock, when we take the reference on the supply
we own the reference.  It's just that the systems which need to use
daisychained regulators (mostly a DCDC to power LDOs for better
efficiency) are moderately rare and tend to not bother representing the
supply relationship as the parent regulator tends to be always on.

In fact it looks rather like the refcounting for supplies is wrong
anyway, regulator_disable() unconditionally drops references to supplies
but regulator_enable() only enables them if the refcount was previously
zero, and it appears we don't clean up supplies after failed enables.
The below patch (which I've not even compile tested) should resolve both
issues, could you give it a spin and let me know if it works for you
please?

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3ffc697..0a7fbde 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1284,19 +1284,6 @@ static int _regulator_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
 
-	if (rdev->use_count == 0) {
-		/* do we need to enable the supply regulator first */
-		if (rdev->supply) {
-			mutex_lock(&rdev->supply->mutex);
-			ret = _regulator_enable(rdev->supply);
-			mutex_unlock(&rdev->supply->mutex);
-			if (ret < 0) {
-				rdev_err(rdev, "failed to enable: %d\n", ret);
-				return ret;
-			}
-		}
-	}
-
 	/* check voltage and requested load before enabling */
 	if (rdev->constraints &&
 	    (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS))
@@ -1370,10 +1357,27 @@ int regulator_enable(struct regulator *regulator)
 {
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret = 0;
+	int disret;
+
+	if (rdev->supply) {
+		ret = regulator_enable(rdev->supply);
+		if (ret < 0) {
+			rdev_err(rdev, "failed to enable supply: %d\n", ret);
+			return ret;
+		}
+	}
 
 	mutex_lock(&rdev->mutex);
 	ret = _regulator_enable(rdev);
 	mutex_unlock(&rdev->mutex);
+
+	if (ret != 0 && rdev->supply) {
+		disret = regulator_disable(rdev->supply);
+		if (disret < 0)
+			rdev_err(rdev, "failed to disable supply: %d\n",
+				 disret);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_enable);
