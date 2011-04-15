Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1DOIqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 04:46:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58628 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1DOIqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 04:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qvY867VnYdKDE0Sgpg4wwZtxF3+Ba3qgCGBRy3p1TkzDE8mtb3kgV5DQFBkvl9vBc4
         7sE5XLQ3z4kzvrFtiy1A==
MIME-Version: 1.0
In-Reply-To: <20110415055852.GA21905@ericsson.com>
References: <1302816996-6345-1-git-send-email-natg@google.com>
	<1302817069-6389-1-git-send-email-natg@google.com>
	<1302821370.26780.585.camel@groeck-laptop>
	<BANLkTin6M0R4d+HMovbRwqthSHowUEKFow@mail.gmail.com>
	<20110415024005.GA21642@ericsson.com>
	<BANLkTi=t+AgRU47DhKoGOJ2mTa6AVfaPVw@mail.gmail.com>
	<20110415055852.GA21905@ericsson.com>
Date: Fri, 15 Apr 2011 01:46:04 -0700
Message-ID: <BANLkTi=464Q8z7GzDZw9Mb-j-L4O0bPRjg@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] Use "request_muxed_region" in it87 watchdog drivers
From: Natarajan Gurumoorthy <natg@google.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 10:58 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> I have seen the list. I don't think you should fix everything in one go.
> First step might be to get the w83697hf and it87 to work together, then
> go from there.
>
> Is there a reason for loading (or trying to load) both the it87 and
> the w83697hf driver at the same time ? Those drivers are usually only
> loaded if the respective chip is known to exist. If there is no reason
> to try loading both drivers, a simple workaround would be to not do it.
>
Guenter,
      I agree the above should never happen. The only way the 2
drivers will be loaded at the same time is a misconfigured kernel
where these 2 drivers get built and the rc scripts end up loading them
too. If we are agreed that I suggest we make the superio_enter routine
be the following:

static inline void
superio_enter(void)
{
	/*
	 * Reserve REG and REG + 1 for exclusive access.
	 */
	while (!request_muxed_region(REG, 2, WATCHDOG_NAME))
		continue;

	outb(0x87, REG);
	outb(0x01, REG);
	outb(0x55, REG);
	outb(0x55, REG);
}

What I am suggesting is not returning an error and instead keep
calling "request_muxed_region" till it succeeds. If superio_enter
returns an error then we will have to rewrite a large chunk of
it8712f_wdt to deal with it. There are 8-9 calls to superio_enter. We
will have supreio_enter returning errors at awkward places in the
driver where the current logic has no code to deal with errors.

In case of properly written drivers the while loop will eventually
exit. I agree this is ugly as sin but it limits the perturbation of
the driver. Feedback please.

Regards
Nat


> Thanks,
> Guenter
>
>



-- 
Regards
Nat Gurumoorthy AB6SJ
