Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696Ab1D1SCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:02:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60335 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab1D1SCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <1304009810.18763.179.camel@gandalf.stny.rr.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-2-git-send-email-wad@chromium.org>
	<1303998629.18763.149.camel@gandalf.stny.rr.com>
	<BANLkTikrXHvLhFH0A2LbpZ7sGBi0iOH+gQ@mail.gmail.com>
	<1304009810.18763.179.camel@gandalf.stny.rr.com>
Date: Thu, 28 Apr 2011 13:02:14 -0500
Message-ID: <BANLkTinyt34YcwqpP8Z1Zby4q0dvYPEk4A@mail.gmail.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 11:56 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-04-28 at 10:30 -0500, Will Drewry wrote:
>
>> >> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> >> index 57d4b13..1bee87c 100644
>> >> --- a/kernel/seccomp.c
>> >> +++ b/kernel/seccomp.c
>> >> @@ -8,10 +8,11 @@
>> >>
>> >>  #include <linux/seccomp.h>
>> >>  #include <linux/sched.h>
>> >> +#include <linux/slab.h>
>> >>  #include <linux/compat.h>
>> >>
>> >>  /* #define SECCOMP_DEBUG 1 */
>> >> -#define NR_SECCOMP_MODES 1
>> >> +#define NR_SECCOMP_MODES 2
>> >>
>> >>  /*
>> >>   * Secure computing mode 1 allows only read/write/exit/sigreturn.
>> >> @@ -32,9 +33,11 @@ static int mode1_syscalls_32[] = {
>> >>
>> >>  void __secure_computing(int this_syscall)
>> >>  {
>> >> -     int mode = current->seccomp.mode;
>> >> +     int mode = -1;
>> >>       int * syscall;
>> >> -
>> >> +     /* Do we need an RCU read lock to access current's state? */
>> >
>> > I'm actually confused to why you are using RCU. What are you protecting.
>> > Currently, I see the state is always accessed from current->seccomp. But
>> > current should not be fighting with itself.
>> >
>> > Maybe I'm missing something.
>>
>> I'm sure it's me that's missing something.  I believe the seccomp
>> pointer can be accessed from:
>> - current
>> - via /proc/<pid>/seccomp_filter (read-only)
>>
>> Given those cases, would it make sense to ditch the RCU interface for it?
>
> Looking at this in a bit more detail. I think you can ditch the
> rcu_readlocks where current accesses its own seccomp state. As current
> is the one that duplicates it (and ups the refcount) on fork, and
> current wont free it until after it performs a rcu_synchronization. No
> one else can free current's seccomp state while current has a reference
> to it.
>
> You still need the rcu_readlocks on the readers for the proc system.
> Otherwise the handle can be freed while its still in use. With the
> rcu_readlocks, these readers will always get the refcount before current
> frees it. And then the dec_and_test should work as expected when the
> readers do the put.

Great, I'll do that!
