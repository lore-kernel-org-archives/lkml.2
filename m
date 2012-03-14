Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2CNPIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:08:13 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:34861 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2CNPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:08:09 -0400
Message-ID: <4F60B44D.1020600@linux.vnet.ibm.com>
Date: Wed, 14 Mar 2012 20:37:57 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        skannan@codeaurora.org, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper
 is not yet available
References: <201203032122.36745.chunkeey@googlemail.com> <201203132042.07794.rjw@sisk.pl> <CAPXgP11fWf-0Jkk=d6G+d=sQa-hoX3jUM+K6K4rGYhh0dv1u_w@mail.gmail.com> <201203140110.40671.rjw@sisk.pl>
In-Reply-To: <201203140110.40671.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12031415-4790-0000-0000-000001C8071C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 05:40 AM, Rafael J. Wysocki wrote:

> On Wednesday, March 14, 2012, Kay Sievers wrote:
>> On Tue, Mar 13, 2012 at 20:42, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Sunday, March 11, 2012, Kay Sievers wrote:
>>>> On Sat, Mar 10, 2012 at 00:36, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>>>>> What does uevent have to do with things here?
>>>>
>>>> I don't think that the firmware loader should care about the
>>>> usermodehelper at all, and that stuff fiddling should just be removed
>>>> from the firmware class.
>>>
>>> It's there to warn people that their drivers do stupid things like
>>> loading frimware during system resume, which is guaranteed not to work.
>>>
>>> IOW, it's there very much on purpose.
>>
>> Using the /sbin/hotplug is no case that needs any warning. It' such a
>> broken model these days, that firmware loading is the least problem
>> that occurs with it.
>>
>>>> Forking /sbin/hotplug is disabled by default, it is a broken concept,
>>>> and it cannot work reliably on today's systems.
>>>>
>>>> Firmware is not loaded by /sbin/hotplug since many years, but by udev
>>>> or whatever service handles uevents, like ueventd on android.
>>>
>>> Which I'm not sure why is relevant here.
>>
>> It is relevant in the sense that the firmware loader should not even
>> know that a uevent *can* cause a usermodehelper exec() if it runs in
>> legacy mode. The firmware loader just has no business in fiddling with
>> the details of driver core legacy stuff. I don't think his warning
>> makes much sense.
> 
> But that warning actually triggers for drivers that attempt to use
> request_firmware() during system resume, even though /sbin/hotplug isn't
> used any more.
> 


I agree with Rafael about why the warning and the bail out is required,
including the part about the races with freezer which he explained in his
other mail. These problems have already been well documented too.
(See Documentation/power/freezing-of-tasks.txt).

> usermodehelper_is_disabled() means "we are in the middle of system power
> transition" rather than anything else (I agree it should be called
> suspend_in_progress() or something similar these days).
> 


How about this patch then?

---

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: PM/firmware loader: Use better name for usermodehelper_is_disabled()

Rafael J. Wysocki <rjw@sisk.pl> wrote:

| usermodehelper_is_disabled() means "we are in the middle of system power
| transition" rather than anything else (I agree it should be called
| suspend_in_progress() or something similar these days).


But simply renaming usermodehelper_is_disabled() to suspend_in_progress()
isn't the best thing to do since that would be misleading because suspend
transitions are begun much before usermodehelpers are disabled.

Apart from that, we don't want people to suddenly start abusing this function
in future in a totally different context to check if suspend is in progress.

So, add an alias specific to firmware loaders alone, that will internally
call usermodehelpers_is_disabled().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/base/firmware_class.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6c9387d..9e401e1 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -510,6 +510,8 @@ static void fw_destroy_instance(struct firmware_priv *fw_priv)
 	device_unregister(f_dev);
 }
 
+#define suspend_in_progress()	usermodehelper_is_disabled()
+
 static int _request_firmware(const struct firmware **firmware_p,
 			     const char *name, struct device *device,
 			     bool uevent, bool nowait)
@@ -535,7 +537,15 @@ static int _request_firmware(const struct firmware **firmware_p,
 
 	read_lock_usermodehelper();
 
-	if (WARN_ON(usermodehelper_is_disabled())) {
+	/*
+	 * It is wrong to request firmware when the system is suspended,
+	 * because it simply won't work reliably. Also, it can cause races with
+	 * the freezer, leading to freezing failures. So check if the system is
+	 * in a state which is unsuitable for requesting firmware (because the
+	 * system is suspended or not yet fully resumed) and bail out early if
+	 * needed.
+	 */
+	if (WARN_ON(suspend_in_progress())) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
 		retval = -EBUSY;
 		goto out;


