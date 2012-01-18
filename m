Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2ARX1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:27:36 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35828 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2ARX1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:27:32 -0500
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
	<20120118224956.GF15652@moon>
Date: Wed, 18 Jan 2012 15:29:50 -0800
In-Reply-To: <20120118224956.GF15652@moon> (Cyrill Gorcunov's message of "Thu,
	19 Jan 2012 02:49:56 +0400")
Message-ID: <m1zkdk4mj5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/X6o4v0Hma6omnwqxT1HIBYe5eP9fQvs8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Wed, Jan 18, 2012 at 02:05:31PM -0800, david@lang.hm wrote:
> ...
>> >>
>> >>Why on Earth would user space need to know which order in memory certain
>> >>kernel objects are?
>> >
>> >For checkpoint restart and for some other kinds of introspection what is
>> >needed is a comparison function to see if two processes share the same
>> >object.  The most interesting of these objects from a checkpoint restart case
>> >are file descriptors, and there can be a lot of file descriptors.
>> >
>> >The order in memory does not matter.  What does matter is that the
>> >comparison function return some ordering between objects.  The algorithm
>> >for figuring out of N items which of them are duplicates is O(N^2) if
>> >the comparison function can only return equal or not equal.  The
>> >algorithm for finding duplications is only O(NlogN) if the comparison
>> >function will return an ordering among the objects.
>> 
>> so what you really want is a syscall that can take a list of objects
>> instead of having to do a syscall per object. right?
>> 
>
> It doesn't matter. Even if we take a list of objects the kernel either
> should return us some ordering info or find duplicates, in any case it
> makes things more complex i think. So we wanted to bring some minimum
> into kernel leaving the rest of work to user-space.

Agreed a syscall does the duplication is probably not the way to go.

 A syscall that takes a huge list of objects would solve any security
concerns that we have with returning the object order to user space if
done carefully, but it would require a bunch of additional user space
and kernel memory.

Sometimes taking a data structure transforming it into a weird form for
a specific task and then transforming the data structure back to it's
original form is a useful way to go.  So I think a general kernel object
deduplicating system call is an interesting plan B, but a straight
comparison function if we can make it work is a lot more flexible and
useful.

Eric
