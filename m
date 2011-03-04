Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab1CDCbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 21:31:00 -0500
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:61115 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759195Ab1CDCa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 21:30:59 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Mar 2011 21:30:59 EST
X-AuditID: 12074422-b7c3eae000000a70-ff-4d704db68900
Message-ID: <4D704DAB.9080100@mit.edu>
Date: Thu, 03 Mar 2011 21:25:47 -0500
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
References: <20110303204749.GY3663@linux.intel.com> <20110303211336.GA32645@kroah.com> <20110303214104.GZ3663@linux.intel.com> <20110303215155.GA30451@kroah.com> <20110303220735.GA3663@linux.intel.com> <20110303222226.GA30966@kroah.com>
In-Reply-To: <20110303222226.GA30966@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAARePLzc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 05:22 PM, Greg KH wrote:
> On Thu, Mar 03, 2011 at 05:07:35PM -0500, Matthew Wilcox wrote:
>> On Thu, Mar 03, 2011 at 01:51:55PM -0800, Greg KH wrote:
>>> Heh, no, well, submit_io should just go through the block layer and not
>>> be a separate ioctl, right?
>>
>> Just like with SG_IO, there are reasons to do I/Os without going through
>> the block layer.
>
> Ok, that makes sense.
>
>>>> There's a bit of an impedence mismatch there.  Think of this as
>>>> being drive firmware instead of controller firmware.  This isn't for
>>>> request_firmware() kind of uses, it's for some admin tool to come along
>>>> and tell the drive "Oh, here's some new firmware for you".
>>>
>>> That's fine, request_firmware will work wonderfully for that.
>>
>> How would the driver know that it should call request_firmware()?
>> Do it every 60 seconds in case somebody's downloaded some new firmware?
>
> Ick, no, just use the function provided that lets you create a firmware
> request and be notified when it is written to,
> request_firmware_nowait().  That is what it is there for.
>
>>>> If you look at the spec [1], you'll see there are a number of firmware
>>>> slots in the device, and it's up to the managability utility to decide
>>>> which one to replace or activate.  I dno't think you want to pull all
>>>> that gnarly decision making code into the kernel, do you?
>>>>
>>>> [1] http://download.intel.com/standards/nvmhci/NVM_Express_1_0_Gold.pdf
>>>
>>> No, just export multiple "slots" as firmware devices ready to be filled
>>> in by userspace whenever it wants/needs to.  The management utility can
>>> just dump the firmware to those sysfs files when it determines it needs
>>> to update the firmware, no decision making in the kernel at all.
>>
>> OK ... glad we decided to limit the number of slots.  I still don't see
>> (in Documentation/firmware_class/README) how this works for user-initiated
>> firmware updates rather than kernel-initiated.
>
> I didn't even realize we had a firmware README file...
>
> Anyway, just use request_firmware_nowait(), you will be fine.
>

Unless I'm misunderstanding the spec, this is for *nonvolatile* firmware 
updates.  So if I have two of these devices and I stick a firmware file 
into /lib/firmware, should it update both devices?

Shouldn't reflashing the device firmware be something that the users 
asks for by something a little more specific than just creating a file? 
  (In any case, creating /lib/firmware/nvmhci-3 to flash slot 3 seems 
rather silly.)

--Andy
