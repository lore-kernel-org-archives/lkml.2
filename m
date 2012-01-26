Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2AZAlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 19:41:10 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:58230 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2AZAlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 19:41:04 -0500
Message-ID: <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
In-Reply-To: <201201260032.57937.vda.linux@googlemail.com>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
    <20120125193635.GA30311@redhat.com>
    <201201260032.57937.vda.linux@googlemail.com>
Date: Thu, 26 Jan 2012 01:40:35 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Cc: "Oleg Nesterov" <oleg@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Jamie Lokier" <jamie@shareable.org>,
        "Andrew Lutomirski" <luto@mit.edu>, "Will Drewry" <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        "Roland McGrath" <mcgrathr@chromium.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: f4db13d1ab50da585241c80c5e12767b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 26, 2012 00:32, Denys Vlasenko wrote:
> On Wednesday 25 January 2012 20:36, Oleg Nesterov wrote:
>> On 01/18, Linus Torvalds wrote:
>> >
>> > Using the high bits of 'eflags' might work.
>>
>> I thought about changing eflags too, this looks very natural to me.
>>
>> But I do not understand the result of this discussion, are you going
>> to apply this change?
>>
>> If not...
>>
>> Not sure this is really better, but there is another idea. Currently we
>> have PTRACE_O_TRACESYSGOOD to avoid the confusion with the real SIGTRAP.
>> Perhaps we can add PTRACE_O_TRACESYS_VERY_GOOD (or we can look at
>> PT_SEIZED instead) and report TS_COMPAT via ptrace_report_syscall ?

Disadvantage of that is that all archs have to add support for this,
while it only affects x86_64.

>>
>> IOW. Currently ptrace_report_syscall() does
>>
>> 	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
>>
>> We can add the new events,
>>
>> 	PTRACE_EVENT_SYSCALL_ENTRY
>> 	PTRACE_EVENT_SYSCALL_COMPAT_ENTRY
>> 	PTRACE_EVENT_SYSCALL_EXIT
>> 	PTRACE_EVENT_SYSCALL_COMPAT_EXIT
>
> We can get away with just the first one.
> (1) It's unlikely people would want to get native sysentry events but not compat ones,
> thus first two options can be combined into one;

True.

> (2) syscall exit compat-ness is known from entry type - no need to indicate it; and
> (3) if we would flag syscall entry with an event value in wait status, then syscall
> exit will be already distinquisable.

False for execve which messes everything up by changing TID sometimes.

>
> Thus, minimally we need one new option, PTRACE_O_TRACE_SYSENTRY -
> "on syscall entry ptrace stop, set a nonzero event value in wait status"
> , and two event values: PTRACE_EVENT_SYSCALL_ENTRY (for native entry),
> PTRACE_EVENT_SYSCALL_ENTRY1 for compat one.

Not all code wants to receive a syscall exit event all the time, so
if you add PTRACE_O_TRACE_SYSENTRY, please add PTRACE_O_TRACE_SYSEXIT
too. That would pretty much halve ptrace's overhead for my use case.
But this is orthogonal to the compat problem.

> To future-proof this scheme we may reserve a few more event values
> PTRACE_EVENT_SYSCALL_ENTRY2, PTRACE_EVENT_SYSCALL_ENTRY3, etc,
> if we'll ever have arches with more than one non-native syscall
> entry. I'm no expert, but looking at strace code, ARM may already have
> more than one additional convention how to pass syscall args.

Please, no! This way lays madness, just one PTRACE_EVENT_SYSCALL_ENTRY,
no PTRACE_EVENT_SYSCALL_ENTRY1 or PTRACE_EVENT_SYSCALL_ENTRY2, that
would be horrible. Keep arch specific stuff in arch specific areas,
please don't spread it around.

What was wrong with using eflags again? Is it too simple or something?

Greetings,

Indan


