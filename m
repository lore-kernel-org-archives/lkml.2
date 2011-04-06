Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab1DFXl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 19:41:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:31518 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089Ab1DFXl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 19:41:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,313,1299484800"; 
   d="scan'208";a="730101114"
Message-ID: <4D9CFA13.5020709@linux.intel.com>
Date: Wed, 06 Apr 2011 16:41:07 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Jean Delvare <khali@linux-fr.org>, Wei Song <Wsong@nuvoton.com>
Subject: w83795 fan control not working
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't been able to control the fan speed using the w83795 driver.
The BIOS "Quiet" setting appears to be braindead as it runs quietly for
a while and then switches to near full throttle for a minute or so and
then returns to the previous state (this is with the system basically
idle). The temperatures (from w83795adg-i2c-0-2f) never reach anything
approaching critical:

Quiet State:
temp1:       +83.5°C  (high = +127.0°C, hyst = +127.0°C)
             (crit = +127.0°C, hyst = +127.0°C)  sensor = thermal diode
temp5:       +40.0°C  (high = +127.0°C, hyst = +127.0°C)
             (crit = +75.0°C, hyst = +70.0°C)  sensor = thermistor
temp7:       +29.5°C  (high = +95.0°C, hyst = +92.0°C)
             (crit = +95.0°C, hyst = +92.0°C)  sensor = Intel PECI
temp8:       +25.5°C  (high = +95.0°C, hyst = +92.0°C)
             (crit = +95.0°C, hyst = +92.0°C)  sensor = Intel PECI

Loud State:
...
OK, waited 10 minutes and it didn't want to scream at me. But if memory
serves, there is only a variance of a few degrees before the fans kick
in.

I'm hoping to use pwmconfig/fancontrol with the w83795 driver to restore
some sanity to the fan usage. I tried with V 0.7 on the Ubuntu 10.10
server kernel (vmlinuz-2.6.35-22-server) as well as with the current
version in the linux-2.6.git tree (2.6.39-rc1+). I'm running on the
following hardware with a pair of Intel Xeon X5680 CPUs.

SUPERMICRO MBD-X8DTL-iF-O Motherboard
http://www.supermicro.com/products/motherboard/QPI/5500/X8DTL-iF.cfm

On the following kernel:
linux-2.6.39-rc1+: 99759619b27662d1290901228d77a293e6e83200

With the experimental fan control enabled for the w83795:
$ grep 83795 .config
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y

The module is loaded:
$ lsmod | grep 83795
w83795                 43879  0 
pwmconfig reports the following:

---------------------------
Found the following devices:
   hwmon0/device is max1617
   hwmon1/device is w83627dhg
   hwmon2/device is w83795adg <--- So it found the device

Found the following PWM controls:
   hwmon1/device/pwm1
   hwmon1/device/pwm2
   hwmon1/device/pwm3
   hwmon2/device/pwm1
hwmon2/device/pwm1 stuck to 125 <--- This doesn't look good.
Manual control mode not supported, skipping hwmon2/device/pwm1.
   hwmon2/device/pwm2 <--- Which fans does it control?

Giving the fans some time to reach full speed...
Found the following fan sensors:
   hwmon1/device/fan1_input     current speed: 0 ... skipping!
   hwmon1/device/fan2_input     current speed: 0 ... skipping!
   hwmon1/device/fan3_input     current speed: 0 ... skipping!
   hwmon1/device/fan5_input     current speed: 0 ... skipping!
   hwmon2/device/fan1_input     current speed: 0 ... skipping!
   hwmon2/device/fan2_input     current speed: 1931 RPM <-- cpu fan

Note, the CPUs are very close together and to the rear chassis fan, this
prevents me from installing both CPU fans. I opted to keep the larger
(quieter) chassis fan adjacent to the second CPU over the second smaller
CPU fan.

   hwmon2/device/fan3_input     current speed: 0 ... skipping!
   hwmon2/device/fan4_input     current speed: 2652 RPM <-- small chassis fan
   hwmon2/device/fan5_input     current speed: 1814 RPM <-- large chassis fan
   hwmon2/device/fan6_input     current speed: 0 ... skipping!

---------------------------

The fans didn't change speed during the pwmconfig run. I did allow it to
switch all the pwm controls to manual mode.

Fans 2, 4, and 5 below should be connected via the w83795 driver as far as I can tell:
$ rage-ipmi.sh sensor
FAN 1            | na         | RPM        | na    | na        | na        | na        | na        | na        | na        
FAN 2            | 1936.000   | RPM        | ok    | 400.000   | 576.000   | 784.000   | 33856.000 | 34225.000 | 34596.000 
FAN 3            | na         | RPM        | na    | na        | na        | na        | na        | na        | na        
FAN 4            | 2704.000   | RPM        | ok    | 400.000   | 576.000   | 784.000   | 33856.000 | 34225.000 | 34596.000 
FAN 5            | 1764.000   | RPM        | ok    | 400.000   | 576.000   | 784.000   | 33856.000 | 34225.000 | 34596.000 
FAN 6            | na         | RPM        | na    | na        | na        | na        | na        | na        | na        
CPU1 Vcore       | 0.952      | Volts      | ok    | 0.776     | 0.800     | 0.824     | 1.352     | 1.376     | 1.400     
CPU2 Vcore       | 0.952      | Volts      | ok    | 0.776     | 0.800     | 0.824     | 1.352     | 1.376     | 1.400     
CPU1 DIMM        | 1.520      | Volts      | ok    | 1.288     | 1.312     | 1.336     | 1.656     | 1.680     | 1.704     
CPU2 DIMM        | 1.520      | Volts      | ok    | 1.288     | 1.312     | 1.336     | 1.656     | 1.680     | 1.704     
+1.5 V           | na         | Volts      | na    | na        | na        | na        | na        | na        | na        
+5 V             | 5.056      | Volts      | ok    | 4.416     | 4.448     | 4.480     | 5.536     | 5.568     | 5.600     
+5VSB            | 5.056      | Volts      | ok    | 4.416     | 4.448     | 4.480     | 5.536     | 5.568     | 5.600     
+12 V            | 12.137     | Volts      | ok    | 10.600    | 10.653    | 10.706    | 13.250    | 13.303    | 13.356    
-12 V            | -11.904    | Volts      | ok    | -13.650   | -13.456   | -13.262   | -10.546   | -10.352   | -10.158   
VTT              | 1.112      | Volts      | ok    | 0.808     | 0.816     | 0.824     | 1.320     | 1.336     | 1.352     
+3.3VCC          | 3.264      | Volts      | ok    | 2.880     | 2.904     | 2.928     | 3.648     | 3.672     | 3.696     
+3.3VSB          | 3.264      | Volts      | ok    | 2.880     | 2.904     | 2.928     | 3.648     | 3.672     | 3.696     
VBAT             | 3.096      | Volts      | ok    | 2.880     | 2.904     | 2.928     | 3.648     | 3.672     | 3.696     
CPU1 Temp        | 0x1        | discrete   | 0x0000| na        | na        | na        | na        | na        | na        
CPU2 Temp        | 0x1        | discrete   | 0x0000| na        | na        | na        | na        | na        | na        
System Temp      | 40.000     | degrees C  | ok    | -9.000    | -7.000    | -5.000    | 75.000    | 77.000    | 79.000    
P1-DIMM1A        | 37.000     | degrees C  | ok    | -9.000    | -7.000    | -5.000    | 65.000    | 70.000    | 75.000    
P1-DIMM2A        | na         | degrees C  | na    | na        | na        | na        | na        | na        | na        
P1-DIMM3A        | na         | degrees C  | na    | na        | na        | na        | na        | na        | na        
P2-DIMM1A        | 37.000     | degrees C  | ok    | -9.000    | -7.000    | -5.000    | 65.000    | 70.000    | 75.000    
P2-DIMM2A        | na         | degrees C  | na    | na        | na        | na        | na        | na        | na        
P2-DIMM3A        | na         | degrees C  | na    | na        | na        | na        | na        | na        | na        
Chassis Intru    | 0x0        | discrete   | 0x0000| na        | na        | na        | na        | na        | na        
PS Status        | 0x1        | discrete   | 0x01ff| na        | na        | na        | na        | na        | na        


dmesg reports:
$ dmesg | grep 83795
[   12.643929] i2c i2c-0: Found w83795adg rev. B at 0x2f
[   12.883789] w83795 0-002f: PECI agent 1 Tbase temperature: 100
[   12.903779] w83795 0-002f: PECI agent 2 Tbase temperature: 100
[ 2288.932629] w83795 0-002f: Failed to read from register 0x030, err -6
[ 2613.292773] w83795 0-002f: Failed to write to register 0x040, err -6
[ 2693.333461] w83795 0-002f: Failed to read from register 0x01e, err -11

Am I doing something wrong? Can I provide any additional information to
help narrow down what might be wrong?

Thanks!

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
