Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0KDQHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:07:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42366 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab0KDQHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=G2rWdcCFAgjbGFSsqSTAlw3gd1wn+QWHCFMd81LjXNjtKA03/RoJmVPS9miQWEG+ib
         +5RtoNoTyL8J8cdxthcSE/+M4tfdq6iVpb4T/SFndWPNCOQ6iwPeoY+cxol1ylpfAAqo
         If0M1gEDUdjAObkiADhsj985i+HtRyZEvk1/g=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "linux-kernel" <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        rui.zhang@intel.com, len.brown@intel.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [REGRESSION] [2.6.37-rc1] Fan noise after suspend to ram/disk
Date: Thu, 4 Nov 2010 17:06:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011041706.59046.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. 
Last known good kernel: 2.6.36
Bad kernel: 2.6.37-rc1
===============================

2. Problem:
When I resume computer from s2ram/s2disk and current CPU temp is below lowest 
trip point, and -- from unknown reason -- fan start in maximum speed it 
doesn't turn off (it should).

It doesn't happen always but only when fan starts work and any of trip points 
aren't exceed. It seems that system only check temperature when exceed trip 
point.
===============================

3. /sys/cass/thermal/ info:

I have:
maciek@gumis:/sys/class/thermal$ ls
cooling_device0  cooling_device2  cooling_device4  cooling_device6  
thermal_zone1  thermal_zone3
cooling_device1  cooling_device3  cooling_device5  thermal_zone0    
thermal_zone2  thermal_zone4

maciek@gumis:/sys/class/thermal$ cat cooling_device*/type 
LCD
Processor
Processor
Fan
Fan
Fan
Fan

===============================

Colling device from 3 to 6 are inform what is current fan speed, for example:
cooling_device3 = 0
cooling_device4 = 0
cooling_device5 = 0
cooling_device6 = 0 
Means that fan is off.

cooling_device3 = 0
cooling_device4 = 0
cooling_device5 = 0
cooling_device6 = 1
Means fan works on 40% of full speed (1st trip point is exceed).

cooling_device3 = 1
cooling_device4 = 1
cooling_device5 = 1
cooling_device6 = 1
Means fan works on full speed (all (4) trip points is exceed).
===============================

5. State when fan works on full speed after resume:
maciek@gumis:/sys/class/thermal$ cat cooling_device*/cur_state
0
0
0
1
1
1
1
(Runs on full speed)

maciek@gumis:/sys/class/thermal$ cat thermal_zone0/trip_point_*
256000
critical
78000
active
70000
active
60000
active
50000
active

(It's OK for current CPU temp)

"sensors" command shows:
maciek@gumis:/sys/class/thermal$ sensors
acpitz-virtual-0
Adapter: Virtual device
temp1:       +37.0°C  (crit = +256.0°C)                  
temp2:       +42.0°C  (crit = +90.0°C)                  
temp3:       +33.0°C  (crit = +105.0°C)                  
temp4:       +20.0°C  (crit = +90.0°C)                  
temp5:      +100.0°C  (crit = +110.0°C)

"temp1" in this model of HP notebook is only for debug purposes (I think).
"temp2" shows CPU temp (fan speed depends on it)
"temp5" shows fan speed in % of maximum speed.
===============================

6. I run this command, to "hot" the processor:
"while true; do echo -n; done"
and cancel it, when I see, that first trip point was exceed, and fan starts 
working on lower speed.
===============================

7. When it done I saw:
maciek@gumis:/sys/class/thermal$ cat cooling_device*/cur_state
0
0
0
0
0
0
1

Fan works on 40% of full speed. It's OK.

maciek@gumis:/sys/class/thermal$ cat thermal_zone0/trip_point_*
256000
critical
78000
active
70000
active
60000
active
45000
active

Last trip point was changed from 50000 to 45000 because trip point was exceed 
(it's OK, fan stops working below 45*C or starts working on 60% speed, above 
60*C).

"sensors" show:
maciek@gumis:/sys/class/thermal$ sensors
acpitz-virtual-0
Adapter: Virtual device
temp1:       +50.0°C  (crit = +256.0°C)                  
temp2:       +48.0°C  (crit = +90.0°C)                  
temp3:       +34.0°C  (crit = +105.0°C)                  
temp4:       +20.0°C  (crit = +90.0°C)                  
temp5:       +40.0°C  (crit = +110.0°C)
===============================

Dmesg:
http://unixy.pl/maciek/download/kernel/2.6.37-rc1/gumis/dmesg-2.6.37-rc1.txt

acpidump:
http://unixy.pl/maciek/download/kernel/2.6.37-rc1/gumis/acpidump.dat

Config:
http://unixy.pl/maciek/download/kernel/2.6.37-rc1/gumis/config-2.6.37-rc1

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
