Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031710Ab2COQdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:33:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:10760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030656Ab2COQdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:33:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="121346943"
Date: Thu, 15 Mar 2012 18:39:27 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-algo-bit: Fix spurious SCL timeouts under heavy load
Message-ID: <20120315163927.GK4917@intel.com>
References: <1331713973-7711-1-git-send-email-syrjala@sci.fi>
 <20120315153240.75efc254@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120315153240.75efc254@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 03:32:40PM +0100, Jean Delvare wrote:
> Hi Ville,
> 
> On Wed, 14 Mar 2012 10:32:52 +0200, Ville Syrjälä wrote:
> > When the system is under heavy load, there can be a significant delay
> > between the getscl() and time_after() calls inside sclhi(). That delay
> > may cause the time_after() check to trigger after SCL has gone high,
> > causing sclhi() to return -ETIMEDOUT.
> > 
> > To fix the problem, double check that SCL is still low after the
> > timeout has been reached, before deciding to return -ETIMEDOUT.
> > 
> > Signed-off-by: Ville Syrjälä <syrjala@sci.fi>
> > ---
> > I can easily reproduce these spurious timeouts on my HP-compaq nc6000
> > laptop with the radeon kms driver. It's enough to have a -j2 kernel
> > build running, and simultaneosly issue xrandr commands in a
> > terminal. Calling xrandr will cause the driver to re-read the EDID
> > from the display. A significant number of the EDID reads will fail.
> > With this fix I have yet to see any failed EDID reads.
> 
> Thanks for describing a test case, I was able to reproduce the problem
> easily by following your instructions. The problem is real, even with
> the pending fixes I have to radeon's I2C implementation.
> 
> I only have one concern about your implementation:
> 
> > 
> >  drivers/i2c/algos/i2c-algo-bit.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/i2c/algos/i2c-algo-bit.c b/drivers/i2c/algos/i2c-algo-bit.c
> > index 525c734..d25112e 100644
> > --- a/drivers/i2c/algos/i2c-algo-bit.c
> > +++ b/drivers/i2c/algos/i2c-algo-bit.c
> > @@ -104,9 +104,11 @@ static int sclhi(struct i2c_algo_bit_data *adap)
> >  		 * are processing data internally.
> >  		 */
> >  		if (time_after(jiffies, start + adap->timeout))
> > -			return -ETIMEDOUT;
> > +			break;
> >  		cond_resched();
> >  	}
> > +	if (!getscl(adap))
> > +		return -ETIMEDOUT;
> 
> This means double-check even in the most common case where time_after()
> didn't cause the loop break. From a performance perspective, this seems
> undesirable. What would you think of the alternative fix below?

Yeah that fact also occured to today. IIRC I did post an another version
of the patch to some bugzilla quite a while ago that didn't suffer from
this issue. Ah here [1] it is. By that time I no longer had access to the
machine (a Thinkpad T400) where I initially saw the problem, so I didn't
pursue it further.

[1] https://bugs.freedesktop.org/show_bug.cgi?id=29787

> --- linux-3.3-rc7.orig/drivers/i2c/algos/i2c-algo-bit.c	2012-03-15 09:33:10.232176790 +0100
> +++ linux-3.3-rc7/drivers/i2c/algos/i2c-algo-bit.c	2012-03-15 14:52:48.127778459 +0100
> @@ -103,8 +103,14 @@ static int sclhi(struct i2c_algo_bit_dat
>  		 * chips may hold it low ("clock stretching") while they
>  		 * are processing data internally.
>  		 */
> -		if (time_after(jiffies, start + adap->timeout))
> +		if (time_after(jiffies, start + adap->timeout)) {
> +			/* Test one last time, as we may have been preempted
> +			 * between last check and timeout test.
> +			 */
> +			if (getscl(adap))
> +				break;
>  			return -ETIMEDOUT;
> +		}
>  		cond_resched();
>  	}
>  #ifdef DEBUG
>
> Functionally it should be equivalent to your proposal, but faster. I'll
> apply that (and send for stable inclusion.)

Looks good. Thanks for taking care of it.

-- 
Ville Syrjälä
Intel OTC
