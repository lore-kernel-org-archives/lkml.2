Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2CKL4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 07:56:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38986 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2CKL4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 07:56:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120309233659.GA21256@kroah.com>
References: <201203032122.36745.chunkeey@googlemail.com> <4F551E46.7000100@linux.vnet.ibm.com>
 <201203092330.24438.chunkeey@googlemail.com> <20120309233659.GA21256@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 11 Mar 2012 12:56:13 +0100
Message-ID: <CAPXgP10oHRnPo7Es1RX8GM68dH13E0rzcFhXzOYFPcmKs=yh1A@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when
 helper is not yet available
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 00:36, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 09, 2012 at 11:30:24PM +0100, Christian Lamparter wrote:
>> This patch fixes a regression which was introduced by:
>> "PM: Print a warning if firmware is requested when tasks are frozen"
>>
>> request_firmware_nowait does not stall in any system resume paths.
>> Therefore, I think it is perfectly save to use request_firmware_nowait
>> from at least the ->complete() callback.
>
> Is there code somewhere in the kernel that wants to do this?  Has commit
> a144c6a broken it somehow that this fix would resolve it?
>
>>
>> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
>> ---
>>  drivers/base/firmware_class.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>> index 6c9387d..017e020 100644
>> --- a/drivers/base/firmware_class.c
>> +++ b/drivers/base/firmware_class.c
>> @@ -535,7 +535,7 @@ static int _request_firmware(const struct firmware **firmware_p,
>>
>>       read_lock_usermodehelper();
>>
>> -     if (WARN_ON(usermodehelper_is_disabled())) {
>> +     if (WARN_ON(usermodehelper_is_disabled() && !(nowait && uevent))) {
>
> What does uevent have to do with things here?

I don't think that the firmware loader should care about the
usermodehelper at all, and that stuff fiddling should just be removed
from the firmware class.

Forking /sbin/hotplug is disabled by default, it is a broken concept,
and it cannot work reliably on today's systems.

Firmware is not loaded by /sbin/hotplug since many years, but by udev
or whatever service handles uevents, like ueventd on android.

Kay
