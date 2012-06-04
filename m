Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab2FDDUD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 23:20:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:55670 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab2FDDUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 23:20:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174328297"
Message-ID: <1338780084.1472.271.camel@rui.sh.intel.com>
Subject: Re: thermal_zone trip_point_0_temp =?ISO-8859-1?Q?200=B0C?=
From: Zhang Rui <rui.zhang@intel.com>
To: Mark <markieb.lists.20090330@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>
Date: Mon, 04 Jun 2012 11:21:24 +0800
In-Reply-To: <4FCBAB57.4030305@gmail.com>
References: <CABAQT1ChtWVauLisaRk_KpN3JSWsvUXKKWDTAW6yuW-G32vmMw@mail.gmail.com>
	 <4FC9D021.1030207@ladisch.de> <4FCBAB57.4030305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 日, 2012-06-03 at 14:22 -0400, Mark wrote:
> Hi Clemens, thanks for writing;
> 
> On 06/02/2012 04:34 AM, Clemens Ladisch wrote:
> > The k10temp module provides nothing but a sensor for monitoring
> > applications.  Your thermal zones are managed by the acpitz driver,
> > which is compiled into the kernel and uses its own sensor.
> thanks for confirming that, I've noticed that the k10temp, at least as ksensors
> interpret it, seems to report a more sensible limit of 80°, although as you say
> that's a reporting module that won't affect actual management, I suppose it's
> neither here nor there, unless that's a sign that the kernel code is faulty while
> the k10temp code is correct — inasmuch as it interprets the readings in
> accordance with the BIOS's directions
> >> my understanding of it is that the Kernel/the Bios manages the fan
> >> speed in 'automatic' mode, as distinguished from fancontrol-type
> >> 'manual' mode; given that windows manages it properly, I'd have to
> >> conclude it wouldn't normally be the Bios's fault?
> > The ACPI tables are provided by the BIOS.
> >
> > For documentation about the thermal zone files, see
> > <Documentation/thermal/sysfs-api.txt>.
> yet the documentation for 3.3.7 says 'mode' for instance should be \in [kernel,
> user], while the node is reporting 'enabled'

yes, this is a problem introduced by 6503e5df.
we should update Documentation/thermal/sysfs-api.txt as well
patch attached.

Subject: Fix Documentation for thermal code changes

Fix the documentation about predefined values of "mode" file.

With commit 6503e5df, we use "enabled/disabled" as the predefined values
for enable/disable kernel thermal management, instead of "user/kernel".

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 Documentation/thermal/sysfs-api.txt |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: rtd3/Documentation/thermal/sysfs-api.txt
===================================================================
--- rtd3.orig/Documentation/thermal/sysfs-api.txt
+++ rtd3/Documentation/thermal/sysfs-api.txt
@@ -45,11 +45,11 @@ temperature) and throttle appropriate de
 	.bind: bind the thermal zone device with a thermal cooling device.
 	.unbind: unbind the thermal zone device with a thermal cooling device.
 	.get_temp: get the current temperature of the thermal zone.
-	.get_mode: get the current mode (user/kernel) of the thermal zone.
-	    - "kernel" means thermal management is done in kernel.
-	    - "user" will prevent kernel thermal driver actions upon trip points
+	.get_mode: get the current mode (enabled/disabled) of the thermal zone.
+	    - "enabled" means the kernel thermal management is enabled.
+	    - "disable" will prevent kernel thermal driver actions upon trip points
 	      so that user applications can take charge of thermal management.
-	.set_mode: set the mode (user/kernel) of the thermal zone.
+	.set_mode: set the mode (enabled/disabled) of the thermal zone.
 	.get_trip_type: get the type of certain trip point.
 	.get_trip_temp: get the temperature above which the certain trip point
 			will be fired.
@@ -167,14 +167,14 @@ temp
 	RO, Required
 
 mode
-	One of the predefined values in [kernel, user].
+	One of the predefined values in [enabled, disableed].
 	This file gives information about the algorithm that is currently
 	managing the thermal zone. It can be either default kernel based
 	algorithm or user space application.
-	kernel	= Thermal management in kernel thermal zone driver.
-	user	= Preventing kernel thermal zone driver actions upon
-		  trip points so that user application can take full
-		  charge of the thermal management.
+	enabled		= enable Kernel Thermal management.
+	disabled	= Preventing kernel thermal zone driver actions upon
+			  trip points so that user application can take full
+			  charge of the thermal management.
 	RW, Optional
 
 trip_point_[0-*]_temp
@@ -248,7 +248,7 @@ method, the sys I/F structure will be bu
 |thermal_zone1:
     |---type:			acpitz
     |---temp:			37000
-    |---mode:			kernel
+    |---mode:			enabled
     |---trip_point_0_temp:	100000
     |---trip_point_0_type:	critical
     |---trip_point_1_temp:	80000


> >> $ grep -r . /sys/class/thermal/thermal_zone*
> >> /sys/class/thermal/thermal_zone0/power/async:disabled
> >> /sys/class/thermal/thermal_zone0/power/runtime_status:unsupported
> >> /sys/class/thermal/thermal_zone0/power/runtime_usage:0
> >> /sys/class/thermal/thermal_zone0/power/runtime_active_kids:0
> >> /sys/class/thermal/thermal_zone0/power/runtime_enabled:disabled
> >> /sys/class/thermal/thermal_zone0/power/control:auto
> >> /sys/class/thermal/thermal_zone0/power/runtime_suspended_time:0
> >> /sys/class/thermal/thermal_zone0/power/runtime_active_time:0
> >> grep: /sys/class/thermal/thermal_zone0/power/autosuspend_delay_ms:
> >> Input/output error
> >> /sys/class/thermal/thermal_zone0/type:acpitz
> >> /sys/class/thermal/thermal_zone0/temp:62000
> >> /sys/class/thermal/thermal_zone0/mode:enabled
> >> /sys/class/thermal/thermal_zone0/trip_point_0_type:critical
> >> /sys/class/thermal/thermal_zone0/trip_point_0_temp:200000
> >> /sys/class/thermal/thermal_zone0/trip_point_1_type:passive
> >> /sys/class/thermal/thermal_zone0/trip_point_1_temp:90000
> >> /sys/class/thermal/thermal_zone0/cdev0_trip_point:1
> >> /sys/class/thermal/thermal_zone0/cdev1_trip_point:1
> >> /sys/class/thermal/thermal_zone0/cdev2_trip_point:1
> >> /sys/class/thermal/thermal_zone0/cdev3_trip_point:1
> given that the 90° is a 'passive' trip_point it seems natural that the cdev[0-3]
> linked to it, are apparently internal cpu cooling mechanisms rather than fans
> 
> $ grep -r . /sys/class/thermal/cool*
> /sys/class/thermal/cooling_device0/power/async:disabled
> /sys/class/thermal/cooling_device0/power/runtime_status:unsupported
> /sys/class/thermal/cooling_device0/power/runtime_usage:0
> /sys/class/thermal/cooling_device0/power/runtime_active_kids:0
> /sys/class/thermal/cooling_device0/power/runtime_enabled:disabled
> /sys/class/thermal/cooling_device0/power/control:auto
> /sys/class/thermal/cooling_device0/power/runtime_suspended_time:0
> /sys/class/thermal/cooling_device0/power/runtime_active_time:0
> grep: /sys/class/thermal/cooling_device0/power/autosuspend_delay_ms: Input/output
> error
> /sys/class/thermal/cooling_device0/type:Processor
> /sys/class/thermal/cooling_device0/max_state:10
> /sys/class/thermal/cooling_device0/cur_state:0
> /sys/class/thermal/cooling_device1/power/async:disabled
> /sys/class/thermal/cooling_device1/power/runtime_status:unsupported
> /sys/class/thermal/cooling_device1/power/runtime_usage:0
> /sys/class/thermal/cooling_device1/power/runtime_active_kids:0
> /sys/class/thermal/cooling_device1/power/runtime_enabled:disabled
> /sys/class/thermal/cooling_device1/power/control:auto
> /sys/class/thermal/cooling_device1/power/runtime_suspended_time:0
> /sys/class/thermal/cooling_device1/power/runtime_active_time:0
> grep: /sys/class/thermal/cooling_device1/power/autosuspend_delay_ms: Input/output
> error
> /sys/class/thermal/cooling_device1/type:Processor
> /sys/class/thermal/cooling_device1/max_state:3
> /sys/class/thermal/cooling_device1/cur_state:0
> /sys/class/thermal/cooling_device2/power/async:disabled
> /sys/class/thermal/cooling_device2/power/runtime_status:unsupported
> /sys/class/thermal/cooling_device2/power/runtime_usage:0
> /sys/class/thermal/cooling_device2/power/runtime_active_kids:0
> /sys/class/thermal/cooling_device2/power/runtime_enabled:disabled
> /sys/class/thermal/cooling_device2/power/control:auto
> /sys/class/thermal/cooling_device2/power/runtime_suspended_time:0
> /sys/class/thermal/cooling_device2/power/runtime_active_time:0
> grep: /sys/class/thermal/cooling_device2/power/autosuspend_delay_ms: Input/output
> error
> /sys/class/thermal/cooling_device2/type:Processor
> /sys/class/thermal/cooling_device2/max_state:3
> /sys/class/thermal/cooling_device2/cur_state:0
> /sys/class/thermal/cooling_device3/power/async:disabled
> /sys/class/thermal/cooling_device3/power/runtime_status:unsupported
> /sys/class/thermal/cooling_device3/power/runtime_usage:0
> /sys/class/thermal/cooling_device3/power/runtime_active_kids:0
> /sys/class/thermal/cooling_device3/power/runtime_enabled:disabled
> /sys/class/thermal/cooling_device3/power/control:auto
> /sys/class/thermal/cooling_device3/power/runtime_suspended_time:0
> /sys/class/thermal/cooling_device3/power/runtime_active_time:0
> grep: /sys/class/thermal/cooling_device3/power/autosuspend_delay_ms: Input/output
> error
> /sys/class/thermal/cooling_device3/type:Processor
> /sys/class/thermal/cooling_device3/max_state:3
> /sys/class/thermal/cooling_device3/cur_state:0
> /sys/class/thermal/cooling_device4/power/async:disabled
> /sys/class/thermal/cooling_device4/power/runtime_status:unsupported
> /sys/class/thermal/cooling_device4/power/runtime_usage:0
> /sys/class/thermal/cooling_device4/power/runtime_active_kids:0
> /sys/class/thermal/cooling_device4/power/runtime_enabled:disabled
> /sys/class/thermal/cooling_device4/power/control:auto
> /sys/class/thermal/cooling_device4/power/runtime_suspended_time:0
> /sys/class/thermal/cooling_device4/power/runtime_active_time:0
> grep: /sys/class/thermal/cooling_device4/power/autosuspend_delay_ms: Input/output
> error
> /sys/class/thermal/cooling_device4/type:LCD
> /sys/class/thermal/cooling_device4/max_state:9
> /sys/class/thermal/cooling_device4/cur_state:0
> 
> surprising that the fan seems to work at all, given that there is no
> kernel-registered cooling fan;

this only means that there is no ACPI controlled Fan on this platforms.
As we can see, there are only two trip points, critical and passive.
this suggests that ACPI thermal management can only use processors for
passive cooling.
The fan may be controlled either by some platform code or by firmware.

thanks,
rui
>  yet it definitely goes faster the hotter the cpu
> is, the trouble is that that is already too hot
> > Regards,
> > Clemens
> thanks for allowing me to make some progress, seems I'll need to look more
> carefully at the BIOS too; from my understanding of it Acer has non-pwm ways of
> setting hardware registers to manage fan speed that'll be one angle to look into,
> as long as they'll provide some documentation
> 
> hoping to avoid needing to compile custom kernels given that I've already emerged
> bruised a few times from the myriad of compile options :)
> 
> Best regards
> 
> Mark


