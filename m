Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab1FPJ4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:56:23 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:41914 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531Ab1FPJ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:56:21 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#4
Date: Thu, 16 Jun 2011 10:56:17 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <201106031125.16071.pedro@codesourcery.com> <20110616083828.GJ8141@htj.dyndns.org>
In-Reply-To: <20110616083828.GJ8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161056.17798.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thursday 16 June 2011 09:38:28, Tejun Heo wrote:
> On Fri, Jun 03, 2011 at 11:25:15AM +0100, Pedro Alves wrote:
> > It'd be _very_ useful for x86 (and others) to have
> > something like TRAP_BRKPT for int3.  Both for ptracers
> > and in-process self debuggers.
> > 
> > I'd be super happy to be told we have that already
> > in recent kernels and I missed it.  :-)
> 
> Unfortunately, AFAICS, x86 doesn't have it nor is there a generic
> mechanism, but this should be solvable without disrupting existing
> users.

Hmm, looks like there was an earlier attempt:

<http://lkml.indiana.edu/hypermail/linux/kernel/0809.2/1898.html>

Reading that thread, there were some minor revisions, but I didn't
see any objection.  It seems that patch made it 2.6.28 (the only
sources I have handy), as I see get_si_code calls in arch/x86/kernel/traps.c,
and arch/x86/include/asm/traps.h.

But, I'm running 2.6.38, x86-64, and 

#include <stdio.h>
#include <string.h>
#include <signal.h>

static void
handler (int sig, siginfo_t *info, void *context)
{
  printf ("si_code = %x\n", info->si_code);
}

int
main (void)
{
  struct sigaction action;

  memset (&action, 0, sizeof (action));
  action.sa_sigaction = handler;
  action.sa_flags |= SA_SIGINFO;
  sigaction (SIGTRAP, &action, NULL);

  asm volatile ("int3");

  return 0;
}

still prints:

$ ./trap 
si_code = 80

Hmm...  I don't have any other kernel version sources or
git checkout handy at the moment to check the history
behind this.

-- 
Pedro Alves
