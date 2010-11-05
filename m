Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0KEA1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 20:27:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:39531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab0KEA1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 20:27:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,299,1286175600"; 
   d="scan'208";a="854348714"
Subject: Re: [REGRESSION] [2.6.37-rc1] Fan noise after suspend to ram/disk
From: Zhang Rui <rui.zhang@intel.com>
To: "maciej.rutecki@gmail.com" <maciej.rutecki@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <201011041706.59046.maciej.rutecki@gmail.com>
References: <201011041706.59046.maciej.rutecki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 08:27:34 +0800
Message-ID: <1288916854.2234.275.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-05 at 00:06 +0800, Maciej Rutecki wrote:
> 1. 
> Last known good kernel: 2.6.36
> Bad kernel: 2.6.37-rc1
> ===============================
> 
> 2. Problem:
> When I resume computer from s2ram/s2disk and current CPU temp is below lowest 
> trip point, and -- from unknown reason -- fan start in maximum speed it 
> doesn't turn off (it should).
> 
could you please attach the output of "grep . /sys/class/thermal/*/*"
when this happens?

thanks,
rui

> It doesn't happen always but only when fan starts work and any of trip points 
> aren't exceed. It seems that system only check temperature when exceed trip 
> point.
> ===============================
> 
> 3. /sys/cass/thermal/ info:
> 
> I have:
> maciek@gumis:/sys/class/thermal$ ls
> cooling_device0  cooling_device2  cooling_device4  cooling_device6  
> thermal_zone1  thermal_zone3
> cooling_device1  cooling_device3  cooling_device5  thermal_zone0    
> thermal_zone2  thermal_zone4
> 
> maciek@gumis:/sys/class/thermal$ cat cooling_device*/type 
> LCD
> Processor
> Processor
> Fan
> Fan
> Fan
> Fan
> 
> ===============================
> 
> Colling device from 3 to 6 are inform what is current fan speed, for example:
> cooling_device3 = 0
> cooling_device4 = 0
> cooling_device5 = 0
> cooling_device6 = 0 
> Means that fan is off.
> 
> cooling_device3 = 0
> cooling_device4 = 0
> cooling_device5 = 0
> cooling_device6 = 1
> Means fan works on 40% of full speed (1st trip point is exceed).
> 
> cooling_device3 = 1
> cooling_device4 = 1
> cooling_device5 = 1
> cooling_device6 = 1
> Means fan works on full speed (all (4) trip points is exceed).
> ===============================
> 
> 5. State when fan works on full speed after resume:
> maciek@gumis:/sys/class/thermal$ cat cooling_device*/cur_state
> 0
> 0
> 0
> 1
> 1
> 1
> 1
> (Runs on full speed)
> 
> maciek@gumis:/sys/class/thermal$ cat thermal_zone0/trip_point_*
> 256000
> critical
> 78000
> active
> 70000
> active
> 60000
> active
> 50000
> active
> 
> (It's OK for current CPU temp)
> 
> "sensors" command shows:
> maciek@gumis:/sys/class/thermal$ sensors
> acpitz-virtual-0
> Adapter: Virtual device
> temp1:       +37.0°C  (crit = +256.0°C)                  
> temp2:       +42.0°C  (crit = +90.0°C)                  
> temp3:       +33.0°C  (crit = +105.0°C)                  
> temp4:       +20.0°C  (crit = +90.0°C)                  
> temp5:      +100.0°C  (crit = +110.0°C)
> 
> "temp1" in this model of HP notebook is only for debug purposes (I think).
> "temp2" shows CPU temp (fan speed depends on it)
> "temp5" shows fan speed in % of maximum speed.
> ===============================
> 
> 6. I run this command, to "hot" the processor:
> "while true; do echo -n; done"
> and cancel it, when I see, that first trip point was exceed, and fan starts 
> working on lower speed.
> ===============================
> 
> 7. When it done I saw:
> maciek@gumis:/sys/class/thermal$ cat cooling_device*/cur_state
> 0
> 0
> 0
> 0
> 0
> 0
> 1
> 
> Fan works on 40% of full speed. It's OK.
> 
> maciek@gumis:/sys/class/thermal$ cat thermal_zone0/trip_point_*
> 256000
> critical
> 78000
> active
> 70000
> active
> 60000
> active
> 45000
> active
> 
> Last trip point was changed from 50000 to 45000 because trip point was exceed 
> (it's OK, fan stops working below 45*C or starts working on 60% speed, above 
> 60*C).
> 
> "sensors" show:
> maciek@gumis:/sys/class/thermal$ sensors
> acpitz-virtual-0
> Adapter: Virtual device
> temp1:       +50.0°C  (crit = +256.0°C)                  
> temp2:       +48.0°C  (crit = +90.0°C)                  
> temp3:       +34.0°C  (crit = +105.0°C)                  
> temp4:       +20.0°C  (crit = +90.0°C)                  
> temp5:       +40.0°C  (crit = +110.0°C)
> ===============================
> 
> Dmesg:
> http://unixy.pl/maciek/download/kernel/2.6.37-rc1/gumis/dmesg-2.6.37-rc1.txt
> 
> acpidump:
> http://unixy.pl/maciek/download/kernel/2.6.37-rc1/gumis/acpidump.dat
> 
> Config:
> http://unixy.pl/maciek/download/kernel/2.6.37-rc1/gumis/config-2.6.37-rc1
> 
> Regards


