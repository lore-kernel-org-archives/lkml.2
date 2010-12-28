Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab0L1Mxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 07:53:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52314 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab0L1Mxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 07:53:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YnFJwSZlMC1fKtLJwrHDZCPYWRgavIxfJ1dpT/aEWa/FHhIpPNQ94xax/Z9n+SMZ/I
         M+P2r52fiawLWFRIWgNEg3zP0L2dHB0gCI3pySDLj/IpNjniEyYA02Sq4+XT9KxcO694
         v/0c+K74kDShghteV/kbiO1rRr0ejMwGfhbiE=
Date: Tue, 28 Dec 2010 13:53:32 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Richard Cochran <richard.cochran@omicron.at>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] Cleanup ADJ_SETOFFSET patch
Message-ID: <20101228125332.GA26363@riccoc20.at.omicron.at>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
 <20101228112000.GA17470@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101228112000.GA17470@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 12:20:00PM +0100, Richard Cochran wrote:
> The exisiting code seems to assume that a timespec can only have the
> sign in one field. In other words, if tv_sec is non-zero, then tv_nsec
> must be non-negative. (I added a check for this into my patch).

Looking at ktime.h we find:

 * Be especially aware that negative values are represented in a way
 * that the tv.sec field is negative and the tv.nsec field is greater
 * or equal to zero but less than nanoseconds per second. This is the
 * same representation which is used by timespecs.
 *
 *   tv.sec < 0 and 0 >= tv.nsec < NSEC_PER_SEC

So it seems that the time values (or time intervals) in the range
-1 < x < 0 are not even possible, from the point of view of ktime.

> So it seems that I have now way to correctly encode a negative offset

I meant, "no way"---------^

> less than -1.0 into a timespec. Perhaps we could specify new rules for
> timespecs.

> 1. Time Values:
>    If tv_sec is non-zero, then tv_nsec must be non-negative.
> 
> 2. Time Deltas:
>    The sign of tv_sec and tv_nsec must be the same.

For me, the confusion gets worse when you consider the timespec values
delivered by the system for dates before the 1970 epoch. In that case,
the kernel always gives the tv_nsec value as a positive number. The
value makes sense when interpreted as a sum.

Reading consecutive clock values every 0.1 seconds produces, for
example:

{sec, nsec}        sum
-------------------------
{-2, +600000000}  -1.4
{-2, +700000000}  -1.3
{-2, +800000000}  -1.2
{-2, +900000000}  -1.1
{-1,  000000000}  -1.0
{-1, +100000000}  -0.9
{-1, +200000000}  -0.8
{-1, +300000000}  -0.7

If we say that the time value or interval in a timespec is always the
sum of the fields, still it would seem that the ktime code is broken
according to that assumption.

Perhaps someone can clarify?

Thanks,
Richard








