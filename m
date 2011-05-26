Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab1EZREp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:04:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41801 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1EZREo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:04:44 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
	<BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
	<BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
	<1306254027.18455.47.camel@twins>
	<20110524195435.GC27634@elte.hu>
	<alpine.LFD.2.02.1105242239230.3078@ionos>
	<20110525150153.GE29179@elte.hu>
	<alpine.LFD.2.02.1105251836030.3078@ionos>
	<20110525180100.GY19633@outflux.net>
	<BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
	<20110525191152.GC19633@outflux.net>
	<BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
	<BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
	<BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com>
	<BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
	<BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
	<BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
Date: Thu, 26 May 2011 12:04:43 -0500
Message-ID: <BANLkTikZLGvGUU40hhFdubMey8ZdJfJJew@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Colin Walters <walters@verbum.org>, Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 12:02 PM, Will Drewry <wad@chromium.org> wrote:
> On Thu, May 26, 2011 at 11:46 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, May 26, 2011 at 9:33 AM, Will Drewry <wad@chromium.org> wrote:
>>>
>>> FWIW, none of the patches deal with privilege escalation via setuid
>>> files or file capabilities.
>>
>> That is NOT AT ALL what I'm talking about.
>>
>> I'm talking about the "setuid()" system call (and all its cousins:
>> setgit/setreuid etc). And the whole thread has been about filtering
>> system calls, no?
>>
>> Do a google code search for setuid.
>>
>> In good code, it will look something like
>>
>>  uid = getuid();
>>
>>  if (setuid(uid)) {
>>    fprintf(stderr, "Unable to drop provileges\n");
>>    exit(1);
>>  }
>>
>> but I guarantee you that there are cases where people just blindly
>> drop privileges. google code search found me at least the "heirloom"
>> source code doing exactly that.
>>
>> And if you filter system calls, it's entirely possible that you can
>> attack suid executables through such a vector. Your "limit system
>> calls for security" security suddenly turned into "avoid the system
>> call that made things secure"!
>>
>> See what I'm saying?
>
> Absolutely - that was what I meant :/  The patches do not currently
> check creds at creation or again at use, which would lead to
> unprivileged filters being used in a privileged context.  Right now,
> though, if setuid() is not allowed by the seccomp-filter, the process
> will be immediately killed with do_exit(SIGKILL) on call -- thus
> avoiding a silent failure. I mentioned file capabilities because they
> can have setuid-like side effects, too.  As long as system call
> rejection results in a process death, I *think* it helps with some of
> this complexity, but I haven't fully vetted the patches for these
> scenarios to be 100% confident.

Bah - by "setuid-like side effects", I meant suid executable-like side
effects.  And I blocking even outside of those scenarios, I think
immediate process-death helps resolves coding mistakes leading to
filtering setuid() calls prior to use.

cheers,
will
