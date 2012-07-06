Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2GFDrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 23:47:52 -0400
Received: from ozlabs.org ([203.10.76.45]:35920 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab2GFDru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 23:47:50 -0400
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
In-reply-to: <29711.1341545979@neuling.org>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org> <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com> <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com> <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com> <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com> <1340726856.977.6.camel@mop> <22482.1341471787@neuling.org> <CAPXgP11=o5WB4WejaQCSCL-+5e4sL7tfVz_r3Khyrq3SyrMvsA@mail.gmail.com> <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com> <16043.1341483625@neuling.org> <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com> <1341492628.834.3.camel@mop> <30233.1341535279@neuling.org> <CAPXgP12_F_H2XPpo2wFmb-u3jBdV__=h67R-LVYbqHuLh7tqLg@mail.gmail.com> <29711.1341545979@neuling.org>
Comments: In-reply-to Michael Neuling <mikey@neuling.org>
   message dated "Fri, 06 Jul 2012 13:39:39 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Fri, 06 Jul 2012 13:47:49 +1000
Message-ID: <30343.1341546469@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling <mikey@neuling.org> wrote:

> Kay Sievers <kay@vrfy.org> wrote:
> 
> > On Fri, Jul 6, 2012 at 2:41 AM, Michael Neuling <mikey@neuling.org> wrote:
> > 
> > >> > Does this happen only very early during bootup, or also later when the
> > >> > box fully initialized?
> > >
> > > I'm seeing during boot but not later (xmon (ppc kernel debugger) doesn't
> > > see it if I do 'echo x > /proc/sysrq-trigger') .  I wouldn't say
> > > it's "very early boot".  It's a secondary CPU coming up and the primary
> > > is waiting for it.  We've already configured the console when this
> > > happens.
> > 
> > Sounds like an early boot console.
> > 
> > >> > The output of 'dmesg' later looks always correct, right?
> > >
> > > No, dmesg also has the extra new lines: eg
> > >
> > > <4>NIP: c00000000004e234 LR: c00000000004e230 CTR: 0000000000000000
> > > <4>REGS: c00000007c3b7b50 TRAP: 0700   Tainted: G        W     (3.5.0-rc4-mikey)
> > > <4>MSR: 9000000000021032
> > > <4><
> > > <4>SF
> > > <4>,HV
> > > <4>,ME
> > > <4>,IR
> > > <4>,DR
> > > <4>,RI
> > > <4>>
> > > <4>  CR: 28000042  XER: 22000000
> > 
> > Can you please paste the output of /dev/kmsg of this section? So we
> > can see the timestamps and what really went into the record buffer.
> 
> Sure.
> 
> 4,89,24561;NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
> 4,90,24576;REGS: c00000007e59fb50 TRAP: 0700   Tainted: G        W     (3.5.0-rc4-mikey)
> 4,91,24583;MSR: 9000000000021032 
> 4,92,24586;<
> 4,93,24591;SF
> 4,94,24596;,HV
> 4,95,24601;,ME
> 4,96,24606;,IR
> 4,97,24611;,DR
> 4,98,24616;,RI
> 4,99,24619;>
> 4,100,24628;  CR: 28000042  XER: 22000000

FWIW, compiling with the parent commit gives this:

4,89,1712;NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
4,90,1713;REGS: c00000007e59fb50 TRAP: 0700   Tainted: G        W     (3.5.0-rc4-mikey)
4,91,1716;MSR: 9000000000021032 <SF,HV,ME,IR,DR,RI>  CR: 22000082  XER: 02000000

Mikey

> 
> > 
> > >> Could you possibly try this patch?
> > >
> > > Sorry, doesn't help.  It also reprints the entire boot log to the
> > > console once the console get inited.
> > 
> > Which is the normal behaviour to do that, right? We should not have
> > touched any of that logic.
> 
> Not until this patch you asked me to try.  Hence why I noted it.  
> 
> Mikey
