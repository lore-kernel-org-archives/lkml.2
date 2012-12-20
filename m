Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab2LTQfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:35:45 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41709 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2LTQfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:35:39 -0500
Date: Thu, 20 Dec 2012 08:38:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: Re: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
Message-ID: <20121220163839.GA30120@kroah.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
 <1355822977-4804-5-git-send-email-durgadoss.r@intel.com>
 <20121220054201.GE28007@kroah.com>
 <4D68720C2E767A4AA6A8796D42C8EB5924CB6C@BGSMSX101.gar.corp.intel.com>
 <20121220161202.GA29796@kroah.com>
 <4D68720C2E767A4AA6A8796D42C8EB5924CF1F@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB5924CF1F@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 04:25:32PM +0000, R, Durgadoss wrote:
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, December 20, 2012 9:42 PM
> > To: R, Durgadoss
> > Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > hongbo.zhang@linaro.org; wni@nvidia.com
> > Subject: Re: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
> > 
> > On Thu, Dec 20, 2012 at 07:52:03AM +0000, R, Durgadoss wrote:
> > > > On Tue, Dec 18, 2012 at 02:59:33PM +0530, Durgadoss R wrote:
> > > > > This patch adds a thermal_trip directory under
> > > > > /sys/class/thermal/zoneX. This directory contains
> > > > > the trip point values for sensors bound to this
> > > > > zone.
> > > >
> > > > Eeek, you just broke userspace tools that now can no longer see these
> > > > entries :(
> > > >
> > > > Why do you need to create a subdirectory?  As you found out, doing so
> > > > isn't the easiest, right?  That is on purpose.
> > >
> > > Yes, I observed the complexity.
> > >
> > > >
> > > > I really wouldn't recommend doing this at all, please stick within the
> > > > 'struct device' framework here, don't create new kobjects and hang sysfs
> > > > files off of them.
> > >
> > > But, we cannot put all _trip directly under ZoneX directory.
> > 
> > Why not?  What is preventing this?
> > 
> > > We can remove the thermal_trip directory, and put sensorY_trip under
> > > /sys/class/thermal/zoneX/.  But this sensorY_trip needs to be a
> > > directory which has four sysfs nodes named, active, passive, crit,
> > > hot.
> > >
> > > Rui, What do you think about this ?
> > >
> > > The only other way I see, is directly put
> > sensorY_trip_[active/passive/hot/crit]
> > > which will create way too many nodes, under /sys/class/thermal/zoneX/.
> > 
> > What is "too many"?  20000?  50000?  How many are we talking about here?
> 
> Not in 1000's though..
> 
> > What is the limiting factor that is preventing this from all going into
> > one directory?
> 
> We support a MAX of 12 sensors per zone today, which will lead to
> 12 * 4, 48 nodes under this directory named
> sensorY_trip_[active/passive/hot/crit], besides the other nodes.

That's fine, we can easily support that many files, have you tried this
already?

The main point is, if you use a kobject like you are, userspace tools
can't "see" these directories and files easily, if at all.  Try it out
with libudev yourself to verify it, the attributes will not show up as
owned to that device like you need them to be.

So put them all in one directory, we can handle 10's of thousands of
files quite easily, so 48 is trivial :)

thanks,

greg k-h
