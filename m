Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0IUTo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:44:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753740Ab0IUTo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:44:56 -0400
Date: Tue, 21 Sep 2010 12:44:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Purdie <rpurdie@rpsys.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] led-class: always implement blinking
Message-Id: <20100921124419.6b88f7f6.akpm@linux-foundation.org>
In-Reply-To: <1282296102.3785.28.camel@jlt3.sipsolutions.net>
References: <1282296102.3785.28.camel@jlt3.sipsolutions.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 11:21:42 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> +static int led_blink_set(struct led_classdev *led_cdev,
> +			 unsigned long *delay_on, unsigned long *delay_off)
> +{
> +	int current_brightness;
> +
> +	current_brightness = led_get_brightness(led_cdev);
> +	if (current_brightness)
> +		led_cdev->blink_brightness = current_brightness;
> +	if (!led_cdev->blink_brightness)
> +		led_cdev->blink_brightness = led_cdev->max_brightness;
> +
> +	if (*delay_on == led_cdev->blink_delay_on &&
> +	    *delay_off == led_cdev->blink_delay_off)
> +		return 0;
> +
> +	/* deactivate previous settings */
> +	del_timer_sync(&led_cdev->blink_timer);
> +
> +	led_cdev->blink_delay_on = *delay_on;
> +	led_cdev->blink_delay_off = *delay_off;
> +
> +	/* never on - don't blink */
> +	if (!*delay_on)
> +		return 0;
> +
> +	/* never off - just set to brightness */
> +	if (!*delay_off) {
> +		led_set_brightness(led_cdev, led_cdev->blink_brightness);
> +		return 0;
> +	}
> +
> +	mod_timer(&led_cdev->blink_timer, jiffies + 1);
> +
> +	return 0;
> +}

delay_on and delay_off could have been pass-by-value rather than
pass-by-reference?  That would clean up some gunk in callers, too.

If there was some reason for doing it with pass-by-reference then that
reason should have been documented!
