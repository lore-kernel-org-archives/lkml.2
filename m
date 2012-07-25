Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2GYHjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:39:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42868 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2GYHjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:39:46 -0400
Date: Wed, 25 Jul 2012 00:39:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: George Spelvin <linux@horizon.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REPOST #3 PATCH v2] Input: atkbd - make repeat period more
 accurate.
Message-ID: <20120725073940.GB15997@core.coreip.homeip.net>
References: <20120714110114.31895.qmail@science.horizon.com>
 <20120722034228.14345.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120722034228.14345.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On Sat, Jul 21, 2012 at 11:42:28PM -0400, George Spelvin wrote:
> This replaces some inaccurate lookup tables with an exact
> computation.  Although the diff adds source comments,
> it shrinks binary size.  (By only 50 bytes, but hey.)
> 
> AT keyboard repeat rates are multiples of 1/240 second
> expressed in a 0.2.3 bit floating point format.  That
> is, possible values are ({8..15} << {0..3}) / 240 s.

OK.

> 
> In addition to a slightly inaccurate lookup table, the
> old code would round up to the next repeat period.
> E.g. to get a period of 9/60 = 0.15 seconds, you had to
> ask for no more than 149 ms; if you asked for 150, it
> would round up to 167.

This works as intended - it was designed to never have faster than
requested.

>  The new code rounds to nearest.
> 
> User-visible changes to the repeat periods reported by EVIOCGREP:
> 
> Old	 37	109	116	149	182	232
> Exact	 37.50	108.33	116.66	150.00	183.33	233.33
> New	 38	108	117	150	183	233
> 
> Old	270	303	370	435	470
> Exact	266.66	300.00	366.66	433.33	466.66
> New	267	300	367	433	467
> 
> This does not bother utilities like kbdrate(8).
> 
> Signed-off-by: George Spelvin <linux@horizon.com>

I am sorry but I have to ask - is this your real name?

> ---
>  drivers/input/keyboard/atkbd.c |   47 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 31 insertions(+), 16 deletions(-)
> 
> Now that 3.5 is out, I'm posting this for a FOURTH time,
> hoping for some comments of any sort.
> 
> 
> Now that I've tweaked it (v1 had an error in rounding near exponent
> range boundaries), I think it's ready for merging upstream.
> 
> 
> One possible bug I observed in the code that calls this:
> 
> Users of the KDKBDREP ioctl seem to assume that it returns the actual
> values set, but I'm not sure it really works that way; I don't think
> the command to change the parameters makes its way through the event
> queue and atkbd's schedule_delayed_work() to actually set dev->rep[]
> to the rounded values before kbd_rate_helper returns them to userspace.
> 
> If desired, the fix that's most obvious to me would be to split this
> function in two: perform the conversion to a command byte synchronously,
> and only defer the actual ps2_command().

Yes, I agree, this is a problem.

Thanks.

-- 
Dmitry
