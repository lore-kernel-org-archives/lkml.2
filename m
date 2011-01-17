Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1AQXeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 18:34:08 -0500
Received: from racecourse.oldelvet.net ([93.93.128.81]:40867 "EHLO
	racecourse.oldelvet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1AQXeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 18:34:07 -0500
Subject: Re: R_SPARC_13
From: Richard Mortimer <richm@oldelvet.org.uk>
To: David Miller <davem@davemloft.net>
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Jesper.Nilsson@axis.com, jeffm@suse.com
In-Reply-To: <20110117.130238.245404805.davem@davemloft.net>
References: <20110116.220755.179947617.davem@davemloft.net>
	 <1295259761.32152.20.camel@duncow> <1295293581.32152.70.camel@duncow>
	 <20110117.130238.245404805.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 23:34:03 +0000
Message-ID: <1295307243.32152.106.camel@duncow>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 13:02 -0800, David Miller wrote:
> From: Richard Mortimer <richm@oldelvet.org.uk>
> Date: Mon, 17 Jan 2011 19:46:21 +0000
> 
> > As an example from drivers/scsi/scsi_error.c function scsi_eh_wakeup().
> > 
> > This has relocation records of
>  ...
> > 0000000000002be4 R_SPARC_LO10      __tracepoint_scsi_eh_wakeup
> > 0000000000002be4 R_SPARC_13        *ABS*+0x0000000000000008
>  ...
> > lduw    [%g1+%lo(__tracepoint_scsi_eh_wakeup)+8], %g2   ! __tracepoint_scsi_eh_wakeup.state,
> 
> In a final object, the binutils linker should be using one
> R_SPARC_OLO10 relocation for this kind of expression on sparc64.  Not
> the two relocations on the same instruction it appears to be using
> here.  I think you're looking at an object output by the assembler
> and not the finally linked module.
> 
> You should also be careful about which objects you are analyzing.  You
> should be looking at the finally linked "foo.ko" file, not the
> individual "foo.o" objects, as the majority of the relocations go away
> when the linker puts together the final module.
> 
> Is that what you're doing?

Yes in this instance I was/am. Thanks for the explanation.

However the same R_SPARC_13 also exists in scsi_mod.ko. It exists in the
original Debian 2.6.37-trunk-sparc64 version and in my current build of
the same with the 8 byte alignment for _trace_events.


00000000000074a8 R_SPARC_HI22      __tracepoint_scsi_eh_wakeup
00000000000074ac R_SPARC_LO10      __tracepoint_scsi_eh_wakeup
00000000000074ac R_SPARC_13        *ABS*+0x0000000000000008
00000000000074bc R_SPARC_LO10      __tracepoint_scsi_eh_wakeup
00000000000074bc R_SPARC_13        *ABS*+0x0000000000000020

    74a8:       03 00 00 00     sethi  %hi(0), %g1
    74ac:       c4 00 60 00     ld  [ %g1 ], %g2
    74b0:       80 a0 a0 00     cmp  %g2, 0
    74b4:       02 48 00 0c     be  %icc, 74e4 <scsi_eh_wakeup+0x50>
    74b8:       01 00 00 00     nop
    74bc:       e0 58 60 00     ldx  [ %g1 ], %l0

I guess that points towards the binutils linker not doing the correct
thing.

ld reports its version as

$ ld -v
GNU ld (GNU Binutils for Debian) 2.20.1-system.20100303

and scsi_mod.ko is linked with the following command

ld -r -m elf64_sparc -T /richmtmp/linux-2.6-2.6.37/scripts/module-common.lds --build-id  -o drivers/scsi/scsi_mod.ko drivers/scsi/scsi_mod.o drivers/scsi/scsi_mod.mod.o

Regards

Richard

