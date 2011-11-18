Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1KRTGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:06:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab1KRTGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:06:44 -0500
Date: Fri, 18 Nov 2011 20:06:38 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Purdie <rpurdie@rpsys.net>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "leds: save the delay values after a successful
 call to blink_set()"
Message-ID: <20111118190638.GA19331@localhost>
References: <1317973118.3988.2.camel@jlt3.sipsolutions.net>
 <1320662197-21471-1-git-send-email-jhovold@gmail.com>
 <20111116222100.323aa751b8a19c0fc2e08a97@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116222100.323aa751b8a19c0fc2e08a97@studenti.unina.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 10:21:00PM +0100, Antonio Ospite wrote:
> On Mon,  7 Nov 2011 11:36:37 +0100
> Johan Hovold <jhovold@gmail.com> wrote:
> 
> > This reverts commit 6123b0e274503a0d3588e84fbe07c9aa01bfaf5d.
> > 
> > The problem this patch intends to solve has already been fixed by commit
> > 7a5caabd090b8f7 (drivers/leds/ledtrig-timer.c: fix broken sysfs delay
> > handling).
> > 
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> 
> Sorry for not replying earlier, I was on vacation.
> 
> Thanks Johan, I've just verified the timer trigger works fine on 3.1
> indeed even without my changes. But keep reading, please.
> 
> > ---
> > 
> > Hi, 
> > 
> > A fix for the problem with the delay parameters not being stored is already in
> > 3.1 (and stable). Rather than storing both values at every call to
> > led_blink_set only the updated value is stored in led_delay_{on,off}_store in
> > ledtrig-timer.c.
> >
> 
> I thought that this was better fixed in the led_blink_set() directly,
> as delay_on and delay_off are led_cdev fields after all, not
> necessarily specific to ledtrig-timer, what about other users of them?
> For example I can see led_blink_set() used in: net/mac80211/led.c
> and led_trigger_blink(), which uses led_blink_set() in:
> drivers/power/power_supply_leds.c
> 
> Maybe I am missing something.

When ledtrig-timer was generalised to led_set_blink() with fallback to
software blinking, the blink_delay_{on,off} parameters were moved to
led_classdev and now have two, partly overlapping uses: to store the
ledtrig-timer delay parameters and to implement generic software
blinking.

Note that both uses are internal -- drivers implementing hardware
blinking through blink_set() receives both parameters at each call and
need not access these fields directly. And apart from the ledtrig-timer
sysfs interface there is no other way to read them back either.

In particular, there is currently no need to update them at each call to
led_blink_set() as far as I can see.

Thanks,
Johan
