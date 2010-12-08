Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0LHUPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:15:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64234 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0LHUPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:15:21 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=DyXz9hFaH-oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=W5DtAvtns-7MNOLbaAsA:9 a=mdiZ3XTleDTRuafrDdsjfqMFqi8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] timekeeping: Keep xtime_nsec remainder separate
 from ntp_error
From: Steven Rostedt <rostedt@goodmis.org>
To: john stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1291838382.2909.17.camel@work-vm>
References: <1291833054.5015.1133.camel@gandalf.stny.rr.com>
	 <1291838382.2909.17.camel@work-vm>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 08 Dec 2010 15:15:17 -0500
Message-ID: <1291839317.5015.1139.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 11:59 -0800, john stultz wrote:

> Hey Steven!
> 
> Thanks for the great analysis and tooling to help find these unexpected
> behaviors! 
> 
> Sadly, I believe your proposed change can still cause minor nsec
> inconsistencies from gettimeofday/vgettimeofday. In fact, the previous
> implementation where the nsec inconsistency error was observed preserved
> the sub-nanosecond remainder in xtime_nsec.

What inconsistencies exactly? Not to say they aren't any, but I really
want to know exactly what is happening. Even the change log that Roman
showed in that commit does not explain well what the issue was.

Here's the log:

    timekeeping: fix rounding problem during clock update
    
    Due to a rounding problem during a clock update it's possible for readers
    to observe the clock jumping back by 1nsec.  The following simplified
    example demonstrates the problem:
    
    cycle       xtime
    0   0
    1000        999999.6
    2000        1999999.2
    3000        2999998.8
    ...
    
    1500 =      1499999.4
    =   0.0 + 1499999.4
    =   999999.6 + 499999.8
    
    When reading the clock only the full nanosecond part is used, while
    timekeeping internally keeps nanosecond fractions.  If the clock is now
    updated at cycle 1500 here, a nanosecond is missing due to the truncation.
    
    The simple fix is to round up the xtime value during the update, this also
    changes the distance to the reference time, but the adjustment will
    automatically take care that it stays under control.

I have no idea what he's trying to say with that "simplified example".
Where did that "1500" come from? There's a bit too much black magic
going on to make this comfortable.


> 
> I suspect we may need to still round up and store the error, but tweak
> the adjustment code to handle the larger error per-iteration then it was
> originally designed for (note: the current code is still functioning
> properly, its just not often hitting the expected trivial case).

I'm afraid that may also do damage. This code needs real documentation
explaining in detail what the frick it's doing. Having someone that
shows up once ever 10 years that understands it is not something I feel
confident about.

> 
> The only alternative would be to integrate the sub-ns remainder into the
> gettime caclculation (including reworking all the vsyscall
> implementations to utilize it as well).
> 

First lets talk about all the issues, and perhaps even start documenting
what it currently does. The comments in the code are not enough for a
reviewer to understand the logic. I've spent today reading some RFC's to
understand more about NTP but, it still does not explain the magic
constants that are used in the code.

Thanks,

-- Steve


