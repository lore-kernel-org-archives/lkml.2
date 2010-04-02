Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0DBULu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:11:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842Ab0DBULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:11:43 -0400
Date: Fri, 2 Apr 2010 13:07:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
cc: Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net, linux-arm@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/5] kgdb: Use atomic operators which use barriers
In-Reply-To: <alpine.LFD.2.00.1004021244140.3634@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004021250170.3634@i5.linux-foundation.org>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com> <1270233145-29335-2-git-send-email-jason.wessel@windriver.com> <1270233145-29335-3-git-send-email-jason.wessel@windriver.com> <1270233145-29335-4-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-5-git-send-email-jason.wessel@windriver.com> <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org> <4BB64762.6040806@windriver.com> <alpine.LFD.2.00.1004021238270.3634@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004021244140.3634@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, Linus Torvalds wrote:
> 
> But Linux does expect that if some other CPU modifies a memory location, 
> then we _will_ see that modification eventually. If the CPU needs help to 
> do so, then cpu_relax() needs to do that. Again - this has nothing to do 
> with memory barriers. It's just a basic requirement.

Btw, this is not necessarily just limited to cpu_relax() either. The 
assumption that we'll eventually see changes to memory is pretty common.

If some architecture doesn't see updates from other CPU's (or maybe DMA) 
without extra help, I suspect that it might be a good idea to not just 
have IO instructions but also things like 'udelay()' have that "extra 
helping sauce" in them.

For the exact same reason: we have drivers that depend on things like 
jiffies updates happening automatically, eg:

	drivers/scsi/u14-34f.c:   while ((jiffies - time) < (10 * HZ) && limit++ < 200000) udelay(100L);

or

	drivers/isdn/hisax/elsa_ser.c-  while(timeout-- && cs->hw.elsa.transcnt)
	drivers/isdn/hisax/elsa_ser.c:          udelay(1000);

or

	drivers/serial/68328serial.c:   while (!(uart->utx.w & UTX_TX_AVAIL)) udelay(5);

where those variables we read may be updated from another CPU taking an 
interrupt (or by DMA - I didn't look at how UTX_TX_AVAIL gets set, for 
example).

Now, in practice, I suspect the above kind of busy loop is _way_ less 
common. It's harder to grep for (I picked 'udelay()' to look for, but 
the result is full of noise that does IO etc that would presumably fix 
things anyway, so the above two are just random examples of some drivers 
basically reading variables in a busy loop).

And for something like ARM, random drivers probably don't much matter. So 
I doubt that this udelay() thing is at _all_ as important as cpu_relax() 
is, and ARM maintainers can probably happily just ignore it.

			Linus
