Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab2AKURP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:17:15 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52524 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab2AKURL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:17:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [RFC] on general object IDs again
References: <20120111161939.GI8752@moon>
	<CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com>
	<20120111175952.GI466@moon>
	<CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com>
	<4F0DD365.6070200@parallels.com> <20120111183115.GA28196@moon>
	<CAHGf_=oXsrbsXPqBw_CvZQjwdXhzhqkoWX3mRSEgMZHy44ZUKg@mail.gmail.com>
Date: Wed, 11 Jan 2012 12:19:23 -0800
In-Reply-To: <CAHGf_=oXsrbsXPqBw_CvZQjwdXhzhqkoWX3mRSEgMZHy44ZUKg@mail.gmail.com>
	(KOSAKI Motohiro's message of "Wed, 11 Jan 2012 14:29:48 -0500")
Message-ID: <m139bmxa9g.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/1jWZS0ZMHudzrWNdDkg3JE6h7ZBN6ktA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@gmail.com> writes:

>>> > Then, you only need to compare. not any other calculation. i.e. only
>>> > need id uniqueness.
>>> > And any resource are referenced from tasks. so, can you reuse pid for
>>> > this? example,
>>> > two taska share one mm.
>>> >
>>> > task-a(pid: 100)
>>> >               |-----------------mm
>>> > task-b(pid: 200)
>>> >
>>> >
>>> > gen_obj_id(task-b, GEN_OBJ_ID_VM) return 100. (youngest pid of referenced tasks)
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

A couple of things.
1) This is generally useful debug information so if we can we should
   design something that is enabled everywhere.

2) Something like avoiding a O(N^2) check is easy.  Just store the pid
   when we create the structure.

3) Which leads to the very obvious question.  Why don't we just assign
   an arbitrary id to all of the interesting structures?  The code to do
   that is trivial and the implementation is secure in a way that
   hashing pointers never will be.

   I thought for a little bit that struct file might be too light weight
   for that to make sense but on second glance struct file is fat enough
   that I think we could squeeze in another 64 bits without noticeably
   bloating the structure.

At a first case things like the mm struct really aren't interesting.
99+% of the time the sharing is well know and running around discovering
it is just a waste of time.

It is struct file that is really interesting.  Even on the most trivial
unix system struct file is shared between multiple processes and
multiple open file descriptors in the same process.

And it is struct file where there are a lot of them that the performance
difference matters.

....

Hmm.  Come to think of it I don't think an object comparison system call
is half as worthless as it has been made out to be.

The justification for not doing an object comparison system call is that
using an object comparison system call will result in a O(N^2)
algorithm.   For file descriptors we can avoid most of that by comparing
the file the file descriptor points to, and the offset of the file
descriptor.  So we should not need an all to all comparison.

In the second place the only reason why we would need O(N^2) complexity
instead of O(NlogN) is if the comparison system call only compares for
identity instead of returning a result that allows us to order the
objects we are worrying about.

Now the only possible problem with comparing pointers and returning
the objects in memory order is that some evil attacker might be
able to use that to their advantage.   However the in memory order
is generally derivable from the creation order of the objects so
I don't think it is worth worry about at this point.

Furthermore we can preserve the order of objects across a checkpoint by
carefully controlling the order that the objects are created when we
restore the system.

Part of me wants to say: go assign an id to everything that is
interesting, but now that I have thought through the comparison
system call it is an obvious and trivial solution with no practical
impact on the rest of the kernel.

Guys please go back and implement a comparison system call that
orders the objects and does not just compare for identity.

Eric
