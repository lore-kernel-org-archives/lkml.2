Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2B0TOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:14:11 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49919 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2B0TOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:14:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keescook@google.com designates 10.60.28.10 as permitted sender) smtp.mail=keescook@google.com; dkim=pass header.i=keescook@google.com
MIME-Version: 1.0
In-Reply-To: <CAObL_7GZVrHpQ0yR9LihQ=UrjAR=BOLRT1F0m4JGGRbEeh=-fQ@mail.gmail.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
	<1330140111-17201-7-git-send-email-wad@chromium.org>
	<20120227171132.GB10608@redhat.com>
	<CAGXu5jJQhfSSwTU5fSGR_Q57LAQBFW25A_FtR2GFsxyT_ibnzQ@mail.gmail.com>
	<20120227181434.GA13903@redhat.com>
	<CAObL_7GZVrHpQ0yR9LihQ=UrjAR=BOLRT1F0m4JGGRbEeh=-fQ@mail.gmail.com>
Date: Mon, 27 Feb 2012 11:14:04 -0800
X-Google-Sender-Auth: kUh_h40BUQREljCArS3U47TF0Co
Message-ID: <CAGXu5jJGiLSRSgQ1nssLSMY1V+9X3y4Uh-kMgQG7moa6PPj3bw@mail.gmail.com>
Subject: Re: [PATCH v11 07/12] seccomp: add SECCOMP_RET_ERRNO
From: Kees Cook <keescook@chromium.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 10:35 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Mon, Feb 27, 2012 at 10:14 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 02/27, Kees Cook wrote:
>>>
>>> On Mon, Feb 27, 2012 at 9:11 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> > On 02/24, Will Drewry wrote:
>>> >>
>>> >>  static u32 seccomp_run_filters(int syscall)
>>> >>  {
>>> >>       struct seccomp_filter *f;
>>> >> -     u32 ret = SECCOMP_RET_KILL;
>>> >>       static const struct bpf_load_fn fns = {
>>> >>               bpf_load,
>>> >>               sizeof(struct seccomp_data),
>>> >>       };
>>> >> +     u32 ret = SECCOMP_RET_ALLOW;
>>> >>       const void *sc_ptr = (const void *)(uintptr_t)syscall;
>>> >>
>>> >> +     /* Ensure unexpected behavior doesn't result in failing open. */
>>> >> +     if (unlikely(current->seccomp.filter == NULL))
>>> >> +             ret = SECCOMP_RET_KILL;
>>> >
>>> > Is "seccomp.filter == NULL" really possible?
>>>
>>> It should not be, but I'm much more comfortable with this failing
>>> closed. I think it's important to be as defensive as possible with
>>> this code given its intended use.
>>
>> Can't resists... Sorry, I know I am troll but personally I think
>> in this case the most defensive code is BUG_ON(->filter == NULL)
>> or at least WARN_ON().
>
> Linus will probably object because he objected (correctly) to a very
> similar problem in my old vsyscall emulation series.  A userspace
> security feature shouldn't have a failure mode in which it confuses
> the kernel and results in an oops, unless the situation is really
> unrecoverable.  So WARN_ON plus do_exit would be okay but BUG_ON would
> not.

Yeah, actually, add WARN_ON would be preferred here because it should
be an impossible situation. It should still fail closed, though:

     /* Ensure unexpected behavior doesn't result in failing open. */
     if (WARN_ON(current->seccomp.filter == NULL))
             return SECCOMP_RET_KILL;

-Kees

-- 
Kees Cook
ChromeOS Security
