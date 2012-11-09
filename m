Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2KIWOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:14:25 -0500
Received: from mail2.ruggedcom.com ([204.50.148.11]:43003 "EHLO
	mail2.ruggedcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab2KIWOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:14:23 -0500
Message-ID: <509D804A.7080807@ruggedcom.com>
Date: Fri, 9 Nov 2012 17:14:34 -0500
From: Richard Retanubun <richardretanubun@ruggedcom.com>
Organization: Ruggedcom
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tang Nguyen <TangNguyen@ruggedcom.com>,
        linux-usb mailing list <linux-usb@vger.kernel.org>
Subject: Re: kmemleak report on isp1763 and sierra MC8705
References: <Pine.LNX.4.44L0.1210291806360.31151-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1210291806360.31151-100000@netrider.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/12 06:14 PM, Alan Stern wrote:
> On Mon, 29 Oct 2012, Richard Retanubun wrote:
>> Focusing down on one of the dumps:
>>
>> unreferenced object 0xd3849740 (size 8):
>>     comm "khubd", pid 1026, jiffies 232553037 (age 506.597s)
>>     hex dump (first 8 bytes):
>>       4d 43 38 37 30 35 00 00                          MC8705..
>>     backtrace:
>>       [<e30efd74>] usb_cache_string+0x74/0xac [usbcore]
>>       [<e30e77bc>] usb_enumerate_device+0x44/0xf8 [usbcore]
>>       [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
>>       [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
>>       [<c0043aa8>] kthread+0x7c/0x80
>>       [<c000ed48>] kernel_thread+0x4c/0x68
>>
>> I have a small question. How does the memory kmalloc-ed() in usb_cache_string is supposed to be released?
>> (during usb_serial_disconnect()?)
>
> It doesn't get released during usb_serial_disconnect().  It gets
> released during usb_release_dev() in drivers/usb/core/usb.c.
>
>>   Is the sierra driver is supposed to participate
>> in the tear down process (in sierra_release() maybe) and not doing something that is expected?
>
> Probably not.
>
>> I am still missing the link between the actions done by the hub_thread() for the caching the stings
>> and the sierra driver code.
>
> They aren't all that closely related.
>
> usb_release_dev() won't be called until all references to the USB
> device have been dropped.  Maybe there's an extra reference hanging
> around.
>
> Alan Stern
>
Thanks a lot for the hint Alan.

I added a dev_dbg print in usb_release_dev() and saw that in the builds where there is a leak, this was simply never called!
the last line printed in a trace with all dev_dbg on is this "usb_disable_device nuking all URBs"
When the sierra modem is unplugged, the cleanup sequence never calls usb_release_dev() (on PL2303 it always calls usb_release_dev()

This is the current state of versions from linux-stable

3.0.y (3.0.51) - Have the issue
3.2.y (3.2.33) - Have the issue
3.4.y (3.4.18) - Have the issue
3.5.y (3.5.7)  - Does not have the issue (but leaks because the portdata patches is not backported yet)
3.6.y (3.6.6)  - Does not have the issue

So a diff between 3.4.y and 3.5.y ought to narrow it down further.

I am posting just in case someone recalls a particular patch I should be trying out first...

-- RR --
