Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2DRO6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:58:43 -0400
Received: from host171.canaca.com ([67.55.55.225]:45369 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2DRO6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:58:41 -0400
Message-ID: <2702029527a38f9e28882007b36eaf73.squirrel@mungewell.org>
In-Reply-To: <alpine.LNX.2.00.1204181320180.16373@pobox.suse.cz>
References: <alpine.LNX.2.00.1204131458290.16373@pobox.suse.cz>
    <1334732588-9351-1-git-send-email-simon@mungewell.org>
    <alpine.LNX.2.00.1204181320180.16373@pobox.suse.cz>
Date: Wed, 18 Apr 2012 10:58:39 -0400
Subject: Re: [PATCH 1/2] HID: hid-lg4ff: Add support for G27 LEDs
From: simon@mungewell.org
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Simon Wood" <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Michael Bauer" <michael@m-bauer.org>,
        "Michal Maly" <madcatxster@gmail.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	__u8  led_state;
>> +	struct led_classdev *led[5];
>
> Why not put this under the CONFIG_LEDS_CLASS condition as well?

Can do, I don't think these are referenced anywhere else.

>> +	/* register led subsystem - G27 only */
>> +	entry->led_state = 0;
>> +	for (j = 0; j < 5; j++)
>> +		entry->led[j] = NULL;
>> +
>
> The same here.

OK.

>> +			if (error) {
>> +				hid_err(hid, "failed to register LED %d. Aborting.\n", j);
>> +err:
>> +				/* Deregister LEDs (if any) but let the driver continue */
>> +				for (j = 0; j < 5; j++) {
>> +					led = entry->led[j];
>> +					entry->led[j] = NULL;
>> +					if (!led)
>> +						continue;
>> +					led_classdev_unregister(led);
>> +				kfree(led);
>
> Indentation seems to be wrong here.

Bugger...

>
>> +				}
>> +				break;	/* Don't create any more LEDs */
>
> Putting the whole err: label outside the outer for cycle would make the
> whole thing much more readable (and would save you the break). Could you
> please redo this?

The 'break' is actually not needed as 'j' has reached maximum value and
the outer for loop would be at completion. I put the 'break' there just to
highlight this fact.

Maybe just a comment would be OK, such as 'on error fall though to driver
completion'.

The reason I'd like this code here is that it seems traditional to output
the following 'hid_info' line once the driver is fully active.

>>  	hid_info(hid, "Force feedback for Logitech Speed Force Wireless by
>> Simon Wood <simon@mungewell.org>\n");

Moving the 'err:' code would have to:
1). Jump back to hit this hid_info line
2). Duplicate the hid_info line
3). Have err code called as a function

Any major objections to keeping it as is?


Man, it seems to be taking me ages to get this code right....
Simon

