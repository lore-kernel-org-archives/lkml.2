Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab0L1LNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:13:31 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:57358 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab0L1LNa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:13:30 -0500
From: Sundar R IYER <sundar.iyer@stericsson.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linus.ml.walleij@gmail.com" <linus.ml.walleij@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dtor@mail.ru>
Date: Tue, 28 Dec 2010 12:13:09 +0100
Subject: RE: linux-next: build failure after merge of the final tree
 (ux500-core tree related)
Thread-Topic: linux-next: build failure after merge of the final tree
 (ux500-core tree related)
Thread-Index: AcumJk4vVHS0SF8CT2COcPn+7ooRiwAWZONQ
Message-ID: <33A307AF30D7BF4F811B1568FE7A9B18047CAF8DF1@EXDCVYMBSTM006.EQ1STM.local>
References: <20101223223634.8c92ef31.sfr@canb.auug.org.au>
	<20101227162021.de3af7bc.sfr@canb.auug.org.au>
 <AANLkTinjwN2-cVy8qsemuPOntPy-x0WS9_3t-Hc4xh0+@mail.gmail.com>
In-Reply-To: <AANLkTinjwN2-cVy8qsemuPOntPy-x0WS9_3t-Hc4xh0+@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is the patch which fixes this build issues. I am very sorry for the inconvenience caused.

>From 7338ad3039b3fbd3e20c8691c0bcf6f6fd614904 Mon Sep 17 00:00:00 2001
From: Sundar Iyer <sundar.iyer@stericsson.com>
Date: Tue, 28 Dec 2010 16:37:54 +0530
Subject: [PATCH] input/tc3589x-keypad: fix build issues

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/input/keyboard/tc3589x-keypad.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tcc
3589x-keypad.c
index e363b91..9d64d25 100644
--- a/drivers/input/keyboard/tc3589x-keypad.c
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -206,8 +206,9 @@ static irqreturn_t tc3589x_keypad_irq(int irq, void *dev)
        return IRQ_HANDLED;
 }

-static int tc3589x_keypad_enable(struct tc3589x *tc3589x)
+static int tc3589x_keypad_enable(struct tc_keypad *keypad)
 {
+       struct tc3589x *tc3589x = keypad->tc3589x;
        int ret;

        /* pull the keypad module out of reset */
@@ -241,8 +242,9 @@ static int tc3589x_keypad_enable(struct tc3589x *tc3589x)
        return ret;
 }

-static int tc3589x_keypad_disable(struct tc3589x *tc3589x)
+static int tc3589x_keypad_disable(struct tc_keypad *keypad)
 {
+       struct tc3589x *tc3589x = keypad->tc3589x;
        int ret;

        /* clear IRQ */
@@ -274,10 +276,9 @@ static int tc3589x_keypad_open(struct input_dev *input)
 {
        int error;
        struct tc_keypad *keypad = input_get_drvdata(input);
-       struct tc3589x *tc3589x = keypad->tc3589x;

        /* enable the keypad module */
-       error = tc3589x_keypad_enable(tc3589x);
+       error = tc3589x_keypad_enable(keypad);
        if (error < 0) {
                dev_err(&input->dev, "failed to enable keypad module\n");
                return error;
@@ -295,10 +296,9 @@ static int tc3589x_keypad_open(struct input_dev *input)
 static void tc3589x_keypad_close(struct input_dev *input)
 {
        struct tc_keypad *keypad = input_get_drvdata(input);
-       struct tc3589x *tc3589x = keypad->tc3589x;

        /* disable the keypad module */
-       tc3589x_keypad_disable(tc3589x);
+       tc3589x_keypad_disable(keypad);
 }

 static int __devinit tc3589x_keypad_probe(struct platform_device *pdev)
@@ -388,11 +388,10 @@ err_free_mem:
 static int __devexit tc3589x_keypad_remove(struct platform_device *pdev)
 {
        struct tc_keypad *keypad = platform_get_drvdata(pdev);
-       struct tc3589x *tc3589x = keypad->tc3589x;
        int irq = platform_get_irq(pdev, 0);

        if (!keypad->keypad_stopped)
-               tc3589x_keypad_disable(tc3589x);
+               tc3589x_keypad_disable(keypad);

        free_irq(irq, keypad);

@@ -407,7 +406,6 @@ static int tc3589x_keypad_suspend(struct device *dev)
 {
        struct platform_device *pdev = to_platform_device(dev);
        struct tc_keypad *keypad = platform_get_drvdata(pdev);
-       struct tc3589x *tc3589x = keypad->tc3589x;
        int irq = platform_get_irq(pdev, 0);

        /* keypad is already off; we do nothing */
@@ -416,7 +414,7 @@ static int tc3589x_keypad_suspend(struct device *dev)

        /* if device is not a wakeup source, disable it for powersave */
        if (!device_may_wakeup(&pdev->dev))
-               tc3589x_keypad_disable(tc3589x);
+               tc3589x_keypad_disable(keypad);
        else
                enable_irq_wake(irq);

@@ -427,7 +425,6 @@ static int tc3589x_keypad_resume(struct device *dev)
 {
        struct platform_device *pdev = to_platform_device(dev);
        struct tc_keypad *keypad = platform_get_drvdata(pdev);
-       struct tc3589x *tc3589x = keypad->tc3589x;
        int irq = platform_get_irq(pdev, 0);

        if (!keypad->keypad_stopped)
@@ -435,15 +432,15 @@ static int tc3589x_keypad_resume(struct device *dev)

        /* enable the device to resume normal operations */
        if (!device_may_wakeup(&pdev->dev))
-               tc3589x_keypad_enable(tc3589x);
+               tc3589x_keypad_enable(keypad);
        else
                disable_irq_wake(irq);

        return 0;
 }

-static const SIMPLE_DEV_PM_OPS(tc3589x_keypad_dev_pm_ops, tc3589x_keypad_suspenn
d
-                               ,tc3589x_keypad_resume)
+static const SIMPLE_DEV_PM_OPS(tc3589x_keypad_dev_pm_ops,
+               tc3589x_keypad_suspend, tc3589x_keypad_resume);

 static struct platform_driver tc3589x_keypad_driver = {
        .driver.name  = "tc3589x-keypad",
--
1.7.2.dirty

Please let me know if you can include this patch now.

Cheers!

>-----Original Message-----
>From: Linus Walleij [mailto:linus.ml.walleij@gmail.com]
>Sent: Tuesday, December 28, 2010 6:00 AM
>To: Stephen Rothwell
>Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Sundar R IYER; Dmitry
>Torokhov
>Subject: Re: linux-next: build failure after merge of the final tree (ux500-core tree
>related)
>
>2010/12/27 Stephen Rothwell <sfr@canb.auug.org.au>:
>> Hi all,
>>
>> On Thu, 23 Dec 2010 22:36:34 +1100 Stephen Rothwell <sfr@canb.auug.org.au>
>wrote:
>>>
>>> After merging the final tree, today's linux-next build (powerpc allyesconfig)
>>> failed like this:
>>>
>>> drivers/input/keyboard/tc3589x-keypad.c: In function 'tc3589x_keypad_enable':
>>> drivers/input/keyboard/tc3589x-keypad.c:239: error: 'keypad' undeclared (first
>use in this function)
>>> drivers/input/keyboard/tc3589x-keypad.c: In function 'tc3589x_keypad_disable':
>>> drivers/input/keyboard/tc3589x-keypad.c:268: error: 'keypad' undeclared (first
>use in this function)
>>> drivers/input/keyboard/tc3589x-keypad.c: At top level:
>>> drivers/input/keyboard/tc3589x-keypad.c:448: error: expected ',' or ';' before
>'static'
>>> drivers/input/keyboard/tc3589x-keypad.c: In function 'tc3589x_keypad_init':
>>> drivers/input/keyboard/tc3589x-keypad.c:460: error: 'tc3589x_keypad_driver'
>undeclared (first use in this function)
>>> drivers/input/keyboard/tc3589x-keypad.c: In function 'tc3589x_keypad_exit':
>>> drivers/input/keyboard/tc3589x-keypad.c:466: error: 'tc3589x_keypad_driver'
>undeclared (first use in this function)
>>> drivers/input/keyboard/tc3589x-keypad.c:466: warning: 'return' with a value, in
>function returning void
>>>
>>> Caused by commit 1967733650dac41c93954a187246c91430c4a94f
>>> ("input/tc3589x: add tc3589x keypad support").
>>
>> This error is still there, so I reverted the above commit for today.
>
>Ooopsie, thanks for noticing. I've reverted this driver and pushed now.
>This driver will likely have to wait for the next merge window.
>
>Yours,
>Linus Walleij
