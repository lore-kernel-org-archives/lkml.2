Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab2B0UAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 15:00:48 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42827 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754905Ab2B0UAl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 15:00:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keescook@google.com designates 10.182.12.74 as permitted sender) smtp.mail=keescook@google.com; dkim=pass header.i=keescook@google.com
MIME-Version: 1.0
In-Reply-To: <1330370733.2542.18.camel@localhost>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
	<1330140111-17201-6-git-send-email-wad@chromium.org>
	<20120226202828.GE3990@outflux.net>
	<CABqD9hbKU=EVagCfo25AZsNoq=hmzkeOxK6mE=q8m=Be-ZFb9w@mail.gmail.com>
	<1330361396.2542.11.camel@localhost>
	<CAGXu5jKJ7pYeULM=CvifpQ8jUoyH6Ska2Znx9tGjhz0tn5kZmQ@mail.gmail.com>
	<1330370733.2542.18.camel@localhost>
Date: Mon, 27 Feb 2012 12:00:37 -0800
X-Google-Sender-Auth: hij1hTg_j9gBR54vvt2sDLmlba0
Message-ID: <CAGXu5jKyLHLF+HuU=SLHJLg8AaOPJXoqq1=hOBy5oOvffA-xiQ@mail.gmail.com>
Subject: Re: [PATCH v11 06/12] seccomp: add system call filtering using BPF
From: Kees Cook <keescook@chromium.org>
To: Eric Paris <eparis@redhat.com>
Cc: Will Drewry <wad@chromium.org>, Kees Cook <kees@ubuntu.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 11:25 AM, Eric Paris <eparis@redhat.com> wrote:
> On Mon, 2012-02-27 at 10:55 -0800, Kees Cook wrote:
>> On Mon, Feb 27, 2012 at 8:49 AM, Eric Paris <eparis@redhat.com> wrote:
>
>> You mean as used in audit_log_exit() ? It looks like that depends on a
>> lot of state cached in __audit_syscall_entry() and finally triggered
>> in __audit_syscall_exit() (and ..._free()). I don't think this is
>> really want seccomp wants to be involved in.
>>
>> By CONFIG_AUDITSC, you mean CONFIG_AUDITSYSCALL? Without that set,
>> audit_seccomp is a no-op.
>>
>> The reason compat needs to be reported (or rather, arch) is because
>> just reporting syscall is ambiguous. It either needs arch or compat to
>> distinguish it.
>
> Yes, that is what I mean and you are right.  You shouldn't push the
> syscall in this record either.  If !audit_dummy_context() you are
> already going to get arch, syscall, and a0-a4 in the associated audit
> record.  Please do not duplicate that info.

Ah, in that case, please ignore the patch I just sent. Heh.

> It might make sense to have a separate audit_seccomp() path when
> audit_dummy_context() which includes arch, syscall, and a0-a4.

Ah! I think I understand what you mean now. If audit_dummy_context(),
then the syscall, arch, and a0-a4 were not already collected. Gotcha.

How do you envision it looking? I still see it as two distinct events
(the syscall itself, and the rejection). Would you want those details
added to the context structure to be reported at ..._exit() time? It
seems like context->type couldn't be used to see if those fields were
valid.

Something like:

void __audit_seccomp(unsigned long syscall, long signr)
{
        struct audit_buffer *ab;

        if (!audit_dummy_context()) {
                struct audit_context *context = current->audit_context;
                context->syscall_signr = signr;
                context->syscall_ip = KSTK_EIP(current);
                return;
        }

        ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
        audit_log_abend(ab, "seccomp", signr);
        audit_log_format(ab, " syscall=%ld", syscall);
        audit_log_format(ab, " ip=0x%lx", KSTK_EIP(current));
        audit_log_end(ab);
}

And then report syscall_ip and syscall_signr if syscall_signr != 0 in
the _exit()? I think everything else from audit_log_abend() will end
up in the _exit() report.

> It is my fault (85e7bac3) that we have syscall at all, but I'm on a new
> crusade to remove audit record duplication.  So I'd happily see a patch
> in this series that removes that instead of adds to it.

Well, I think the abend reporting is nice; I'd hate to see that
totally removed. The seccomp case is a bit different, I agree. I could
see it either way.

-Kees

-- 
Kees Cook
ChromeOS Security
