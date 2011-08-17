Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1HQQsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:48:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41288 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab1HQQsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110817162041.GA21406@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
 <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
 <20110817134516.GA14136@redhat.com> <CAPXgP101N_GESzpqu=P_H8cLoekMzb2_W2eWyAqATSjm4Gj9CA@mail.gmail.com>
 <20110817162041.GA21406@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 17 Aug 2011 18:47:56 +0200
Message-ID: <CAPXgP13Dn2c-OnYg-Cty5r4JbqeH_zYPtXDj5GAfK1btoKYmDg@mail.gmail.com>
Subject: Re: + prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
 .patch added to -mm tree
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 18:20, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/17, Kay Sievers wrote:

>> No, we want to be the parent of the process,
>> ...
>> The sub-init is the babysitter of all the things it has
>> started, and that should be reflected in the parent child relation.
>
> OK. But could you explain why do we want this? This is not clear from
> the changelog/discussion.

As said, PID1 has the privilege of reaping all processes that
double-fork. Any sub-init wants to do the same for the stuff it
watches. The process that reaps has all the information about the
process as long as wants, it can look up stuff in /proc if needed or
has all the return values of wait(). Async notifications like
taskstats just can not provide what SIGCHLD, /proc and wait() offer.

>> > You should check ->child_reaper only. But see above, it can be multithreaded.
>>
>> The main PID 1 from the system has no ->child_reaper set as far as I
>> see, hence we check for init_task.
>
> No, you don't.

Don't? I don't check, or we don't have it set?

> Once again, if pid_ns->child_reaper exits, you should
> not even try to find the sub-reaper in its parents chain.

That would mean we can never run a sub-init in a pid namespace? Why not?

Or do you mean that we *are* already the pid_ns->child_reaper, not
that one *exists*?

>> >> > Also. You shouldn't do this if the sub-namespace init exits, this is
>> >> > wrong.
>> >>
>> >> It we find a sub-init, before the namespace PID1, why wouldn't we return it?
>> >
>> > Ah, I meant pid_ns->child_reaper, not task->child_reaper.
>> >
>> > If pid_ns->child_reaper exits we should never try to "reparent" its
>> > children, see zap_pid_ns_processes() in particular. IOW, this should
>> > go into the "else" branch of "if (pid_ns->child_reaper == father)"
>>
>> I don't understand this. If we find a marked task->child_reaper
>> _before_ we find a pid_ns->child_reaper in the chain of parents,
>
> This is fine.
>
> OK. I guess I wasn't clear, and I do not know how to explaine better.
> Please look at your code ;) Suppose that a sub-namespace init exits.
> Not the global /sbin/init. Not the caller of prctl(REAPER).
>
> In this case we should kill the children, not reparent them. Or panic
> if it is the global init (see above).
>
> See?

Not sure. You mean that the lookup for a possible task->cild_reaper
should be _before_ the check for pid_ns->child_reaper == father which
is currently below?

Kay
