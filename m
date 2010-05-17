Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0EQPy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:54:59 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:37302 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab0EQPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:54:58 -0400
Subject: Re: [PATCH 1/1] regulator: return set_mode is same mode is
 requested
From: Sundar R Iyer <sundar.iyer@stericsson.com>
Reply-To: <sundar.iyer@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Linus WALLEIJ <linus.walleij@stericsson.com>
In-Reply-To: <20100517153431.GA6218@opensource.wolfsonmicro.com>
References: <1274105393-32197-1-git-send-email-sundar.iyer@stericsson.com>
	 <20100517144411.GD5257@opensource.wolfsonmicro.com>
	 <1274108214.20589.28.camel@bnru01> <1274109402.20589.39.camel@bnru01>
	 <20100517153431.GA6218@opensource.wolfsonmicro.com>
Content-Type: text/plain
Organization: STEricsson
Date: Mon, 17 May 2010 21:24:48 +0530
Message-ID: <1274111688.20589.54.camel@bnru01>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 17:34 +0200, Mark Brown wrote:
> This doesn't seem like the right error handling - if the driver has a
> set_mode() you'd *expect* it to have a get_mode() but there's no need
> for it to be a strict requirement.
True. In such a case, even a valid request would be lost! So now
in the updated patch:
 - check if get_mode is present to avoid oops;
 - if get_mode is not present, proceed anyways for the request.

Here is the updated patch:

>From bad0d5eb51ef84be5b100e3dd0f5a590ea0529b6 Mon Sep 17 00:00:00 2001
From: Sundar R Iyer <sundar.iyer@stericsson.com>
Date: Fri, 14 May 2010 15:14:17 +0530
Subject: [PATCH 1/1] regulator: return set_mode when same mode is requested

save I/O costs by returning when the same mode is
requested for the regulator

Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>
---
 drivers/regulator/core.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 98e5d14..2248087 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1745,6 +1745,7 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode)
 {
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
+	int regulator_curr_mode;
 
 	mutex_lock(&rdev->mutex);
 
@@ -1754,6 +1755,15 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode)
 		goto out;
 	}
 
+	/* return if the same mode is requested */
+	if (rdev->desc->ops->get_mode) {
+		regulator_curr_mode = rdev->desc->ops->get_mode(rdev);
+		if (regulator_curr_mode == mode) {
+			ret = 0;
+			goto out;
+		}
+	}
+
 	/* constraints check */
 	ret = regulator_check_mode(rdev, mode);
 	if (ret < 0)
-- 
1.7.0



