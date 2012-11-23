Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2KWPbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:31:47 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60142 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2KWPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:31:44 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] Support of dual pen/multitouch and new default for win 7 certified devices
Date: Fri, 23 Nov 2012 16:31:23 +0100
Message-Id: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

Last week, I received two new interesting devices report:
- N-trig win 8 certified pen/touch panel
- Samsung Nexio 42"


N-trig device
-------------
The first one is the origin of patches 1 to 6.
The multiouch part worked flawlessly with the win 8 patches I sent before,
but the pen part was completely ignored.
I could have used the quirk MULTI_INPUT, but by testing this quirk against
several devices report I have (https://github.com/bentiss/hid-devices), it
was a pain because some of them create 4 or 5 useless inputs.

I choose to allow the hid driver to control the creation of input devices, thus
patches 1 to 3.


Nexio device
------------
The second one was more problematic. Indeed, it was not working at all with the
current release of hid-multitouch. I had several ghost points, and any of the
available quirks worked.
I finaly found the trick, and this trick applies to all the win7 and win8
devices I saw so far (same url as before).

So I think I finally understood why the windows driver was better than us: it
first looks at the announced contact count, and treat only the right number. It
was so simple... and it works so well...

However, for us, I need to get this information from the raw_event because most
of the devices put the contact count field at the end of the report.

I also decided to change the default class as it is much more tolerant than the
previous one. I could have changed all the devices, but in the end, I changed
only those that get a benefit and that I could test.


Debug tool
----------
I was able to discover this trick only recently because I made a small C program
that allows me to replay the hid events through hid-multitouch. The code is
here: https://github.com/bentiss/hid-replay and you will need a kernel 3.6
to make it work (it requires uhid).

However, be careful, this program can be the root of many kernel oopses if the
targeted hid module tries to directly handle the usb or with any of the usbhid
function.
So, Henrik, I really need you to push your abstraction of usbhid in all hid
modules :)

Anyway, this tool can be very helpful to debug hid devices, that's why I share
it there... and also because I work for an open-source company :)

Happy reviewing.

Cheers,
Benjamin

Benjamin Tissoires (11):
  HID: hid-input factorize hid_input allocation
  HID: hid-input: simplify hid_input allocation and registration
  HID: hid-input: export hidinput_allocation function
  HID: hid-multitouch: creates and handle stylus report with dual-sensors
  HID: hid-multitouch: manually send sync event for pen input report
  HID: hid-multitouch: append " Pen" to the name of the stylus input
  HID: hid-multitouch: rename MT_CLS_DEFAULT into MT_CLS_NSMU
  HID: hid-multitouch: add support for Nexio 42" panel
  HID: hid-multitouch: check if ContactCount is given for default quirk
  HID: hid-multitouch: fix protocol for 3 devices
  HID: hid-multitouch: use MT_QUIRK_CONTACT_COUNT_ACCURATE for win 8 devices

 drivers/hid/hid-ids.h        |   3 +
 drivers/hid/hid-input.c      | 100 +++++++++++++---------
 drivers/hid/hid-multitouch.c | 198 +++++++++++++++++++++++++++++++++++--------
 include/linux/hid.h          |   1 +
 4 files changed, 229 insertions(+), 73 deletions(-)

-- 
1.8.0

