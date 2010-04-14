Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab0DNQQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:16:51 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:46562 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab0DNQQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:16:50 -0400
Message-ID: <4BC5EA75.9090803@colorfullife.com>
Date: Wed, 14 Apr 2010 18:16:53 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       zach.brown@oracle.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in semtimedop
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com> <1271098163-3663-2-git-send-email-chris.mason@oracle.com> <4BC4A6B2.1090906@colorfullife.com> <20100413173941.GI13327@think> <20100413180945.GD5683@laptop> <20100413181937.GM13327@think>
In-Reply-To: <20100413181937.GM13327@think>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 08:19 PM, Chris Mason wrote:
> On Wed, Apr 14, 2010 at 04:09:45AM +1000, Nick Piggin wrote:
>    
>> On Tue, Apr 13, 2010 at 01:39:41PM -0400, Chris Mason wrote:
>>      
>> The other thing I don't know if your patch gets right is requeueing on
>> of the operations. When you requeue from one list to another, then you
>> seem to lose ordering with other pending operations, so that would
>> seem to break the API as well (can't remember if the API strictly
>> mandates FIFO, but anyway it can open up starvation cases).
>>      
> I don't see anything in the docs about the FIFO order.  I could add an
> extra sort on sequence number pretty easily, but is the starvation case
> really that bad?
>
>    
How do you want to determine the sequence number?
Is atomic_inc_return() on a per-semaphore array counter sufficiently fast?

>> I was looking at doing a sequence number to be able to sort these, but
>> it ended up getting over complex (and SAP was only using simple ops so
>> it didn't seem to need much better).
>>
>> We want to be careful not to change semantics at all. And it gets
>> tricky quickly :( What about Zach's simpler wakeup API?
>>      
> Yeah, that's why my patches include code to handle userland sending
> duplicate semids.  Zach's simpler API is cooking too, but if I can get
> this done without insane complexity it helps with more than just the
> post/wait oracle workload.
>
>    
What is the oracle workload, which multi-sembuf operations does it use?
How many semaphores are in one array?

When the last optimizations were written, I've searched a bit:
- postgres uses per-process semaphores, with small semaphore arrays.
     [process sleeps on it's own semaphore and is woken up by someone 
else when it can make progress]
- with google, I couldn't find anything relevant that uses multi-sembuf 
semop() calls.

And I agree with Nick: We should be careful about changing the API.

--
     Manfred
