Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1JSADm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:03:42 -0400
Received: from mail.lang.hm ([64.81.33.126]:48490 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1JSADl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:03:41 -0400
Date: Tue, 18 Oct 2011 17:03:27 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Rientjes <rientjes@google.com>
cc: Jan Kara <jack@suse.cz>, Mark Mielke <mark@mark.mielke.cc>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Appropriate use of sync() from user space?
In-Reply-To: <alpine.DEB.2.00.1110181652400.8149@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1110181656360.28233@asgard.lang.hm>
References: <4E8CEECF.4050008@mark.mielke.cc> <20111018211446.GF4599@quack.suse.cz> <alpine.DEB.2.00.1110181652400.8149@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, David Rientjes wrote:

> On Tue, 18 Oct 2011, Jan Kara wrote:
>
>>> Quick summary: We have a vendor who is claiming that it is required
>>> for their userspace program to execute sync(), and I am looking for
>>> some sort of authoritative document or person to refer them to that
>>> will state that this belief is incorrect and/or that this
>>> architecture is not acceptable in a Unix environment.
>>>
>>> I checked Google and the archives and didn't find anything
>>> appropriate. Unfortunately, the word "sync" is very popular. :-)
>>>
>>> We have users who have been experiencing 3 to 5 minutes "freezes"
>>> for a particular command which often times out and fails. I traced
>>> this down from the commercial userspace program (IBM Rational
>>> ClearCase / "cleartool mkview") that they are executing to a backend
>>> "view_server" process (also IBM Rational ClearCase) that is running
>>> sync() as a means of synchronizing their database to disk before
>>> proceeding, and VMware using a "large" memory mapped file to back
>>> it's virtual "RAM". The sync() for my computer normally completes in
>>> 7 to 8 seconds. The sync() for some of our users is taking 5 minutes
>>> or longer. This can be demonstrated simply by typing "time sync"
>>> from the command line at intervals. The time itself is relevant
>>> because if it finishes before a timeout elapses - the operation
>>> works (albeit slowly). If the timeout elapses, the operation fails.
>>>
>>> The vendor stated that sync() is integral to their synchronization
>>> process to ensure all files reach disk before they are accessed, and
>>> that this is not a defect in their product. We have a work around -
>>> run "sync" before calling their command, and this generally avoids
>>> the failures.
>>>
>>> I think the use of sync() in this regard is a hack. According to
>>> POSIX.1 and the Linux man pages, it seems clear to me that sync()
>>> does not guarantee data integrity (bytes guaranteed to have reached
>>> disk) - and it also seems clear that forcing all system data to
>>> flush out in response to a minor command is over kill. Like cutting
>>> down the forest to harvest fruit from a single tree.
>>   Actually the manpage is wrong. Linux waits for all data to be safely on
>> disk before sync returns. So calling sync is a correct way (although
>> inefficient at times) to achieve data integrity. What kernel version are
>> you using? Different kernel versions are differently efficient when doing
>> sync(2) and quite some effort went to make sync less prone to livelocks in
>> recent kernels...
>>
>
> Let's make sure to keep Michael Kerrisk cc'd if anything needs to be
> clarified in the manpages.

also, you may want to check if they are really doing a 'sync' (syncing the 
entire filesystem) or just a 'fsync' (syncing the file). Depending on the 
technical depth of the people you are talking to, they may say sync when 
what is actually happening is a fsync.

there is little dispute that fsync is correct, but not a complete answer 
to the issue. take a look at the LWN article on the subject at 
http://lwn.net/Articles/457667

Ext3 has a pathalogical condition where a sync to one file can force a 
complete journal flush, which isn't as bad as a sync of the entire 
filesystem, but can still take a long time if there is other ongoing write 
activity on the system (I knwo I've read about fsyncs taking longer than 
30 seconds, and I think I've heard of them taking minutes). As far as I 
know, Ext3 is the only filesystem to suffer this problem, but 
unfortunantly it's the default filesystem on most linux distros.

David Lang
