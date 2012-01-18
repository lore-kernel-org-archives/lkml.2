Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab2ARErR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:47:17 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:49187 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2ARErP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:47:15 -0500
Message-ID: <e6bc7a5b7bca20855c6e7b9c66e9662e.squirrel@webmail.greenhost.nl>
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
Date: Wed, 18 Jan 2012 05:47:11 +0100
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using
 BPF
From: "Indan Zupancic" <indan@nul.nu>
To: "Will Drewry" <wad@chromium.org>
Cc: "Kees Cook" <keescook@chromium.org>, "Oleg Nesterov" <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org,
        "Roland McGrath" <mcgrathr@google.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 897836312160ed0141c32cdc6ac56212
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, January 17, 2012 21:42, Will Drewry wrote:
> On Tue, Jan 17, 2012 at 2:34 PM, Kees Cook <keescook@chromium.org> wrote:
>> If this turns out to be expensive, it might be possible to break it up
>> and load the arguments on demand (and cache them); i.e. have
>> load_pointer() or similar notice when it is about to access something
>> other than bpf_data.syscall_nr.
>
> Makes perfect sense!  In theory (as a few other people pointed this
> out off list), it is entirely possible to never populate any data for
> load_pointer except an optional cache.  Just provide a custom
> load_pointer that knows to take the offset return the syscall nr or
> the args or some slice of the returned data.

That sounds like a very good idea. I don't think the cache is needed
because an argument is usually only checked once.

> This is even easier if the struct looks like:
> struct {
>   int nr;
>   union {
>     uint32_t args32[6];
>     uint64_t args64[6];
>   }
> };
>
> since you can just use the offset without doing any endian-based
> splitting.

But then the filter has to know if it's 32 or 64-bit, and still know about
endianness, or am I missing something? It seems better to provide the upper
32 bits seperately so code that cares about it can check it.

> Another suggestion (thanks roland!) was to add
>   int syscall_arch;
> to the struct populated with the AUDIT_ARCH_* defines.  This would
> help the case Indan was worried about -- portable filter programs.

I never heard of AUDIT_ARCH* before, so I have no idea how it could be
used. Do you have a documentation pointer?

A quick scan through the kernel code seems it tells what arch the system is.

Such flag could be used to use the syscall number depending on what arch it
is, but I'm not sure that would make things cleaner or easier for anyone.
Still, it won't hurt to have it and at least gives that option.

> It looks like there'd be some cross-arch plumbing to make the
> AUDIT_ARCH_ data available, but not too bad.
>
> Seem sane? I'm headed down this path now and I think it'll work out
> assuming there aren't major objections to the syscall_arch piece.

I'm not sure about the union, and no objections to syscall_arch if it just
tells what arch it is.

Greetings,

Indan


