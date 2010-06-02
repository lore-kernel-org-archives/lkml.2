Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab0FBVOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:14:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59228 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912Ab0FBVOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=DUT/4j+Mik2gsCRgMBzCi+tzjUi02LnpIa8MAmPH07LdFFtMM79LI9hwNm7h011YIy
         4fLJRNGovq2JzT5dNO1wkBY64HGbUVTU8QxoTByKNZT8t+cgY66pIW+pxWW4lsfJyqLR
         qVYa40vPs5QPzKuDYc/sct4MBs6hjoshq4bPM=
MIME-Version: 1.0
From: Islam Amer <pharon@gmail.com>
Date: Thu, 3 Jun 2010 01:14:09 +0400
Message-ID: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com>
Subject: Dell Studio 1555 eject key does not work ( small patch to fix 
	included )
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Pressing the eject key on my Dell Studio 1555 does not work and dmesg produces
this message :
dell-wmi: Unknown key 0 pressed

Adding a debugging printk in dell-wmi.c after line 222 like this :

printk(KERN_INFO "dell:wmi 0x%x , 0x%x \n", buffer_entry[1], buffer_entry[2]);

dmesg now shows :

dell:wmi 0x0 , 0xe009
dell-wmi: Unknown key 0 pressed

So for some reason buffer_entry[1] is used although it is empty.

Falling back to buffer_entry[2] in case buffer_entry[1] is 0x0 makes
the button work.

I suspect it might be better to fix the "dell_new_hk_type" logic though

I had submitted this as
https://bugzilla.kernel.org/show_bug.cgi?id=16075 but repeating the
information and patch
here as per Andrew Morton's suggestion.


Thanks.

--- linux-sidux-2.6-2.6.34/drivers/platform/x86/dell-wmi.c.orig	2010-06-03
01:02:17.418824168 +0400
+++ linux-sidux-2.6-2.6.34/drivers/platform/x86/dell-wmi.c	2010-06-03
01:01:40.641833249 +0400
@@ -221,7 +221,7 @@ static void dell_wmi_notify(u32 value, v
 			return;
 		}

-		if (dell_new_hk_type)
+		if (dell_new_hk_type || buffer_entry[1] == 0x0)
 			reported_key = (int)buffer_entry[2];
 		else
 			reported_key = (int)buffer_entry[1] & 0xffff;
