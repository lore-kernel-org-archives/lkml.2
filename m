Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2DPUBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:01:21 -0400
Received: from imr3.ericy.com ([198.24.6.13]:42361 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2DPUBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:01:20 -0400
Message-ID: <1334606368.18790.10.camel@groeck-laptop>
Subject: Re: [RFC] IT87xx GPIO and other drivers
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Diego Elio =?ISO-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>
CC: Grant Likely <grant.likely@secretlab.ca>,
        guillaume ligneul <guillaume.ligneul@oselis.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Denis Turischev <denis@compulab.co.il>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Date: Mon, 16 Apr 2012 12:59:28 -0700
In-Reply-To: <4F8C7839.6060104@flameeyes.eu>
References: <4F8C7839.6060104@flameeyes.eu>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 15:51 -0400, Diego Elio Pettenò wrote:
> Hi all, sorry if I'm mailing lots of you at once, but I'm afraid I got
> my hands on a can of worms right now...
> 
> As some of you remember I've been working on a driver for supporting the
> GPIO functions of the IT8728F Super I/O chip, as well as making the WDT
> driver to work on this chip.
> 
> After trying to make a bit of sense of it all, I'm concerned that the
> only _correct_ way to handle this would be to ahve a set of drivers that
> work together, rather than a number of drivers that all do their own
> part. Currently we have:
> 
>  - hwmon/it87 which supports most it87xx chips;
>  - it87_wdt for most it87xx chips (including it8712);
>  - it8712f_wdt which supports the "Smart Guardian" watchdog;
>  - gpio_it8761e for that single IT87xx gpio;
>  - my gpio_it87 driver that works with it8728f and should work with
> it8761e (for what I can tell from the other driver), and Guillaume has
> code for IT8712 as well (which variant?).
> 
> What issues are there with this situation?
> 
> All these drivers use to some extent the Super I/O addresses (0x2e/0x2f)
> to read and write to its registers, including detection code which is
> replicated for each of them. The functions to read and write superio
> registers is also duplicate.
> 
> Only some of these drivers (namely gpio-it8761e for what I can tell)
> support checking both 0x2e/0x2f and 0x4e/0x4f, which is an alternative
> addressing for the superio register handling.
> 
> The GPIO pins on most of the it87xx chips are also multi-function, and
> _should not_ be user-visible, but for some of them it might make sense
> to (for instance it should be possible to drive some of the LEDs on
> it8728f-based motherboards by replacing the functions of some PINs to GPIO).
> 
> For what I can tell, it should probably be a good idea to have something
> along these lines, but I'm _not_ a driver expert:
> 
>  - mfd-it87xx: a platform driver, which probes the superio to check it
> to be an it87xx chip, and then reserve resources for the other drivers;
>  - hwmon/it87: no longer probes autonomously for which chip it is, and
> where it is;
>  - it87_wdt: ibidem;
>  - it8712_wdt: no clue about it, but I guess the same;
>  - gpio-it87: ibidem again;
>  - pinctrl-it87: abstracts support for the various pin-choice registers;
>  - led-it87: possibly to drive the power/network/hdd leds, akin to what
> happens with some laptops, and embedded systems.
> 
> Does a plan like this make sense? Denis have you still access to an
> it8761e board?
> 
Yes, that sounds about right.

Guenter


