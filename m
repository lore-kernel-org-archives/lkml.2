Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935250Ab2JXQhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:37:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46966 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935193Ab2JXQha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:37:30 -0400
Message-ID: <1351096647.23327.64.camel@hornet>
Subject: Re: [RFC] Energy/power monitoring within the kernel
From: Pawel Moll <pawel.moll@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean Delvare <khali@linux-fr.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jesper Juhl <jj@chaosbits.net>, Thomas Renninger <trenn@suse.de>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Date: Wed, 24 Oct 2012 17:37:27 +0100
In-Reply-To: <20121023220240.GA25895@roeck-us.net>
References: <1351013449.9070.5.camel@hornet>
	 <20121023220240.GA25895@roeck-us.net>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 24 Oct 2012 16:37:28.0261 (UTC) FILETIME=[DB032750:01CDB205]
X-MC-Unique: 112102417372802201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 23:02 +0100, Guenter Roeck wrote:
> > Traditionally such data should be exposed to the user via hwmon sysfs
> > interface, and that's exactly what I did for "my" platform - I have
> > a /sys/class/hwmon/hwmon*/device/energy*_input and this was good
> > enough to draw pretty graphs in userspace. Everyone was happy...
> > 
> Only driver supporting "energy" output so far is ibmaem, and the reported energy
> is supposed to be cumulative, as in energy = power * time. Do you mean power,
> possibly ?

So the vexpress would be the second one, than :-) as the energy
"monitor" actually on the latest tiles reports 64-bit value of
microJoules consumed (or produced) since the power-up.

Some of the older boards were able to report instant power, but this
metrics is less useful in our case.

> > Now I am getting new requests to do more with this data. In particular
> > I'm asked how to add such information to ftrace/perf output. The second
> > most frequent request is about providing it to a "energy aware"
> > cpufreq governor.
> 
> Anything energy related would have to be along the line of "do something after a
> certain amount of work has been performed", which at least at the surface does
> not make much sense to me, unless you mean something along the line of a
> process scheduler which schedules a process not based on time slices but based
> on energy consumed, ie if you want to define a time slice not in milli-seconds
> but in Joule.

Actually there is some research being done in this direction, but it's
way too early to draw any conclusions...

> If so, I would argue that a similar behavior could be achieved by varying the
> duration of time slices with the current CPU speed, or simply by using cycle
> count instead of time as time slice parameter. Not that I am sure if such an
> approach would really be of interest for anyone. 
> 
> Or do you really mean power, not energy, such as in "reduce CPU speed if its
> power consumption is above X Watt" ?

Uh. To be completely honest I must answer: I'm not sure how the "energy
aware" cpufreq governor is supposed to work. I have been simply asked to
provide the data in some standard way, if possible.

> I am not sure how this would be expected to work. hwmon is, by its very nature,
> a passive subsystem: It doesn't do anything unless data is explicitly requested
> from it. It does not update an attribute unless that attribute is read.
> That does not seem to fit well with the idea of tracing - which assumes
> that some activity is happening, ultimately, all by itself, presumably
> periodically. The idea to have a user space application read hwmon data only
> for it to trigger trace events does not seem to be very compelling to me.

What I had in mind was similar to what adt7470 driver does. The driver
would automatically access the device every now and then to update it's
internal state and generate the trace event on the way. This
auto-refresh "feature" is particularly appealing for me, as on some of
"my" platforms can take up to 500 microseconds to actually get the data.
So doing this in background (and providing users with the last known
value in the meantime) seems attractive.

> An exception is if a monitoring device suppports interrupts, and if its driver
> actually implements those interrupts. This is, however, not the case for most of
> the current drivers (if any), mostly because interrupt support for hardware
> monitoring devices is very platform dependent and thus difficult to implement.

Interestingly enough the newest version of our platform control micro
(doing the energy monitoring as well) can generate and interrupt when a
transaction is finished, so I was planning to periodically update the
all sort of values. And again, generating a trace event on this
opportunity would be trivial.

> > Of course a particular driver could register its own perf PMU on its
> > own. It's certainly an option, just very suboptimal in my opinion.
> > Or maybe not? Maybe the task is so specialized that it makes sense?
> > 
> We had a couple of attempts to provide an in-kernel API. Unfortunately,
> the result was, at least so far, more complexity on the driver side.
> So the difficulty is really to define an API which is really simple, and does
> not just complicate driver development for a (presumably) rare use case.

Yes, I appreciate this. That's why this option is actually my least
favourite. Anyway, what I was thinking about was just a thin shin that
*can* be used by a driver to register some particular value with the
core (so it can be enumerated and accessed by in-kernel clients) and the
core could (or not) create a sysfs attribute for this value on behalf of
the driver. Seems lightweight enough, unless previous experience
suggests otherwise?

Cheers!

Paweł


