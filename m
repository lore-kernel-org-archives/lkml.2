Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1BUI3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 03:29:12 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:57955 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189Ab1BUI3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 03:29:11 -0500
Message-ID: <4D622243.8030507@metafoo.de>
Date: Mon, 21 Feb 2011 09:28:51 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Pali Rohar <pali.rohar@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14 v3] bq27x00: Cache battery registers
References: <1297539554-13957-8-git-send-email-lars@metafoo.de>	<1297652493-7207-1-git-send-email-lars@metafoo.de>	<AANLkTimn2JYtUSUrJBQKzXrw+URD5n0Y2h7QMaFzKFdY@mail.gmail.com>	<4D59A93A.7090800@metafoo.de>	<AANLkTi=RJfYEoiCPgesmZUoeOy+MehZQWeWDCWoW7vnh@mail.gmail.com> <AANLkTik6df6X2Jw8m6SYCFi9aN2LZc=C72WCw=gDevOr@mail.gmail.com>
In-Reply-To: <AANLkTik6df6X2Jw8m6SYCFi9aN2LZc=C72WCw=gDevOr@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry, for not responding earlier I was traveling and didn't had my board with me.

On 02/15/2011 11:39 PM, Grazvydas Ignotas wrote:
> On Tue, Feb 15, 2011 at 1:48 PM, Grazvydas Ignotas <notasas@gmail.com> wrote:
>> On Tue, Feb 15, 2011 at 12:14 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>> On 02/14/2011 10:58 PM, Grazvydas Ignotas wrote:
>>>> This is wrong, as read function returns negative values for bq27500
>>>> when discharging. That's why read function used to pass value through
>>>> argument before your series (return value was for error code).
>>>
>>> I don't think so. The register is 16bit wide and it is read as a unsigned. So
>>> in the non error case bq27x00_read will always return >= 0.
>>> The value is later reinterpreted as a signed 16bit.(See the other lines you
>>> quoted underneath).
>>
>> Hmh, right..
>>
>>> Did you experience any actual problem with current being wrong?
>>
>> Yes, the returned current values were randomly jumping between -500000
>> and 600000 while the device was discharging, so I thought
>> uninitialized values were being returned (this never happened before
>> the series; no errors in dmesg). I'll need to debug a bit more I
>> guess..
> 
> ok this series seem to trigger unrelated bug, probably due to lots of
> reads when cache is being updated, the attached patch seems to help.
> Feel free to integrate it or I'll send it separately after your
> patches are merged.
I've added the patch to my bq27x00-for-upstream tree.

> 
> However there is bigger problem, compiling as module and doing
> insmod/rmmod/insmod causes kernel OOPS:
> 
> [  882.575714] BUG: sleeping function called from invalid context at
> arch/arm/mm/fault.c:295
> [  882.584350] in_atomic(): 0, irqs_disabled(): 128, pid: 1154, name: insmod
> ...
> [  882.959930] Unable to handle kernel NULL pointer dereference at
> virtual address 00000000
> [  882.968444] pgd = c14c8000
> [  882.977905] Internal error: Oops: 817 [#1]
> ...
> [  883.304412] [<c007eed8>] (__queue_work+0x140/0x260) from
> [<c007f044>] (queue_work_on+0x2c/0x34)
> [  883.313568] [<c007f044>] (queue_work_on+0x2c/0x34) from
> [<bf008390>] (bq27x00_update+0x1f8/0x220 [bq27x00_battery])
> [  883.324584] [<bf008390>] (bq27x00_update+0x1f8/0x220
> [bq27x00_battery]) from [<bf0084c8>] (bq27x00_battery_poll+0x14/0x48
> [bq27x00_battery])
> 
> full backtrace attached.

I can't reproduce that OOPS. And the backtrace looks a bit strange,
queue_work_on is not called from bq27x00_update.
Can you send me the disassembly of your bq27x00_update?

- Lars

