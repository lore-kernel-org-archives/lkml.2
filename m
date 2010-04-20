Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0DTXMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:12:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37489 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0DTXMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:12:18 -0400
Message-ID: <4BCE34CC.9030506@canonical.com>
Date: Tue, 20 Apr 2010 16:12:12 -0700
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, pingc@wacom.com,
       Anton@anikin.name, stable@kernel.org, stable-commits@vger.kernel.org
Subject: Re: patch input-wacom-switch-mode-upon-system-resume.patch added
 to 2.6.33-stable tree
References: <1271697023113@kroah.org> <201004191024.43397.dmitry.torokhov@gmail.com> <20100419172856.GA6965@suse.de>
In-Reply-To: <20100419172856.GA6965@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------010904080400080502030604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010904080400080502030604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Greg KH wrote:
> On Mon, Apr 19, 2010 at 10:24:41AM -0700, Dmitry Torokhov wrote:
>> Greg,
>>
>> On Monday 19 April 2010 10:10:23 am gregkh@suse.de wrote:
>>> This is a note to let you know that we have just queued up the patch titled
>>>
>>>     Subject: Input: wacom - switch mode upon system resume
>>>
>>> to the 2.6.33-stable tree.  Its filename is
>>>
>>>     input-wacom-switch-mode-upon-system-resume.patch
>>>
>> Could you add this to .32 as well, please?
> 
> I looked, and it didn't seem to apply at all.  Can someone backport it
> to .32 and I will be glad to apply it.
> 

That would be my backport for .32, maybe Ping or Dmitry can sanity check.

Stefan

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe stable-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--------------010904080400080502030604
Content-Type: text/x-diff;
 name="0001-Input-wacom-switch-mode-upon-system-resume.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Input-wacom-switch-mode-upon-system-resume.patch"

>From 7021bbc3685fc147eb47deee345801ffb007a7e9 Mon Sep 17 00:00:00 2001
From: Ping Cheng <pingc@wacom.com>
Date: Tue, 13 Apr 2010 23:07:52 -0700
Subject: [PATCH] Input: wacom - switch mode upon system resume

commit 014f61504af276ba9d9544d8a7401d8f8526eb73 upstream

When Wacom devices wake up from a sleep, the switch mode command
(wacom_query_tablet_data) is needed before wacom_open is called.
wacom_query_tablet_data should not be executed inside wacom_open
since wacom_open is called more than once during probe.

wacom_retrieve_hid_descriptor is removed from wacom_resume due
to the fact that the required descriptors are stored properly
upon system resume.

Reported-and-tested-by: Anton Anikin <Anton@Anikin.name>
Signed-off-by: Ping Cheng <pingc@wacom.com>
Cc: stable@kernel.org
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/input/tablet/wacom_sys.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index b5b69cc..5be07f9 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -562,11 +562,15 @@ static int wacom_resume(struct usb_interface *intf)
 	int rv;
 
 	mutex_lock(&wacom->lock);
-	if (wacom->open) {
+
+	/* switch to wacom mode first */
+	wacom_query_tablet_data(intf, features);
+
+	if (wacom->open)
 		rv = usb_submit_urb(wacom->irq, GFP_NOIO);
-		wacom_query_tablet_data(intf);
-	} else
+	else
 		rv = 0;
+
 	mutex_unlock(&wacom->lock);
 
 	return rv;
-- 
1.6.3.3


--------------010904080400080502030604--
