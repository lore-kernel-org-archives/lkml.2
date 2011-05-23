Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1EWMLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab1EWMLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:11:48 -0400
Date: Mon, 23 May 2011 14:10:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: Ptrace documentation, draft #1
Message-ID: <20110523121011.GA5799@redhat.com>
References: <201105152235.32073.vda.linux@googlemail.com> <20110516153122.GA15856@redhat.com> <BANLkTintE-QVUJhJY-_A5nvgj7viJatZ4Q@mail.gmail.com> <20110519194908.GA26584@redhat.com> <BANLkTi=bRb+NCqqS9+ptzxHVOjKKXhZgsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=bRb+NCqqS9+ptzxHVOjKKXhZgsg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Denys Vlasenko wrote:
>
> On Thu, May 19, 2011 at 9:49 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Once again, PTRACE_KILL == ptrace(PTRACE_CONT, SIGKILL), except it
> > doesn't return the error if the tracee is not stopped.
>
> Oleg, this doesn't explain the resulting behavior in terms understandable
> to mere mortals. *What will happen* when user does ptrace(PTRACE_KILL)?
>
> Yes, it's obvious that the tracee gets SIGKILLed,

No, it is not necessarily killed. Once again, it is equivalent to PTRACE_CONT
except it returns 0 (but does nothing) if the tracee is not stopped.

"does nothing" is not 100% true, it does wake_up_process() but this shouldn't
be documented, this should be fixed.

> >> >> ??? can this SIGTRAP be distinguished from "real" user-generated SIGTRAP
> >> >>     by looking at its siginfo?
> >> >
> >> > Afaics no. Well, except .si_pid shows that the signal was sent by the
> >> > tracing process to itself.
> >>
> >> What about si_code? Is it set to SI_KERNEL for this signal?
> >
> > No, SI_USER.
>
> This is stupid. This signal is sent by kernel. Why is it flagged as "from user"?
> Maybe we should change it?

Well, may be... I dunno actually. Hmm. On a second thought you are probably
right. ptrace_report_syscall() does send_sig() too, but it sets SI_KERNEL.
I am starting to think, at least they should use the same si_code.

> (BTW, where is it generated in the kernel source? I found
> PTRACE_EVENT_EXEC generation, but failed to find
> "old-school SIGTRAP" generation code...)

tracehook_report_exec()->send_sig(SIGTRAP).

Oleg.

