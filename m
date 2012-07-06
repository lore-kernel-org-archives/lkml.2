Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab2GFKqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:46:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63097 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab2GFKqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:46:36 -0400
MIME-Version: 1.0
In-Reply-To: <30343.1341546469@neuling.org>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop> <22482.1341471787@neuling.org>
 <CAPXgP11=o5WB4WejaQCSCL-+5e4sL7tfVz_r3Khyrq3SyrMvsA@mail.gmail.com>
 <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com>
 <16043.1341483625@neuling.org> <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com>
 <1341492628.834.3.camel@mop> <30233.1341535279@neuling.org>
 <CAPXgP12_F_H2XPpo2wFmb-u3jBdV__=h67R-LVYbqHuLh7tqLg@mail.gmail.com>
 <29711.1341545979@neuling.org> <30343.1341546469@neuling.org>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 6 Jul 2012 12:46:16 +0200
Message-ID: <CAPXgP13_cQUQLE4RSjACTzj28Pn6r3ZaPhjch2U+uwgi7YKcWA@mail.gmail.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
To: Michael Neuling <mikey@neuling.org>
Cc: linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 5:47 AM, Michael Neuling <mikey@neuling.org> wrote:

>> 4,89,24561;NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
>> 4,90,24576;REGS: c00000007e59fb50 TRAP: 0700   Tainted: G        W     (3.5.0-rc4-mikey)
>> 4,91,24583;MSR: 9000000000021032
>> 4,92,24586;<
>> 4,93,24591;SF
>> 4,94,24596;,HV
>> 4,95,24601;,ME
>> 4,96,24606;,IR
>> 4,97,24611;,DR
>> 4,98,24616;,RI
>> 4,99,24619;>
>> 4,100,24628;  CR: 28000042  XER: 22000000
>
> FWIW, compiling with the parent commit gives this:
>
> 4,89,1712;NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
> 4,90,1713;REGS: c00000007e59fb50 TRAP: 0700   Tainted: G        W     (3.5.0-rc4-mikey)
> 4,91,1716;MSR: 9000000000021032 <SF,HV,ME,IR,DR,RI>  CR: 22000082  XER: 02000000

Hmm, I don't understand, which parent commit do you mean? You maybe
mean without 084681d?

I think it's a race of the two CPUs printing continuation lines, and
the continuation buffer is still occupied with data from one CPU and
not available to the other one at the same time.

What you see is likely not the direct output to the console (that
would work) but the replay of the stored buffer when the console is
registered. Because the cont buffer was still busy with one CPU, the
other thread needs to store the continuation line prints in individual
records, which leads to the (unwanted) printed newlines when
replaying.

The data we store looks all fine, it just looks needlessly separated
when we replay fromt he buffer on a newly registered boot console. We
need to merge the lines in the output, so they *look* like they are
all in one line. I'll work on a fix for that now.

Thanks,
Kay
