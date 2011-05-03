Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab1ECCBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 22:01:44 -0400
Received: from anumail9.anu.edu.au ([130.56.64.136]:44139 "EHLO
	anumail9.anu.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1ECCBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 22:01:42 -0400
X-Greylist: delayed 947 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 22:01:42 EDT
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF0497F1B201@HQMAIL01.nvidia.com>
Date: Tue, 3 May 2011 11:45:21 +1000
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D43C969C-DB05-4778-AB2B-824EB9A3CF7D@niasdigital.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com> <74CDBE0F657A3D45AFBB94109FB122FF0497F1B201@HQMAIL01.nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
X-Mailer: Apple Mail (2.1084)
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.3.13616 internal
X-PMX-Outbound: anu.edu.au
X-PMX-Info: external-sender
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MIME_VERSION_APPLEMAIL 0, __MSGID_APPLEMAIL 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT_APPLEMAIL 0, __X_MAILER_APPLEMAIL 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/05/2011, at 6:52 AM, Stephen Warren wrote:

> Linus Walleij wrote at Monday, May 02, 2011 1:16 PM:
>> From: Linus Walleij <linus.walleij@linaro.org>
>> 
>> This creates a subsystem for handling of pinmux devices. These are
>> devices that enable and disable groups of pins on primarily PGA and
>> BGA type of chip packages and common in embedded systems.
> 
> I would avoid any references to particular package types; I've seen
> pinmuxing applied to PLCC and DIP/DIL too, and in general, it's possible
> irrespective of package type.
> 
>> This is being done to depopulate the arch/arm/* directory of such
>> custom drivers and try to abstract the infrastructure they all
>> need. See the Documentation/pinmux.txt file that is part of this
>> patch for more details.
> 
>> diff --git a/Documentation/pinmux.txt b/Documentation/pinmux.txt
>> ...
>> +The mux settings are:
>> +
>> +- Oriented around enumerated physical pins or pads denoted by unsigned
>> +  integers in the range 0..MAX_INT. Every pin on your system (or atleast
>> +  every pin that can be muxed) should have a unique number. The numberspace
> 
> Does this imply a model where each pin's "special function" can be
> controlled independently? I think reading through the document that
> isn't the case, but I just wanted to be sure.

The relevant driver can /request/ each special function independently but if
the pinmux driver can't implement it for whatever reason, including being
batshit-crazy like Tegra, it can just return an error.  It's still up to the
board designer to ensure the requested setup is physically possible.

> 
> In particular, NVIDIA Tegra has a setup where:
> 
> * Pinmux configuration for "special functions" is at a "pad-group"
> level, where there may be 1..N pins in a pad-group, and there is a
> single register field that defines the current special function routed
> to/from all pins in that pad-group at once.
> 
> * Each pad group can be assigned 1 of N special functions (none might be
> an option in some/all cases too)
> 
> * Some special functions may be assignable to multiple pad groups,
> although obviously only 1 pad group per function at a time.

To me that all looks like it can be encapsulated by this interface

> 
> * GPIO selection is at per-pin granularity; individual pins may be used
> as a GPIO irrespective of what SFR is selected for the pad group
> containing the pin.
> 
> * There are also other configurations associated with pinmuxing, such
> as drive strength, pull up/down enables, etc.

This pin configuration stuff should be bunted to gpiolib gpio_config()
callbacks which Linus implemented last week.

> 
> Also, some of our drivers use "dynamic pinmuxing". For example, our
> downstream I2C driver exposes N I2C busses and reprograms the pinmux
> at runtime to attach the actual I2C controller to different sets of
> pins, essentially multi-plexing the control across N physical busses.

Neat!  Should be a perfect use-case for this pinmux subsystem.  Perhaps,
if you've got time, you could try and implement a pinmux driver for your
chip and make sure all bases are covered?  Nothing like taking a madhouse
chip and actually trying to code for it to shake down a new interface like
this one :)

	--Ben.

