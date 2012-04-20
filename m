Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab2DTP5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:57:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33489 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab2DTP5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:57:19 -0400
Message-ID: <4F918758.8020001@oracle.com>
Date: Fri, 20 Apr 2012 10:57:12 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120406 Thunderbird/11.0.1
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: Jeff Moyer <jmoyer@redhat.com>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying
 file
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com> <1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com> <4F917751.9040600@parallels.com> <4F917C2F.4020805@oracle.com> <x49mx66whty.fsf@segfault.boston.devel.redhat.com> <4F91862F.2030502@zabbo.net>
In-Reply-To: <4F91862F.2030502@zabbo.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F91875B.005F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 10:52 AM, Zach Brown wrote:
> On 04/20/2012 11:20 AM, Jeff Moyer wrote:
>> Dave Kleikamp<dave.kleikamp@oracle.com>  writes:
>>
>>> On 04/20/2012 09:48 AM, Maxim V. Patlasov wrote:
>>>> On 03/30/2012 07:43 PM, Dave Kleikamp wrote:
>>>>> From: Zach Brown<zab@zabbo.net>
>>>>>
>>>>> This uses the new kernel aio interface to process loopback IO by
>>>>> submitting concurrent direct aio.  Previously loop's IO was serialized
>>>>> by synchronous processing in a thread.
>>>>>
>>>>
>>>> The patch ignores REQ_FLUSH bit of bi_rw. Is it simply overlook?
>>>
>>> Good question. Since the loop device is sending only direct IO requests,
>>> it shouldn't be necessary to explicitly flush page cache, but REQ_FLUSH
>>
>> REQ_FLUSH isn't about the page cache, it's about flushing the volatile
>> disk write cache.  You need to handle that.
> 
> I guess O_DIRECT doesn't routinely issue flushes simply because it's too
> expensive?  Apps that care about consistent IO and O_DIRECT are expected
> to not have writeback caching enabled?  'cause there's no way they're
> issuing syncs themselves.

If we weren't using aio, we might be okay, but we don't know that any
prior asynchronous request has completed.
> 
> So yeah, I'd agree that the loop code should be reworked a bit so that
> both the filebacked and aio methods call vfs_sync() when they see
> REQ_FLUSH.

It's an easy fix. I don't anticipate that it will hurt performance too
badly.

> 
> Bleh.
> 
> - z
> (Sorry, no real time to dig into this now. Lots more time in two months!)
