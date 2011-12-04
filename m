Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1LDIyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 03:54:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63801 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab1LDIyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 03:54:12 -0500
Date: Sun, 4 Dec 2011 00:54:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Feng Tang <feng.tang@intel.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Clark, Joel" <joel.clark@intel.com>
Subject: Re: [PATCH 2/2] Input: tsc2007 - Add a z1_low_threshhold platform
 data parameter
Message-ID: <20111204085405.GD14593@core.coreip.homeip.net>
References: <1322554378-348-1-git-send-email-feng.tang@intel.com>
 <1322554378-348-2-git-send-email-feng.tang@intel.com>
 <20111129092310.GB21758@core.coreip.homeip.net>
 <20111130103418.4514b630@feng-i7>
 <20111201054726.GC16816@core.coreip.homeip.net>
 <20111201141948.13162071@feng-i7>
 <20111201084524.GB31610@core.coreip.homeip.net>
 <20111201170455.2e8ebcfc@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201170455.2e8ebcfc@feng-i7>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 05:04:55PM +0800, Feng Tang wrote:
> Hi Dmitry,
> 
> 
> On Thu, 1 Dec 2011 16:45:24 +0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> 
> > > > 
> > > > Even if we add the pressure threshold would not that noise cause
> > > > endless stream of interrupts?
> > > 
> > > No, there is no endless interrupts for tsc2007. Without the z1
> > > threshold, the while circle in tsc2007_soft_irq will run endlessly
> > > as the noise data will be seen as a valid data:
> > > 
> > > 		rt = tsc2007_calculate_pressure(ts, &tc);
> > > 		if (rt == 0 && !ts->get_pendown_state) {
> > > 			/*
> > > 			 * If pressure reported is 0 and we don't
> > > have
> > > 			 * callback to check pendown state, we have
> > > to
> > > 			 * assume that pen was lifted up.
> > > 			 */
> > > 			break;
> > > 		}
> > > 
> > > With the z1 threshold check, the rt will be 0 for noise data, and
> > > the code flow broke out.
> > 
> > What I meant is with the threshold check we'll break out of the ISR
> > but why won't IRQ be raised again?
> 
> The IRQ will be fired again after we exist the tsc2007_soft_irq in my
> test, as I re-enable the irq before existing the code.
> 
> > 
> > > 
> > > > 
> > > > Also, what kind of z2 is reported with low z1? And do you
> > > > implement get_pendown_state()?
> > > 
> > > z2 seems normal as some data between 3000-4000. We don't have a
> > > get_pendown_state().
> > 
> > OK, there is max_rt platform parameter. I think we should employ it
> > instead and break out if we get several incorrect samples in a row.
> > Too bad you do not have a dedicate method.
> > 
> No, the max_rt won't help here, if the rt > max_rt, it won't break the
> while loop, but just issue a warning message
> 
> 		if (rt <= ts->max_rt) {
> 			.......
> 
> 		} else {
> 			/*
> 			 * Sample found inconsistent by debouncing or pressure is
> 			 * beyond the maximum. Don't report it to user space,
> 			 * repeat at least once more the measurement.
> 			 */
> 			dev_dbg(&ts->client->dev, "ignored pressure %d\n", rt);
> 		}

What I meant that we need to ajust the logic to _exit_ the loop if we
receive several samples with rt > max_rt instead of adding a new
parameter.

Thanks.

-- 
Dmitry
