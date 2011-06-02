Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1FBPSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:18:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62330 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab1FBPSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BaZnZYoHM8jHndNU3XKBD5ehUCUxr9xU0Sh27+SZzuQBy9fDZR5gcn7TFXyfC4Orz7
         kNN5HpV/g0BIGTnlxQvAIgG4rJ1PTCuLh3ltYV7X+j3diw/q/LY8Wb5WF/ApzfF1+QpP
         Nhd9BDPLQxTR0tS6nFacPjKYMbkVpnEJyqGQ0=
MIME-Version: 1.0
In-Reply-To: <20110602142916.GA18325@elte.hu>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
	<1306897845-9393-2-git-send-email-wad@chromium.org>
	<20110601070023.GB27671@elte.hu>
	<BANLkTimWvddKkVQA1qOc6KhxPUj8j2dWQg@mail.gmail.com>
	<20110602142916.GA18325@elte.hu>
Date: Thu, 2 Jun 2011 10:18:20 -0500
Message-ID: <BANLkTi=-SpzRFg2SF_M4xrwYBf6SoJ_mGQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/13] tracing: split out syscall_trace_enter construction
From: Will Drewry <wad@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, rostedt@goodmis.org,
        jmorris@namei.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 9:29 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Will Drewry <wad@chromium.org> wrote:
>
[...]
>
>> Based on my observations while exploring the code, it appears that
>> the LSM security_* calls could easily become active trace events
>> and the LSM infrastructure moved over to use those as tracepoints
>> or via event_filters.  There will be a need for new predicates for
>> the various new types (inode *, etc), and so on.  However, the
>> trace_sys_enter/__secure_computing model will still be a special
>> case.
>
> Yes, and that special event will not go away!
>
> I did not suggest to *replace* those events with the security events.
> I suggested to *combine* them - or at least have a model that
> smoothly extends to those events as well and does not limit itself to
> the syscall surface alone.
>
> We'll want to have both.
>
> But by hardcoding to only those events, and creating a
> syscall-numbering special ABI, a wall will be risen between this
> implementation and any future enhancement to cover other events. My
> suggestion would be to use the event filter approach - that way
> there's not a wall but an open door towards future extensions ;-)

Yeah, I can definitely see that.  We could have the prctl interface
take in the event id, but that introduces dependency on
CONFIG_PERF_EVENTS in addition
(to get the id exported) and means we'll have much more limited
coverage of syscalls until the syscall wrapping matures.

Could this be resolved in the proposed change by supporting both
mechanisms? Or is that just asking for trouble?

E.g., it could be an extra field:
  prctl(PR_SET_SECCOMP_FILTER, PR_SECCOMP_FILTER_TYPE_EVENT, event_id,
filter_string);
  prctl(PR_SET_SECCOMP_FILTER, PR_SECCOMP_FILTER_TYPE_SYSCALL,
__NR_somesyscall, filter_string);
  [and the same for CLEAR_FILTER and GET_FILTER]

or even reserve negative values for event ids and positive for
syscalls (which feels more hackish).  Adding event_id support wouldn't
be much more additional code (since it's just a layer of
dereferencing).  Since there will likely be syscall-indexed entry
behavior no matter what (like there is for ftrace/perf_sysenter), it
won't necessarily be a large diversion in the future either.

If not, seccomp_filter could depend on both FTRACE_SYSCALLS and
exported PERF_EVENTS (or make "id"s not perf_event specific), then it
could just use the sys_enter event ids.  Doing so does have some other
properties that I'm not as fond of, like requiring debugfs to be
compiled in, mounted, and readable by the caller in order to construct
a filterset, so I can still see some benefit for the syscall number
use in some cases (much easier to deploy on a server without debugfs
access, etc).  Right now, having both interfaces doesn't really give
us anything, but having the field set aside for future exploration
isn't necessarily a bad thing!

What do you think? Would a change to support both be too crazy/dumb or
just crazy/dumb enough?  Or do you see another path that could avoid
isolating any current work from a more fruitful future?

thanks!
will
