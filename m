Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab2LNEKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 23:10:31 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:35285 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab2LNEK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 23:10:29 -0500
Date: Thu, 13 Dec 2012 21:10:24 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Feng Tang <feng.tang@intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
Message-ID: <20121214041024.GA1040@obsidianresearch.com>
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
 <50CA7EE4.3000306@linaro.org>
 <20121214013725.GA11276@feng-snb>
 <50CA8837.5010800@linaro.org>
 <20121214023826.GA31613@obsidianresearch.com>
 <20121214031330.GC11276@feng-snb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214031330.GC11276@feng-snb>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 11:13:30AM +0800, Feng Tang wrote:

> > This seems like a great use of that hardware resource, and no doubt
> > those mach's also have a class RTC driver available talking to
> > different hardware.
> 
> Interesting to know this, thanks for the info. For the x86 desktop
> and mobile processors I've used, the read_persistent_clock and rtc
> are the same on-board device (always power on), so I see many time
> related code are execuated twice, like init/suspend/resume if
> HCTOSYS config is enabled, that's why I came up with the patches.

Ah, I see, there is some duplication here, my earlier comments about
update_persistent_clock are not quite right, some places like PCs
stick a RTC driver and then continue to access the same hardware
directly outside the rtc driver context! That seems ugly :|

I see the PC CMOS rtc driver does not implement the set_mmss
operation, instead running that code through update_persistent_clock..
That seems like a cleanup waiting to happen.

Regarding your problem - IMHO, it would be fantastic if the class RTC
driver could be used instead of read_persistent_clock on PC.

John mentioned that read_persistent_clock had a requirement to work
with IRQs off - that seems like it would be easy to incorporate into
class rtc - for hardware that supports it (and PC is not the only RTC
HW that can do this) Is that the only reason it still exists on pc?

I have to feel the long term direction should be to remove
*_persistent_clock in favor of class RTC?

> > Maybe Feng would be better off adjusting read_persistent_clock to
> > return ENODEV in such cases??
> 
> For mach's without read_persistent_clock capability, there is already
> a weakly defined 

This is used for arch's without the functionality, mach's are arch
specific things. ARM provides a function pointer indirection for it's
read_persistent_clock implementation.

Jason
