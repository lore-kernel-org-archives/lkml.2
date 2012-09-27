Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2I0QU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:20:59 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38773 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2I0QU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:20:58 -0400
Message-ID: <50647CCC.7010407@ahsoftware.de>
Date: Thu, 27 Sep 2012 18:20:28 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
References: <50531629.9020107@ahsoftware.de> <20120925110206.GD28937@mwanda> <50643C4A.9010202@ahsoftware.de> <20120927151232.GA12210@quack.suse.cz> <506474E8.3030300@ahsoftware.de>
In-Reply-To: <506474E8.3030300@ahsoftware.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2012 17:46, schrieb Alexander Holler:
> Hello,
>
> Am 27.09.2012 17:12, schrieb Jan Kara:
>>    Just some thoughts about your oops:
>> The assertion which fails is:
>> BUG_ON(!list_empty(&bh->b_assoc_buffers));
>>
>> Now b_assoc_buffers isn't used very much. In particular ext4 which you
>> seem
>> to be using doesn't use this list at all (except when mounted in
>> nojournal
>> mode but that doesn't seem to be your case). That would point rather
>> strongly at a memory corruption issue.
>>
>> So if you can reproduce the oops, it might be interesting to print
>> bh->b_assoc_buffers.next and &bh->b_assoc_buffers.next if the list is
>> found
>> to be non-empty.
>
> Hmm, a loose pointer would explain it all too. Especially the cases when
> I just have seen wrong content in the archive without having any oops. I
> try to reproduce it with
>
> pr_info("AHO: %p %p\n", bh->b_assoc_buffers.next,
> &bh->b_assoc_buffers.next);
>
> after the BUG_ON().
>
> Thanks for the hint. I wasn't already that far to know that
> b_assoc_buffers isn't used that much.

Hmm, that doesn't look very practicable because b_assoc_buffers seems to 
be used a lot here. ;)
Maybe I should have mentioned that I'm mounting the source filesystem 
(root with ext4) with 
nodelalloc(rw,noatime,nodelalloc,errors=remount-ro,data=ordered), and to 
backup it, I'm using a bind-mount (mount -o bind / /foo) as source.

But the debug output starts very early on boot, where no bind-mount is used:

---------------------
Sep 27 18:03:23 krabat udevd[1254]: invalid rule 
'/etc/udev/rules.d/80-aho.rules:26'
Sep 27 18:03:23 krabat kernel: [    4.562670] usb usb8: New USB device 
found, idVendor=1d6b, idProduct=0001
Sep 27 18:03:23 krabat kernel: [    4.562671] usb usb8: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Sep 27 18:03:23 krabat systemd-uaccess[1363]: Failed to apply ACL on 
/dev/kvm: Operation not supported
Sep 27 18:03:23 krabat kernel: [    4.562673] usb usb8: Product: UHCI 
Host Controller
Sep 27 18:03:23 krabat kernel: [    4.562674] usb usb8: Manufacturer: 
Linux 3.5.4-00009-gfa43f23-dirty uhci_hcd
Sep 27 18:03:23 krabat kernel: [    4.562676] usb usb8: SerialNumber: 
0000:00:1d.0
Sep 27 18:03:23 krabat systemd-uaccess[1716]: Failed to apply ACL on 
/dev/kvm: Operation not supported
Sep 27 18:03:23 krabat kernel: [    4.563285] hub 8-0:1.0: USB hub found
Sep 27 18:03:23 krabat kernel: [    4.563288] hub 8-0:1.0: 2 ports detected
Sep 27 18:03:23 krabat systemd-uaccess[2324]: Failed to apply ACL on 
/dev/snd/timer: Operation not supported
Sep 27 18:03:23 krabat kernel: [    4.563316] AHO: ffff880212e4b048 
ffff880212e4b048
Sep 27 18:03:23 krabat kernel: [    4.563318] AHO: ffff880212e4b0b0 
ffff880212e4b0b0
Sep 27 18:03:23 krabat kernel: [    4.563319] AHO: ffff880212e4b118 
ffff880212e4b118
---------------------

And afterwards I see tons of those messages, so it doesn't look usable. 
Anyway, I retry to repdroduce the problem without that debug line, just 
to see if still can reproduce the problem with F17 as userspace (and 
kernel 3.5.4 instead of 3.5.3).

Regards,

Alexander
