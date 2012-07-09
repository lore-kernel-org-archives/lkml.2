Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2GIRKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:10:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42125 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2GIRKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:10:02 -0400
Date: Mon, 9 Jul 2012 10:09:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
Message-ID: <20120709170956.GB24728@kroah.com>
References: <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com>
 <1341492628.834.3.camel@mop>
 <30233.1341535279@neuling.org>
 <CAPXgP12_F_H2XPpo2wFmb-u3jBdV__=h67R-LVYbqHuLh7tqLg@mail.gmail.com>
 <29711.1341545979@neuling.org>
 <30343.1341546469@neuling.org>
 <CAPXgP13_cQUQLE4RSjACTzj28Pn6r3ZaPhjch2U+uwgi7YKcWA@mail.gmail.com>
 <CAPXgP10JthGjZyqD6gqn2n1rPu1uP+=mem_T-iOritXAQMstRQ@mail.gmail.com>
 <21892.1341608647@neuling.org>
 <1341770155.1011.27.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341770155.1011.27.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 07:55:55PM +0200, Kay Sievers wrote:
> On Sat, 2012-07-07 at 07:04 +1000, Michael Neuling wrote:
> > Whole kmsg below.
> 
> I guess I have an idea now what's going on.
> 
> > 4,47,0;WARNING: at /scratch/mikey/src/linux-ozlabs/arch/powerpc/sysdev/xics/xics-common.c:105
> > 4,51,0;MSR: 9000000000021032 <SF,HV,ME,IR,DR,RI>  CR: 24000042  XER: 22000000
> > 4,54,0;TASK = c000000000b2dd80[0] 'swapper/0' THREAD: c000000000c24000 CPU: 0
> 
> This is the warning on CPU#1, all fine, all in one line.
> 
> > 6,74,0;console [tty0] enabled
> > 6,75,0;console [hvc0] enabled
> 
> Now the boot consoles are registered, which replays the whole buffer
> that was collected up to this point. During the entire time the console
> semaphore needs to be held, and this can be quite a while.
> 
> > 4,87,24545;WARNING: at /scratch/mikey/src/linux-ozlabs/arch/powerpc/sysdev/xics/xics-common.c:105
> > \4,91,24586;MSR: 9000000000021032 
> > 4,92,24590;<
> > 4,93,24594;SF
> > 4,94,24599;,HV
> > 4,95,24604;,ME
> > 4,96,24609;,IR
> > 4,97,24614;,DR
> > 4,98,24619;,RI
> > 4,99,24623;>
> > 4,104,24661; CPU: 1
> 
> At the same time the CPU#2 prints the same warning with a continuation
> line, but the buffer from CPU#1 can not be flushed to the console, nor
> can the continuation line printk()s from CPU#2 be merged at this point.
> The consoles are still locked and busy with replaying the old log
> messages, so the new continuation data is just stored away in the record
> buffer as it is coming in.
> If the console would be registered a bit earlier, or the warning would
> happen a bit later, we would probably not see any of this.
> 
> I can fake something like this just by holding the console semaphore
> over a longer time and printing continuation lines with different CPUs
> in a row.
> 
> The patch below seems to work for me. It is also here:
>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-merge-cont.patch;hb=HEAD
> 
> It only applies cleanly on top of this patch:
>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-syslog-1-byte-read.patch;hb=HEAD
> 
> Thanks,
> Kay
> 
> 
> Subject: kmsg: merge continuation records while printing
> 
> In (the unlikely) case our continuation merge buffer is busy, we unfortunately
> can not merge further continuation printk()s into a single record and have to
> store them separately, which leads to split-up output of these lines when they
> are printed.
> 
> Add some flags about newlines and prefix existence to these records and try to
> reconstruct the full line again, when the separated records are printed.
> ---
>  kernel/printk.c |  119 ++++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 77 insertions(+), 42 deletions(-)

Michael, did this solve the issue for you?

It's a bit "big" of a patch so late in the -rc cycle, is it ok if we
just merge this in 3.6-rc1 and backport it to 3.5.1 if it looks ok
there?

thanks,

greg k-h
