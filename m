Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2IQL25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:28:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46555 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab2IQL24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:28:56 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Question about cleaning up the LP5521/5523 LED driver
Thread-Topic: Question about cleaning up the LP5521/5523 LED driver
Thread-Index: Ac2Ux5p32LFQ6BkaSD2YmDg6N4ig1g==
Date: Mon, 17 Sep 2012 11:28:47 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF514F@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

I would like to have your opinion about cleaning up 
LP5521 and LP5523/LP55231 drivers.

Three devices have similar features such like multi channels,
register access via the I2C and internal RAM usage for loading
various LED patterns.
Moreover upcoming IC has also similar layout and interface.

So I would re-design the driver architecture as below.

- Common code which supports shared features.
- Chip code which enables specific features.

For example, leds-lp55xx-common.c is common code.
Chip specific configurations are leds-lp5521.c, leds-lp5523.c and something like that.
Then Makefile will be as following.

obj-$(CONFIG_LEDS_LP5521) 	+= leds-lp5521.o leds-lp55xx-common.o
obj-$(CONFIG_LEDS_LP5523)	+= leds-lp5523.o leds-lp55xx-common.o
obj-$(CONFIG_LEDS_LP55AB)	+= leds-lp55ab.o leds-lp55xx-common.o

Then many duplicated lines can be joined into one file - common code.
Only IC specific code exists each chip dependant file.

But I'm hesitating that some *device attributes* should be kept or not.
For example, The drivers have each 'engine_load' file for loading LED pattern.
LED pattern means blinking LED or ramping up/down the brightness.
To load pattern simply, LP5521/5523/55231 provide programmable memory.

I'll replace these attributes with the firmware interfaces for simplicity.
To load a pattern, hex byte stream is put into the sysfs node.
Then this data is transferred to the internal RAM area of the device.
This is same concept as the firmware interface.
Moreover hex code is dependent on the application or platform.

But it has a problem, point of view of user-space interface.
An application needs to be changed also with the driver version.
The application will failed to run because 'engine_mode' and
'engine_load' don't exist anymore.

Should I keep the sysfs layout of LP5521 and LP5523?
When we change the device attributes, do we have to consider the backward compatibility?

Thank you.

Best Regards,
Milo


