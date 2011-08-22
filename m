Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1HVX2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:28:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab1HVX2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:28:32 -0400
MIME-Version: 1.0
In-Reply-To: <4E52D280.3010107@zytor.com>
References: <20110822011645.GM2203@ZenIV.linux.org.uk> <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
 <4E51B56F.3080301@zytor.com> <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com>
 <20110822020737.GP2203@ZenIV.linux.org.uk> <CAObL_7HY7qFUoqtNju42=BHTR8WuuW-cL_cQh_uUfx_7gFfHRg@mail.gmail.com>
 <4E51D597.3060800@zytor.com> <20110822095336.GB25949@kernel.org>
 <CAObL_7F6D8nQovf+aJGiEOF1mBpBU8RwtjNA-5myxvEBRRHgsg@mail.gmail.com>
 <20110822144051.GD2946@aftab> <20110822151305.GV2203@ZenIV.linux.org.uk>
 <CA+55aFwoRO9xxnTyt_gYFdTS9LsaFoCWRuyNeXY7gvrE8CdZ0A@mail.gmail.com>
 <4E52B7F8.3050002@zytor.com> <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com>
 <4E52D280.3010107@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 22 Aug 2011 16:27:51 -0700
Message-ID: <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Lutomirski <luto@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 3:04 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> However, we could just issue a SIGILL or SIGSEGV at this point; the same
> way we would if we got an #UD or #GP fault; SIGILL/#UD would be
> consistent with Intel CPUs here.

Considering that this is not a remotely new issue, and that it has
been around for years without anybody even noticing, I'd really prefer
to just fix things going forwards rather than add any code to actively
break any possible unlucky legacy users.

So I think the "let's fix the vdso case for sysenter" + "let's remove
the 32-bit syscall vdso" is the right solution. If somebody has
hardcoded syscall instructions, or generates them dynamically with
some JIT, that's their problem. We'll continue to support it as well
as we ever have (read: "almost nobody will ever notice").

One thing we *could* do is to just say "we never restart a x86-32
'syscall' instruction at all", and just make such a case return EINTR.
IOW, do something along the lines of the appended pseudo-patch.

Because returning -EINTR is always "almost correct".

Hmm?

                               Linus

---
  diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
  index 54ddaeb221c1..bc1a0f8b2707 100644
  --- a/arch/x86/kernel/signal.c
  +++ b/arch/x86/kernel/signal.c
  @@ -678,6 +678,16 @@ setup_rt_frame(int sig, struct k_sigaction *ka,
siginfo_t *info,
   	return ret;
   }

  +static void restart_syscall(struct pt_regs *regs, int orig)
  +{
  +	if (regs->syscall_using_syscall_insn) {
  +		regs->ax = -EINTR;
  +		return;
  +	}
  +	regs->ax = orig;
  +	regs->ip -= 2;
  +}
  +
   static int
   handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
   		struct pt_regs *regs)
  @@ -701,8 +711,7 @@ handle_signal(unsigned long sig, siginfo_t
*info, struct k_sigaction *ka,
   			}
   		/* fallthrough */
   		case -ERESTARTNOINTR:
  -			regs->ax = regs->orig_ax;
  -			regs->ip -= 2;
  +			restart_syscall(regs, regs->orig_ax);
   			break;
   		}
   	}
  @@ -786,13 +795,11 @@ static void do_signal(struct pt_regs *regs)
   		case -ERESTARTNOHAND:
   		case -ERESTARTSYS:
   		case -ERESTARTNOINTR:
  -			regs->ax = regs->orig_ax;
  -			regs->ip -= 2;
  +			restart_syscall(regs, regs->orig_ax);
   			break;

   		case -ERESTART_RESTARTBLOCK:
  -			regs->ax = NR_restart_syscall;
  -			regs->ip -= 2;
  +			restart_syscall(regs, NR_restart_syscall);
   			break;
   		}
   	}
