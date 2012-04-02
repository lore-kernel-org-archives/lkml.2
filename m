Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab2DBI3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:29:53 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:33351 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2DBI3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:29:52 -0400
Message-ID: <4F796377.2050008@ahsoftware.de>
Date: Mon, 02 Apr 2012 10:29:43 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120303 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
CC: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: bluetooth: fix deadlock on device reset and power down
References: <4F77055A.2070502@ahsoftware.de> <20120402065525.GA29687@aemeltch-MOBL1>
In-Reply-To: <20120402065525.GA29687@aemeltch-MOBL1>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.04.2012 08:55, schrieb Andrei Emeltchenko:
> Hi Alexander,
> 
> On Sat, Mar 31, 2012 at 03:23:38PM +0200, Alexander Holler wrote:
>> I've experienced a deadlock on shutdown using kernel 3.3 and tracked
>> it down. Because I'm not very familiar with the bluetooth stack I'm
>> not sure if the below patch is correct, but it fixed the problem
>> here.
> 
> Could you please attach deadlock dump?
> 
>>
>> Commit 09fd0de5bd8f8ef3317e5365f92f1a13dcd89aa9 introduced a deadlock:
>>
>> bluetoothd calls ioctl HCIDEVDOWN
>>     hci_sock_ioctl()
>>         hci_dev_close()
>>             hci_dev_do_close()
>>                 hci_dev_lock(hdev);
>>                 inquiry_cache_flush();
>>                 hci_conn_hash_flush();
>>                     hci_conn_del()
>>                         cancel_delayed_work_sync()
>>                             hci_conn_timeout()
>>                                 hci_dev_lock(hdev); /* DEADLOCK */
> 
> I am actually not sure that hci_conn_timeout locks hdev. Why do you think
> so?

By reading the source, printk and suffering through the deadlock. It's
especially painfull when using a bt-keyboard and systemd, because
systemd tries 4 times (~ some minutes) to kill bluetoothd before it
marks the service as failed and finally continues to shut down.

Just try to kill bluetoothd while a bt-mouse or bt-keyboard is connected.

But I have to admit, that my patch is likely the wrong solution as I
think it will introduce some race conditions. Anyway, I prefer to live
with them (the race conditions) instead of the deadlock. So for
inclusion into the kernel a proper solution is needed.
But already said, I'm not familiar with the bt-stack and don't know
about the locking strategies inside the stack, so it's hard for me to
find my way through the source.

Regards,

Alexander
