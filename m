Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1E3Nu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:50:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab1E3Nu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:50:58 -0400
Date: Mon, 30 May 2011 15:49:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation,
	draft #3)
Message-ID: <20110530134925.GB4739@redhat.com>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com> <20110525143250.GJ10146@htj.dyndns.org> <201105300528.17384.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105300528.17384.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Denys Vlasenko wrote:
>
> Consider how strace tracks its tracees. Currently, it remembers
> their pids - sometimes by remembering clone's return values!
> This is hopelessly broken wrt pid namespaces.

Yes. Unless the tracer lives in the same namespace it can't use
RAX as the pid. This return value is only makes sense inside the
tracee's namespace.

There is another problem, tracehook_report_clone_complete()
sets PTRACE_GETEVENTMSG == global_pid. IOW, this value can't
be used unless the tracer runs in the root namespace.

> So I looked at removing all pid tracking from strace,

I am not sure... but you certainly know better what strace
can/should do.

> The idea is that strace can simply create a new tracee's data
> structure when it sees a new, never before seen pid popping up
> from waitpid

This can probably work for strace. Note that this means strace
can't detach all tracees gracefully, it simply doesn't know them
all. But probably strace doesn't need this.

> This works (I have a patch against a somewhat older strace),
> but now in light of this "interesting" execve-under-ptrace
> behavior it appears to have a flaw: all threads except the
> execve'ing one disappear without any notification to strace,
> therefore strace doesn't know which tracee data ("struct tcb"
> in strace-speak) need to be dropped!

I think there is no choice currently, strace should remember tgid.

> I think the API needs fixing.

ptrace() should not be pid/thread based ;) But this is offtopic now.

Oleg.

