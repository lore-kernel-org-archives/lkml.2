Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab2ALRD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:03:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61609 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2ALRDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:03:23 -0500
MIME-Version: 1.0
In-Reply-To: <20120112161806.21a09335@pyramind.ukuu.org.uk>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112161806.21a09335@pyramind.ukuu.org.uk>
Date: Thu, 12 Jan 2012 11:03:20 -0600
Message-ID: <CABqD9hbEzcEF3KbG4=yA2haUUaXB8rMH9JbO+ZkZHU08Nt3ydQ@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 10:18 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Filter programs may _only_ cross the execve(2) barrier if last filter
>> program was attached by a task with CAP_SYS_ADMIN capabilities in its
>> user namespace.  Once a task-local filter program is attached from a
>> process without privileges, execve will fail.  This ensures that only
>> privileged parent task can affect its privileged children (e.g., setuid
>> binary).
>
> I think this model is wrong. The rest of the policy rules all work on the
> basis that dumpable is the decider (the same rules for not dumping, not
> tracing, etc). A user should be able to apply filter to their own code
> arbitarily. Any setuid app should IMHO lose the trace subject to the usual
> uid rules and capability rules. That would seem to be more flexible and
> also the path of least surprise.

My line of thinking up to now has been that disallowing setuid exec
would mean there is no risk of an errant setuid binary allowing escape
from the system call filters (which the containers people may care
more about).  Since setuid is privilege escalation, then perhaps it
makes sense to allow it as an escape hatch.

Would it be sane to just disallow setuid exec exclusively?

> [plus you can implement non setuid exec entirely in userspace so it's
> a rather meaningless distinction you propose]

Agreed.

>> be tackled separately via separate patchsets. (And at some point sharing
>> BPF JIT code!)
>
> A BPF jit ought to be trivial and would be a big win.
>
> In general I like this approach. It's simple, it's compact and it offers
> interesting possibilities for solving some interesting problem spaces,
> without the full weight of SELinux, SMACK etc which are still needed for
> heavyweight security.
>

Thanks!  Yeah I think merging with the network stack is eminently
doable, but I didn't want to bog down the proposal in how much
overhead I might be adding to the network layer.
