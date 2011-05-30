Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1E3D2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:28:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61676 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1E3D2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=g1bvD0XaVdgFNVUek25yiBdfRv6osBns0Au43y5GFxwwmQOuFSyeKMSyicXnzyOyvH
         Gtk7I9cMNuMhe6g0wNZ5hDIEhF527QPjSTKroIN8oCstlnlxqTgnMPcPIijMUMS+xH2V
         7inoGXLTm0+C0L4RY1YjcnO5iMnvUVEhVz8N4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: execve-under-ptrace API bug (was Re: Ptrace documentation, draft #3)
Date: Mon, 30 May 2011 05:28:17 +0200
User-Agent: KMail/1.8.2
Cc: jan.kratochvil@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com> <20110525143250.GJ10146@htj.dyndns.org>
In-Reply-To: <20110525143250.GJ10146@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105300528.17384.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 May 2011 16:32, Tejun Heo wrote:
> > 	1.x execve under ptrace.
> > 
> ...
> >   ** we get death notification: leader died: **
> >  PID0 exit(0)                            = ?
> >   ** we get syscall-entry-stop in thread 1: **
> >  PID1 execve("/bin/foo", "foo" <unfinished ...>
> >   ** we get syscall-entry-stop in thread 2: **
> >  PID2 execve("/bin/bar", "bar" <unfinished ...>
> >   ** we get PTRACE_EVENT_EXEC for PID0, we issue PTRACE_SYSCALL **
> >   ** we get syscall-exit-stop for PID0: **
> >  PID0 <... execve resumed> )             = 0
> > 
> > ??? Question: WHICH execve succeeded? Can tracer figure it out?
> 
> Hmmm... I don't know.  Maybe we can set ptrace message to the original
> tid?

The problem with execve is bigger than merely reporting this pid.

Consider how strace tracks its tracees. Currently, it remembers
their pids - sometimes by remembering clone's return values!
This is hopelessly broken wrt pid namespaces.

So I looked at removing all pid tracking from strace, because
it uses pids only for some (extremely fragile) workarounds
for old kernel bugs, such as: it suspends waitpid's in tracees
until there is a child it can wait for; it detaches from
a tracee if it gets signaled with a fatal signal or calls exit;
and similar madness.

There are many bugs in strace in this area, because it cannot
properly emulate a lot of things (such as signal interrupting
waitpid, waitpid(-PGID), etc).

Therefore I plan to delete this madness.

The idea is that strace can simply create a new tracee's data
structure when it sees a new, never before seen pid popping up
from waitpid - this means that [v]fork/clone created a child,
and now it is traced too. It does not need to know beforehand
about its pid. It does not need to know who is whose parent
or sibling.

This works (I have a patch against a somewhat older strace),
but now in light of this "interesting" execve-under-ptrace
behavior it appears to have a flaw: all threads except the
execve'ing one disappear without any notification to strace,
therefore strace doesn't know which tracee data ("struct tcb"
in strace-speak) need to be dropped!

I am not sure current strace handles this correctly either.
I will be very surprised if it does.

I think the API needs fixing. Tracee must never disappear like that
on execve (or in any other case). They must always deliver a
WIFEXITED or WIFSIGNALED notification, allowing tracer to know
that they are gone. We probably also need to document how are these
"I died on execve" notifications are ordered wrt PTRACE_EVENT_EXEC
stop in execve-ing thread.

Ideas?


-- 
vda


