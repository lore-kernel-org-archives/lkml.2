Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2EAGQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:16:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37602 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2EAGQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:16:18 -0400
Date: Tue, 1 May 2012 08:16:05 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] ntp: advertise correct TAI offset during leap
 second
Message-ID: <20120501061605.GC2243@netboy.at.omicron.at>
References: <cover.1335442155.git.richardcochran@gmail.com>
 <7af92d6eabef55ddce07007ea515eda2e1474c52.1335442155.git.richardcochran@gmail.com>
 <4F9B1C55.50004@linaro.org>
 <20120428061718.GA2258@netboy.at.omicron.at>
 <4F9EEC86.8010201@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9EEC86.8010201@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 12:48:22PM -0700, John Stultz wrote:
> On 04/27/2012 11:17 PM, Richard Cochran wrote:
> >
> >Wait a minute. If user space manages this variable, then shouldn't the
> >kernel leave it alone?
> 
> Right. That's why I'm asking. I actually haven't spent much time
> looking at how the tai value provided via adjtimex is handled, and I
> want to make sure its ok if we modify it from the kernel.

We *are* already modifying it in kernel, but at the wrong time.

I don't know either what ntpd does, but I will find out.

[ But if ntpd just uses adjtimex() to use the kernel as storage for
  variables, then that is really stupid. ]

> >This David Mills paper [1] gives a leap second example that does it
> >the "other" way from Linux (see Figure 4), repeating the new epoch
> >rather than the leap second. It may well be that ntp.org servers do
> >behave that way. However, the NIST file claims that this way is
> >unusual.
> >
> >So, you have a good question. But, if ntp.org uses the NIST second
> >method, shouldn't Linux do the same?
> >
> Not sure I'm following here.  In Linux 23:59:60 is represented as
> 23:59:59 + TIME_OOP.  Could you expand on what in particular is
> inconsistent here?

I am talking about the numerical values of time_t. The NIST note
explains it well. There are two ways to insert a leap second, and
neither way is specified by any standard, or at least I think that is
what the note is saying.

So you can have either sequences [1] or [2] during a leap second, but
not [3], which is what you are doing. The Mills paper has a table that
looks like [2], but the NIST note says that is not usual. So, I wonder
what ntpd broadcasts during a leap second.

    NTP		OFF	TAI		UTC       STATUS
[1] ----------------------------------------------------
    2287785598	10	78796808  	78796798  ins
    2287785599	10	78796809  	78796799  ins
    2287785599	11	78796810  	78796799  oop
    2287785600	11	78796811  	78796800  wait
    2287785601	11	78796812  	78796801  wait
[2] ----------------------------------------------------
    2287785598	10	78796808  	78796798  ins
    2287785599	10	78796809  	78796799  ins
    2287785600	10	78796810  	78796800  oop
    2287785600	11	78796811  	78796800  wait
    2287785601	11	78796812  	78796801  wait
[3] ----------------------------------------------------
    2287785598	10	78796808  	78796798  ins
    2287785599	10	78796809  	78796799  ins
    2287785599	10	78796809 *  	78796799  oop
    2287785600	11	78796811 * 	78796800  wait
    2287785601	11	78796812  	78796801  wait

* Notice apparent jump in TAI value.

Thanks,
Richard
