Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab0KEIEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 04:04:14 -0400
Received: from smtp.nokia.com ([192.100.105.134]:37250 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0KEIEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 04:04:07 -0400
From: <samu.p.onkalo@nokia.com>
To: <gregkh@suse.de>
CC: <hmh@hmh.eng.br>, <alan@linux.intel.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 5 Nov 2010 09:03:07 +0100
Subject: RE: [PATCH] sysfs: device-core: sysfs open close notify
Thread-Topic: [PATCH] sysfs: device-core: sysfs open close notify
Thread-Index: Act8JAbVi2LIYxN3TLy2EmcUCWuuogAiueXg
Message-ID: <62697B07E9803846BC582181BD6FB6B836EB63CF34@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1288861417-469-1-git-send-email-samu.p.onkalo@nokia.com>
 <20101104132339.GC10390@suse.de>
In-Reply-To: <20101104132339.GC10390@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Nov 2010 08:03:31.0411 (UTC) FILETIME=[EFCF0230:01CB7CBF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: ext Greg KH [mailto:gregkh@suse.de]
>Sent: 04 November, 2010 15:24
>To: Onkalo Samu.P (Nokia-MS/Tampere)
>Cc: hmh@hmh.eng.br; alan@linux.intel.com; akpm@linux-foundation.org;
>linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] sysfs: device-core: sysfs open close notify
>
>On Thu, Nov 04, 2010 at 11:03:37AM +0200, Samu Onkalo wrote:
>> Patch adds possibility for a driver to get open and close
>> notifications from the sysfs accesses. Driver may need this
>> information for enabling features and for runtime
>> power management control.
>>
>> Patch causes quite small overhead compared to current implementation.
>> Sysfs_ops is enhanced with open_close notify method which causes
>> some increase to static memory consumption. Sysfs attribute defition
>> is not changed.
>>
>> Device core is modified with open_close_notification function and
>> corresponding sysfs_ops change. New macro is introduced which can
>> be used to setup sysfs attributes with open_close notification
>> in a device driver.
>>
>> Sysfs control itself contains new optional calls to open_close_
>> notifications and a function which controls the feature.
>> By default nothing it changed at runtime.
>>
>> Normal sysfs creation and remove functions can be used to control
>> attributes in device drivers.
>>
>> Change needed device drivers:
>> For sysfs attributes which needs open_close_notification:
>> Use DEVICE_ATTR_NOTIFY instead of DEVICE_ATTR with sysfs attributes.
>> Call sysfs_set_open_notify for those attributes after the creation.
>
>Can you somehow not have to make the extra call to
>sysfs_set_open_notify?  The driver doesn't want to dig down and find the
>kobject, and shouldn't have to do this.  Also, it will race with the
>creation of the sysfs file and userspace opening the file before the
>driver has the ability to set this marking on the file, so the driver
>could never be notified of the original open and everyone involved will
>be confused.
>

Driver have to find out kobj when it creates sysfs files. Most probably
file creation is quite close to the sysfs_set_open_notify.

However, the race condition is real issue. I don't find a clean way
to solve it. There is no clean way to pass information using current
file creation functions. By clearing read/write permissions from the
mode_t during creation and setting them in sys_set_open_notify removes
race condition, but from userspace it looks quite odd that there is an entry
without permissions and suddenly permissions just exist. Doesn't sound
good - sounds like a hack.

It would be nice to implement this so that the driver decides what to do in
case of open and close and not just call pm_runtime by the device core.
For some driver, it is possible to keep part of the HW at inactive state
depending on what userspace really uses.

In the first proposal, there were two function pointers in struct device_driver.
One pointer is enough. This causes some overhead to all device drivers.

What do you think, it is acceptable to add one function pointer to
struct device_driver? If yes, implementation becomes quite clean.

Device driver itself can then do whatever it needs and it can detect which
attribute was opened since it receives pointer to attribute definition.

-Samu




