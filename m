Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0KBDhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 23:37:22 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47057 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab0KBDhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 23:37:20 -0400
Date: Tue, 2 Nov 2010 14:07:10 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Cross Memory Attach
Message-ID: <20101102140710.5f2a6557@lilo>
In-Reply-To: <4C91E2CC.9040709@redhat.com>
References: <20100915104855.41de3ebf@lilo>
	<4C90A6C7.9050607@redhat.com>
	<AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com>
	<20100916104819.36d10acb@lilo>
	<4C91E2CC.9040709@redhat.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 11:26:36 +0200
Avi Kivity <avi@redhat.com> wrote:
>   On 09/16/2010 03:18 AM, Christopher Yeoh wrote:
> > On Wed, 15 Sep 2010 23:46:09 +0900
> > Bryan Donlan<bdonlan@gmail.com>  wrote:
> >
> > >  On Wed, Sep 15, 2010 at 19:58, Avi Kivity<avi@redhat.com>  wrote:
> > >
> > >  >  Instead of those two syscalls, how about a vmfd(pid_t pid,
> > >  > ulong start, ulong len) system call which returns an file
> > >  > descriptor that represents a portion of the process address
> > >  > space.  You can then use preadv() and pwritev() to copy
> > >  > memory, and io_submit(IO_CMD_PREADV) and
> > >  > io_submit(IO_CMD_PWRITEV) for asynchronous variants
> > >  > (especially useful with a dma engine, since that adds latency).
> > >  >
> > >  >  With some care (and use of mmu_notifiers) you can even mmap()
> > >  > your vmfd and access remote process memory directly.
> > >
> > >  Rather than introducing a new vmfd() API for this, why not just
> > > add implementations for these more efficient operations to the
> > > existing /proc/$pid/mem interface?
> >
> > Perhaps I'm misunderstanding something here, but
> > accessing /proc/$pid/mem requires ptracing the target process.
> > We can't really have all these MPI processes ptraceing each other
> > just to send/receive a message....
> >
> 
> You could have each process open /proc/self/mem and pass the fd using 
> SCM_RIGHTS.
> 
> That eliminates a race; with copy_to_process(), by the time the pid
> is looked up it might designate a different process.

Just to revive an old thread (I've been on holidays), but this doesn't
work either. the ptrace check is done by mem_read (eg on each read) so
even if you do pass the fd using SCM_RIGHTS, reads on the fd still
fail. 

So unless there's good reason to believe that the ptrace permission
check is no longer needed, the /proc/pid/mem interface doesn't seem to
be an option for what we want to do.

Oh and interestingly reading from /proc/pid/mem involves a double copy
- copy to a temporary kernel page and then out to userspace. But that is
fixable.

Regards,

Chris
-- 
cyeoh@ozlabs.org
