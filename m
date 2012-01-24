Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab2AXWvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:51:49 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47028 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2AXWvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:51:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
References: <20120124064719.GA29735@moon> <4F1E57F3.6020607@zytor.com>
	<20120124071716.GC29735@moon>
	<20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124073842.GE29735@moon>
	<20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124084823.GF29735@moon>
	<CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
	<20120124202606.GC2546@moon> <m18vkwj0dw.fsf@fess.ebiederm.org>
	<20120124205039.GB2278@moon>
	<20120124132222.d78bc0d4.akpm@linux-foundation.org>
Date: Tue, 24 Jan 2012 14:54:18 -0800
In-Reply-To: <20120124132222.d78bc0d4.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 24 Jan 2012 13:22:22 -0800")
Message-ID: <m1ty3kg19h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+3G7mC8Ns3vGgE7mWfVv5nOPww40ts4Pk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:


> <reads the code>
>
> Seems that it performs lookups only in the caller's PID namespace. 
> Maybe this is appropriate but it should be described and justified in
> the changelog and in code comments, please.  And in the forthcoming
> manpage ;)

Well pids should always and only be looked up in the callers pid
namespace.  Any other behavior is broken.  It is probably worth
a mention in a manpage but you should not need to justify using
abstractions as they were designed to be used.


>> +static int kcmp_ptr(long v1, long v2, int type)
>> +{
>> +	long ret;
>> +
>> +	ret = kptr_obfuscate(v1, type) - kptr_obfuscate(v2, type);
>> +
>> +	return (ret < 0) | ((ret > 0) << 1);
>> +}
>> +
>> +#define KCMP_TASK_PTR(task1, task2, member, type)	\
>> +	kcmp_ptr((long)(task1)->member,			\
>> +		 (long)(task2)->member,			\
>> +		 type)
>> +
>> +#define KCMP_PTR(ptr1, ptr2, type)			\
>> +	kcmp_ptr((long)ptr1, (long)ptr2, type)
>
> ugh.  This:
>
> static long kptr_obfuscate(void *p, enum you_forgot_to_name_the_enum type)
> {
> 	return ((long)p ^ cookies[type][0]) * cookies[type][1];
> }
>
> static int kcmp_task_pointers(void *task1, void *task2, size_t field_offset,
> 				enum you_forgot_to_name_the_enum type)
> {
> 	void **field1 = t1 + field_offset;	/* points to a pointer in the task_struct */
> 	void **field2 = t1 + field_offset;
> 	long diff;
>
> 	diff = kptr_obfuscate(*field1, type) - kptr_obfuscate(*field2, type);
> 	return (diff < 0) | ((diff > 0) << 1);
> }
>
> 	...
> 	ret = kcmp_task_pointers(task1, task2, offsetof(task_struct, mm),
> 				KCMP_VM);
> 	...
>
> see?  No nasty macros, it's type-correct and it uses only a single
> explicit typecast.

Seriously?  Simply open coding the comparison would be better. 

        ret = kcmp_ptr(task1->files, task2->files, type);

All pointers are not encoded the same as void * pointers.  Admittedly
the only case I can think of are function pointers on Itanium, but
what is a little wrong today can easily become a lot wrong tomorrow.

Making the kcmp_ptr arguments void * seems the way to go though.

Now there is one interesting case we are not handling properly.
If any of our pointers can be NULL which I think happens in the
file case we should return -EBADF instead of reporting two NULL
pointers point to the same object.

Eric
