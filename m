Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2BWT1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:27:04 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58943 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736Ab2BWT07 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:26:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=4xhqndEw3tMPaUcdZh_jcjQcoK_=7GwOc5gVhnz5o_4eWzQ@mail.gmail.com>
References: <1329845435-2313-1-git-send-email-wad@chromium.org>
	<1329845435-2313-7-git-send-email-wad@chromium.org>
	<9edbabb2262e3d91a7b8c75dbec03d7f.squirrel@webmail.greenhost.nl>
	<CABqD9hY1n9EOAKKT0r9Ev+azhBMnLMAM_FgDNe5we9upVePk_A@mail.gmail.com>
	<CAObL_7Gc0U2JMBQr_kbcVUJwyJq7LRfgdFr+84LR=ec4kSCwEA@mail.gmail.com>
	<CAGXu5jJQrnkCZtcLqK8NEihRgB25C12b0nKp+XWXV_=4QfcVoA@mail.gmail.com>
	<CABqD9hbC8v-rUBW+4T_-EwDwe1+VDohQZweQ-cxOg2A-iDH5CQ@mail.gmail.com>
	<CAGXu5j+fQqkrrKSm3kmCkCcZJKo-VZjL6kkrOD81LZYBY7tf2g@mail.gmail.com>
	<4F45887A.5010809@zytor.com>
	<CAB=4xhq1sm_ewZ_8Kerf2aN7nGx+DEENse7Lqg5N0wuvqtzUAw@mail.gmail.com>
	<4F459109.1060205@zytor.com>
	<CAB=4xhqndEw3tMPaUcdZh_jcjQcoK_=7GwOc5gVhnz5o_4eWzQ@mail.gmail.com>
Date: Thu, 23 Feb 2012 13:26:57 -0600
Message-ID: <CABqD9hbsZTtkFzM_8rHqAWjZhiV0iWb6s1eMF9LriH-NybrorA@mail.gmail.com>
Subject: Re: [PATCH v10 07/11] signal, x86: add SIGSYS info and make it synchronous.
From: Will Drewry <wad@chromium.org>
To: Roland McGrath <mcgrathr@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Andrew Lutomirski <luto@mit.edu>, Indan Zupancic <indan@nul.nu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 11:38 AM, Roland McGrath <mcgrathr@google.com> wrote:
> On Wed, Feb 22, 2012 at 5:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I meant whether or not a signal can be blocked/caught and the fact that
>> the signal exists at all.
>>
>> Now I guess we could have "blockable" and "unblockable" SIGSYS, but that
>> would seem to have its own set of issues...
>
> Oh.  I certainly don't think we should ever add any new signals to the set
> that cannot be caught, blocked, or ignored.  That has been just SIGKILL and
> SIGSTOP since 4.2BSD, which first introduced the modern concept of blocking
> signals.  There are lots of reasons not to change that, which I won't go
> into unless someone really wants me to.
>
> However, I don't think there is anything really wrong with having certain
> cases that generate a signal and at the same time unblock it and reset it
> to SIG_DFL.  That's just an implementation detail of a policy of "dump core
> right now, no other option".  (Conversely, directly calling do_exit won't
> ever dump core, though it can be made to look signalesque to the parent and
> tracers.)
>
> For seccomp-filter, I personally don't see any problem with simply
> generating SIGSYS in the normal way (and aborting the syscall, of course).
> If someone wants to ensure that SIGSYS is never caught or blocked, they can
> just do that by having a filter that doesn't allow it to be caught or
> blocked (and of course make sure to reset its inherited state).  It is a
> bit tricky to cover all the ways, since it's not just sigaction and
> sigprocmask but also sigreturn, where the blocked signal set to be restored
> is in a slightly arcane location--but it ain't rocket science.
>
> But I don't really have any strong opinion about what seccomp-filter should
> do.  (Though it does seem worthwhile not to rule out the possibility of
> dumping core on a policy violation, since that will be useful for people to
> debug their code.)

Seems like there's an argument for another return code,
SECCOMP_RET_CORE, that resets/unblocks the SIGSYS handler since the
existing TRAP and KILL options seem to cover the other paths (signal
handler and do_exit).

It's a very small tweak if that'd be useful to include explicitly.

Thanks!
will
