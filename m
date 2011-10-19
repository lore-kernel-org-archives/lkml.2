Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab1JSJJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 05:09:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43677 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab1JSJJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 05:09:08 -0400
Message-ID: <4E9E9255.7090601@parallels.com>
Date: Wed, 19 Oct 2011 13:03:17 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
References: <20111014110416.552685686@openvz.org> <20111014110511.670174429@openvz.org> <20111014171033.GC4294@google.com> <20111014173304.GD4294@google.com>
In-Reply-To: <20111014173304.GD4294@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 09:33 PM, Tejun Heo wrote:
> Hello, again.

Hi!

Sorry for delay in response. I will answer on both of your concerns at once.

> I don't think this is a good idea.  We already have most of interface
> necessary for restoring task state and there's no need to put it into
> the kernel as one piece.  If there's something which can't be done
> from userland using existing interfaces, let's please discuss what
> they are and whether they can be resolved differently first.

The rest API we will require will look too special-purpose (like Cyrill
mentioned the ability to set the mm's fields such as start_code, etc).

Besides, putting a parasite code to restore the memory state will drive
us into certain limitations. E.g. - what address range in the target task
address space should the parasite occupy? What if we fail in finding one,
how should we act next?

> The exec path is very intricate as it is and it would be very easy to
> introduce security or other bugs by altering its basic behavior.  

Can you elaborate a bit more on this? "Other" bugs can be introduced by
any piece of code injected into the kernel, but what about security?

> exec presumes destruction of (most of) the current process and all its
> other threads and replacing them w/ fresh states from an executable.

This is *exactly* what is expected from the restoration process.

> The scary part - interaction with process hierarchy and zapping of the
> current state - is handled from the core exec code.

Right.

> I see that you removed zapping to allow restoring multi-threaded
> process, which seems quite scary to me.  It might be okay, I don't
> know, but IMHO it just isn't a very good idea to introduce such
> variation to basic exec behavior for this rather narrow use case.

Why? Can you describe your thought on this more, maybe I'm really missing
smth important.

> In addition, leaving it alone doesn't really solve multi-threaded
> restoring, does it?  

So your main concern is about multy-threaded tasks, right? I think we can
prepare the exec handler capable to show how this can look like.

> Who sets the task states for other threads? 

Which states? Pids and other IDs? Threads themselves. Memory state? The
exec handler itself. Registers? My plan is the same - the exec handler.

> The current code doesn't seem to be doing anything but if you're gonna add
> it later, how are you gonna synchronize other threads?

Synchronize what? If we're providing to a userspace a way to put things right
it's up to userspace to use it correctly. Like we saw this wit pid namespaces -
there's are plenty of ways how to kill the app with CLONE_NEWPID clone flag, but
the intention of one is not the be 100% fool-proof, but to provide an ability
to do what userspace need.

One of the abilities to restore multy-threaded task can be - clone threads from
the userspace, then wait for them to prepare themselves the way they need it,
then the threads go to sleep and the leader one calls execve. Thus the userspace
state consistency is OK.

> If not, what's the point of pushing this chunk in when userland task state
> restoration is necessary anyway?
> 
> So, at the moment, I'm rather strongly against this approach.


> On Fri, Oct 14, 2011 at 10:10:33AM -0700, Tejun Heo wrote:
>> I see that you removed zapping to allow restoring multi-threaded
>> process, which seems quite scary to me.  It might be okay, I don't
>> know, but IMHO it just isn't a very good idea to introduce such
>> variation to basic exec behavior for this rather narrow use case.
> 
> * It's still calling exec_mmap(), so the exec'ing thread will be on
>   the new mm while other threads would still be on the old one.

Why do you think it's a problem?

> * There are operations which assume that the calling task is
>   de-threaded and thus has exclusive access to data structures which
>   can be shared among the thread group (e.g. signal struct).  How are
>   accesses to them synchronized?

If we're talking about keeping the userspace state solid, then stopping the
other threads solves this.

> * What about properties which should be reset and then shared by
>   threads by inheriting (credentials, comm, self_exec_id and so on)?
>   e.g. new thread follows exec-time imposed rules but old ones keep
>   their original credentials.

I'm looking at the sys_setresuid and see that threads have independent creds
and thus they should be restored *before* calling exec.

> So, no, it really doesn't look good.

That's a pity. As I stated above, we'll try to demonstrate the exec handler
capable to restore the multy-threaded APP and send the 2nd RFC. Can you answer
my questions above so we keep your concerns in mind while doing this, please.

> Thanks.

Thank you for your feedback!
