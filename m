Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2JXQvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:51:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50385 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2JXQvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:51:52 -0400
Message-ID: <1351097507.23327.78.camel@hornet>
Subject: Re: [RFC] Energy/power monitoring within the kernel
From: Pawel Moll <pawel.moll@arm.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jesper Juhl <jj@chaosbits.net>, Jean Pihet <jean.pihet@newoldbits.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Date: Wed, 24 Oct 2012 17:51:47 +0100
In-Reply-To: <4317776.evLpJapyim@hammer82.arch.suse.de>
References: <1351013449.9070.5.camel@hornet>
	 <4317776.evLpJapyim@hammer82.arch.suse.de>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 24 Oct 2012 16:51:48.0443 (UTC) FILETIME=[DBB882B0:01CDB207]
X-MC-Unique: 112102417515014101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 01:40 +0100, Thomas Renninger wrote:
> > More and more of people are getting interested in the subject of power
> > (energy) consumption monitoring. We have some external tools like
> > "battery simulators", energy probes etc., but some targets can measure
> > their power usage on their own.
> > 
> > Traditionally such data should be exposed to the user via hwmon sysfs
> > interface, and that's exactly what I did for "my" platform - I have
> > a /sys/class/hwmon/hwmon*/device/energy*_input and this was good
> > enough to draw pretty graphs in userspace. Everyone was happy...
> > 
> > Now I am getting new requests to do more with this data. In particular
> > I'm asked how to add such information to ftrace/perf output.
> Why? What is the gain?
> 
> Perf events can be triggered at any point in the kernel.
> A cpufreq event is triggered when the frequency gets changed.
> CPU idle events are triggered when the kernel requests to enter an idle state
> or exits one.
> 
> When would you trigger a thermal or a power event?
> There is the possibility of (critical) thermal limits.
> But if I understand this correctly you want this for debugging and
> I guess you have everything interesting one can do with temperature
> values:
>   - read the temperature
>   - draw some nice graphs from the results
> 
> Hm, I guess I know what you want to do:
> In your temperature/energy graph, you want to have some dots
> when relevant HW states (frequency, sleep states,  DDR power,...)
> changed. Then you are able to see the effects over a timeline.
> 
> So you have to bring the existing frequency/idle perf events together
> with temperature readings
> 
> Cleanest solution could be to enhance the exisiting userspace apps
> (pytimechart/perf timechart) and let them add another line
> (temperature/energy), but the data would not come from perf, but
> from sysfs/hwmon.
> Not sure whether this works out with the timechart tools.
> Anyway, this sounds like a userspace only problem.

Ok, so it is actually what I'm working on right now. Not with the
standard perf tool (there are other users of that API ;-) but indeed I'm
trying to "enrich" the data stream coming from kernel with user-space
originating values. I am a little bit concerned about effect of extra
syscalls (accessing the value and gettimeofday to generate a timestamp)
at a higher sampling rates, but most likely it won't be a problem. Can
report once I know more, if this is of interest to anyone.

Anyway, there are at least two debug/trace related use cases that can
not be satisfied that way (of course one could argue about their
usefulness):

1. ftrace-over-network (https://lwn.net/Articles/410200/) which is
particularly appealing for "embedded users", where there's virtually no
useful userspace available (think Android). Here a (functional) trace
event is embedded into a normal trace and available "for free" at the
host side.

2. perf groups - the general idea is that one event (let it be cycle
counter interrupt or even a timer) triggers read of other values (eg.
cache counter or - in this case - energy counter). The aim is to have a
regular "snapshots" of the system state. I'm not sure if the standard
perf tool can do this, but I do :-)

And last, but not least, there are the non-debug/trace clients for
energy data as discussed in other mails in this thread. Of course the
trace event won't really satisfy their needs either.

Thanks for your feedback!

Paweł


