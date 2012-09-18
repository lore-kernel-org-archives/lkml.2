Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2IRVVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:21:22 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:60667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab2IRVVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:21:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Performance device PM QoS (was: Re: [PATCH v3 1/2] PM / devfreq: add global PM QoS support)
Date: Tue, 18 Sep 2012 23:27:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: myungjoo.ham@samsung.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>,
        =?utf-8?q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "khilman@ti.com" <khilman@ti.com>,
        "jean.pihet@newoldbits.com" <jean.pihet@newoldbits.com>,
        "mturquette@ti.com" <mturquette@ti.com>,
        =?utf-8?q?=EC=9D=B4=EC=A2=85=ED=99=94?= <jonghwa3.lee@samsung.com>,
        Paul Walmsley <paul@pwsan.com>
References: <24667979.34981347880276536.JavaMail.weblogic@epml25> <201209172310.09622.rjw@sisk.pl> <20120918044211.GA19417@MGROSS-X220VM>
In-Reply-To: <20120918044211.GA19417@MGROSS-X220VM>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209182327.45024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 18, 2012, mark gross wrote:
> On Mon, Sep 17, 2012 at 11:10:09PM +0200, Rafael J. Wysocki wrote:
> > On Monday, September 17, 2012, MyungJoo Ham wrote:

[...]

> > > > What QoS types do you think could be used here?
> > > 
> > > I don't think the devfreq core needs to care of it.
> > > Whatever the device driver wants could be available here.
> > 
> > That's a bit of a problem.  I don't want device drivers to use the global
> > QoS types, because they aren't sufficiently well defined (units are kind of
> > unknown in some cases, for example).
> > 
> > In my opinion it would be better to add performance device PM QoS in analogy
> > with the existing latency device PM QoS.  The unit might be percentage of full
> > performance (0 - 100).
> > 
> > Of course, that only would cover device performance, but there also is the
> > problem of interconnect throughput that may depend on what frequencies are
> > used by devices on it.
> >
> 
> Paul W. and I where talking about a boost interface I think may be worth
> considering.
> 
> We need to take a step back at this point.  What type of algebra is
> needed WRT the device pm_qos analogy?  do we need an ordered set or even
> partial ordering?  Do we need to be able to tell one state is more
> performing than another at all?
> 
> The use cases of these performance levels tend to be platform and device
> specific AFAICT so far.  The units of performance are not portable
> across ISA's and they're interpretation varies from device to device.

However, the approach used in the patchset being discussed in this thread
addresses this problem by mapping different "QoS" values to specific
device operating points with the help of an array.  Of course, the array
has to be provided by either the platform or the driver, but it allows
us to use "portable" QoS values in the core, at least in principle.

> What if we didn't think of it in terms of an ordered field of some sort?
> What if we had a per device boost hash who's meaning is defined by the
> board / device level module but, the interface and use is defined in the
> common code?  If the platform code didn't implement any then those are
> NOOPs if the platform code cares about that device qos then it
> implements and interprets the specific boost qos as needed.
> 
> So in practice when a driver or use case needed qos, it would request a
> qos hash from the platform code to use and that platform code would need
> to interpret that hash in a platform specific way.

That seems to be conceptually similar to what dev_pm_qos_expose_latency_limit()
does.  It essentially allows drivers to request that PM QoS latency constraints
be used for the devices they handle.

> This would remove the portability problem from drivers requested QoS
> levels from assorted devices.  the QoS levels will be a hash, to be
> interpreted by platform code.

I personally think that the QoS levels should be specified in a way allowing
user space to interpret them, so that they can be exposed to the actual user
in a comprehensible manner accross different systems (be it Android or a
random Linux distro).  There may be a mapping between this "portable"
representation and the platform-specific one (or even driver-specific one
if need be), but user space should be able to say what the particular setting
actually means.

> there are a lot of details to work out but I think something could be
> done along these lines.

Possibly, yes.

Thanks,
Rafael
