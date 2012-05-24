Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2EXGny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:43:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45925 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2EXGnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:43:52 -0400
Date: Thu, 24 May 2012 08:43:40 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai
 threshold
Message-ID: <20120524064340.GA2180@netboy.at.omicron.at>
References: <cover.1337348892.git.richardcochran@gmail.com>
 <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com>
 <4FBA84EF.5040506@linaro.org>
 <20120521190815.GA19812@netboy.at.omicron.at>
 <20120522173953.GA4177@netboy.at.omicron.at>
 <4FBBD591.1000103@linaro.org>
 <20120523082916.GA15627@localhost.localdomain>
 <4FBD1545.4070408@linaro.org>
 <20120523191747.GA2348@netboy.at.omicron.at>
 <4FBD4613.7040003@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBD4613.7040003@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 01:18:27PM -0700, John Stultz wrote:
> So I've avoided the term epoch just to try not to confuse things
> with the unix epoch, that's why I've used next_leap, etc.
> Even so, I'm not sure you've made clear the subtlety of the difference.

For me, when working with the whole UTC leap second mess, it is
important to distinguish between the leap seconds and the epochs. I
sometime have written mini-epoch to make clear that it is not about
*the* epoch from 1970.

The NIST leap second table give a list of epochs and TAI offsets. The
leap second is always the second just before the epoch. For example:

 30 June 1972 23:59:59 (NTP 2287785599,  first time)  <-- normal second
 30 June 1972 23:59:60 (NTP 2287785599, second time)  <-- leap second
 1  July 1972 00:00:00 (NTP 2287785600)               <-- epoch

We should write the thresholding code so that it is clear whether we
are testing against the epoch or the leap second.

> I believe the internal time_state (along with the next leap second)
> already provides this.
> 
> From the reader's perspective:
> 
> Not applied:		(INS&&  U<  leap):		return (INS, U)
> Applied:		(INS&&   U == leap):		return (OOP, U-1)
> Finished applied:	((INS||OOP)&&  U>= (leap+1)):	return (WAIT,U-1)
> Delete:			(DEL&&  U>= (leap-1)):		return (WAIT,U+1)

I think this is still wrong, but I get your point.

My patch makes the state of the leap second application explicit and
then infers time_state on demand. You can also, of course, make
time_state explicit and infer whether or not the leap second has been
applied.

My point is that in either case, it is the same amount of code.

I prefer what I wrote, because I think it is clearer.

> Again, no state change is done by the reader, so we don't have to
> keep track of application state or not.
> Then when the tick comes in, it will move the state machine appropriately.
> 
> Sorry working this out is so difficult. If we don't come to
> consensus soon, I'll try to find some time to implement what I'm
> suggesting so you aren't up against my unclear hand-waving. :)

BTW you can use the program I have been using to test this at

   git://github.com/richardcochran/leap.git

Thanks,
Richard
