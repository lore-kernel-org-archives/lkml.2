Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab1LNJlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 04:41:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55973 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1LNJlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 04:41:47 -0500
MIME-Version: 1.0
In-Reply-To: <201112141014.33696.oneukum@suse.de>
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org>
 <201112140855.40050.oneukum@suse.de> <CAGS+omDMipRTVOGV9fG0ciWpuwMRBL-eTY8uDwaiSOW==CkQ-w@mail.gmail.com>
 <201112141014.33696.oneukum@suse.de>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 14 Dec 2011 17:41:25 +0800
X-Google-Sender-Auth: g-40Qwt2hFW2KFPRIM4iUccWizY
Message-ID: <CAGS+omBR6=SknipHES5Kb20V-8pN5knSx1=Q=z7xP6xc-GfWKQ@mail.gmail.com>
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

On Wed, Dec 14, 2011 at 5:14 PM, Oliver Neukum <oneukum@suse.de> wrote:
> Am Mittwoch, 14. Dezember 2011, 09:00:18 schrieb Daniel Kurtz:
>> On Wed, Dec 14, 2011 at 3:55 PM, Oliver Neukum <oneukum@suse.de> wrote:
>> > Am Donnerstag, 17. November 2011, 12:23:49 schrieb Daniel Kurtz:
>> >> Unfortunately, this usually happens while the first LED request is
>> >> actually still being processed.  Thus when the completion handler tries
>> >> to submit the second LED request it fails, since REPORTED_IDLE is
>> >> already set!  This REPORTED_IDLE check failure causes the completion
>> >> handler to complete, however without clearing the CTRL_RUNNING flag.
>> >> This, in turn, means that the suspend() handler's wait_io() condition
>> >> is never satisfied, and instead it times out after 10 seconds, aborting
>> >> the original system suspend.
>> >>
>> >> This patch changes the behavior to the following:
>> >>   (1) allow completion handler to finish submitting all queued URBs, even if
>> >>       REPORTED_IDLE is set.  This guarantees that all URBs queued before the
>> >>       hid-core suspend() call will be submitted before the system is
>> >>       suspended.
>> >
>> > Hi,
>> >
>> > why is this desirable? You'd want to requests to be executed at resumption.
>> > A system suspend will alter the LED state anyway.
>>
>> This is how a system suspend 'alters' the LED state.  The input layer
>> sends those LED off commands down through HID as it is trying to
>> suspend.  We want to make sure the usbhid layer actually finishes
>> forwarding those requests on to the device before the system is
>> suspended.
>
> You know the HID layer will send those commands. You don't know which
> other commands may already be queued. So I don't know whether you really want
> to execute them all while the system is asuspending.

I'm confused.  The HID layer is sending which commands?

AFAICT, suspend works like this:
    On system suspend, the input.c suspend() gets called, which saves
off current LED value, and sends LED off events to all keyboards.  If
more than one LED was on, there will be multiple LED off requests.
The HID core immediately submits the first of them (assuming it isn't
in the middle of sending another Control request URB), and queues URBs
for the rest of them, to be submitted by the completion handler.
    Meanwhile, the hid-core.c suspend() gets called soon after the
input suspend() finishes.  This can happen while usbhid driver is
still processing the first LED off request, and therefore there are
still other URBs queued up.  However, since suspend() sets
REPORTED_IDLE, the completion handler can't actually submit them.
Therefore, suspend() times out while waiting for i/o to complete, and
as a result aborts the system suspend.

This patch fixes this problem, and synchronizes queued URBs with
system suspend by sending all urbs that were queued before the usbhid
suspend() was called.

Please let me know if I'm missing something?

-Dan

>
>        Regards
>                Oliver
