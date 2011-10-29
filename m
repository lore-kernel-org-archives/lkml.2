Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1J2Kxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 06:53:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64112 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab1J2Kxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 06:53:31 -0400
MIME-Version: 1.0
In-Reply-To: <4EABC937.60600@broadcom.com>
References: <1319846297-2985-3-git-send-email-julia@diku.dk>
	<20111029062412.GG14881@longonot.mountain>
	<4EABC937.60600@broadcom.com>
Date: Sat, 29 Oct 2011 12:53:29 +0200
Message-ID: <CANq1E4QJoM+NYub9hfs3KnL1w212FK0MHo8ez2p1nyGmNVb-=A@mail.gmail.com>
Subject: Re: [PATCH 3/5] drivers/hid/hid-roccat.c: eliminate a null pointer dereference
From: David Herrmann <dh.herrmann@googlemail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Julia Lawall <julia@diku.dk>,
        Jiri Kosina <jkosina@suse.cz>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 11:36 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 10/29/2011 08:24 AM, Dan Carpenter wrote:
>> On Sat, Oct 29, 2011 at 01:58:15AM +0200, Julia Lawall wrote:
>>> diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
>>> index 2596321..36a28b8 100644
>>> --- a/drivers/hid/hid-roccat.c
>>> +++ b/drivers/hid/hid-roccat.c
>>> @@ -163,14 +163,15 @@ static int roccat_open(struct inode *inode, struct file *file)
>>>
>>>      device = devices[minor];
>>>
>>> -    mutex_lock(&device->readers_lock);
>>> -
>>>      if (!device) {
>>>              pr_emerg("roccat device with minor %d doesn't exist\n", minor);
>>> -            error = -ENODEV;
>>> -            goto exit_err;
>>> +            kfree(reader);
>>> +            mutex_lock(&devices_lock);
>>
>> Typo.  mutex_unlock() instead of mutex_lock().
>
> This is no typo, but simply wrong. Remove the mutex_lock() as we are
> leaving the function here in error flow.

No, this one is definitely needed. Its devices_lock, not
device->readers_lock! And devices_lock is locked before so we need to
unlock it if we return in this branch.

>>> +            return -ENODEV;
>>>      }
>>>
>>> +    mutex_lock(&device->readers_lock);
>>> +
>>>      if (!device->open++) {
>>>              /* power on device on adding first reader */
>>>              error = hid_hw_power(device->hid, PM_HINT_FULLON);
>>>
>>
>> regards,
>> dan carpenter
>
> Gr. AvS

Regards
David
