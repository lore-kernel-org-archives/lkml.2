Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1GRPEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:04:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59139 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1GRPEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:04:54 -0400
References: <4E1B978C.2030407@psychogeeks.com> <20110712080309.d538fec9.rdunlap@xenotime.net> <7B814F02-408C-434F-B813-8630B60914DA@wilsonet.com> <4E1CCC26.4060506@psychogeeks.com> <1B380AD0-FE0D-47DF-B2C3-605253C9C783@wilsonet.com> <4E1D3045.7050507@psychogeeks.com> <2E869B1F-D476-4645-BE26-B1DD77DF1735@wilsonet.com> <4E1E574E.9010403@psychogeeks.com> <1310863402.7895.6.camel@palomino.walls.org> <4E223D00.1040505@psychogeeks.com> <1310909766.2276.10.camel@palomino.walls.org>
In-Reply-To: <1310909766.2276.10.camel@palomino.walls.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <A91CBD95-B2AF-4F43-8BEC-6C8007ABB33C@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Chris W <lkml@psychogeeks.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Imon module Oops and kernel hang
Date: Mon, 18 Jul 2011 11:04:36 -0400
To: Andy Walls <awalls@md.metrocast.net>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 17, 2011, at 9:36 AM, Andy Walls wrote:

> On Sun, 2011-07-17 at 11:38 +1000, Chris W wrote:
>> On 17/07/11 10:43, Andy Walls wrote:
>>> This is an obviously repeatable NULL pointer dereference in
>>> rc_g_keycode_from_table().  The faulting line of code in both cases
>>> disasembles to:
>>> 
>>>  1e:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
>>> 
>>> %eax obviously holds the value 0 (NULL).  But I'm having a hard time
>>> telling to where exactly that line of assembly corresponds in
>>> rc_g_keycode_from_table().  And I can't tell from the source which data
>>> structure has something at offset 0xdc that gets derefernced early:
>>> struct rc_dev or struct rc_map.
>>> 
>>> Could you provide the output of 
>>> 
>>> $ locate rc-core.ko
>>> $ objdump -d -l /blah/blah/drivers/media/rc/rc-core.ko 
>>> 
>>> for the rc_g_keycode_from_table() function?
>> 
>> 
>> I have a few copies lying about now.
> 
>> This is from my current running kernel
>> /lib/modules/2.6.38-gentoo-r6/kernel/drivers/media/rc/rc-core.ko
>> 
>> and the partial objdump and corresponding oops/crash output:
> 
> Thanks.
> 
> 
>> 00000450 <rc_g_keycode_from_table>:
>> rc_g_keycode_from_table():
>>     450:	55                   	push   %ebp
>>     451:	89 e5                	mov    %esp,%ebp
>>     453:	57                   	push   %edi
>>     454:	56                   	push   %esi
>>     455:	53                   	push   %ebx
>>     456:	83 ec 24             	sub    $0x24,%esp
> 
> Store the (struct rc_dev *) "dev" input argument on the stack
>>     459:	89 45 e8             	mov    %eax,-0x18(%ebp)
> 
> local_irq_save(flags):
>>     45c:	9c                   	pushf
>>     45d:	8f 45 ec             	popl   -0x14(%ebp)
>>     460:	fa                   	cli
> 
> preempt_disable():
>>     461:	89 e0                	mov    %esp,%eax
>>     463:	25 00 e0 ff ff       	and    $0xffffe000,%eax
>>     468:	ff 40 14             	incl   0x14(%eax)
> 
> Move (struct rc_dev *) dev into %eax
>>     46b:	8b 45 e8             	mov    -0x18(%ebp),%eax
> 
> &dev->rc_map->lock 
>>     46e:	8b 80 d4 00 00 00    	mov    0xd4(%eax),%eax
> 
> But that's where the Oops always happens, so the "dev" input argument to
> the function is NULL.
> 
> Someone familiar with the driver/media/rc/imon.c file needs to figure
> out how rc_g_keycode_from_table() can be called with a NULL first
> argument: ictx->rdev is NULL when
> rc_g_keycode_from_table(ictx->rdev,...) is called.
> 
> There might be some race at driver initialization, given that at first
> look ictx-rdev being NULL seems impossible.  Your stack backtraces
> always indicate some sort of IRQ context, so maybe that matters.

Thanks much for the analysis, Andy. I see the problem now. The intf0 urb
callback is wired up before the rc_dev is, and the callback is what makes
the rc_g_keycode_from_table call. And as far as I know, all 0xffdc devices
have the nasty trait of constantly triggering interrupts, even when there's
no valid keydata. (SoundGraph fixed that in later devices). The code has
been like this for some time, and I do have 0xffdc devices, none of which
have hit this somehow, but the fix looks simple and obvious enough. I'll
try to get something sent along later today.

-- 
Jarod Wilson
jarod@wilsonet.com



