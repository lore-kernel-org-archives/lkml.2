Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab2DZI3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:29:02 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:46772 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374Ab2DZI2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:28:37 -0400
Message-ID: <4F9905F0.6030402@st.com>
Date: Thu, 26 Apr 2012 13:53:12 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Stephen Warren <swarren@nvidia.com>, Kyle Manna <kyle.manna@fuel7.com>,
        Anirudh Ghayal <aghayal@codeaurora.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Hui Wang <jason77.wang@gmail.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Trilok Soni <tsoni@codeaurora.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>, Rakesh Iyer <riyer@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] Input: matrix-keymap - uninline and prepare for device
 tree support
References: <20120426081750.GA2684@core.coreip.homeip.net>
In-Reply-To: <20120426081750.GA2684@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/2012 1:47 PM, Dmitry Torokhov wrote:
> diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
> index 3b6b528..7c8f2bc 100644
> --- a/drivers/input/keyboard/spear-keyboard.c
> +++ b/drivers/input/keyboard/spear-keyboard.c
> @@ -49,7 +49,9 @@
>  #define KEY_VALUE      0x00FFFFFF
>  #define ROW_MASK       0xF0
>  #define COLUMN_MASK    0x0F
> -#define ROW_SHIFT      4
> +#define NUM_ROWS       16
> +#define NUM_COLS       16
> +
>  #define KEY_MATRIX_SHIFT       6
> 
>  struct spear_kbd {
> @@ -60,7 +62,7 @@ struct spear_kbd {
>         unsigned int irq;
>         unsigned int mode;
>         unsigned short last_key;
> -       unsigned short keycodes[256];
> +       unsigned short keycodes[NUM_ROWS * NUM_COLS];
>  };
> 
>  static irqreturn_t spear_kbd_interrupt(int irq, void *dev_id)
> @@ -212,18 +214,17 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
>         input_dev->open = spear_kbd_open;
>         input_dev->close = spear_kbd_close;
> 
> -       __set_bit(EV_KEY, input_dev->evbit);
> +       error = matrix_keypad_build_keymap(keymap, NULL, NUM_ROWS, NUM_COLS,
> +                                          kbd->keycodes, input_dev);
> +       if (error) {
> +               dev_err(&pdev->dev, "Failed to build keymap\n");
> +               goto errr_put_clk;
> +       }
> +
>         if (pdata->rep)
>                 __set_bit(EV_REP, input_dev->evbit);
>         input_set_capability(input_dev, EV_MSC, MSC_SCAN);
> 
> -       input_dev->keycode = kbd->keycodes;
> -       input_dev->keycodesize = sizeof(kbd->keycodes[0]);
> -       input_dev->keycodemax = ARRAY_SIZE(kbd->keycodes);
> -
> -       matrix_keypad_build_keymap(keymap, ROW_SHIFT,
> -                       input_dev->keycode, input_dev->keybit);
> -
>         input_set_drvdata(input_dev, kbd);
> 
>         error = request_irq(irq, spear_kbd_interrupt, 0, "keyboard", kbd);

Have you rebased these patches over my patchset for SPEAr and Tegra?

-- 
viresh
