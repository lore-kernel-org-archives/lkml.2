Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab2DTQfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:35:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab2DTQfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:35:15 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Zach Brown <zab@zabbo.net>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying file
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
	<1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com>
	<4F917751.9040600@parallels.com> <4F917C2F.4020805@oracle.com>
	<x49mx66whty.fsf@segfault.boston.devel.redhat.com>
	<4F91862F.2030502@zabbo.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 20 Apr 2012 12:35:08 -0400
In-Reply-To: <4F91862F.2030502@zabbo.net> (Zach Brown's message of "Fri, 20
	Apr 2012 11:52:15 -0400")
Message-ID: <x49aa26wedf.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown <zab@zabbo.net> writes:

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
> expensive?  

Bypassing the page cache is different from bypassing the underlying
device's cache.  O_DIRECT does not mean "straight to platter".

> Apps that care about consistent IO and O_DIRECT are expected to not
> have writeback caching enabled?  'cause there's no way they're issuing
> syncs themselves.

They most certainly should be!  The app should be written with the
assumption that there is a write-back cache on the storage.  Turning
those flushes into noops is an optimization the OS performs.  See this
lwn article: http://lwn.net/Articles/457667/.

Cheers,
Jeff
