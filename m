Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2DBNwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 09:52:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47996 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2DBNwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 09:52:18 -0400
MIME-Version: 1.0
In-Reply-To: <4F797C80.7070107@ahsoftware.de>
References: <4F77055A.2070502@ahsoftware.de>
	<20120402065525.GA29687@aemeltch-MOBL1>
	<4F796377.2050008@ahsoftware.de>
	<CANq1E4RCQvQX6deGOTjdhbEkAahZD9MmAmfgz-Y-+wDfRtx0dw@mail.gmail.com>
	<20120402090337.GB29687@aemeltch-MOBL1>
	<4F796E98.8070603@ahsoftware.de>
	<4F797C80.7070107@ahsoftware.de>
Date: Mon, 2 Apr 2012 10:52:16 -0300
Message-ID: <CACJA=fUgp-Dg1_9RHySHhU5r6W8_jgGMhE6=Aj2Jnt==muHrbg@mail.gmail.com>
Subject: Re: bluetooth: fix deadlock on device reset and power down
From: Andre Guedes <andre.guedes@openbossa.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
        David Herrmann <dh.herrmann@googlemail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Mon, Apr 2, 2012 at 7:16 AM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 02.04.2012 11:17, schrieb Alexander Holler:
>
>> Am 02.04.2012 11:03, schrieb Andrei Emeltchenko:
>>>
>>> Hi guys,
>>>
>>> On Mon, Apr 02, 2012 at 10:44:43AM +0200, David Herrmann wrote:
>>>>
>>>> Hi Andrei and Alexander
>>>>
>>>> On Mon, Apr 2, 2012 at 10:29 AM, Alexander Holler<holler@ahsoftware.de>
>>>>  wrote:
>>>>>
>>>>> Am 02.04.2012 08:55, schrieb Andrei Emeltchenko:
>>>>>>
>>>>>> Hi Alexander,
>>>>>>
>>>>>> On Sat, Mar 31, 2012 at 03:23:38PM +0200, Alexander Holler wrote:
>>>>>>>
>>>>>>> I've experienced a deadlock on shutdown using kernel 3.3 and tracked
>>>>>>> it down. Because I'm not very familiar with the bluetooth stack I'm
>>>>>>> not sure if the below patch is correct, but it fixed the problem
>>>>>>> here.
>>>>>>
>>>>>>
>>>>>> Could you please attach deadlock dump?
>>>>>>
>>>>>>>
>>>>>>> Commit 09fd0de5bd8f8ef3317e5365f92f1a13dcd89aa9 introduced a
>>>>>>> deadlock:
>>>>>>>
>>>>>>> bluetoothd calls ioctl HCIDEVDOWN
>>>>>>>     hci_sock_ioctl()
>>>>>>>         hci_dev_close()
>>>>>>>             hci_dev_do_close()
>>>>>>>                 hci_dev_lock(hdev);
>>>>>>>                 inquiry_cache_flush();
>>>>>>>                 hci_conn_hash_flush();
>>>>>>>                     hci_conn_del()
>>>>>>>                         cancel_delayed_work_sync()
>>>>>>>                             hci_conn_timeout()
>>>>>>>                                 hci_dev_lock(hdev); /* DEADLOCK */
>>>>>>
>>>>>>
>>>>>> I am actually not sure that hci_conn_timeout locks hdev. Why do you
>>>>>> think
>>>>>> so?
>>>>>
>>>>>
>>>>> By reading the source, printk and suffering through the deadlock. It's
>>>>> especially painfull when using a bt-keyboard and systemd, because
>>>>> systemd tries 4 times (~ some minutes) to kill bluetoothd before it
>>>>> marks the service as failed and finally continues to shut down.
>>>>
>>>>
>>>> hci_conn_timeout does lock the device. See the source. But the problem
>>>
>>>
>>> I think you need to check commit e72acc13c770a82b4ce4a07e9716f29320eae0f8
>>>
>>> commit e72acc13c770a82b4ce4a07e9716f29320eae0f8
>>> Author: Andre Guedes<andre.guedes@openbossa.org>
>>> Date:   Fri Jan 27 19:42:03 2012 -0300
>>>
>>>     Bluetooth: Remove unneeded locking
>>>
>>>     We don't need locking hdev in hci_conn_timeout() since it doesn't
>>>     access any hdev's shared resources, it basically queues HCI commands.
>>
>>
>> So if the locks in hci_conn_timeout() aren't needed, your commit which
>> removes them should go to the stable tree because it fixes a painful
>> deadlock.
>
>
> Oh, sorry, that patch is not from you, your first name is only similiar.
> I've added the author to cc, just in case the lock might still be needed in
> 3.3 if no other patches (from 3.4) besides that one are applied.

It is still applicable. It was applied to bluetooth-next tree a week
after 3.3 merge window was closed. This is the reason why it is not
present in 3.3.

BR,

Andre
