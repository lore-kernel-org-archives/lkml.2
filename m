Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2EVRkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:40:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33697 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2EVRkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:40:05 -0400
Date: Tue, 22 May 2012 19:39:53 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai
 threshold
Message-ID: <20120522173953.GA4177@netboy.at.omicron.at>
References: <cover.1337348892.git.richardcochran@gmail.com>
 <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com>
 <4FBA84EF.5040506@linaro.org>
 <20120521190815.GA19812@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521190815.GA19812@netboy.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 09:08:15PM +0200, Richard Cochran wrote:
> On Mon, May 21, 2012 at 11:09:51AM -0700, John Stultz wrote:
> > On 05/18/2012 07:09 AM, Richard Cochran wrote:
> > >+	/* Tracks where we stand with regard to leap the second epoch. */
> > >+	enum {
> > >+		LEAP_IDLE,
> > >+		LEAP_INS_PENDING,
> > >+		LEAP_INS_DONE,
> > >+		LEAP_DEL_PENDING,
> > >+		LEAP_DEL_DONE,
> > >+	} leap_state;

...

> I don't think I am explaining this very well. I will try again to make
> it clear using a table or something later on.

The following table illustrates what happens around a (fictitious)
leap second. Imagine a new epoch will occur at UTC time value 10 and
the new TAI - UTC offset will be 2 seconds. The columns of the table
show the values of the relevant time variables.

U:     UTC time
CODE:  NTP time code
T:     TAI - UTC offset
P:     pending (explained below)

   U   CODE    T   P 
 --------------------
   1   INS     1   1  leap second sheduled
 --------------------
   2   INS     1   1 
 --------------------
       ...
 --------------------
   8   INS     1   1 
 --------------------
   9   INS     1   1 
 --------------------
| 10   OOP     1   1  leap second, 1st tick
|~~~~~~~~~~~~~~~~~~~
|  9           2   0  leap second, 2nd and subsequent ticks
 --------------------
  10   WAIT    2   0  new epoch
 --------------------
  11   WAIT    2   0 

Without adding some extra state, it is impossible to decide if UTC
time value 10 means OOP or WAIT. With the current tick based
implementation, this value can appear in the leap second and also in
the new epoch. A similar problem exists for UTC time value 9. We
cannot consult the NTP state to figure these out, since that is what
we are trying to compute in the first place.

The solution I came up with is to add a "leap second pending" flag
which tracks whether the leap second correction has been applied yet,
shown in column P. Since the case for deletion is a bit different than
insertion, there are actually two flags, and together they appear in
the new enumerated state variable.

So, I hope that explains why this extra state is needed.

Thanks,
Richard
