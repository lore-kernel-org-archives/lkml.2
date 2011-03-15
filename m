Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1COJYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:24:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1COJYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:24:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device driver into misc
Date: Tue, 15 Mar 2011 10:24:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        mems applications <mems.applications@st.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "carmine.iascone@st.com" <carmine.iascone@st.com>,
        "matteo.dameno@st.com" <matteo.dameno@st.com>,
        "rubini@ipvvis.unipv.it" <rubini@cvml.unipv.it>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <20110314224244.3d6d23ba@endymion.delvare> <20110314224859.GA16970@ericsson.com>
In-Reply-To: <20110314224859.GA16970@ericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151024.26436.arnd@arndb.de>
X-Provags-ID: V02:K0:dvE6rV3NzcVawoU7+lob07zfPXEG67Qs9O2xPuRdxpL
 jQpPmHYG3gCwrjUdM7JlozHZbifzPY8dL4QGixvDlJoam/g+Cx
 WlRgD7Phds9KZkorzaWGVB80B8svfdUnVfbL5is8GmsNfZwaKx
 qj6WE2VEzbhWuTArYuTmYCx1lXRFppSrtpTA3pH88HzMujCYdv
 dZTmcPm6tyDbeRNug+glA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 March 2011 23:48:59 Guenter Roeck wrote:
> On Mon, Mar 14, 2011 at 05:42:44PM -0400, Jean Delvare wrote:
> > On Mon, 14 Mar 2011 21:36:43 +0100, Arnd Bergmann wrote:
> > > On Monday 14 March 2011 21:18:09 Jean Delvare wrote:
> > > > Jonathan is correct. Pressure sensors are not hardware monitoring
> > > > devices, their drivers have nothing to do in drivers/hwmon. This is
> > > > something for drivers/misc or staging/iio.
> > > 
> > > I generally try to prevent people from adding more ad-hoc interfaces
> > > to drivers/misc. Anything that is called a drivers/misc driver to me
> > > must qualify as "there can't possibly be a second driver with the
> > > same semantics", otherwise it should be part of another subsystem
> > > with clear rules, or be put into its own file system.
> > 
> > I see drivers/misc differently. I see it as "not enough drivers of the
> > same type to justify a new subsystem". So I encourage people to put
> > things there in the absence of any suitable subsystem, until someone
> > gets enough motivation to start such a subsystem. This is more
> > pragmatic than requesting subsystems to be created upfront.
> > 
> Agreed.
> 
> Note that there is already a pressure sensor in drivers/misc - bmp085.c.
> That chip also includes a temperature sensor.

That driver proves exactly what I was trying to say about drivers/misc.
Even though bmp085 has done everything correctly according to the
rules (its interface is documented and it has gone into drivers/misc
instead of another subsystem), we're now stuck with an interface that
was written for a specific chip without widespread review, and need
to apply it to all other similar drivers, or risk breaking applications.

The interface used in bmp085 has no way of finding out which devices
are actually pressure/temparature sensors, other than by looking
at the name of the attributes in every i2c device. There are probably
ways to retrofit this without breaking compatibility, but the options
are now fairly limited.

> > That being said, staging is another option nowadays.
> > 
> > > While it seems that right now everyone is just trying to keep move
> > > the driver to some other subsystem, I think it's worth noting that
> > > it is indeed a useful thing to have the driver, I'm optimistic
> > > that we can find some place for it. ;-)
> > > 
> > > Now how about the IIO stuff? This is the first time I've even
> > > heard about it. Does it have any major disadvantages besides
> > > being staging-quality?
> > 
> > This is indeed the major disadvantage. IIO seems to take a lot of time
> > to move out of staging, although I don't know what the current ETA is.
> > 
> In general it would be nice to have a "sensors" subsystem. iio is going into
> that direction, so creating another one might not make much sense at this point.

It depends on the quality of the iio code base, which I have not looked
at. If it's good enough, we could use that, and ideally find a way to
be backwards-compatible with bmp085. Otherwise, creating a new subsystem
could work as well, but only if the people behind iio support that move.
A new subsystem of that sort would need to start out with a well-designed
user interface, and allow moving over drivers from staging/iio without
too much pain.

	Arnd
