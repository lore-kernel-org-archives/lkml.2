Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1DOBTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 21:19:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45205 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab1DOBTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 21:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mX9reiLa5lkK1Z1XNrNvxV7plreKOMZbcf932phR0lHl5F8u8Z4SFtqlRZT3EbIJLn
         XcCIvZwUNbuzolJdSwug==
MIME-Version: 1.0
In-Reply-To: <1302821370.26780.585.camel@groeck-laptop>
References: <1302816996-6345-1-git-send-email-natg@google.com>
	<1302817069-6389-1-git-send-email-natg@google.com>
	<1302821370.26780.585.camel@groeck-laptop>
Date: Thu, 14 Apr 2011 18:18:57 -0700
Message-ID: <BANLkTin6M0R4d+HMovbRwqthSHowUEKFow@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] Use "request_muxed_region" in it87 watchdog drivers
From: Natarajan Gurumoorthy <natg@google.com>
To: guenter.roeck@ericsson.com
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

On Thu, Apr 14, 2011 at 3:49 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> This is way too complicated. Just return an error if
> request_muxed_region fails, like all other callers of
> request_muxed_region do.
>
Guenter,
      This maybe a little complicated but it is a solution that will
correctly deal with the following scenario:
      Hardware: it8712f
      cpu: Multicore
      kernel: smp
      Modules being loaded during initialization: it8712f_wtd and w83697hf

The problem is one of the cores is halfway through initializing
it8712f_wdt and another core is just starting to run the
"w83697hf_check_wdt" which is going to call "request_region" to
reserve 0x2e 0x2f region. Just after that call on the other core
it8712f_wdt_init calls it8712f_wdt_disable which calls superio_enter
which will call "request_muxed_region" for the exact same region. This
is  guaranteed to fail because as of now w83697hf is one of the many
non compliant drivers who are calling "request_region". The w83697hf
will do the probe and conclude there is no w83697hf chip in the system
and abort rest of the driver initialization. Meanwhile the it8712f_wtd
driver initialization will fail. This will be one of those
intermittent failures that make most kernel device driver writers
prematurely bald :-).

The way I have reworked the driver will survive the above scenario.

Regards
Nat

> Guenter
>
>
>



-- 
Regards
Nat Gurumoorthy AB6SJ
