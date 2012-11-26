Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2KZMzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 07:55:06 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:47352 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab2KZMzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 07:55:04 -0500
Subject: Re: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range check)
To: avagin@gmail.com (Andrey Wagin)
Date: Mon, 26 Nov 2012 23:55:01 +1100 (EST)
Cc: gorcunov@openvz.org (Cyrill Gorcunov), oleg@redhat.com (Oleg Nesterov),
        xemul@parallels.com (Pavel Emelyanov),
        rostedt@goodmis.org (Steven Rostedt),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra),
        linux-kernel@vger.kernel.org (LKML)
Reply-To: u3557@dialix.com.au
In-Reply-To: <CANaxB-yCSrUMQbjrZPMoHp0hN+uUuRDCW6yRazFYX1YR_di9dQ@mail.gmail.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121126125502.0FDDD592064@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

So what do you do if a catched interrupt occured inside vdso code?

You can easily detect that the task is currently in vdso code,
then delay its dump, but how do you detect whether a sigreturn()
or even a series of sigreturn()s won't bring it back to the middle
of some old vdso code?

You could of course keep that old code and modify only the very
first instruction of each routine into a jump instruction, but then
the code to which the process returns may not be compatible with
the new kernel and/or hardware configuration.

You cannot even rely on a vdso enter/exit counter, because interrupt
code can use "longjmp()".

My idea was to introduce a kernel option saying "don't send me any
catched signals while the program-counter is in this range (eg. the
vdso page), but I was told that it is not feasible to implement it.

Regards,
Amnon.

> 2012/11/26 Cyrill Gorcunov <gorcunov@openvz.org>:
> > On Thu, Nov 22, 2012 at 05:12:38PM +0100, Oleg Nesterov wrote:
> >> On 11/22, Amnon Shiloh wrote:
> >> >
> >> > Now however, that "vsyscall" was effectively replaced by vdso, it
> >> > creates a new problem for me and probably for anyone else who uses
> >> > some form of checkpoint/restore:
> >>
> >> Oh, sorry, I can't help here. I can only add Cyrill and Pavel, they
> >> seem to enjoy trying to solve the c/r problems.
> >
> > Hi Oleg, Amnon, sorry for delay on this message. First of all, I'm
> > not vDSO specialist but as to c/r aspect of it I've had in mind the
> > the following scenario: we dump vDSO area either complete euther simply
> > remember the functions addresses it provides, then on restore we replace
> > the functions prologue with jmp instruction which would point to the
> > vDSO entries provided us by a kernel. But again, I didn't spend much time
> > for vDSO yet.
> 
> I think this approach should work. Here is a bit more details:
> 1. A task will be not dumped in vdso code. If a task is in vdso code,
> we will try to catch it again.
> 2. Only addresses of vdso symbols will be dumped.
> 3. On restore we will compare addresses of symbols. If addresses are
> not changes, a new vdso will be mapped instead of old one. If they are
> changed, a new vdso will be mapped in a free space and the old vdso
> will be replaced on a proxy library, where all functions are replaced
> on jumps to suitable functions in the new vdso.
> 
> Looks simple and does not required to hack a kernel.
> 
> >
> >         Cyrill
> 

