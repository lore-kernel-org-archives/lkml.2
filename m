Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab2AKThn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:37:43 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:44409 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab2AKThm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:37:42 -0500
Message-ID: <4F0DE4B0.4070800@parallels.com>
Date: Wed, 11 Jan 2012 23:36:16 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [RFC] on general object IDs again
References: <20120111161939.GI8752@moon> <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com> <20120111175952.GI466@moon> <CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com> <4F0DD365.6070200@parallels.com> <20120111183115.GA28196@moon> <CAHGf_=oXsrbsXPqBw_CvZQjwdXhzhqkoWX3mRSEgMZHy44ZUKg@mail.gmail.com>
In-Reply-To: <CAHGf_=oXsrbsXPqBw_CvZQjwdXhzhqkoWX3mRSEgMZHy44ZUKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 11:29 PM, KOSAKI Motohiro wrote:
>>>> Then, you only need to compare. not any other calculation. i.e. only
>>>> need id uniqueness.
>>>> And any resource are referenced from tasks. so, can you reuse pid for
>>>> this? example,
>>>> two taska share one mm.
>>>>
>>>> task-a(pid: 100)
>>>>               |-----------------mm
>>>> task-b(pid: 200)
>>>>
>>>>
>>>> gen_obj_id(task-b, GEN_OBJ_ID_VM) return 100. (youngest pid of referenced tasks)
>>>
>>> We can, but determining the youngest pid for an mm struct is O(N) algo.
>>> Having N tasks with N mm_structs getting the sharing picture becomes O(N^2).
>>
>> Yeah, exactly. If not the speed problem we would simply stick
>> with Andrew's proposal as two-id-are-the-same(pid1, pid2)
>> syscall.
> 
> Why O(N^2) is matter? Typical HPC system have mere a few hundred pids.
> so, O(N^2)
> is not slow. How do you mesure Andrew's proposal?
> 
> If you have 1000 pids and each syscall need 10usec,
> 
> 1000 * 1000 * 10 = 10,000,000usec = 10sec. But, important thing is, almost all
> processes don't share fs, mm and other structs. then, if we check
> reference count
> before task traversal, required time may reduce 1/10x - 1/100x.

This might work for mm_structs, although quite a lot apps now do have threads and
this mm->users check will be negative. But how about open files? Once we entered the
get-the-youngest-file-owner routine we need to take locks and with 1000 tasks the
overhead is not 1000 syscalls, but 1000 (syscalls + locks).

> 
>> But when we get a number of pids to dump we need the
>> resource affinity picture over them all.
> .
> 

