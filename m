Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab2DBIoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:44:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35278 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2DBIoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:44:44 -0400
MIME-Version: 1.0
In-Reply-To: <4F796377.2050008@ahsoftware.de>
References: <4F77055A.2070502@ahsoftware.de>
	<20120402065525.GA29687@aemeltch-MOBL1>
	<4F796377.2050008@ahsoftware.de>
Date: Mon, 2 Apr 2012 10:44:43 +0200
Message-ID: <CANq1E4RCQvQX6deGOTjdhbEkAahZD9MmAmfgz-Y-+wDfRtx0dw@mail.gmail.com>
Subject: Re: bluetooth: fix deadlock on device reset and power down
From: David Herrmann <dh.herrmann@googlemail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrei and Alexander

On Mon, Apr 2, 2012 at 10:29 AM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 02.04.2012 08:55, schrieb Andrei Emeltchenko:
>> Hi Alexander,
>>
>> On Sat, Mar 31, 2012 at 03:23:38PM +0200, Alexander Holler wrote:
>>> I've experienced a deadlock on shutdown using kernel 3.3 and tracked
>>> it down. Because I'm not very familiar with the bluetooth stack I'm
>>> not sure if the below patch is correct, but it fixed the problem
>>> here.
>>
>> Could you please attach deadlock dump?
>>
>>>
>>> Commit 09fd0de5bd8f8ef3317e5365f92f1a13dcd89aa9 introduced a deadlock:
>>>
>>> bluetoothd calls ioctl HCIDEVDOWN
>>>     hci_sock_ioctl()
>>>         hci_dev_close()
>>>             hci_dev_do_close()
>>>                 hci_dev_lock(hdev);
>>>                 inquiry_cache_flush();
>>>                 hci_conn_hash_flush();
>>>                     hci_conn_del()
>>>                         cancel_delayed_work_sync()
>>>                             hci_conn_timeout()
>>>                                 hci_dev_lock(hdev); /* DEADLOCK */
>>
>> I am actually not sure that hci_conn_timeout locks hdev. Why do you think
>> so?
>
> By reading the source, printk and suffering through the deadlock. It's
> especially painfull when using a bt-keyboard and systemd, because
> systemd tries 4 times (~ some minutes) to kill bluetoothd before it
> marks the service as failed and finally continues to shut down.

hci_conn_timeout does lock the device. See the source. But the problem
here is actually a race-condition, too. The do_close() code locks the
device and then cancels all workqueues in a synchronous manner.
However, the hci_conn_timeout work might get started exactly before
calling cancel_delayed_work_sync(). The proper fix would probably be
releasing the lock before calling "cancel_delayed_work_sync()".
However, then we need to make sure that the work is not restarted
while we do not have the lock.
I think we recently introduced some flag that is set while closing a
device. How about checking that in hci_conn_timeout before aquiring
the lock?

> Just try to kill bluetoothd while a bt-mouse or bt-keyboard is connected.

Reproducable, indeed.

> But I have to admit, that my patch is likely the wrong solution as I
> think it will introduce some race conditions. Anyway, I prefer to live
> with them (the race conditions) instead of the deadlock. So for
> inclusion into the kernel a proper solution is needed.
> But already said, I'm not familiar with the bt-stack and don't know
> about the locking strategies inside the stack, so it's hard for me to
> find my way through the source.

Yes, your fix introduces races. We need to hold the lock there!
Applying your fix would introduce harder to trace bugs even during
runtime so we need to fix this properly.

> Regards,
>
> Alexander

Thanks
David
