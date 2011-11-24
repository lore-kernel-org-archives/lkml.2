Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1KXPwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:52:08 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:45445 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754080Ab1KXPwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:52:06 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAK1mzk5tg6zW/2dsb2JhbABDqnGBBoFyAQEEATocHAcFCwgDRhQlAyGIGAK1ARKKUASUSZIN
Date: Thu, 24 Nov 2011 16:48:47 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Marc Vertes <marc.vertes@sigfox.com>
Cc: w.sang@pengutronix.de, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, HaraldWelte@viatech.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111124154847.GT23376@infomag.iguana.be>
References: <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com> <20111123104926.GB4063@pengutronix.de> <20111123121329.GM23376@infomag.iguana.be> <20111123122018.GA12227@opensource.wolfsonmicro.com> <20111123124037.GN23376@infomag.iguana.be> <4ecd075d.2YyTTCA13zxwZmwT%marc.vertes@sigfox.com> <20111123214614.GQ23376@infomag.iguana.be> <4ece231e./LkW+9i4Wmz+9zzn%marc.vertes@sigfox.com> <20111124134247.GS23376@infomag.iguana.be> <4ece57c9.2i1u841q3U3s+xD7%marc.vertes@sigfox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ece57c9.2i1u841q3U3s+xD7%marc.vertes@sigfox.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

> The smallest possible value is 1 second, both in BIOS and datasheet. For
> info, the maximum value is 1023 seconds, approx. 17 min.

Good that means that the driver value is allready OK.

> I think it is dangerous to set the timer to 1s, both in BIOS, obviously
> as the boot is still in progress when it expires, and even in the driver,
> where you loose a chance to avoid mandatory reboot after only 1 second
> of latency, even if the hardware timer is higher.
> 
> The value you have set, 15 seconds, is reasonable to me, and should not
> be lowered. If the BIOS was well designed, it should also not allow less
> than, say 1 minute.

I have the feeling that you don't understand the function of the timer...
The timer actually sperates the userspace timeout from the watchdog's heartbeat.
The watchdog's heartbeat is what the hardware is actually using as it's timeout
value. That is the 1 second minimum in this case. if userspace is not using
the watchdog device then the timer will make sure that the watchdog is being
reset each 1/2 seconds (or 500ms). We use the smallest value because we don't
know what the actual value is and need to be safe. I do agree that you should
set this higher in the BIOS to survice the actual boot sequence, but we should
make sure that we reset regularly enough so that the system doesn't reboot in
normal operation. That's why I needed to know the minimum value.

The userspace timeout is the timeout that the watchdog daemon will use.
Meaning: in this time period the daemon needs to ping the watchdog, if not
the system should reboot. So how does the timer do this? When userspace opens
the watchdog (and thus takes control) the timer will know that we should
receive a ping between now and now+timeout. In this period the timer will
reset the watchdog each 500ms (the 1/2 seconds=half of the heartbeat time).
when we are at now+timeout and we did not receive a ping the timer will stop
resetting the watchdog, which will result in a reboot (after expiration of
watchdog's real heartbeat). If in the period between now and now+timeout
userspace did receive a ping, then the timer will now that now+timeout can
be replaced by new_now+timeout. And that's how it works. So the userspace
timeout has no real relation with the watchdog's heartbeat.

Or in short the timer does the following:
1) when /dev/watchdog is not opened by the watchdog dameon, it should reset
the watchdog hardware so that the system doesn't reboot.
2) when /dev/watchdog is opened by the watchdog dameon, it needs to reset
the watchdog hardware so that the system does not reboot unless we didn't
receive a ping in the timeout period. In that case the system should be
rebooted (and we do this by not resetting the watchdog anymore).

Hope this is clearer now.

Extra remark: the value in the BIOS should indeed be chosen with some
common sense: you need to survice the boot sequence, but if the heartbeat
is much higher then the timeout value, then you're system will not reboot
before the heartbeat has passed away (which means that the heartbeat of
your system will dominate anyway).

I think we should change the default timeout value to 60 seconds instead of 15.

Kind regards,
Wim.

