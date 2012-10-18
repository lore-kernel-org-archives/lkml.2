Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2JRTyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:54:04 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42823 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754050Ab2JRTyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:54:02 -0400
Message-ID: <50805E5B.8090209@sgi.com>
Date: Thu, 18 Oct 2012 14:54:03 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] procfs: Improve Scaling in proc
References: <1350505538-22733-1-git-send-email-nzimmer@sgi.com> <1350546398.26103.1133.camel@edumazet-glaptop>
In-Reply-To: <1350546398.26103.1133.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 02:46 AM, Eric Dumazet wrote:
> On Wed, 2012-10-17 at 15:25 -0500, Nathan Zimmer wrote:
>> I am currently tracking a hotlock reported by a customer on a large, 512 cores,
>> system, I am currently running 3.7.0 rc1 but the issue looks like it has been
>> this way for a very long time.
>> The offending lock is proc_dir_entry->pde_unload_lock.
>>
>> This patch converts the replaces the lock with the rcu. It is a refresh of what
>> was orignally suggested by Eric Dumazet.  I refreshed it to the 3.7.
>>
>> Supporting numbers, lower is better, they are from the test I posted earlier.
>> cpuinfo baseline        Rcu
>> tasks   read-sec        read-sec
>> 1       0.0141          0.0141
>> 2       0.0140          0.0142
>> 4       0.0140          0.0141
>> 8       0.0145          0.0140
>> 16      0.0553          0.0168
>> 32      0.1688          0.0549
>> 64      0.5017          0.1690
>> 128     1.7005          0.5038
>> 256     5.2513          2.0804
>> 512     8.0529          3.0162
>>
>>
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Alexey Dobriyan <adobriyan@gmail.com>
>> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
>
> Hmm, this patch had several issues and I had no time yet to work on a
> new version. I probably wont have time in a near future.
>
> Paul sent me some comments about it, I hope he doesnt mind I copy them
> here, if you want to polish the patch.
>
> Thanks !

I'll try to polish this up and resend it.
And any comments are most welcome.


> On Wed, 2012-10-03 at 10:56 -0700, Paul E. McKenney wrote:
>> Finally getting back to this...  :-/
>>
>> Why not set the initial value of the reference counter to 1
>> (rather than zero), continue acquiring with atomic_inc(), but
>> use atomic_dec_and_test() to decrement?  Put a completion in
>> the data structure, so if the atomic_dec_and_test() indicates that
>> the counter is now zero, do a complete().
>>
>> Then to free the object, remove it from the data structure, do a
>> synchronize_rcu(), do an atomic_dec_and_test() to remove the initial
>> value, again doing a complete() if the counter is now zero.  The do
>> a wait_for_completion().
>>
>> This would get rid of the polling loop.
>>
>> So, what am I missing here?  ;-)
>>
>> 							Thanx, Paul
>>

