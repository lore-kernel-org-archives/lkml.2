Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab2DTP7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:59:33 -0400
Received: from lulu.zabbo.net ([69.168.54.52]:58827 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab2DTP7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:59:32 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2012 11:59:32 EDT
Message-ID: <4F91862F.2030502@zabbo.net>
Date: Fri, 20 Apr 2012 11:52:15 -0400
From: Zach Brown <zab@zabbo.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Dave Kleikamp <dave.kleikamp@oracle.com>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying
 file
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com> <1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com> <4F917751.9040600@parallels.com> <4F917C2F.4020805@oracle.com> <x49mx66whty.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49mx66whty.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 11:20 AM, Jeff Moyer wrote:
> Dave Kleikamp<dave.kleikamp@oracle.com>  writes:
>
>> On 04/20/2012 09:48 AM, Maxim V. Patlasov wrote:
>>> On 03/30/2012 07:43 PM, Dave Kleikamp wrote:
>>>> From: Zach Brown<zab@zabbo.net>
>>>>
>>>> This uses the new kernel aio interface to process loopback IO by
>>>> submitting concurrent direct aio.  Previously loop's IO was serialized
>>>> by synchronous processing in a thread.
>>>>
>>>
>>> The patch ignores REQ_FLUSH bit of bi_rw. Is it simply overlook?
>>
>> Good question. Since the loop device is sending only direct IO requests,
>> it shouldn't be necessary to explicitly flush page cache, but REQ_FLUSH
>
> REQ_FLUSH isn't about the page cache, it's about flushing the volatile
> disk write cache.  You need to handle that.

I guess O_DIRECT doesn't routinely issue flushes simply because it's too
expensive?  Apps that care about consistent IO and O_DIRECT are expected
to not have writeback caching enabled?  'cause there's no way they're
issuing syncs themselves.

So yeah, I'd agree that the loop code should be reworked a bit so that
both the filebacked and aio methods call vfs_sync() when they see
REQ_FLUSH.

Bleh.

- z
(Sorry, no real time to dig into this now. Lots more time in two months!)
