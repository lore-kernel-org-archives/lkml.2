Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0EYOTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587Ab0EYOTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:19:19 -0400
Date: Tue, 25 May 2010 16:17:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, Roland McGrath <roland@redhat.com>
Cc: wezhang@redhat.com, linux-kernel@vger.kernel.org
Subject: Q: sys_personality() && misc oddities
Message-ID: <20100525141720.GA2253@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This code is really old, and I do not know whom should I ask. And,
despite the fact it is really trivial, I have no idea how to fix it.
And even more, I am not sure it actually needs fixes. I'd better ask
the questions. Please help ;)



First of all, task_struct->personality is "int", but sys_personality()
takes "long". This means that every comparison or assignment inside of
sys_personality() paths is not right.

Probably we need something like this trivial patch

	--- x/kernel/exec_domain.c
	+++ x/kernel/exec_domain.c
	@@ -192,7 +192,9 @@ SYSCALL_DEFINE1(personality, u_long, per
	 {
		u_long old = current->personality;
	
	-	if (personality != 0xffffffff) {
	+	if (personality > 0xffffffff)
	+		return -EINVAL;
	+	else if (personality != 0xffffffff) {
			set_personality(personality);
			if (current->personality != personality)
				return -EINVAL;

?

Or, perhaps we shouldn't allow personality >= int32_max = 0x7ffffff ?
Otherwise, on 32bit machine the value returned to the user-space can
look like -ESOMETHING.

Even on x86_64, in user-space it is declared as

	int personality(unsigned long persona);

if the kernel returns the "large" old it looks negative to the user-space,
and the test-case thinks that the syscall failed but errno is not set.

This is the actual reason for the question. I am really surprized I
do not know how to close the redhat-internal bugzilla entry, the
problem is very trivial.

------------------------------------------------------------------------------

But there are other oddities I can't understand. Let's forget about
the sizeof(task_struct->personality), let's suppose it is "long" too.
And note that is was long before 97dc32cdb1b53832801159d5f634b41aad9d0a23
which did s/long/int/ to reduce the sizeof task_struct.

__set_personality(). What is the point to check
ep == current_thread_info()->exec_domain ? This buys nothing afaics.
IOW, it could be simplified:

	int __set_personality(u_long personality)
	{
		struct exec_domain *oep = current_thread_info()->exec_domain;

		current_thread_info()->exec_domain = lookup_exec_domain(personality);
		current->personality = personality;
		module_put(oep->module);

		return 0;
	}

Now let's look at the caller, sys_personality()

	set_personality(personality);
	if (current->personality != personality)
		return -EINVAL;

but __set_personality() always sets current->personality = personality,
what is the point to check equality?

IOW, when we should return -EINVAL? Perhaps, lookup_exec_domain() should
return NULL instead of default_exec_domain when the search in exec_domains
fails? And probably we shouldn't change task->personality/exec_domain in
this case? It is really strange that sys_personality() can return -EINVAL
but change ->personality.

But this can probably break exec. alpha does set_personality(PER_OSF4)
but I do not see the corresponding register_exec_domain(). On the other
hand, I do not understand why it puts PER_OSF4 into PER_MASK. PER_OSF4
is only used by sys_osf_readv/sys_osf_writev.

Thanks,

Oleg.

