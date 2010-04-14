Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab0DNTLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 15:11:42 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:53527 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0DNTLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 15:11:40 -0400
Message-ID: <4BC61370.7020700@colorfullife.com>
Date: Wed, 14 Apr 2010 21:11:44 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       zach.brown@oracle.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in semtimedop
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com> <1271098163-3663-2-git-send-email-chris.mason@oracle.com> <4BC4A6B2.1090906@colorfullife.com> <20100413173941.GI13327@think> <20100413180945.GD5683@laptop> <20100413181937.GM13327@think> <4BC5EA75.9090803@colorfullife.com> <20100414173319.GA3228@think>
In-Reply-To: <20100414173319.GA3228@think>
Content-Type: multipart/mixed;
 boundary="------------080508040006050705080103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080508040006050705080103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/14/2010 07:33 PM, Chris Mason wrote:
> On Wed, Apr 14, 2010 at 06:16:53PM +0200, Manfred Spraul wrote:
>    
>> On 04/13/2010 08:19 PM, Chris Mason wrote:
>>      
>>> On Wed, Apr 14, 2010 at 04:09:45AM +1000, Nick Piggin wrote:
>>>        
>>>> On Tue, Apr 13, 2010 at 01:39:41PM -0400, Chris Mason wrote:
>>>> The other thing I don't know if your patch gets right is requeueing on
>>>> of the operations. When you requeue from one list to another, then you
>>>> seem to lose ordering with other pending operations, so that would
>>>> seem to break the API as well (can't remember if the API strictly
>>>> mandates FIFO, but anyway it can open up starvation cases).
>>>>          
>>> I don't see anything in the docs about the FIFO order.  I could add an
>>> extra sort on sequence number pretty easily, but is the starvation case
>>> really that bad?
>>>
>>>        
>> How do you want to determine the sequence number?
>> Is atomic_inc_return() on a per-semaphore array counter sufficiently fast?
>>      
> I haven't tried yet, but hopefully it won't be a problem.  A later patch
> does atomics on the reference count and it doesn't show up in the
> profiles.
>
>    
>>      
>>>> I was looking at doing a sequence number to be able to sort these, but
>>>> it ended up getting over complex (and SAP was only using simple ops so
>>>> it didn't seem to need much better).
>>>>
>>>> We want to be careful not to change semantics at all. And it gets
>>>> tricky quickly :( What about Zach's simpler wakeup API?
>>>>          
>>> Yeah, that's why my patches include code to handle userland sending
>>> duplicate semids.  Zach's simpler API is cooking too, but if I can get
>>> this done without insane complexity it helps with more than just the
>>> post/wait oracle workload.
>>>
>>>        
>> What is the oracle workload, which multi-sembuf operations does it use?
>> How many semaphores are in one array?
>>
>> When the last optimizations were written, I've searched a bit:
>> - postgres uses per-process semaphores, with small semaphore arrays.
>>      [process sleeps on it's own semaphore and is woken up by someone
>> else when it can make progress]
>>      
> This is similar to Oracle (and the sembench program).  Each process has
> a semaphore and when it is waiting for a commit it goes to sleep on it.
> They are woken up in bulk with semtimedop calls from a single process.
>
>    
Hmm. Thus you have:
- single sembuf decrease operations that are waiting frequently.
- multi-sembuf  increase operations.

What about optimizing for that case?
Increase operations succeed immediately. Thus complex_count is 0.

If we have performed an update operation, then we can scan all 
simple_lists that have seen an increase instead of checking the global 
list - as long as there are no complex operations waiting.
Right now, we give up if the update operation was a complex operation - 
but that does not matter.
All that matters are the sleeping operations, not the operation that did 
the wakeup.
I've attached an untested idea.

> But oracle also uses semaphores for locking in a traditional sense.
>
> Putting the waiters into a per-semaphore list is really only part of the
> speedup.  The real boost comes from the patch to break up the locks into
> a per semaphore lock.
>
>    
Ok. Then simple tricks won't help.
How many semaphores are in one array?

--
     Manfred

--------------080508040006050705080103
Content-Type: text/plain;
 name="patch-ipc-optimize_bulkwakeup"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch-ipc-optimize_bulkwakeup"

diff --git a/ipc/sem.c b/ipc/sem.c
index dbef95b..8986239 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1224,8 +1224,18 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
-		if (alter && error == 0)
-			update_queue(sma, (nsops == 1) ? sops[0].sem_num : -1);
+		if (alter && error == 0) {
+			if (sma->complex_count) {
+				update_queue(sma, -1);
+			} else {
+				int i;
+				
+				for (i=0;i<nsops;i++) {
+					if (sops[i].sem_op > 0)
+						update_queue(sma, sops[i].sem_num);
+				}
+			}
+		}
 
 		goto out_unlock_free;
 	}

--------------080508040006050705080103--
