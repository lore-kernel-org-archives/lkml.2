Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2IRSRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:17:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45265 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2IRSRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:17:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120918180200.GA2281@netboy.at.omicron.at>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
 <5057BE59.3050903@linaro.org> <20120918180200.GA2281@netboy.at.omicron.at>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 18 Sep 2012 11:17:23 -0700
Message-ID: <CALCETrUd=Tg31nrkBW2RxxSjaLNPYwPF2+=j-19UWP_dShYnSQ@mail.gmail.com>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
To: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 11:02 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Mon, Sep 17, 2012 at 05:20:41PM -0700, John Stultz wrote:
>> On 09/17/2012 04:49 PM, Andy Lutomirski wrote:
>> >2. There's nothing vsyscall-specific about the code in
>> >vclock_gettime.c.  In fact, the VVAR macro should work just fine in
>> >kernel code.  If you moved all this code into a header, then in-kernel
>> >uses could use it, and maybe even other arches could use it.  Last
>> >time I checked, it seemed like vclock_gettime was considerably faster
>> >than whatever the in-kernel equivalent did.
>> I like the idea of unifying the implementations, but I'd want to
>> know more about why vclock_gettime was faster then the in-kernel
>> getnstimeofday(), since it might be due to the more limited locking
>> (we only update vsyscall data under the vsyscall lock, where as the
>> timekeeper lock is held for the entire execution of
>> update_wall_time()), or some of the optimizations in the vsyscall
>> code is focused on providing timespecs to userland, where as
>> in-kernel we also have to provide ktime_ts.
>
> This there a valid technical reason why each arch has its own vdso
> implementation?

I don't know too much about other arch vdsos.  i386's doesn't have
clock functions.  x32 works exactly like x86-64, except that it
probably involves a bit of addressing mode weirdness.  ia64's is very
strange indeed, I think.

In any case, the VVAR macro is an x86-64-ism, although if it were to
be the beginning of a generic mechanism, #define VVAR(x) (x) would be
a perfectly fine start, I think.

>
> If not, I would suggest that the first step would be to refactor these
> into one C-language header. If this can be shared with kernel code,
> then all the better.

That should be most straightforward to do.

One issue: you can't call a function pointer from vdso code (because
the vdso is in a different place in different processes).  The
vclock_mode stuff would need to be extended to work across
architectures, and the fallback to a real syscall would need to turn
into something else.

--Andy
