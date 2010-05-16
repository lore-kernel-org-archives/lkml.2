Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0EPQ4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 12:56:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57781 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab0EPQ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 12:56:12 -0400
Message-ID: <4BF02402.8060204@colorfullife.com>
Date: Sun, 16 May 2010 18:57:38 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>
CC: zach.brown@oracle.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in semtimedop
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com> <1271098163-3663-2-git-send-email-chris.mason@oracle.com> <4BC4A6B2.1090906@colorfullife.com> <20100413173941.GI13327@think> <20100413180945.GD5683@laptop> <20100413181937.GM13327@think> <20100413185756.GE5683@laptop>
In-Reply-To: <20100413185756.GE5683@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 08:57 PM, Nick Piggin wrote:
> On Tue, Apr 13, 2010 at 02:19:37PM -0400, Chris Mason wrote:
>    
>> I don't see anything in the docs about the FIFO order.  I could add an
>> extra sort on sequence number pretty easily, but is the starvation case
>> really that bad?
>>      
> Yes, because it's not just a theoretical livelock, it can be basically
> a certainty, given the right pattern of semops.
>
> You could have two mostly-independent groups of processes, each taking
> and releasing a different sem, which are always contended (eg. if it is
> being used for a producer-consumer type situation, or even just mutual
> exclusion with high contention).
>
> Then you could have some overall management process for example which
> tries to take both sems. It will never get it.
>
>    
The management process won't get the sem on Linux either:
Linux implements FIFO, but there is no protection at all against starvation.

If I understand the benchmark numbers correctly, a 4-core, 2 GHz Phenom 
is able to do ~ 2 million semaphore operations per second in one 
semaphore array.
That's the limit - cache line trashing on the sma structure prevent 
higher numbers.

For a NUMA system, the limit is probably lower.

Chris:
Do you have an estimate how many semop() your app will perform in one array?

Perhaps we should really remove the per-array list, sma->sem_perm.lock 
and sma->sem_otime.

--
     Manfred
