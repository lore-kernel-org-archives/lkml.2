Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2GFAlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:41:22 -0400
Received: from ozlabs.org ([203.10.76.45]:44854 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab2GFAlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:41:21 -0400
From: Michael Neuling <mikey@neuling.org>
To: Kay Sievers <kay@vrfy.org>
cc: linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
In-reply-to: <1341492628.834.3.camel@mop>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org> <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com> <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com> <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com> <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com> <1340726856.977.6.camel@mop> <22482.1341471787@neuling.org> <CAPXgP11=o5WB4WejaQCSCL-+5e4sL7tfVz_r3Khyrq3SyrMvsA@mail.gmail.com> <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com> <16043.1341483625@neuling.org> <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com> <1341492628.834.3.camel@mop>
Comments: In-reply-to Kay Sievers <kay@vrfy.org>
   message dated "Thu, 05 Jul 2012 14:50:28 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Fri, 06 Jul 2012 10:41:19 +1000
Message-ID: <30233.1341535279@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay@vrfy.org> wrote:

> On Thu, 2012-07-05 at 13:47 +0200, Kay Sievers wrote:
> > On Thu, Jul 5, 2012 at 12:20 PM, Michael Neuling <mikey@neuling.org> wrote:
> > 
> > > I can only make 2) happen on SMP.  It's when the second CPU is coming up
> > > and it's printing something.  The first CPU isn't printing anything at
> > > this stage (there is no garbled console here) so I don't think it's a
> > > race.  I see it consistently in show_regs().  Every printk without a
> > > newline.  ie I get this:
> > > ---
> > > NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
> > > REGS: c00000007e59fb50 TRAP: 0700   Tainted: G        W     (3.5.0-rc5-mikey)
> > > MSR: 9000000000021032
> > > <
> > > SF
> > > ,HV
> > > ,ME
> > > ,IR
> > > ,DR
> > > ,RI
> > >>
> > >   CR: 28000042  XER: 22000000
> > > SOFTE: 0
> > > CFAR: c0000000007402f8
> > > TASK = c00000007e56bb40[0] 'swapper/1' THREAD: c00000007e59c000
> > >  CPU: 1
> > > ---
> > >
> > > It's consistent for printks without newlines in show_regs().  MSR
> > > through to XER should all be on the same line.
> > 
> > I see. Something to fix then, I'll have a look.
> > 
> > Does this happen only very early during bootup, or also later when the
> > box fully initialized?

I'm seeing during boot but not later (xmon (ppc kernel debugger) doesn't
see it if I do 'echo x > /proc/sysrq-trigger') .  I wouldn't say
it's "very early boot".  It's a secondary CPU coming up and the primary
is waiting for it.  We've already configured the console when this
happens.

> > 
> > The output of 'dmesg' later looks always correct, right?

No, dmesg also has the extra new lines: eg

<4>NIP: c00000000004e234 LR: c00000000004e230 CTR: 0000000000000000
<4>REGS: c00000007c3b7b50 TRAP: 0700   Tainted: G        W     (3.5.0-rc4-mikey)
<4>MSR: 9000000000021032 
<4><
<4>SF
<4>,HV
<4>,ME
<4>,IR
<4>,DR
<4>,RI
<4>>
<4>  CR: 28000042  XER: 22000000
<4>SOFTE: 0
<4>CFAR: c0000000008139b4
<4>TASK = c00000007c3a4e00[0] 'swapper/1' THREAD: c00000007c3b4000
<4> CPU: 1
<4>

> If it's an early printk issue like it looks like, where stuff got
> printed before we had any console registered, this might fix the issue
> you are seeing.
>
> Could you possibly try this patch?

Sorry, doesn't help.  It also reprints the entire boot log to the
console once the console get inited.

FWIW HVC RTAS is the console.

Mikey

> 
> Thanks,
> Kay
> 
> 
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1957,6 +1951,12 @@ skip:
>  			 */
>  			console_idx = log_next(console_idx);
>  			console_seq++;
> +			/*
> +			 * We will get here again when we register a new
> +			 * CON_PRINTBUFFER console. Clear the flag so we
> +			 * will properly dump everything later.
> +			 */
> +			msg->flags &= ~LOG_NOCONS;
>  			goto skip;
>  		}
>  
> 
