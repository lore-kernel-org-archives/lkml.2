Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab2CSH36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:29:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18111 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2CSH3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:29:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 Mar 2012 00:29:44 -0700
Message-ID: <4F66DF25.9000909@nvidia.com>
Date: Mon, 19 Mar 2012 12:54:21 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "david@protonic.nl" <david@protonic.nl>,
        "tklauser@distanz.ch" <tklauser@distanz.ch>,
        "alexander.stein@informatik.tu-chemnitz.de" 
	<alexander.stein@informatik.tu-chemnitz.de>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1] input: keyboard: gpio: Support for interrupt only
 key
References: <1331715123-15099-1-git-send-email-ldewangan@nvidia.com> <20120314160011.GA12987@core.coreip.homeip.net> <20120319060610.GA8835@core.coreip.homeip.net>
In-Reply-To: <20120319060610.GA8835@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Monday 19 March 2012 11:36 AM, Dmitry Torokhov wrote:
>
> OK, so I am generally happy with the patch; the only issue is that in
> interrupt mode the only event type that makes sense is EV_KEY so we need
> to make sure we do not accept anything else.
>

Thanks for taking care of patch. I am ok with this policy.

> Also, I do not think that having button_irq() that is called all the
> time is the best solution; I;d rather pulled RQ number up into button
> data.
>

Yes, this is nice cleanups.

> I tried doing the above in the patch below. Please let me know if it
> still works for you. Note that it depends on some other patches for
> gpio_keys that I have; I am attaching them for your reference.
>

This works fine with one small change.
The function gpio_keys_report_event() is gettign called from probe for 
initialing the key state. This function should bypass if it is not the 
gpio based otherwise system crash.
I made following change and after that it works fine.

static void gpio_keys_report_event(struct gpio_button_data *bdata)
{
     const struct gpio_keys_button *button = bdata->button;
     struct input_dev *input = bdata->input;
     unsigned int type = button->type ?: EV_KEY;
     int state;

     if (!gpio_is_valid(button->gpio))
         return;

     state = (gpio_get_value_cansleep(button->gpio) ? 1 : 0) ^ 
button->active_low;


