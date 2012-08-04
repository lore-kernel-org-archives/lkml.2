Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2HDQHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 12:07:53 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55495 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab2HDQHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 12:07:49 -0400
X-Sasl-enc: OFNs/4ts9tz/UoX4iwKnjv1oKc45WqZhypThUDU9sZHC 1344096468
Date: Sat, 4 Aug 2012 13:07:45 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Borislav Petkov <bp@amd64.org>, Sven Joachim <svenjoac@gmx.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Winchester <kjwinchester@gmail.com>
Subject: Re: [ 33/73] x86, microcode: Sanitize per-cpu microcode reloading
 interface
Message-ID: <20120804160745.GA17188@khazad-dum.debian.net>
References: <20120731044310.013763753@decadent.org.uk>
 <20120731044316.585695559@decadent.org.uk>
 <87y5lw73eh.fsf@turtle.gmx.de>
 <20120803094314.GB31792@aftab.osrc.amd.com>
 <20120803122727.GA32299@aftab.osrc.amd.com>
 <1344094877.4642.183.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344094877.4642.183.camel@deadeye.wl.decadent.org.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Aug 2012, Ben Hutchings wrote:
> On Fri, 2012-08-03 at 14:27 +0200, Borislav Petkov wrote:
> > On Fri, Aug 03, 2012 at 11:43:14AM +0200, Borislav Petkov wrote:
> > > On Fri, Aug 03, 2012 at 11:04:06AM +0200, Sven Joachim wrote:
> > > > On 2012-07-31 06:43 +0200, Ben Hutchings wrote:
> > > > 
> > > > > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > Alas, this does not build if CONFIG_SMP is unset:
> > > > 
> > > > ,----
> > > > | arch/x86/kernel/microcode_core.c: In function 'reload_store':
> > > > | arch/x86/kernel/microcode_core.c:304:19: error: 'struct cpuinfo_x86' has no member named 'cpu_index'
> > > > `----
> > > 
> > > Crap. :-(
> > > 
> > > 3.2 still has this:
> > > 
> > > <arch/x86/include/asm/processor.h>:
> > > ...
> > > #ifdef CONFIG_SMP
> > >         /* number of cores as seen by the OS: */
> > >         u16                     booted_cores;
> > >         /* Physical processor id: */
> > >         u16                     phys_proc_id;
> > >         /* Core id: */
> > >         u16                     cpu_core_id;
> > >         /* Compute unit id */
> > >         u8                      compute_unit_id;
> > >         /* Index into per_cpu list: */
> > >         u16                     cpu_index;
> > > #endif
> > >         u32                     microcode;
> > > } __attribute__((__aligned__(SMP_CACHE_BYTES)));
> > > ---
> > > 
> > > which got removed by
> > > 
> > > commit 141168c36cdee3ff23d9c7700b0edc47cb65479f
> > > Author: Kevin Winchester <kjwinchester@gmail.com>
> > > Date:   Tue Dec 20 20:52:22 2011 -0400
> > > 
> > >     x86: Simplify code by removing a !SMP #ifdefs from 'struct cpuinfo_x86'
> > > 
> > > Ben, you might want to backport this one too... I'll run a couple of 3.2
> > > builds with it ontop of 3.2 to verify nothing else breaks.
> > 
> > Ok, 141168c36cdee3ff23d9c7700b0edc47cb65479f doesn't apply cleanly to
> > 3.2-stable, as expected. I've attached a partly backported version. Why
> > partly? Well, it broke an UP build in mainline which got fixed later by
> > 
> > commit 3f806e50981825fa56a7f1938f24c0680816be45
> > Author: Borislav Petkov <bp@alien8.de>
> > Date:   Fri Feb 3 20:18:01 2012 +0100
> > 
> >     x86/mce/AMD: Fix UP build error
> >     
> >     141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs
> >     from 'struct cpuinfo_x86'") removed a bunch of CONFIG_SMP ifdefs
> >     around code touching struct cpuinfo_x86 members but also caused
> >     the following build error with Randy's randconfigs:
> >     
> >     mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'
> > ---
> > 
> > which reverted what the original patch removed.
> > 
> > So I've taken out the parts that introduce the breakage from the
> > backport.
> [...]
> 
> Thanks everyone for working this out.
> 
> If you combine multiple mainline commits like this, the new commit
> message should refer to all of them.  I've fixed that up this time.

Ben, the backport is also needed on 3.0 and 3.4, do you have your patch
queue available for download/pull somewhere?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
