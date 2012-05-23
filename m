Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab2EWI3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:29:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40313 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab2EWI31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:29:27 -0400
Date: Wed, 23 May 2012 10:29:16 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai
 threshold
Message-ID: <20120523082916.GA15627@localhost.localdomain>
References: <cover.1337348892.git.richardcochran@gmail.com>
 <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com>
 <4FBA84EF.5040506@linaro.org>
 <20120521190815.GA19812@netboy.at.omicron.at>
 <20120522173953.GA4177@netboy.at.omicron.at>
 <4FBBD591.1000103@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBBD591.1000103@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 11:06:09AM -0700, John Stultz wrote:
> On 05/22/2012 10:39 AM, Richard Cochran wrote:
> >On Mon, May 21, 2012 at 09:08:15PM +0200, Richard Cochran wrote:
> >>On Mon, May 21, 2012 at 11:09:51AM -0700, John Stultz wrote:
> >>>On 05/18/2012 07:09 AM, Richard Cochran wrote:
> >>>>+	/* Tracks where we stand with regard to leap the second epoch. */
> >>>>+	enum {
> >>>>+		LEAP_IDLE,
> >>>>+		LEAP_INS_PENDING,
> >>>>+		LEAP_INS_DONE,
> >>>>+		LEAP_DEL_PENDING,
> >>>>+		LEAP_DEL_DONE,
> >>>>+	} leap_state;
> >...
> >
> >>I don't think I am explaining this very well. I will try again to make
> >>it clear using a table or something later on.
> >The following table illustrates what happens around a (fictitious)
> >leap second. Imagine a new epoch will occur at UTC time value 10 and
> >the new TAI - UTC offset will be 2 seconds. The columns of the table
> >show the values of the relevant time variables.
> >
> >U:     UTC time
> >CODE:  NTP time code
> >T:     TAI - UTC offset
> >P:     pending (explained below)
> >
> >    U   CODE    T   P
> >  --------------------
> >    1   INS     1   1  leap second sheduled
> >  --------------------
> >    2   INS     1   1
> >  --------------------
> >        ...
> >  --------------------
> >    8   INS     1   1
> >  --------------------
> >    9   INS     1   1
> >  --------------------
> >| 10   OOP     1   1  leap second, 1st tick
> >|~~~~~~~~~~~~~~~~~~~
> >|  9           2   0  leap second, 2nd and subsequent ticks
> >  --------------------
> >   10   WAIT    2   0  new epoch
> >  --------------------
> >   11   WAIT    2   0
> 
> Not sure I'm still following.
> 
> It seems currently we have:
> 
>    U   CODE    T
>  ----------------
>    9   INS     1
>  ----------------
>   10   INS     1     pre tick, post leap second edge (this is the technically incorrect interval)
>  ~~~~~~~~~~~~~~~~
>    9   OOP     2     post tick, post leap second edge
>  ----------------
>   10   WAIT    2     new epoch
> 
> 
> If you're trying to correct the pre-tick, post leap second edge, the above provides all you need.
> 
> In the adjtimex code, all you have to do is:
> 
> 
> if (unlikely(CODE == INS&&  U == 10))
> 
> 	/*note, we're not modifying state here, just returning corrected local values*/
> 
> 	return (U-1, OOP, T+1);
> 
> return (U,CODE, T);

Okay, if you want it that way, then you will have to add the other
cases. For example:

	switch (code) {
	case INS:
		if (U == epoch) {
			U--;
			T++;
			code = OOP;
		}
		break;
	case OOP:
		if (U == epoch) {
			code = WAIT;
		}
		break;
	case DEL:
		if (U == epoch - 1) {
			U++;
			T--;
			code = WAIT;
		}
		break;
	default:
		break;
	}
	return (U, code, T);

This is beginning to look a lot like the code in my patch. However,
your approach is somewhat simpler, because it assumes the tick will
never miss a second overflow.

> Since when the tick triggers, we'll move the CODE state appropriately.
> 
> Or am I still missing something?

Considering the tickless options, is it safe to assume that the CODE
state update will never be an entire second too late?  If so, then
I'll rework the patch as above. If not, then I think the patch I
posted already handles all the cases.

Thanks,
Richard
