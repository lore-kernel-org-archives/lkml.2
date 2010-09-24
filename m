Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123Ab0IXEl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:41:58 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42831 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0IXElz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:41:55 -0400
Message-ID: <4C9C2C0C.4070506@interlog.com>
Date: Fri, 24 Sep 2010 00:41:48 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com> <4C9C129E.5050504@teksavvy.com>
In-Reply-To: <4C9C129E.5050504@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-09-23 10:53 PM, Mark Lord wrote:
> On 10-09-23 08:05 PM, Douglas Gilbert wrote:
>> Mark,
>> If you issued the SG_IO ioctl with a timeout of at
>> least 66 minutes (expressed in milliseconds) then
>> it looks like ata_scsi_queuecmd() has a problem.
> ..
>
> Mmm.. more like blk_execute_rq() perhaps.
> That's where the wait_for_completion(&wait) call is at.
>
> Perhaps I should change it to wait in smaller increments,
> so that the lockup detection doesn't trigger on it..
>
> Doing that seems rather wasteful, though.
>
> Note that this is the ATA "SECURITY ERASE" command,
> which doesn't have an "immed" bit to toggle.
> So one must wait for it to complete.

And I have seen another issue with long (SCSI) commands.
During a FORMAT UNIT another pesky program might
have nothing better to do than periodically send out
things like TEST UNIT READY (check a disk is ready
for IO) which will have a normal timeout on it (e.g.
60 seconds). With a format underway, the HBA or the device
may not accept the TEST UNIT READY so its timeout expires
and the error handling code thinks the device is unwell
and decides to reset it.

There is a useful flag in the scsi_device structure called
no_uld_attach which hides a device from the sd driver
(assuming it is a disk). Then the disk can only be accessed
via the bsg or sg driver. And those other pesky programs
can't find the disk in question. I'm not aware of a way
to control that flag from the user space.

Doug Gilbert
