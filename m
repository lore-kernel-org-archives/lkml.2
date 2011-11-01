Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1KAUCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 16:02:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32884 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1KAUCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 16:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <4EA0935C.4020605@gmail.com>
References: <4E9E17F4.7080306@gmail.com>
	<CALdu-PDzw=6oGBU25K0TSAckuRmfQOnA6Aw-WZJkxLj1LyvNWg@mail.gmail.com>
	<4EA0935C.4020605@gmail.com>
Date: Tue, 1 Nov 2011 15:02:01 -0500
Message-ID: <CABqD9hY0A4EBP+C4uJvrhtFZKr=S3GV_js5Z2bhmmZbVgOkKUw@mail.gmail.com>
Subject: Re: [RFC] cgroup: syscalls limiting subsystem
From: Will Drewry <wad@chromium.org>
To: =?UTF-8?B?xYF1a2FzeiBTb3dh?= <luksow@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some much delayed comments - thanks for the post.  It's cool to see
all the different ways to approach system call filtering!

On Thu, Oct 20, 2011 at 4:32 PM, Łukasz Sowa <luksow@gmail.com> wrote:
> First of all, thanks a lot for your replay.
>
>> On Tue, Oct 18, 2011 at 5:21 PM, Łukasz Sowa <luksow@gmail.com> wrote:
>>> Hi,
>>>
>>> Currently, I'm writing BSc thesis about security in modern Linux.
>>> Together with my thesis mentor, I decided that as practical part of my
>>> work I'll implement cgroup subsystem that allows to limit particular
>>> (defined by number) syscalls for groups of processes. The patch is ready
>>> for first review and we decided that I may try to push it to the
>>> mainline - so here it is.

Have you considered doing this as a system call namespace instead of a
cgroup?  (Just curious!)

>>
>> The major problem with this approach is that denying/allowing system
>> calls based purely on the syscall number is very coarse. I'd guess
>> that most vulnerabilities in a system can be exploited just using
>> system calls that almost all applications need in order to get regular
>> work done (open, write, exec ,mmap, etc) which limits the utility of
>> only being able to turn them off by syscall number. So overall I don't
>> think you'll find very much support for this patch.
>
> I have to disagree. Have you read through the link to the article at LWN
> I gave? If not, please do so. There are a few people being interested in
> ability to limit access to some system calls, just like seccomp does.
> Moreover, as stated in the article, there are some projects looking
> forward to this feature like QEMU, vsftpd or Chromium. Another (but
> maybe not very convincing) point is that there are some other operating
> systems that have such feature successfully implemented and used, like BSD.

Feel free to pull the archives from ~May-June w.r.t seccomp filters.
I've agreed with you, and I've tried to lay out the uses.  The other
important point which I've neglected to mention in the past is that
the system call ABI is the only stable place where the kernel attack
surface can be instrumented.  LSM hooks provide policy level decision
making, but it doesn't help explicitly with attack surface (only
implicitly :), and deeper tracepoints aren't considered "stable".

>> Having said that, to address the patch itself:
>>
>>> 2. Performance. It's not that bad: I measured 5% more sys time for
>>> process on root level, and 8% more sys time for processes on first
>>> level. However, I think it may and should be improved but currently
>>> I have no idea how to do it.
>>
>> Do you mean for all processes, or just for processes that had deny
>> bits set? If the former, then 8% is a non-starter, I think. But if you
>> hook into the ptrace as I suggested above, you can probably get it to
>> zero overhead for threads in allow-all cgroups, and I suspect people
>> would scream much less about slowing down threads that are being
>> specifically limited anyway.
>
> The overhead is for all processes, not only the 'denying one'.
> Implementing it in a way that you suggested (setting bits in all
> descendants) is a very good idea. It enables us to have constant
> overhead (same on all levels) - currently 5%.
> All existing syscalls tracing solutions use ptrace hooking. It's clean
> but the performance of ptrace is horrible. I ran the same benchmark as I
> used for my code on ptrace based tracing and the overhead was immense.
> It was 100 times (sic!) slower. I have another good paper on the
> syscalls tracing that you may look through:
> http://www.linux-kongress.org/2009/slides/system_call_tracing_overhead_joerg_zinke.pdf
> All in all, I think that 5% overhead tracing is quite good trade-off
> between no tracing and extremely slow tracing.
> I have to say it again - I'm not satisfied with the current performance
> and I'm investigating into making it lower but I wonder that there's a
> way to go under, let's say - 3%.

Have you considered using the semi-slow path used by auditsc? It uses
a thread_info flag but doesn't take the completely slow-path if _only_
audit is selected.  You may be able to get by with a new TIF flag that
fits in with the same mask that is always called for all syscalls,
then only fork if the process is in a filtered cgroup.  It will be
messy to ensure all the paths work correctly, but it should mean that
the overhead for normal applications is unchanged, and you might avoid
the total slow-path overhead (just something similar to audit
overhead).

Another approach I've been toying with is putting a sys_call_table
pointer in the thread_info and then use it if the given flag is set.
But there are so many potential reasons that's a bad idea, I'm not
sure if it makes sense to suggest exploring it :)

> However, if such overhead is still unacceptable maybe we should provide
> a way to turn it off (besides not compiling it, of course)? My current
> idea is to introduce a per-cgroup triggering bit (which will not be
> hierarchical, of course). Then, the overhead for cgroups with tracing
> turned off would be minimal (additional bit checking and short jumping
> only). Or maybe there's a better way (for ex. a per-process triggering
> bit)?

A TIF flag might be the fit.

>>> 3. Naming convention - it's not bad either but I don't like the names -
>>> 'scs' abbreviation sound a little bit silly but full form (syscalls)
>>> makes lines far too long.
>>
>> I'd suggest syscall rather than scs.
>
> Thanks, I prefer syscall too, but I'll have to cope with long lines.
>
>>> +       switch (cftype->private) {
>>> +       case SCS_CGROUP_ALLOW:
>>> +               for (bit = 0; bit < NR_syscalls; ++bit) {
>>> +                       if (__scs_cgroup_perm(scg, bit))
>>> +                               seq_printf(seq_file, "%d\n", bit);
>>
>> Since this is presumably meant to be only used programmatically (as
>> syscall numbers can be different on different platforms, so you'll
>> need programs to translate between names and numbers) I wouldn't
>> bother with the \n - a plain space will be fine for the process
>> reading it, and less destructive to screen real-estate if someone
>> happens to cat it by hand.
>
> Plane space is a good idea, I'll make it this way.
> Relaying on the names is in my opinion very error prone, so I think it's
> best to left it for sysadmins scripts working on unistd.h file, fetching
> numbers based on the names of syscalls.

Agreed here.  Names are inconsistent -- just compare ftrace syscall
metadata names to those exported to userspace.  Only the exported
NR_blah is ABI as far as I can tell.  I believe deferencing those is
pretty easy in userspace and should be left to the tools. (e.g.,
http://goo.gl/7rpRp )

That said, your approach won't work on platforms which offset system
call start points, have gaps, and different ABI modes which change
those.  You might want to consider a btree or something that doesn't
need a pre-allocated array, etc.

(If not, you'll need to populate helpers for arches that need it to
get their starting number for the current abi and the max numbers and
then make sure processes either can't flip-flop, like CONFIG_COMPAT,
and exceed the sized array.  But perhaps the btree lookup cost is too
much.)

>>> +       switch (cftype->private) {
>>> +       case SCS_CGROUP_ALLOW:
>>> +               if (__scs_cgroup_perm(parent_scg, number)) {
>>> +                       write_seqlock(&scg->seqlock);
>>> +                       set_bit(number, scg->syscalls_bitmap);
>>> +                       write_sequnlock(&scg->seqlock);
>>> +               } else {
>>> +                       return -EPERM;
>>> +               }
>>> +               break;
>>> +       case SCS_CGROUP_DENY:
>>> +               write_seqlock(&scg->seqlock);
>>> +               clear_bit(number, scg->syscalls_bitmap);
>>> +               write_sequnlock(&scg->seqlock);
>>> +               break;

Have you considered supporting ftrace filters?

>> Deny needs to clear the bit in all descendants as well. And there
>> would need to be synchronization between checking the parent bit
>> during an ALLOW write, and someone changing the parent bit to a DENY.
>
> As I said above, it's a good idea.

You can avoid clearing up the group if you evaluate each set rather
than creating a composed view.  It'll yield more runtime overhead, but
only if there's a reason for the processes to have different filter
rules. (I'm doing this in the current seccomp filter patchset I need
to repost :/  because it's non-trivial (doable, but an optimization)
to compose ftrace filters.)

Good luck - I look forward to seeing your next patch series!
will
