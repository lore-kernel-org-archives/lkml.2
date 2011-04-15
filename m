Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1DOCkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 22:40:55 -0400
Received: from imr3.ericy.com ([198.24.6.13]:42738 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab1DOCky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 22:40:54 -0400
Date: Thu, 14 Apr 2011 19:40:05 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Natarajan Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] Use "request_muxed_region" in it87 watchdog
 drivers
Message-ID: <20110415024005.GA21642@ericsson.com>
References: <1302816996-6345-1-git-send-email-natg@google.com>
 <1302817069-6389-1-git-send-email-natg@google.com>
 <1302821370.26780.585.camel@groeck-laptop>
 <BANLkTin6M0R4d+HMovbRwqthSHowUEKFow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTin6M0R4d+HMovbRwqthSHowUEKFow@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 09:18:57PM -0400, Natarajan Gurumoorthy wrote:
> On Thu, Apr 14, 2011 at 3:49 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > This is way too complicated. Just return an error if
> > request_muxed_region fails, like all other callers of
> > request_muxed_region do.
> >
> Guenter,
>       This maybe a little complicated but it is a solution that will
> correctly deal with the following scenario:
>       Hardware: it8712f
>       cpu: Multicore
>       kernel: smp
>       Modules being loaded during initialization: it8712f_wtd and w83697hf
> 
> The problem is one of the cores is halfway through initializing
> it8712f_wdt and another core is just starting to run the
> "w83697hf_check_wdt" which is going to call "request_region" to
> reserve 0x2e 0x2f region. Just after that call on the other core
> it8712f_wdt_init calls it8712f_wdt_disable which calls superio_enter
> which will call "request_muxed_region" for the exact same region. This
> is  guaranteed to fail because as of now w83697hf is one of the many
> non compliant drivers who are calling "request_region". The w83697hf
> will do the probe and conclude there is no w83697hf chip in the system
> and abort rest of the driver initialization. Meanwhile the it8712f_wtd
> driver initialization will fail. This will be one of those
> intermittent failures that make most kernel device driver writers
> prematurely bald :-).
> 
> The way I have reworked the driver will survive the above scenario.
> 
Unless I am missing something, the problem is that there is another driver 
calling request_region() instead of request_muxed_region().

w83697hf_check_wdt() (and other drivers doing the same) should call
request_muxed_region(). Otherwise, the same problem could happen with the
caller(s) of request_region() - those calls could fail as well.
Plus, other callers of request_muxed_reason() not implementing
your retry code could end up with the same problem, ie with spurious failures.

I think we will have to find a solution which does not require retries
when calling request_muxed_region(). On the other side, others know
this code much better than I do, so maybe someone has a better solution.

Thanks,
Guenter
