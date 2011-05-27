Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab1E0HNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:13:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57668 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1E0HNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=K/zj0Pv0Czc8jElhQ7tjvD2CTBET/2pkXSWXGddwWetDDLWPXshRcKH4mPMKASUohq
         k+dxR3n9ufIAQcuztnnN+naDSi/YIX4zms8z8GvOfjDDsrteUhCR86yqpF2dcsxnHi9u
         LYLPLAkI9Ck7VXNW4iKKtRJbMHfU4J4jZSnz4=
MIME-Version: 1.0
In-Reply-To: <20110526162138.GN9520@thunk.org>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
 <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu> <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com>
 <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com>
 <20110526162138.GN9520@thunk.org>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Fri, 27 May 2011 09:12:34 +0200
Message-ID: <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: "Ted Ts'o" <tytso@mit.edu>, "D. Jansen" <d.g.jansen@googlemail.com>,
        Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 6:21 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, May 26, 2011 at 06:05:43PM +0200, D. Jansen wrote:
>> Problem: any fsync call by any application spins up the hard disk any
>> time even in laptop_mode
>
> What you call a problem, I call a feature.

Problem: any fsync call by any application spins up the hard disk any
time even in laptop_mode and there's nothing the user can do about it
in user space - without risking that the application corrupts existing data if
the kernel decides to commit the queued writes in non-FIFO order OR
modifying every single application itself.

>> Because though there is no possibility to destroy data that is on disk
>> due to non FIFO flushing of application writes queued in the kernel,
>> which seems to be the main kernel level problem, yet new problems come
>> up.
>
> I'm not sure what you're talking about here.  Buffered data can always
> be reordered in terms of when it is written to disk.  This is
> considered good, and normal.  If you want to guarantee that
> application writes are pushed out to disk, then either (a) use
> O_DIRECT, or (b) use fsync().  Those are your two options.

That reordering is exactly what I'm talking about. It wasn't my idea.
But if I understood it correctly, it's possible that the kernel
commits writes of an application, _to one and the same file_, in a
non-FIFO order, if the application does not fsync. And this _afaiu_
could result in the loss not only of new data, but complete corruption
of previously existing data in laptop mode without fsync.

But you're the expert. Is that really the case? If so, could it be
avoided without the daemon and application patching?

> If we didn't (for example) reorder writes to avoid the hard disk head
> from seeking all over the disk, that would actually cause more power
> to be consumed!

Yes, probably. But I doubt if that happens only once in a commit
window in laptop mode that the effect would destroy the gains. Also it
is not always necessary. Only writes to one file should be committed
in order. They could even be merged to one write - if they aren't
already: It seems the ordering is only necessary when an fsync occurs.

1) DDD_ (write D at 0)
2) _HHH (write H at 1) (fsync)
3) DHHH (result/merged write, in order)

As long as we don't end up with:
3) DDDH (out of order write, corrupt)

>> Now there is
(in a special write queue and coordination daemon)
>> 1) special support needed on the application side.
>
> Yep, because this is fundamentally an application-level problem, and
> the kernel doesn't have enough semantic information to solve the
> database coherency problem.

Well if we know that fsyncs mean the application needs the data to be
committed in order, couldn't we watch out for fsync calls and then (in
laptop mode when this feature specially requested by the user) switch
that application to fifo per file writes? (Disregarding the write
performance in that case.) Or we let the userspace eatmydata library
detect the same fsync and use a kernel api to switch that write to
fifo instead of fsyncing. A fifo write call might actually be useful
to other applications and scenarios as well. (trojan horse!)
Or the last write before the fsync is committed last. If reordering is
otherwise possible, this should avoid corruption and decrease
performance less. (Though we're not talking about writing hundreds of
MBs in laptop mode in my average use case scenario of office
applications and maybe a browser running.)
>
>> 2) need for new out-of-kernel buffers.
>
> Yes.  So?

Shouldn't we try to avoid replicating existing infrastructure when possible?

>
>> 3) need for inter-application write alignment nightmares. This sort of
>> structure could cause very uncomfortable bugs that prevent writes from
>> happening at all in cases that were not foreseen at all.
>
> Huh?  I think you are talking about order that buffered writes happen,
> and there's no problem here.  It's a feature that they can be
> reordered.  See above.

No, what I meant is that if there is a bug at any step of the
coordination between the applications and the daemon: in the daemon,
the software, their communication connection, etc., writes may not
occur and we may lose data without need.

>> 5) If the _application_, but not the kernel crashes, the data is safe.
>> In my experience this is the much more likely case than that the mail
>> server on my netbook optimized for battery time receives an email in
>> laptop mode, sends the other server "200" and then before the next
>> commit window my battery slips out and it's all gone.
>
> Huh?  What's the problem that you're worried about here.
Your scenario sounds like this:
daemon announced when to flush data
until then application buffers data in it's user space.

This means if you save a file and the application crashes, e.g. segfaults
and is killed, the data is still in its queue and thus lost.

Without the daemon, the data would be in kernel space already and thus
safe from application crashes.

In my experience the kernel is very stable, applications are much less so.

And I really don't see this entering many applications. They would
probably say this is the task of the kernel itself or some other piece
of layer in between, but not the task of every single app developer to
reinvent write caching, coordination with the laptop writes daemon
etc. In the end we might have one or two special "write in laptop
mode" apps and as soon as I start a browser or any sqlite based app,
the problem is back.

>> I think the alternative of ensuring the application writes are
>> committed in order would make more sense:
>> e..g a _user space library_ disables fsync etc. in laptop_mode if the
>> user chooses to do so and kernel support for forced FIFO ordering or
>> writes.
>> This would fix 1) 2) 3) 4) 5) 6).
>
> And if you do this to a mysql daemon, or to a firefox or chrome
> process which uses sqllite, and you crash at a wrong time, the entire
> database could be scrambled.
Define crash at the wrong time. Because there is always a wrong time,
whether with laptop mode or without, with fsync or without.

> You can't fix this with your solution, because you want to make fsync()
> lie to the database code.  And so all
> of the extra work (and power) consumed by the database code to try to
> make its database writes be safe, will be compromised by making
> fsync() unreliable.

Yes, I would like to have the liberty of extending the decrease of
safety of new data in favor of the choice of creating more new data
(due to longer run time) when in laptop mode.

I still want and use that safety, just not when I'm in laptop mode.
>
>> So you've re-thought this "All that is necessary is a kernel patch to
>> allow laptop_mode to disable fsync() calls(...)"
>> (http://tytso.livejournal.com/2009/03/15/). That post had inspired my
>> patch.
>
> I was thinking about things only from a file system perspective.  The
> problem is that more and more people are running databases or other
> binary files which are updated in place on their laptops, and from a
> more holistic perspective, we have to worry about making sure that
> application-level databases are coherent in the face of a system
> crash.  (For example, you drop your mobile phone, or your tablet, or
> your laptop, and the battery slips out.)

Exactly. Great example! Again, I very much agree.("Even") I don't want
to end up with
corrupt data. But I accept old data. Is there really no way to get there without
rewriting each and every application's fsync code?

Thanks for your insights!
