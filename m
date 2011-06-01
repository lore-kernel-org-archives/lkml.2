Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994Ab1FAVPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:15:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201Ab1FAVPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:15:45 -0400
Message-ID: <4DE6ABF5.6020008@redhat.com>
Date: Wed, 01 Jun 2011 18:15:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Hans Petter Selasky <hselasky@c2i.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated
 structure is transferred from userspace to kernelspace. Keep the old ioctl
 around for compatibility so that existing code is not broken.
References: <201105231558.13084.hselasky@c2i.net> <4DDA711E.3030301@linuxtv.org> <201105231651.55945.hselasky@c2i.net> <4DDA7E07.7070907@linuxtv.org>
In-Reply-To: <4DDA7E07.7070907@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 23-05-2011 12:32, Andreas Oberritter escreveu:
> On 05/23/2011 04:51 PM, Hans Petter Selasky wrote:
>> On Monday 23 May 2011 16:37:18 Andreas Oberritter wrote:
>>> On 05/23/2011 03:58 PM, Hans Petter Selasky wrote:
>>>> From be7d0f72ebf4d945cfb2a5c9cc871707f72e1e3c Mon Sep 17 00:00:00 2001
>>>> From: Hans Petter Selasky <hselasky@c2i.net>
>>>> Date: Mon, 23 May 2011 15:56:31 +0200
>>>> Subject: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated
>>>> structure is transferred from userspace to kernelspace. Keep the old
>>>> ioctl around for compatibility so that existing code is not broken.
>>>
>>
>> Hi,
>>
>>> Good catch, but I think _IOWR would be right, because the result gets
>>> copied from kernelspace to userspace.
>>
>> Those flags are only for the IOCTL associated structure itself. The V4L DVB 
>> kernel only reads the dtv_properties structure in either case and does not 
>> write any data back to it. That's why only _IOW is required.
> 
> I see.
> 
>> I checked somewhat and the R/W bits in the IOCTL command does not appear do be 
>> matched to the R/W permissions you have on the file handle? Or am I mistaken?
> 
> You're right. There's no direct relationship between them, at least not
> within dvb-core.
> 
>> In other words the IOCTL R/W (_IOC_READ, _IOC_WRITE) bits should not reflect 
>> what the IOCTL actually does, like modifying indirect data?
> 
> I'm not sure. Your patch is certainly doing the right thing for the
> current implementation of dvb_usercopy, which however wasn't designed
> with variable length arrays in mind.

The dvb_usercopy will do the right thing, if we use _IOR or _IORW.

> Taking dvb_usercopy aside, my interpretation of the ioctl bits was:
> - _IOC_READ is required if copy_to_user/put_user needs to be used during
> the ioctl.
> - _IOC_WRITE is required if copy_from_user/get_user needs to be used
> during the ioctl.

That is my understanding too. I agree that _IOWR seems to be the more appropriate
definition for it.

That's said, this is just a naming convention. Kernel core won't enforce
any special behavior, as there are some violations about this convention
on a few places.

> 
> Whether that's limited to the structure directly encoded in the ioctl or
> not is unclear to me. Maybe someone at LKML can shed some light on that.

I prefer to not apply this patch, as it won't fix anything. Adding an _OLD means
that we'll need later to remove it, causing a regression. Ok, we may do like we did
with V4L _OLD ioctl's that were marked as _OLD at 2.6.5 and were removed on a late
2.6.3x.

Cheers,
Mauro
