Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017Ab2COOc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:32:56 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:22049 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760113Ab2COOcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:32:51 -0400
Date: Thu, 15 Mar 2012 15:32:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ville =?UTF-8?B?U3lyasOkbMOk?= <syrjala@sci.fi>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, ben-linux@fluff.org
Subject: Re: [PATCH] i2c-algo-bit: Fix spurious SCL timeouts under heavy
 load
Message-ID: <20120315153240.75efc254@endymion.delvare>
In-Reply-To: <1331713973-7711-1-git-send-email-syrjala@sci.fi>
References: <1331713973-7711-1-git-send-email-syrjala@sci.fi>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ville,

On Wed, 14 Mar 2012 10:32:52 +0200, Ville Syrjälä wrote:
> When the system is under heavy load, there can be a significant delay
> between the getscl() and time_after() calls inside sclhi(). That delay
> may cause the time_after() check to trigger after SCL has gone high,
> causing sclhi() to return -ETIMEDOUT.
> 
> To fix the problem, double check that SCL is still low after the
> timeout has been reached, before deciding to return -ETIMEDOUT.
> 
> Signed-off-by: Ville Syrjälä <syrjala@sci.fi>
> ---
> I can easily reproduce these spurious timeouts on my HP-compaq nc6000
> laptop with the radeon kms driver. It's enough to have a -j2 kernel
> build running, and simultaneosly issue xrandr commands in a
> terminal. Calling xrandr will cause the driver to re-read the EDID
> from the display. A significant number of the EDID reads will fail.
> With this fix I have yet to see any failed EDID reads.

Thanks for describing a test case, I was able to reproduce the problem
easily by following your instructions. The problem is real, even with
the pending fixes I have to radeon's I2C implementation.

I only have one concern about your implementation:

> 
>  drivers/i2c/algos/i2c-algo-bit.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/algos/i2c-algo-bit.c b/drivers/i2c/algos/i2c-algo-bit.c
> index 525c734..d25112e 100644
> --- a/drivers/i2c/algos/i2c-algo-bit.c
> +++ b/drivers/i2c/algos/i2c-algo-bit.c
> @@ -104,9 +104,11 @@ static int sclhi(struct i2c_algo_bit_data *adap)
>  		 * are processing data internally.
>  		 */
>  		if (time_after(jiffies, start + adap->timeout))
> -			return -ETIMEDOUT;
> +			break;
>  		cond_resched();
>  	}
> +	if (!getscl(adap))
> +		return -ETIMEDOUT;

This means double-check even in the most common case where time_after()
didn't cause the loop break. From a performance perspective, this seems
undesirable. What would you think of the alternative fix below?

--- linux-3.3-rc7.orig/drivers/i2c/algos/i2c-algo-bit.c	2012-03-15 09:33:10.232176790 +0100
+++ linux-3.3-rc7/drivers/i2c/algos/i2c-algo-bit.c	2012-03-15 14:52:48.127778459 +0100
@@ -103,8 +103,14 @@ static int sclhi(struct i2c_algo_bit_dat
 		 * chips may hold it low ("clock stretching") while they
 		 * are processing data internally.
 		 */
-		if (time_after(jiffies, start + adap->timeout))
+		if (time_after(jiffies, start + adap->timeout)) {
+			/* Test one last time, as we may have been preempted
+			 * between last check and timeout test.
+			 */
+			if (getscl(adap))
+				break;
 			return -ETIMEDOUT;
+		}
 		cond_resched();
 	}
 #ifdef DEBUG

Functionally it should be equivalent to your proposal, but faster. I'll
apply that (and send for stable inclusion.)

Thanks,
-- 
Jean Delvare
