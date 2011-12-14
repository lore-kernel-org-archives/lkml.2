Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1LNIAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 03:00:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52391 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1LNIAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 03:00:40 -0500
MIME-Version: 1.0
In-Reply-To: <201112140855.40050.oneukum@suse.de>
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org>
 <1321529030-7845-3-git-send-email-djkurtz@chromium.org> <201112140855.40050.oneukum@suse.de>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 14 Dec 2011 16:00:18 +0800
X-Google-Sender-Auth: V1_PxD2dZzRWs-zmbl3V3i6rJOw
Message-ID: <CAGS+omDMipRTVOGV9fG0ciWpuwMRBL-eTY8uDwaiSOW==CkQ-w@mail.gmail.com>
Subject: Re: [PATCH 2/3] HID: usbhid: hid-core: submit queued urbs before suspend
To: Oliver Neukum <oneukum@suse.de>
Cc: jkosina@suse.cz, bleung@chromium.org, stern@rowland.harvard.edu,
        olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 3:55 PM, Oliver Neukum <oneukum@suse.de> wrote:
> Am Donnerstag, 17. November 2011, 12:23:49 schrieb Daniel Kurtz:
>> Unfortunately, this usually happens while the first LED request is
>> actually still being processed.  Thus when the completion handler tries
>> to submit the second LED request it fails, since REPORTED_IDLE is
>> already set!  This REPORTED_IDLE check failure causes the completion
>> handler to complete, however without clearing the CTRL_RUNNING flag.
>> This, in turn, means that the suspend() handler's wait_io() condition
>> is never satisfied, and instead it times out after 10 seconds, aborting
>> the original system suspend.
>>
>> This patch changes the behavior to the following:
>>   (1) allow completion handler to finish submitting all queued URBs, even if
>>       REPORTED_IDLE is set.  This guarantees that all URBs queued before the
>>       hid-core suspend() call will be submitted before the system is
>>       suspended.
>
> Hi,
>
> why is this desirable? You'd want to requests to be executed at resumption.
> A system suspend will alter the LED state anyway.

This is how a system suspend 'alters' the LED state.  The input layer
sends those LED off commands down through HID as it is trying to
suspend.  We want to make sure the usbhid layer actually finishes
forwarding those requests on to the device before the system is
suspended.

Regards,
-Daniel

>
>        Regards
>                Oliver
> --
> - - -
> SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
> Maxfeldstraße 5
> 90409 Nürnberg
> Germany
> - - -
