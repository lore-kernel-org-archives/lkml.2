Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab0C0AMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 20:12:31 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:39926 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab0C0AM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 20:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=K35w3WCTTQHbKaV34CUl0cJ0euaiZCAqq1PN57h2E2gGSr8gnvTX3stnzMxgzyUwMX
         d9Xmr3824X+XvMeNtJ2U548hzWc7FJF9T+p6TjvBBqDjBn0AMy7YaOwT93lghLlJL9mk
         GYQ8TD0pinlKYemAtrxVJs64XdTk+lH7HrZZU=
Message-ID: <4BAD4D6A.3010004@garzik.org>
Date: Fri, 26 Mar 2010 20:12:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.34-rc2 breaks via82cxxx Host Protected Area
References: <20100326232104.GA10769@spacedout.fries.net>
In-Reply-To: <20100326232104.GA10769@spacedout.fries.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2010 07:21 PM, David Fries wrote:
> The kernel fails to see the entire disk with 2.6.34-rc2 with VIA
> vt82c586b chipset.  I tracked it down to commit
> f931a5d5785d7b7c44871bd7ad2762e29dfddf29 "via82cxxx: workaround h/w
> bugs" and reverting just that one solves the problem, or just
> commenting out just one outb write in that change.
>
> via82cxxx 0000:00:07.1: VIA vt82c586b (rev 41) IDE UDMA33
> via82cxxx 0000:00:07.1: IDE controller (0x1106:0x0571 rev 0x06)
> via82cxxx 0000:00:07.1: not 100% native mode: will probe irqs later
>
> Note the kernel panic is intentional as I'm given the test kernel an
> invalid root device, so that I can suspend to disk, try a kernel,
> resume and pick up where I left off.  It does have a side benefit of
> dumping the size of all partitions.
>
> 2.6.34-rc2 unmodified, fails and sees 30985416 KiB for the last
> partition.
> ide-gd driver 1.18
> hda: max request size: 128KiB
> hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
> hda: cache flushes supported
>   hda: hda1 hda2 hda3
> hda: p3 size 236037312 exceeds device capacity, enabling native capacity
> hda: p3 size 236037312 exceeds device capacity, limited to end of disk
> ide-cd driver 5.00
> ...
> Please append a correct "root=" boot option; here are the available partitions:
> 0300        33027624 hda driver: ide-gd
>    0301           49391 hda1
>    0302         1992816 hda2
>    0303        30985416 hda3
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)
>
> 2.6.34-rc2 with patch revered, correct size 118018656
> ide-gd driver 1.18
> hda: max request size: 128KiB
> hda: Host Protected Area detected.
>          current capacity is 66055248 sectors (33820 MB)
>          native  capacity is 240121728 sectors (122942 MB)
> hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
> hda: cache flushes supported
>   hda: hda1 hda2 hda3
> hda: p3 size 236037312 exceeds device capacity, enabling native capacity
> hda: detected capacity change from 33820286976 to 122942324736
> ide-cd driver 5.00
> 0300       120060864 hda driver: ide-gd
>    0301           49391 hda1
>    0302         1992816 hda2
>    0303       118018656 hda3
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)
>
> Here are two debug patches, the first adds debug prints and the second
> disables the problematic write, I  have the output of both included.
>
>> From dac7d14ce1f227d8a084c3ec218ea1430bffdc57 Mon Sep 17 00:00:00 2001
> From: David Fries<david@fries.net>
> Date: Thu, 25 Mar 2010 19:51:31 -0500
> Subject: [PATCH 1/2] fails: add print messages
>
> add print messages for debugging
> ---
>   drivers/ide/via82cxxx.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)

Does libata + pata_via work, if you pass ignore_hpa=1 module option to 
libata?

	Jeff




