Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2DQXMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 19:12:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab2DQXMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 19:12:41 -0400
Date: Tue, 17 Apr 2012 16:12:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuahkhan@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH] leds: ledtrig-timer trigger_data allocation fix
Message-Id: <20120417161239.57c41966.akpm@linux-foundation.org>
In-Reply-To: <1334703911.2655.9.camel@lorien2>
References: <1334703911.2655.9.camel@lorien2>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 17:05:11 -0600
Shuah Khan <shuahkhan@gmail.com> wrote:

> ledtrig-timer doesn't allocate memory for trigger_data and assigns
> (void *)1 to save state. Fixed it to allocate int instead. Please 
> note that non-null trigger_data is used to key off of to do proper
> cleanup in deactivation routine and not used during the life of the
> trigger itself.

In that case, overloading the value of ->trigger_data in this fashion
is inappropriate and a new field should be added to led_classdev for
this purpose.

> -	led_cdev->trigger_data = (void *)1;
> +	led_cdev->trigger_data = kzalloc(sizeof(int), GFP_KERNEL);

But that's better than what we have now.

It does require a comment though:

--- a/drivers/leds/ledtrig-timer.c~leds-ledtrig-timer-trigger_data-allocation-fix-fix
+++ a/drivers/leds/ledtrig-timer.c
@@ -89,6 +89,11 @@ static void timer_trig_activate(struct l
 	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
 		      &led_cdev->blink_delay_off);
 
+	/*
+	 * Place a dummy allocation at ->trigger_data so that
+	 * timer_trig_deactivate() cleans up correctly.  This data is never
+	 * actually used.
+	 */
 	led_cdev->trigger_data = kzalloc(sizeof(int), GFP_KERNEL);
 	if (!led_cdev->trigger_data)
 		goto err_out_delayoff;
_

