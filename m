Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0EaSK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:10:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab0EaSK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:10:56 -0400
Message-ID: <4C03FB8E.1060109@redhat.com>
Date: Mon, 31 May 2010 20:10:22 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: device-mapper development <dm-devel@redhat.com>,
       herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
       agk@redhat.com, ak@linux.intel.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
References: <20100531160425.GA20344@basil.fritz.box> <4C03F04D.4040200@redhat.com> <20100531174225.GE10766@basil.fritz.box>
In-Reply-To: <20100531174225.GE10766@basil.fritz.box>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 07:42 PM, Andi Kleen wrote:
> On Mon, May 31, 2010 at 07:22:21PM +0200, Milan Broz wrote:
>> On 05/31/2010 06:04 PM, Andi Kleen wrote:
>>> DM-CRYPT: Scale to multiple CPUs
>>>
>>> Currently dm-crypt does all encryption work per dmcrypt mapping in a
>>> single workqueue. This does not scale well when multiple CPUs
>>> are submitting IO at a high rate. The single CPU running the single
>>> thread cannot keep up with the encryption and encrypted IO performance
>>> tanks.
>>
>> This is true only if encryption run on the CPU synchronously.
> 
> That's the common case isn't it?

Maybe now, but I think not in the near future.
 
> On asynchronous crypto it won't change anything compared
> to the current state.
> 
>> I did a lot of experiments with similar design and abandoned it.
>> (If we go this way, there should be some parameter limiting
>> used # cpu threads for encryption, I had this configurable
>> through dm messages online + initial kernel module parameter.)
> 
> One thread per CPU is exactly the right number.

Sure, I mean to be able set it from 1..max cpu to now use
all CPUs for crypto, more threads makes no sense.
But this is not real problem here.

>> 1) How this scale together with asynchronous
>> crypto which run in parallel in crypto API layer (and have limited
>> resources)? (AES-NI for example)
> 
> AES-NI is not asynchronous and doesn't have limited resources.

AES-NI used asynchronous crypto interface, was using asynchronous
crypto API cryptd daemon IIRC. So this changed?

>> 2) Per volume threads and mempools were added to solve low memory
>> problems (exhausted mempools), isn't now possible deadlock here again?
> 
> Increasing the number of parallel submitters does not increase deadlocks
> with mempool as long as they don't nest.  They would just
> block each other, but eventually make progress as one finishes. 

I mean if they nest of course, sorry for confusion.

> This only matters when you're low on memory anyways, 
> in the common case with enough memory there is full parallelism.

If it breaks not-so-common case, it is wrong approach:-)
It must not deadlock. We had already similar design before and it
was broken, that's why I am asking.

>> (Like one CPU, many dm-crypt volumes - thread waiting for allocating
>> page from exhausted mempool, blocking another request (another volume)
> 
> As long as they are not dependent that is not a deadlock
> (and they are not) 

Please try truecrupt, select AES-Twofish-Serpent mode and see how it is
nested... This is common case. (not that I like it :-)

>> Anyway, I still think that proper solution to this problem is run
>> parallel requests in cryptoAPI using async crypt interface,
>> IOW paralelize this on cryptoAPI layer which know best which resources
>> it can use for crypto work.
> 
> I discussed this with Herbert before and he suggested that it's better
> done in the submitter for the common case. There is a parallel crypt
> manager now (pcrypt), but it has more overhead than simply doing it directly.

Yes, I meant pcrypt extension.
Asynchronous crypto has big overhead, but that can be optimized eventually, no?
Could you please cc me or dm-devel on these discussions?

So we now run parallel crypt over parallel crypt in some case...
This is not good. And dm-crypt have no way to check if crypto
request will be processed synchronously or asynchronously.
(If it is possible, we can run parallel thread using your patch
for sunchronous requests, and in other case just submit request
to crypto API and let it process asynchronously.)

> It can be still used when it is instantiated, but it's likely
> only a win with very slow CPUs. For the case of reasonably fast
> CPUs all that matters is that it scales.

I know this is problem and parallel processing is needed here,
but it must not cause problems or slow  down that AES-NI case,
most of new cpu will support these extensions...

Milan
