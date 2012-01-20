Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2ATDNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 22:13:40 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42964 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab2ATDNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 22:13:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: david@lang.hm, "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
References: <20120117142759.GE16213@moon>
	<CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>
	<20120117144452.GG16213@moon> <4F15C249.3000602@zytor.com>
	<m1obu29fnf.fsf@fess.ebiederm.org>
	<alpine.DEB.2.02.1201181404480.6780@asgard.lang.hm>
	<20120118224956.GF15652@moon> <m1zkdk4mj5.fsf@fess.ebiederm.org>
	<20120119065541.GA31379@moon>
Date: Thu, 19 Jan 2012 19:16:02 -0800
In-Reply-To: <20120119065541.GA31379@moon> (Cyrill Gorcunov's message of "Thu,
	19 Jan 2012 10:55:41 +0400")
Message-ID: <m1ty3rukr1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/1GgsilbRs55vKfggoaTRDdMWNIrhbLdY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Wed, Jan 18, 2012 at 03:29:50PM -0800, Eric W. Biederman wrote:
>> >
>> > It doesn't matter. Even if we take a list of objects the kernel either
>> > should return us some ordering info or find duplicates, in any case it
>> > makes things more complex i think. So we wanted to bring some minimum
>> > into kernel leaving the rest of work to user-space.
>> 
>> Agreed a syscall does the duplication is probably not the way to go.
>> 
>>  A syscall that takes a huge list of objects would solve any security
>> concerns that we have with returning the object order to user space if
>> done carefully, but it would require a bunch of additional user space
>> and kernel memory.
>> 
>
> yes, an it increase syscall time itself since we will have to provide
> this memory dynamically

I just did a back of the napkin calculation.
struct kobj_id {
	pid_t pid;
        size_t descriptor;
	size_t first_idx;
        void *kernel_ignore_this_pointer;
};

int find_kobject_dups(int type, struct kobj_id __user *ids, size_t count);

Looks pretty reasonable on a 64bit machine for 100,000 file
descriptors.

3 Meg of input data.
4 Meg of an internal rbtree that remembers the first entry where
we saw an item.
struct {
       struct rb_node node;
       void *key;
       size_t idx;
};

And the code is very straight forward.  Insert each pointer to a kernel
object we find into an rbtree, and return the index we find.  Then
finally tear down the rbtree.

8Meg worst case does not seem like a lot of memory to me.  Especially
since half of it is userspace memory.

A simple implementation plus a guarantee that we will never ever
leak information that we don't intend to seem very attractive to me.

>> Sometimes taking a data structure transforming it into a weird form for
>> a specific task and then transforming the data structure back to it's
>> original form is a useful way to go.  So I think a general kernel object
>> deduplicating system call is an interesting plan B, but a straight
>> comparison function if we can make it work is a lot more flexible and
>> useful.
>> 
>
> I hope the root-only restriction would resolve the potential security
> problem, since as I mentioned if I've hijacked the machine and already
> goot root -- mem order is not that interesting info I could obtain from
> such computer :)

We either need a full comparison operator or we don't.  Root-only is a
solution just looking to get abused.

Eric
