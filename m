Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2LTQ6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:58:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:35298 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab2LTQ6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:58:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,324,1355126400"; 
   d="scan'208";a="234694832"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
Thread-Topic: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
Thread-Index: AQHN3QLhVtjs0vDJ0k+q6f3rVEfUDJgg0z6AgAB+x2CAADE/AIAAX08A//+oIYCAAF+MAA==
Date: Thu, 20 Dec 2012 16:58:32 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5924CF67@BGSMSX101.gar.corp.intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
 <1355822977-4804-5-git-send-email-durgadoss.r@intel.com>
 <20121220054201.GE28007@kroah.com>
 <4D68720C2E767A4AA6A8796D42C8EB5924CB6C@BGSMSX101.gar.corp.intel.com>
 <20121220161202.GA29796@kroah.com>
 <4D68720C2E767A4AA6A8796D42C8EB5924CF1F@BGSMSX101.gar.corp.intel.com>
 <20121220163839.GA30120@kroah.com>
In-Reply-To: <20121220163839.GA30120@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, December 20, 2012 10:09 PM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
> 
> On Thu, Dec 20, 2012 at 04:25:32PM +0000, R, Durgadoss wrote:
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Thursday, December 20, 2012 9:42 PM
> > > To: R, Durgadoss
> > > Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > hongbo.zhang@linaro.org; wni@nvidia.com
> > > Subject: Re: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
> > >
> > > On Thu, Dec 20, 2012 at 07:52:03AM +0000, R, Durgadoss wrote:
> > > > > On Tue, Dec 18, 2012 at 02:59:33PM +0530, Durgadoss R wrote:
> > > > > > This patch adds a thermal_trip directory under
> > > > > > /sys/class/thermal/zoneX. This directory contains
> > > > > > the trip point values for sensors bound to this
> > > > > > zone.
> > > > >
> > > > > Eeek, you just broke userspace tools that now can no longer see
> these
> > > > > entries :(
> > > > >
> > > > > Why do you need to create a subdirectory?  As you found out, doing
> so
> > > > > isn't the easiest, right?  That is on purpose.
> > > >
> > > > Yes, I observed the complexity.
> > > >
> > > > >
> > > > > I really wouldn't recommend doing this at all, please stick within the
> > > > > 'struct device' framework here, don't create new kobjects and hang
> sysfs
> > > > > files off of them.
> > > >
> > > > But, we cannot put all _trip directly under ZoneX directory.
> > >
> > > Why not?  What is preventing this?
> > >
> > > > We can remove the thermal_trip directory, and put sensorY_trip under
> > > > /sys/class/thermal/zoneX/.  But this sensorY_trip needs to be a
> > > > directory which has four sysfs nodes named, active, passive, crit,
> > > > hot.
> > > >
> > > > Rui, What do you think about this ?
> > > >
> > > > The only other way I see, is directly put
> > > sensorY_trip_[active/passive/hot/crit]
> > > > which will create way too many nodes, under
> /sys/class/thermal/zoneX/.
> > >
> > > What is "too many"?  20000?  50000?  How many are we talking about
> here?
> >
> > Not in 1000's though..
> >
> > > What is the limiting factor that is preventing this from all going into
> > > one directory?
> >
> > We support a MAX of 12 sensors per zone today, which will lead to
> > 12 * 4, 48 nodes under this directory named
> > sensorY_trip_[active/passive/hot/crit], besides the other nodes.
> 
> That's fine, we can easily support that many files, have you tried this
> already?

Yes, in fact, this is sort of what was the old implementation..
although with different sysfs nodes.

> 
> The main point is, if you use a kobject like you are, userspace tools
> can't "see" these directories and files easily, if at all.  Try it out
> with libudev yourself to verify it, the attributes will not show up as
> owned to that device like you need them to be.

I haven't used libudev exactly, but I realized this sort of thing,
when I was trying to catch UEvents on this device path.

I will give libudev a try..

> 
> So put them all in one directory, we can handle 10's of thousands of
> files quite easily, so 48 is trivial :)

Okay, Will make it this way :-)
Now I can see the implementation getting much simpler !!

Thank you Greg,
Durga
P.S: I should thank you for this file(samples/kobject/kobject-example.c) also,
from where I got how to get this implementation done :-)
