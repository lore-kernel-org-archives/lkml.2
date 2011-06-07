Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1FGDN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 23:13:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:1429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1FGDN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 23:13:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,330,1304319600"; 
   d="scan'208";a="14700692"
Message-ID: <4DED976C.90009@linux.intel.com>
Date: Mon, 06 Jun 2011 20:13:48 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	 <1307373819.3098.40.camel@edumazet-laptop>	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>	 <1307377349.3098.65.camel@edumazet-laptop>	 <1307377782.2322.183.camel@twins>	 <1307378564.3098.67.camel@edumazet-laptop>	 <4DED1421.5000300@linux.intel.com> <1307383898.3098.90.camel@edumazet-laptop>
In-Reply-To: <1307383898.3098.90.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/06/2011 11:11 AM, Eric Dumazet wrote:
> Le lundi 06 juin 2011 à 10:53 -0700, Darren Hart a écrit :
>>
> 
>> If I understand the problem correctly, RO private mapping really doesn't
>> make any sense and we should probably explicitly not support it, while
>> special casing the RO shared mapping in support of David's scenario.
>>
> 
> We supported them in 2.6.18 kernels, apparently. This might sounds
> stupid but who knows ?


I guess this is actually the key point we need to agree on to provide a
solution. This particular case "worked" in 2.6.18 kernels, but that
doesn't necessarily mean it was supported, or even intentional.

It sounds to me that we agree that we should support RO shared mappings.
The question remains about whether we should introduce deliberate
support of RO private mappings, and if so, if the forced COW approach is
appropriate or not.

Does anyone with a longer history working with futexes than I have an
opinion on this? Is support for RO private mappings part of our futex
API, or was it an unintentional side effect of the futex simply being a
userspace address.

--
Darren


> 
>>>
>>> In David Oliver case, this is needed : He wants to catch a change in a
>>> file/memory region written by another process.
>>
>> But with shared mapping and shared futexes. He just needs the ability to
>> FUTEX_WAIT on a RO mapping. Or is that what you were saying?
>>
> 
> I am saying that in David Oliver case, he sure uses a MAP_SHARED ro
> mapping.
> 
> Now, what if other software uses a MAP_PRIVATE ro mapping ?
> 
> It was working in previous kernels as well.
> 
> We can say its stupid, but IMHO its not.
> 
> In other words, this program should work, if process never touches
> (writes) into first page.
> 
> This program on previous kernels gave :
> rc=-1 errno=11
> (allowing to wait for a value change and a futex_WAKE)
> 
> With new kernel :
> rc=-1 errno=14  [ no sleep allowed ]
> 
> #include <errno.h>
> #include <fcntl.h>
> #include <stdint.h>
> typedef uint32_t u32;   // for futex.h
> #include <linux/futex.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <unistd.h>
> 
> 
> int main() {
>  	int fd, *futex, rc;
> 
> 	fd = open("/tmp/futex_test", O_RDWR|O_CREAT, 0644);
> 	write(fd, "\1\1\1\1", 4);
> 	futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_PRIVATE, fd, 0);
> 	rc = syscall(SYS_futex, futex, FUTEX_WAIT, 42, 0, 0, 0);
> 	printf("rc=%d errno=%d\n", rc, errno);
> }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
