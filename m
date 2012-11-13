Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab2KMOZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:25:52 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49845 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2KMOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:25:50 -0500
Message-ID: <50A25861.5060803@gmail.com>
Date: Tue, 13 Nov 2012 15:25:37 +0100
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/13] HID: introduce Scan Time
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com> <1352306256-12180-13-git-send-email-benjamin.tissoires@gmail.com> <20121109084527.GA15371@core.coreip.homeip.net>
In-Reply-To: <20121109084527.GA15371@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/09/2012 09:45 AM, Dmitry Torokhov wrote:
> Hi Benjamin,
> 
> On Wed, Nov 07, 2012 at 05:37:35PM +0100, Benjamin Tissoires wrote:
>> Win 8 digitizer devices provides the actual scan time computed by the
>> hardware itself. The value is global to the frame and is not specific
>> to the multitouch protocol (though only touch, not pen, should use it
>> according to the specification).
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>   Documentation/input/event-codes.txt | 9 +++++++++
>>   drivers/hid/hid-input.c             | 4 ++++
>>   include/linux/hid.h                 | 1 +
>>   include/linux/input.h               | 1 +
>>   4 files changed, 15 insertions(+)
>>
>> diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
>> index 53305bd..80c06e5 100644
>> --- a/Documentation/input/event-codes.txt
>> +++ b/Documentation/input/event-codes.txt
>> @@ -174,6 +174,15 @@ A few EV_ABS codes have special meanings:
>>       the input device may be used freely in three dimensions, consider ABS_Z
>>       instead.
>>   
>> +* ABS_SCAN_TIME:
>> +  - Used to report the number of microseconds since the last reset. This event
>> +    should be coded as an uint32 value, which is allowed to wrap around with
>> +    no special consequence. It is assumed that the time difference between two
>> +    consecutive events is reliable on a reasonable time scale (hours).
>> +    A reset to zero can happen, in which case the time since the last event is
>> +    unknown.  If the device does not provide this information, the driver must
>> +    not provide it to the user space.
>> +
> 
> This should not be an absolute event but rather EV_MSC/MSC_TIMESTAMP.
> 
> Thanks.

Hi Dmitry,

alright.
However, since we are using EV_MSC now and the hid layer is not so friendly with them,
the change in hid-input can not be done in the same way, so let's drop it for now.

How about this?


From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Date: Tue, 13 Nov 2012 15:11:22 +0100
Subject: [PATCH] Input: introduce EV_MSC Timestamp

Win 8 digitizer devices provides the actual timestamp (hid_dg_scan_time)
computed by the hardware itself. The value is global to the frame and is
not specific to the multitouch protocol (though only touch, not pen,
should use it according to the specification).

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 Documentation/input/event-codes.txt | 11 +++++++++++
 include/linux/input.h               |  1 +
 2 files changed, 12 insertions(+)

diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
index 53305bd..6f28e11 100644
--- a/Documentation/input/event-codes.txt
+++ b/Documentation/input/event-codes.txt
@@ -196,6 +196,17 @@ EV_MSC:
 EV_MSC events are used for input and output events that do not fall under other
 categories.
 
+A few EV_MSC codes have special meanings:
+
+* MSC_TIMESTAMP:
+  - Used to report the number of microseconds since the last reset. This event
+    should be coded as an uint32 value, which is allowed to wrap around with
+    no special consequence. It is assumed that the time difference between two
+    consecutive events is reliable on a reasonable time scale (hours).
+    A reset to zero can happen, in which case the time since the last event is
+    unknown.  If the device does not provide this information, the driver must
+    not provide it to the user space.
+
 EV_LED:
 ----------
 EV_LED events are used for input and output to set and query the state of
diff --git a/include/linux/input.h b/include/linux/input.h
index ba48743..25354f3 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -858,6 +858,7 @@ struct input_keymap_entry {
 #define MSC_GESTURE		0x02
 #define MSC_RAW			0x03
 #define MSC_SCAN		0x04
+#define MSC_TIMESTAMP		0x05
 #define MSC_MAX			0x07
 #define MSC_CNT			(MSC_MAX+1)
 
-- 
1.8.0

Cheers,
Benjamin
