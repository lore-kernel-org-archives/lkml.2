Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965Ab2EWTUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:20:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39088 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965326Ab2EWTSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:18:02 -0400
Date: Wed, 23 May 2012 21:17:48 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai
 threshold
Message-ID: <20120523191747.GA2348@netboy.at.omicron.at>
References: <cover.1337348892.git.richardcochran@gmail.com>
 <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com>
 <4FBA84EF.5040506@linaro.org>
 <20120521190815.GA19812@netboy.at.omicron.at>
 <20120522173953.GA4177@netboy.at.omicron.at>
 <4FBBD591.1000103@linaro.org>
 <20120523082916.GA15627@localhost.localdomain>
 <4FBD1545.4070408@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBD1545.4070408@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:50:13AM -0700, John Stultz wrote:
> On 05/23/2012 01:29 AM, Richard Cochran wrote:
> >Okay, if you want it that way, then you will have to add the other
> >cases. For example:
> >
> >	switch (code) {
> >	case INS:
> >		if (U == epoch) {
> >			U--;
> >			T++;
> >			code = OOP;
> >		}
> >		break;
> >	case OOP:
> >		if (U == epoch) {
> epoch + 1 here, right?

No, I really mean epoch (not the leap second value, but the value when
the new TAI offset comes into effect).

> >			code = WAIT;
> >		}
> >		break;
> >	case DEL:
> >		if (U == epoch - 1) {
> >			U++;
> >			T--;
> >			code = WAIT;
> >		}
> >		break;
> >	default:
> >		break;
> >	}
> >	return (U, code, T);
> >
> >This is beginning to look a lot like the code in my patch. However,
> >your approach is somewhat simpler, because it assumes the tick will
> >never miss a second overflow.
> 
> I'm a little unclear on the above, because it looks like you're
> modifying the state from the reader.

Sorry about that. Here is a more exact pseudo code:

	switch (time_state) {
	case INS:
		if (U == epoch) {
			U--;
			T++;
			result_code = OOP;
		}
		break;
	case OOP:
		if (U == epoch) {
			result_code = WAIT;
		}
		break;
	case DEL:
		if (U == epoch - 1) {
			U++;
			T--;
			result_code = WAIT;
		}
		break;
	default:
		break;
	}
	return (U, result_code, T);

> I still don't think it matters. If we know the when next leap second
> is supposed to be, if the time_state is INS, then we can still
> handle things without extra state.
> 
> if (unlikely(CODE == INS&&   U == next_leap))
> 	return (U-1, OOP, T+1);
>
> if (unlikely(CODE == INS&&   U == next_leap + 1))
> 	return (U-1, WAIT, T+1);

And what if (U > next_leap + 1)?

In that case, you must also return WAIT. Are you going to add a test
for every second beyond 'next_leap'? I don't think so.

> 
> if (unlikely(CODE == DEL&&   U == next_leap - 1))
> 	return (U+1, WAIT, T-1);
> 
> 
> So even if we somehow sleep for two seconds over the leap second,
> and then an application hits the read critical section before the
> timer interrupt comes in the update the state, we can still provide
> correct state transition in the reader.

No, I think what you wrote above is not correct.

> Thus the only additional state you might need over what we already
> have is the next_leap value.

Again, you will need two things.

1. the epoch threshold value (not the leap second value)
2. whether the new epoch has been applied yet, or not

Thanks,
Richard
