Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0DIDyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:54:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:50627 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0DIDyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:54:45 -0400
Date: Fri, 9 Apr 2010 11:52:18 +0800
From: Liang Li <liang.li@windriver.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, wangchen@cn.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, yinghai@kernel.org,
       akpm@linux-foundation.org, jeremy.fitzhardinge@citrix.com,
       konrad.wilk@oracle.com, Alok Kataria <akataria@vmware.com>
Subject: Re: [PATCH v3] x86: let 'reservetop' functioning right
Message-ID: <20100409035218.GA21391@localhost>
Reply-To: Liang Li <liang.li@windriver.com>
References: <1270773835-2689-1-git-send-email-liang.li@windriver.com>
 <4BBE9B12.1070209@goop.org>
 <20100409032316.GA19938@localhost>
 <4BBEA1E4.1050205@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBEA1E4.1050205@goop.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 09 Apr 2010 03:53:48.0469 (UTC) FILETIME=[4287FE50:01CAD798]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 08:41:24PM -0700, Jeremy Fitzhardinge wrote:
> On 04/08/2010 08:23 PM, Liang Li wrote:
> > On Thu, Apr 08, 2010 at 08:12:18PM -0700, Jeremy Fitzhardinge wrote:
> >   
> >> On 04/08/2010 05:43 PM, Liang Li wrote:
> >>     
> >>> When specify 'reservetop=0xbadc0de' kernel parameter, the kernel will
> >>> stop booting due to a early_ioremap bug that relate to commit 8827247ff.
> >>>
> >>> The root cause of boot failure problem is the value of 'slot_virt[i]'
> >>> was initialized in setup_arch->early_ioremap_init. But later in
> >>> setup_arch, the function 'parse_early_param' will modify 'FIXADDR_TOP'
> >>> when 'reservetop=0xbadc0de' being specified.
> >>>
> >>> The simplest fix might be use __fix_to_virt(idx0) to get updated value
> >>> of 'FIXADDR_TOP' in '__early_ioremap' instead of reference old value
> >>> from slot_virt[slot] directly.
> >>>   
> >>>       
> >> While I guess this patch works OK, I have to say that I'm worried by the
> >> need for it at all; it seems to be papering over a more serious
> >> problem.  reserve_top_address() is supposed to be called very early,
> >> before anything has used or referenced FIXADDR_TOP.  If we're seeing
> >> problems with FIXADDR_TOP changing after it has been used, then it means
> >> that reserve_top_address() is being called too late.  Fixing that would
> >> be the real fix.
> >>     
> > The ideal thing is FIXADDR_TOP should not be touched after
> > early_ioremap_init. The late call to reserve_top_address is from
> > parse_reservetop, aka when reservetop=0xabcd0000 being passed as kernel
> > commandline parameter. In setup_arch, the call sequence is:
> >
> > setup_arch
> >   -> early_ioremap_init
> >   -> parse_early_param
> >     -> parse_reservetop
> > 	  ->reserve_top_address
> >
> > See, how could we solve the confliction better?
> >   
> 
> Well, the first question is "do we need the reservetop= kernel
> parameter"?  Zach added it, I think, so that VMI could be loaded
> dynamically as a module.  Given that VMI is deprecated anyway, I wonder
> if we can just drop support for modular VMI and remove the reservetop=
> kernel parameter.  Or are there other uses for it?

Agree. We can remove the 'reservetop=' kernel parameter then the
problem dispear. :) But we don't have to.....

Regards,
		-Liang Li
