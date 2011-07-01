Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1GAFhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:37:10 -0400
Received: from mobile-166-190-108-096.mycingular.net ([166.190.108.96]:38470
	"EHLO brontomerus.synaptics.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751353Ab1GAFhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:37:08 -0400
X-Greylist: delayed 920 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jul 2011 01:37:06 EDT
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 0/9] input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Thu, 30 Jun 2011 22:19:07 -0700
Message-Id: <1309497556-7344-1-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a driver supporting Synaptics ClearPad and other
touchscreens that use the RMI4 protocol, as defined here:

    http://www.synaptics.com/sites/default/files/511-000136-01_revD.pdf

This patch is against the v2.6.38 tag of Linus' kernel tree, commit
521cb40b0c44418a4fd36dc633f575813d59a43d.

This patch completely supersedes the previous patch of 2011/03/30.  Quite a
few changes have been included in this patch.
      
    - bug fixes and changes based on input received for the 2011/03/30
      patch.  I'm not going to list them all here, but we have resolved
      all bugs and changes suggested for that patch, except as listed
      below.  Many thanks to all the folks who took the time review that
      code and make suggestions.
      
    - major reformatting, variable renaming, and other changes to meet
      kernel coding standards.  Checkpatch.pl should run with not complaints
      at all, not even warnings.
    
    - full support for all Synaptics RMI4 SPI products.
    
    - implementation of suspend/resume behavior.
    
    - improved error handling, particularly during initialization
    
    - improved memory management
    
    - extermination of printk, switching to pr_xxx (and dev_xxx where
      appropriate).
      
    - A major reduction in the amoung of INFO level messages generated.
    
    - Fixed Makefile and Kconfig.
    
What's not in this patch?
    - the RMI bus structure still isn't where we want it to be.  There's
      a lot of ad-hoc-ery going on to match sensor drivers to devices, and
      function drivers to the sensors.  We know it's a mess, but want to get
      the core sensing functionality solid before re-arranging the guts of
      the system. In our opinion, it's better to have a working driver with
      ugly architecture than a beautiful architecture that doesn't work.
      Obviously it's best to have a driver that's beautiful and works, all
      at the same time, so after one more functional patch later in July,
      we intend to address the architectural issue in the next few
      weeks after that.
      
    - a number of people suggested moving some header files to more sensible
      locations.  That's an excellent idea, but because we may wind up
      moving them around again when we update the architecture, we decided
      not to implement that in order to reduce the confusion among those
      folks already using this code.
      
    - full documentation - we've started this, but it is not complete by
      any means.

This patch supports a system having one or more RMI sensors attached to it.
Most devices have just a single touch sensor, but some have more than one.
An example is the Fuse concept phone, which has 4 RMI sensors in it).
Each sensor implements a number of RMI4 functions, which are best represented
as devices on the bus.

I2C functionality was previously ACK'ed by Jean Delvare on 2010/05/29.

We've broken this patch into 9 parts in order to keep the individual emails
down to a manageable size.  

    1/9 - core files implementing the bus and providing global definitions
          and platform data
    	  
    2/9 - the physical device interface drivers for I2C and SPI
      
    3/9 - the sensor level implementation files
    
    4/9 - Makefile, Kconfig, and doc file.
    
    5-9/9 - Function drivers for the following RMI4 functions
    		F01 device control
    		F05 analog data (stub)
    		F11 2D sensing
    		F19 capacitive buttons
    		F34 device reflash

The driver core manages the sensors on a device via the rmi bus (/sys/bus/rmi),
handles interfunction communications (mostly IRQ notifications from F01 to
other functions), and proxies register read/write requests to the appropriate
physical layer for a given sensor.

Individual sensors are presented on the bus as /sys/bus/rmi/devices/sensor00,
/sys/bus/rmi/devices/sensor01/, and so on.
      
Functions for each sensor are presented as devices next to that sensor, for
example /sys/bus/rmi/devices/sensor00f01, /sys/bus/rmi/devices/sensor00f11,
and so on.
      
Sensor driver instances are attached to the bus using the kernel device discovery
mechanism.  As described above, a future release will do the same for
function driver instances, but for now we use an ad hoc mechanism to match
functions to sensors.  Yes, we know it's ugly.

We chose this approach because almost all RMI4 functions are independent
of one another.  The sole exception is F01, and its primary interaction
with other functions is to notify them of the need to read or write data
from or to the sensor.  In the long term, this will allow 3rd parties to
implement additional RMI functions in a modular fashion, without having
to modify the core driver implementation or the implementation of unrelated
functions.


Comments and other feedback on this driver are welcomed.

Christopher Heiny
Bill Manson
Allie Xiong
Peichen Chang

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

---
