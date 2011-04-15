Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1DOF7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 01:59:46 -0400
Received: from imr4.ericy.com ([198.24.6.8]:55194 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab1DOF7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 01:59:45 -0400
Date: Thu, 14 Apr 2011 22:58:52 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Natarajan Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] Use "request_muxed_region" in it87 watchdog
 drivers
Message-ID: <20110415055852.GA21905@ericsson.com>
References: <1302816996-6345-1-git-send-email-natg@google.com>
 <1302817069-6389-1-git-send-email-natg@google.com>
 <1302821370.26780.585.camel@groeck-laptop>
 <BANLkTin6M0R4d+HMovbRwqthSHowUEKFow@mail.gmail.com>
 <20110415024005.GA21642@ericsson.com>
 <BANLkTi=t+AgRU47DhKoGOJ2mTa6AVfaPVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTi=t+AgRU47DhKoGOJ2mTa6AVfaPVw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:14:32PM -0400, Natarajan Gurumoorthy wrote:
> On Thu, Apr 14, 2011 at 7:40 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > Unless I am missing something, the problem is that there is another driver
> > calling request_region() instead of request_muxed_region().
> >
> > w83697hf_check_wdt() (and other drivers doing the same) should call
> > request_muxed_region(). Otherwise, the same problem could happen with the
> > caller(s) of request_region() - those calls could fail as well.
> > Plus, other callers of request_muxed_reason() not implementing
> > your retry code could end up with the same problem, ie with spurious failures.
> >
> > I think we will have to find a solution which does not require retries
> > when calling request_muxed_region(). On the other side, others know
> > this code much better than I do, so maybe someone has a better solution.
> >
> Guenter,
>     Your conclusion is on the money. request_muxed_region will fail if
> someone else called request_region for the same region. The knife cuts
> both ways and reguest_region will fail when a request_muxed_region
> calll has been made for the same zone.  I am not sure what happens
> when the second driver calls request_muxed_region for only part of the
> region that has been reserved by another driver. This is of course one
> of the problems. The other problem is that there are drivers which
> don't call either of those 2 interfaces and just go ahead and clobber
> the 0x2e 0x2f zone because they think they own all of it. I created a
> list drivers in hwmon and watchdog directories that need to be fixed
> in one of my earlier emails. John Delvare replied that are other
> drivers in parport that all need fixing. I got started on this because
> we use 2 different it87 drivers (hwmon/it87.c and
> watchdog/it8712f_wdt.c) concurrently and had to solve this problem.
> 
I have seen the list. I don't think you should fix everything in one go. 
First step might be to get the w83697hf and it87 to work together, then
go from there. 

Is there a reason for loading (or trying to load) both the it87 and
the w83697hf driver at the same time ? Those drivers are usually only
loaded if the respective chip is known to exist. If there is no reason
to try loading both drivers, a simple workaround would be to not do it.

Thanks,
Guenter

