Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab2KIDDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 22:03:36 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52260 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab2KIDDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 22:03:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=PdNoBzpZoHWcHSqh_az2OOGGGegNzCXPxjUDVOHostw@mail.gmail.com>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
	<20121108163835.GA8877@core.coreip.homeip.net>
	<CAKohpo=PdNoBzpZoHWcHSqh_az2OOGGGegNzCXPxjUDVOHostw@mail.gmail.com>
Date: Fri, 9 Nov 2012 08:33:33 +0530
Message-ID: <CAKohpok4oi2RkRKnNi02bCkKazuWErQBKTfmeJAO4LdHHAawCA@mail.gmail.com>
Subject: Re: [PATCH 1/3] input: spear-keyboard: Use devm_*() routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 November 2012 08:06, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 8 November 2012 22:08, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>> There is devm_request_and_ioremap() which you can use here.
>
> Should have been done in V1 only.

Hi Dmitry,

Please apply below fixup to original patch:

----------------x-------------------------x--------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 9 Nov 2012 08:22:28 +0530
Subject: [PATCH] fixup! input: spear-keyboard: Use devm_*() routines

---
 drivers/input/keyboard/spear-keyboard.c | 41 ++++++++++++---------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/input/keyboard/spear-keyboard.c
b/drivers/input/keyboard/spear-keyboard.c
index b8784df..25e0a3b 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -55,7 +55,6 @@

 struct spear_kbd {
 	struct input_dev *input;
-	struct resource *res;
 	void __iomem *io_base;
 	struct clk *clk;
 	unsigned int irq;
@@ -205,11 +204,15 @@ static int __devinit spear_kbd_probe(struct
platform_device *pdev)
 	}

 	kbd = devm_kzalloc(&pdev->dev, sizeof(*kbd), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!kbd || !input_dev) {
+	if (!kbd) {
+		dev_err(&pdev->dev, "out of memory\n");
+		return -ENOMEM;
+	}
+
+	input_dev = devm_input_allocate_device(&pdev->dev);
+	if (!input_dev) {
 		dev_err(&pdev->dev, "out of memory\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+		return -ENOMEM;
 	}

 	kbd->input = input_dev;
@@ -218,41 +221,29 @@ static int __devinit spear_kbd_probe(struct
platform_device *pdev)
 	if (!pdata) {
 		error = spear_kbd_parse_dt(pdev, kbd);
 		if (error)
-			goto err_free_mem;
+			return error;
 	} else {
 		kbd->mode = pdata->mode;
 		kbd->rep = pdata->rep;
 		kbd->suspended_rate = pdata->suspended_rate;
 	}

-	kbd->res = devm_request_mem_region(&pdev->dev, res->start,
-			resource_size(res), pdev->name);
-	if (!kbd->res) {
-		dev_err(&pdev->dev, "keyboard region already claimed\n");
-		error = -EBUSY;
-		goto err_free_mem;
-	}
-
-	kbd->io_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	kbd->io_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!kbd->io_base) {
-		dev_err(&pdev->dev, "ioremap failed for kbd_region\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+		dev_err(&pdev->dev, "request-ioremap failed for kbd_region\n");
+		return -ENOMEM;
 	}

 	kbd->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(kbd->clk)) {
-		error = PTR_ERR(kbd->clk);
-		goto err_free_mem;
-	}
+	if (IS_ERR(kbd->clk))
+		return PTR_ERR(kbd->clk);

 	error = clk_prepare(kbd->clk);
 	if (error)
-		goto err_free_mem;
+		return error;

 	input_dev->name = "Spear Keyboard";
 	input_dev->phys = "keyboard/input0";
-	input_dev->dev.parent = &pdev->dev;
 	input_dev->id.bustype = BUS_HOST;
 	input_dev->id.vendor = 0x0001;
 	input_dev->id.product = 0x0001;
@@ -293,8 +284,6 @@ static int __devinit spear_kbd_probe(struct
platform_device *pdev)

 err_unprepare_clk:
 	clk_unprepare(kbd->clk);
-err_free_mem:
-	input_free_device(input_dev);

 	return error;
 }
