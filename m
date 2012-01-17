Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2AQVJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:09:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45255 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2AQVJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:09:20 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9hYP9TOhZLEXbTc-koba4x=z2wdkuNeh3AUmTWcw0+Ywxg@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112162231.GA23960@redhat.com>
	<CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
	<20120112172315.GA26295@redhat.com>
	<CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
	<addf0ca0d9cc381436209af3afdf878f.squirrel@webmail.greenhost.nl>
	<CABqD9hbBu8cEbArJWhSr-exFUDrnLSXskP1RrTATBczH2MYzFA@mail.gmail.com>
	<293e9587acd158b91d7d1793c7e16f7c.squirrel@webmail.greenhost.nl>
	<CABqD9hY2Uhc2Gzy05+Q+_NrZAq+126+avAO0Kd81zDnEi3EXjQ@mail.gmail.com>
	<9642e1197443efe9716f418c4883489e.squirrel@webmail.greenhost.nl>
	<CAGXu5jJvjq5f7Qw1ADh120jAtUsH+L4BW6CY+uaD7GFN53nPBw@mail.gmail.com>
	<CABqD9hYP9TOhZLEXbTc-koba4x=z2wdkuNeh3AUmTWcw0+Ywxg@mail.gmail.com>
Date: Tue, 17 Jan 2012 15:09:18 -0600
Message-ID: <CABqD9hbKPBmdRz8taASiBoB22bKK2AFVRcX7-VUNg9d3JYMufQ@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: Indan Zupancic <indan@nul.nu>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org,
        Roland McGrath <mcgrathr@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 2:42 PM, Will Drewry <wad@chromium.org> wrote:
> On Tue, Jan 17, 2012 at 2:34 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Jan 16, 2012 at 10:46 PM, Indan Zupancic <indan@nul.nu> wrote:
>>> So call it once and store the value in a long. Then copy the low half
>>> to the right place and then the upper half when on 64 bits. It may not
>>> look too pretty, but the compiler should be able to optimise almost all
>>> overhead away and end up with 6 (or 12) int copies. Something like this:
>>>
>>> struct bpf_data {
>>>        uint32 syscall_nr;
>>>        uint32 arg_low[MAX_SC_ARGS];
>>>        uint32 arg_high[MAX_SC_ARGS];
>>> };
>>>
>>> void fill_bpf_data(struct task_struct *t, struct pt_regs *r, struct bpf_data *d)
>>> {
>>>        int i;
>>>        unsigned long arg;
>>>
>>>        d->syscall_nr = syscall_get_nr(t, r);
>>>        for (i = 0; i < MAX_SC_ARGS; ++i){
>>>                syscall_get_arguments(t, r, i, 1, &arg);
>>>                d->arg_low[i] = arg;
>>>                d->arg_high[i] = arg >> 32;
>>>        }
>>> }
>>
>> If this turns out to be expensive, it might be possible to break it up
>> and load the arguments on demand (and cache them); i.e. have
>> load_pointer() or similar notice when it is about to access something
>> other than bpf_data.syscall_nr.
>
> Makes perfect sense!  In theory (as a few other people pointed this
> out off list), it is entirely possible to never populate any data for
> load_pointer except an optional cache.  Just provide a custom
> load_pointer that knows to take the offset return the syscall nr or
> the args or some slice of the returned data.
>
> This is even easier if the struct looks like:
> struct {
>  int nr;
>  union {
>    uint32_t args32[6];
>    uint64_t args64[6];
>  }
> };
>
> since you can just use the offset without doing any endian-based
> splitting.  Another suggestion (thanks roland!) was to add
>  int syscall_arch;
> to the struct populated with the AUDIT_ARCH_* defines.  This would
> help the case Indan was worried about -- portable filter programs.
>
> It looks like there'd be some cross-arch plumbing to make the
> AUDIT_ARCH_ data available, but not too bad.
>
> Seem sane? I'm headed down this path now and I think it'll work out
> assuming there aren't major objections to the syscall_arch piece.

Hrm. I'm still not so sure about the arch bit.  Without it, BPF
programs aren't directly share-able, but they could be as long as the
values for k and syscall numbers are being adapted.  By putting arch
in the program, it makes it more likely that every system call will
have a bpf preamble that has to check the syscall_arch.  It could
easily add 100s of nanoseconds to every call (on slower arches).

I'll probably do the next patch series without arch-checking support
then I can add if it is seems needed.  Nothing forces a filter program
to check it, so it could be that we let the author make the decision.

cheers!
will
