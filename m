Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1JTIet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:34:49 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:5627 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab1JTIer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:34:47 -0400
Message-ID: <4E9FDCEF.5050008@parallels.com>
Date: Thu, 20 Oct 2011 12:33:51 +0400
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
References: <20111014110416.552685686@openvz.org> <20111014110511.670174429@openvz.org> <20111014171033.GC4294@google.com> <20111014173304.GD4294@google.com> <4E9E9255.7090601@parallels.com> <20111019182228.GJ25124@google.com>
In-Reply-To: <20111019182228.GJ25124@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2011 10:22 PM, Tejun Heo wrote:
> Hello, Pavel.
> 
> On Wed, Oct 19, 2011 at 01:03:17PM +0400, Pavel Emelyanov wrote:
>>> I don't think this is a good idea.  We already have most of interface
>>> necessary for restoring task state and there's no need to put it into
>>> the kernel as one piece.  If there's something which can't be done
>>> from userland using existing interfaces, let's please discuss what
>>> they are and whether they can be resolved differently first.
>>
>> The rest API we will require will look too special-purpose (like Cyrill
>> mentioned the ability to set the mm's fields such as start_code, etc).
> 
> I find that quite difficult to agree with.  We're talking about some
> minor additions to prctl against updating exec path to do something it
> was never designed to do + new binary format.

No, we're talking about a bit more, at least:
* A bunch of fields on mm_struct
  ** mmap layout
  ** stack/code/brk addresses
  ** dumpable bit
  ** etc...
* The /proc/self/exe link
* Proper binfmt pointer on mm_struct
* VDSO (as Cyrill mentioned)

And creating a dedicated API for each of them looks ... strange.

Let's do the thing - we'll try to implement the restore without the exec and will
look at how many additional knobs we'll have to put into the kernel-to-user API, OK?

Besides, this will let us to compare the performance of both...

>> Besides, putting a parasite code to restore the memory state will drive
>> us into certain limitations. E.g. - what address range in the target task
>> address space should the parasite occupy? What if we fail in finding one,
>> how should we act next?
> 
> How is that different from snapshotting time?  

No difference, sure.

> Unless the address is completely packed, I can't see how that can be a problem.  
> In the worst case, you can use the parasite to map what's not overlapping and
> then let the ptracer restore the overlapping areas after parasite is
> done.

Yes, of course, taking into account the parasite code is fairly small to fit
the existing holes in address space. Otherwise poking the overlapping places
byte-by-byte will kill the performance.

Do we believe it will always be true?

>>> The exec path is very intricate as it is and it would be very easy to
>>> introduce security or other bugs by altering its basic behavior.  
>>
>> Can you elaborate a bit more on this? "Other" bugs can be introduced by
>> any piece of code injected into the kernel, but what about security?
> 
> exec is a pretty important security boundary.  A lot of resources (fd,
> VMAs, credentails) have security-sensitive policies forced across exec
> boundary and there are enough places which depends on the all
> resetting property of exec (e.g. no other user of thread-group wide
> resources).

:\ This explanation looks strange. Why then this zapping is performed in binary
handlers, rather than in generic exec code? Methinks this assumption can be
weakened if binary handler thinks it can handle it...

>>> exec presumes destruction of (most of) the current process and all its
>>> other threads and replacing them w/ fresh states from an executable.
>>
>> This is *exactly* what is expected from the restoration process.
> 
> Umm.... so why does the patch skip zapping?  And if you are gonna be
> zapping, how are you gonna do multiple threads?

It skips zapping to let the threads survive the exec.

>>> I see that you removed zapping to allow restoring multi-threaded
>>> process, which seems quite scary to me.  It might be okay, I don't
>>> know, but IMHO it just isn't a very good idea to introduce such
>>> variation to basic exec behavior for this rather narrow use case.
>>
>> Why? Can you describe your thought on this more, maybe I'm really missing
>> smth important.
> 
> Because it breaks one of the very basic assumptions - there are no
> other tasks in the thread group and thus resources usually shared
> among threadgroup can be assumed to be exclusive.

And are we doomed to this assumption due to the security reasons described
above?

>>> In addition, leaving it alone doesn't really solve multi-threaded
>>> restoring, does it?  
>>
>> So your main concern is about multy-threaded tasks, right? I think we can
>> prepare the exec handler capable to show how this can look like.
> 
> I'm strongly against that direction regardless of implementation
> details.
> 
>>> The current code doesn't seem to be doing anything but if you're gonna add
>>> it later, how are you gonna synchronize other threads?
>>
>> Synchronize what? If we're providing to a userspace a way to put things right
>> it's up to userspace to use it correctly. Like we saw this wit pid namespaces -
>> there's are plenty of ways how to kill the app with CLONE_NEWPID clone flag, but
>> the intention of one is not the be 100% fool-proof, but to provide an ability
>> to do what userspace need.
> 
> To shared kernel data structures.

Yet again - keeping shared stuctres self-consistent from which point of view? From
the kernel's one - already handled with in-kernel locks. From the userspace one -
every single kernel API provides a *way* to do things right, but doesn't provide
the fool protection.

>> One of the abilities to restore multy-threaded task can be - clone threads from
>> the userspace, then wait for them to prepare themselves the way they need it,
>> then the threads go to sleep and the leader one calls execve. Thus the userspace
>> state consistency is OK.
> 
> If you're gonna let userspace do it, why bother with in-kernel thing
> at all?

Because userspace cannot just flush itself memory and registers and switch to new
ones. Someone's help is required anyway. Did I misunderstood your question?

>>> * It's still calling exec_mmap(), so the exec'ing thread will be on
>>>   the new mm while other threads would still be on the old one.
>>
>> Why do you think it's a problem?
> 
> Ummm.... they aren't on the same address space?  How can that be okay?

The similar (but mirrored) thing with vfork - two tasks are on the same address space,
but the child is supposed not to kill the parent's one. And this is OK for most of the
apps using it.

> It's not only wrong from CR POV.  The kernel disallows
> CLONE_THREAD/SIGHAND w/o CLONE_VM and depend on that assumption,
> you're breaking that.

OK, if this is the only problem we can keep the mm_struct itself just unmapping the
vmas with unmap(0, 0xff...f) and repopulating one.

>>> * There are operations which assume that the calling task is
>>>   de-threaded and thus has exclusive access to data structures which
>>>   can be shared among the thread group (e.g. signal struct).  How are
>>>   accesses to them synchronized?
>>
>> If we're talking about keeping the userspace state solid, then stopping the
>> other threads solves this.
> 
> Again, there are kernel exclusivity assumptions.
> 
>> That's a pity. As I stated above, we'll try to demonstrate the exec handler
>> capable to restore the multy-threaded APP and send the 2nd RFC. Can you answer
>> my questions above so we keep your concerns in mind while doing this, please.
> 
> IMHO, this is a fundamentally broken approach which isn't even
> necessary.  So, FWIW, NACK.

It's a pity :( Anyway, as I stated above, we'll try to compare two real implementations,
not abstract assumptions.

> Thank you.
