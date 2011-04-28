Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531Ab1D1QFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:05:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46581 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742Ab1D1QFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:05:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110428155745.GF1798@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-2-git-send-email-wad@chromium.org>
	<20110428142857.GC1798@nowhere>
	<BANLkTikf4b1qMSOucNH-DLUFa7K3QOVN7w@mail.gmail.com>
	<20110428155745.GF1798@nowhere>
Date: Thu, 28 Apr 2011 11:05:12 -0500
Message-ID: <BANLkTimH-1J2BmSHu7Hc6tbkyREEB-cyDg@mail.gmail.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 10:57 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> On Thu, Apr 28, 2011 at 10:15:04AM -0500, Will Drewry wrote:
>> On Thu, Apr 28, 2011 at 9:29 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > On Wed, Apr 27, 2011 at 10:08:47PM -0500, Will Drewry wrote:
>> >> This change adds a new seccomp mode based on the work by
>> >> agl@chromium.org. This mode comes with a bitmask of NR_syscalls size and
>> >> an optional linked list of seccomp_filter objects. When in mode 2, all
>> >
>> > Since you now use the filters. Why not using them to filter syscalls
>> > entirely rather than using a bitmap of allowed syscalls?
>>
>> The current approach just uses a linked list of filters.  While a more
>> efficient data structure could be used, the bitmask provides a quick
>> binary decision, and optimizes for the relatively common case where
>> there won't be many non-binary filters to evaluate so we don't have to
>> walk the list for a larger number of yes/no decisions versus more
>> complex predicates.  Though that may be a short-sighted view! I'm
>> happy to change it up.
>
> Well, using a hlist that points to the filters may be not that slower.
> Dunno, that needs to be measured perhaps.
>
> No big deal for now.

Cool - that makes sense.  I just haven't used hlist before and was
reticent to dive in given how much other new territory this was.  I'll
check it out, though.

>>
>> > You have the "nr" field in syscall tracepoints.
>>
>> I'n not sure I follow.  Do you mean moving entirely to using the
>> actual tracepoint infrastructure instead of using the seccomp hooks,
>> or just looking up proper filter by syscall nr?  If there's a sane and
>> better way to do the latter, I'm all ears :)  As far as using the
>> tracepoints themselves, I looked to how the perf/ftrace interactions
>> worked and while I could've registered with the syscalls tracepoints
>> for enter and exit, it would mean later evaluation of the system call
>> interception, possibly out-of-order with respect to other registered
>> event sinks, and there is complexity in just killing current from
>> within the notifier-like list registered syscall events (as Eric Paris
>> ran into when expanding filtering into perf itself).  To get around
>> that, the tracepoint handler would have to pump the data somewhere
>> else (like it does for perf), and it just seemed messy.  I think it's
>> doable, but I don't know that the pure syscall tracepoint
>> infrastructure should be burdened with the added requirements that
>> come with seccomp-filtering.   If I didn't properly understand the
>> code, though, please set me on the right path.
>
> No, my bad I was confused. I always post questions that show my
> misunderstanding of a new (or not) patchset. It's like a tradition ;)

Awesome - I was getting worried I'd missed something terribly obvious!
