Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab1KRJZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:25:12 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:34127 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab1KRJZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:25:06 -0500
Message-ID: <4EC6246A.6020807@parallels.com>
Date: Fri, 18 Nov 2011 13:24:58 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
References: <4EC4DA15.7090106@parallels.com> <20111117124831.688adbeb.akpm@linux-foundation.org>
In-Reply-To: <20111117124831.688adbeb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> One of the ways for checking whether two tasks share e.g. an mm_struct is to
>> provide some mm_struct ID of a task to its proc file. The best from the
>> performance point of view ID is the object address in the kernel, but showing
>> them to the userspace is not good for security reasons.
>>
>> Thus the object address is XOR-ed with a "random" value of the same size and 
>> then shown in proc. Providing this poison is not leaked into the userspace then
>> ID seem to be safe. The objects for which the IDs are shown are:
>>
>> * all namespaces living in /proc/pid/ns/
>> * open files (shown in /proc/pid/fdinfo/)
>> * objects, that can be shared with CLONE_XXX flags (except for namespaces)
>> 
>> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> 
> It doesn't *sound* terribly secure.  There might be clever ways in
> which userspace can determine the secret mask, dunno.  We should ask
> evil-minded security people to review this proposal.

Can you please propose some particular persons we should put in Cc for this thread?

> Why not simply use a sequence number, increment it each time we create
> an mm_struct?  On could use an idr tree to prevent duplicates but it
> would be simpler and sufficient to make it 64-bit and we never have to
> worry about wraparound causing duplicates.

IDR is not OK for me, since we'll have to call it on every fork() thus penalizing
its performance. 64bit increasing numbers are perfectly fine with me (I did this
in the 1st proposal, but put the ID on slub to save space - 64bits per page, not per
object).

But I have one question regarding storing these long IDs per-object. Are we OK with
adding 64-bit field on *all* the structures we need for this? I'm mostly worried 
about these small ones like sem_undo_list and fs_struct.

Thanks,
Pavel
