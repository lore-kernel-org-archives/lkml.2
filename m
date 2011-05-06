Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1EFLug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 07:50:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59292 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1EFLuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 07:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WsjOp9om5xi6+R91v9zD1ABHj+ZEnQcFdsMkE/GShXRgEV+tHn/WEa8U4n544uUwF+
         BlwlA8YPMMlgiO5STjeZWxr+cIbwW5TyoFEq4nIk4GcD1iF8uktunR6b0kX7Rd353nvY
         +l0mgvdQfZzb5U1/eiQ2RylmaNvgCszFwbfbk=
MIME-Version: 1.0
In-Reply-To: <4DC3D296.9060707@slagter.name>
References: <4DC3B0E3.7010008@slagter.name>
	<4DC3D296.9060707@slagter.name>
Date: Fri, 6 May 2011 12:50:33 +0100
Message-ID: <BANLkTimcWN3=qvurDzyMUs8f5+uFPNumaw@mail.gmail.com>
Subject: Re: OOPS after connection Droids MuIn USB display
From: Maxin John <maxin.john@gmail.com>
To: Erik Slagter <erik@slagter.name>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

> In the file drivers/usb/class/cdc-acm.c, around line 1098, there is a
> comment "/*workaround for switched interfaces */" and then a check:
>
> if (data_interface->cur_altsetting->desc.bInterfaceClass !=
> CDC_DATA_INTERFACE_TYPE)
>
> At this point, the variable data_interface is NULL and this causes the OOPS.
>

I have included some checks for "data_interface" since
"usb_ifnum_to_if" could return NULL.
Could you please check by applying this patch ?

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e057e53..073f418 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -960,6 +960,10 @@ static int acm_probe(struct usb_interface *intf,
        if (quirks == NO_UNION_NORMAL) {
                data_interface = usb_ifnum_to_if(usb_dev, 1);
                control_interface = usb_ifnum_to_if(usb_dev, 0);
+               if (!data_interface || !control_interface) {
+                       dev_dbg(&intf->dev, "no interfaces\n");
+                       return -ENODEV;
+               }
                goto skip_normal_probe;
        }

@@ -1031,6 +1035,10 @@ next_desc:
                if (call_interface_num > 0) {
                        dev_dbg(&intf->dev, "No union descriptor,
using call management descriptor\n");
                        data_interface = usb_ifnum_to_if(usb_dev,
(data_interface_num = call_interface_num));
+                       if (!data_interface) {
+                               dev_dbg(&intf->dev, "no data interface\n");
+                               return -ENODEV;
+                       }
                        control_interface = intf;
                } else {
                        if (intf->cur_altsetting->desc.bNumEndpoints != 3) {
