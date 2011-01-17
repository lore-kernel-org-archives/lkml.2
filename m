Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1AQTq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:46:28 -0500
Received: from racecourse.oldelvet.net ([93.93.128.81]:47695 "EHLO
	racecourse.oldelvet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1AQTqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:46:24 -0500
Subject: R_SPARC_13 (Re: Bug#609371: linux-image-2.6.37-trunk-sparc64:
 module scsi_mod: Unknown relocation: 36)
From: Richard Mortimer <richm@oldelvet.org.uk>
To: David Miller <davem@davemloft.net>
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Jesper.Nilsson@axis.com, jeffm@suse.com
In-Reply-To: <1295259761.32152.20.camel@duncow>
References: <4D302B2F.7030108@oldelvet.org.uk>
	 <4D3074FE.3030707@oldelvet.org.uk>
	 <20110115.211722.39173519.davem@davemloft.net>
	 <20110116.220755.179947617.davem@davemloft.net>
	 <1295259761.32152.20.camel@duncow>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 19:46:21 +0000
Message-ID: <1295293581.32152.70.camel@duncow>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 10:22 +0000, Richard Mortimer wrote:
> On Sun, 2011-01-16 at 22:07 -0800, David Miller wrote:
> > From: David Miller <davem@davemloft.net>
> > Date: Sat, 15 Jan 2011 21:17:22 -0800 (PST)
> 
> > > I think the problem we have here is that the _ftrace_events section is
> > > not aligned sufficiently.  That ".align 4" mnemonic is a good indication
> > > of this.  It should at least "8" on sparc64.
> > 
> I noticed another potentially 64 bit unfriendly alignment on struct
> tracepoint in include/linux/tracepoint.h. I don't think that the
> alignment of 32 breaks anything but it does leave a 24 byte hole. I
> don't know enough about tracing to know if that is necessary.
> 
> struct tracepoint {
>         const char *name;               /* Tracepoint name */
>         int state;                      /* State. */
>         void (*regfunc)(void);
>         void (*unregfunc)(void);
>         struct tracepoint_func *funcs;
> }  __attribute__((aligned(32)));        /*
>                                          * Aligned on 32 bytes because it is
>                                          * globally visible and gcc happily
>                                          * align these on the structure size.
>                                          * Keep in sync with vmlinux.lds.h.
>                                          */
> 
> Note I spotted this when looking at some residual sparc64 relocation
> issues when _ftrace_events alignment is changed to 8. I'll follow those
> issues up in a separate email when I get time later today.

I did some experiments looking at what happens when the
include/trace/ftrace.h __aligned__(4) usages for _ftrace_events are
changed to __aligned__(8). This causes the R_SPARC_UA64 relocations to
go to R_SPARC_64 and gets rid of that particular issue.

However it does not cause the R_SPARC_13 relocation records to go away.
They still persist and the ones I've looked at are be related to uses of
struct tracepoint that I mentioned earlier. I tried various different
values of alignment for both __ftrace_events and struct tracepoint but
nothing made the uses of R_SPARC_13 go away.

As an example from drivers/scsi/scsi_error.c function scsi_eh_wakeup().

This has relocation records of

0000000000002be0 R_SPARC_HI22      __tracepoint_scsi_eh_wakeup
0000000000002be4 R_SPARC_LO10      __tracepoint_scsi_eh_wakeup
0000000000002be4 R_SPARC_13        *ABS*+0x0000000000000008
0000000000002bf4 R_SPARC_LO10      __tracepoint_scsi_eh_wakeup
0000000000002bf4 R_SPARC_13        *ABS*+0x0000000000000020

for the following assembly code

sethi  %hi(__tracepoint_scsi_eh_wakeup), %g1   !, tmp135
lduw    [%g1+%lo(__tracepoint_scsi_eh_wakeup)+8], %g2   ! __tracepoint_scsi_eh_wakeup.state,
cmp     %g2, 0  ! __tracepoint_scsi_eh_wakeup.state,
be,pt   %icc, .LL454
nop    !
ldx     [%g1+%lo(__tracepoint_scsi_eh_wakeup)+32], %l0  !, it_func_ptr
brz,pn  %l0, .LL454     ! it_func_ptr,

this corresponds to the first few lines of

void scsi_eh_wakeup(struct Scsi_Host *shost)
{
        if (shost->host_busy == shost->host_failed) {
                trace_scsi_eh_wakeup(shost);
                wake_up_process(shost->ehandler);
                SCSI_LOG_ERROR_RECOVERY(5,
                                printk("Waking error handler thread\n"));
        }
}


If I try compiling with the -Os option removed from KBUILD_CFLAGS it
produces a more traditional R_SPARC_HI22 and R_SPARC_LO10 output as
shown below. So maybe there is a really need to add R_SPARC_13 support
to the sparc64 module loader to allow for the optimizations that the
compiler is making now.

00000000000001bc R_SPARC_HI22      __tracepoint_scsi_eh_wakeup
00000000000001c0 R_SPARC_LO10      __tracepoint_scsi_eh_wakeup
00000000000001dc R_SPARC_HI22      __tracepoint_scsi_eh_wakeup+0x0000000000000020
00000000000001e0 R_SPARC_LO10      __tracepoint_scsi_eh_wakeup+0x0000000000000020


        ldx     [%fp+2175], %g1 ! shost, tmp123
        stx     %g1, [%fp+2007] ! tmp123, shost
        sethi   %hi(__tracepoint_scsi_eh_wakeup), %g1   !, tmp125
        or      %g1, %lo(__tracepoint_scsi_eh_wakeup), %g1      ! tmp125,, tmp124
        ld      [%g1+8], %g1    ! __tracepoint_scsi_eh_wakeup.state, D.32824
        xor     %g1, 0, %g1     ! D.32824,, tmp126
        subcc   %g0, %g1, %g0   !, tmp126
        addx    %g0, 0, %g1     !,, D.32823
        brz     %g1, .LL3
         nop    ! D.32822,
        sethi   %hi(__tracepoint_scsi_eh_wakeup+32), %g1        !, tmp127
        or      %g1, %lo(__tracepoint_scsi_eh_wakeup+32), %g1   ! tmp127,, D.32820
        ldx     [%g1], %g1      !* D.32820, tmp128
        stx     %g1, [%fp+2015] ! tmp128, _________p1

Regards

Richard

