Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1AIDNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 22:13:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40697 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1AIDNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 22:13:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wmW0SBUWlFzfPdBRDEYmj9IFFkBFx16eJZkFfAFuydTy7HdYxdCDkonKvqN+LwZxri
         PvXFlq87+ecx3RjIXovlJQgPugC5HRZOM9QJ3LrySorIJ0ARMtSNnNI4S4PxxZmPbcMn
         1CPXTYTwcvlwq+BBUgf1t8kAJo8narqmhBWIc=
MIME-Version: 1.0
In-Reply-To: <20110108140136.GA13269@mtj.dyndns.org>
References: <AANLkTim75ihzBKXx1e9NbPnECMrKUidOLWjVuBWHwiEP@mail.gmail.com>
	<20110108140136.GA13269@mtj.dyndns.org>
Date: Sun, 9 Jan 2011 11:13:44 +0800
Message-ID: <AANLkTikhN3aEm_c-8LshqkyysKEoEHY60sy2+u++-1zw@mail.gmail.com>
Subject: Re: [PATCH] replace ida in workqueue with page-sized buffer
From: Hillf Danton <dhillf@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 8, 2011 at 10:01 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Sat, Dec 18, 2010 at 09:10:18PM +0800, Hillf Danton wrote:
>> The id of worker of global work queue is monitored with kernel library, ida.
>>
>> The ida in global work queue is redefined to be page-sized buffer,
>> which is allocated when initializing workqueue.
>>
>> The new id allocator could monitor ids in the rage from 0 to INT_MAX.
>> The buffer is used to store freed ids, and if the peak number of ids,
>> in workqueue as whole, is not out of the capacity of the allocated
>> buffer, there is no more allocation of buffer after initializing.
>>
>> The advantage looks that the new allocator runs faster.
>
> I'm confused about why this is necessary.  It's not like workqueue ID
> alloc/dealloc is hot path to begin with (they're quite lazy) and
> during worker creation / destruction ida is a quite insignificant

Great point. Since quite lazy, the patch is quite inapplicable.

> part, so what is it trying to optimize?  It's not like ida allocator
> is slow to begin with.
>
> Also, the allocator looks quite dubious.
>
> * What happens if more entries than what can fit in a page are freed?
>  It'll just lose track of it.
>

Losing track of allocated ids could happen only if allocation is not
quite lazy, and it could be fixed by extending the page buffer, though
not included in the delivered patch.

> * ida guarantees that always the lowest available slot is allocated.
>  The new allocator doesn't.
>

Since the allocated ids are then hashed, the lowest available looks
unnecessary in workqueue, which simplifies allocation.

Thanks a lot for reviewing the patch.
Hillf
