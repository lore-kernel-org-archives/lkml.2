Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab1BYLFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:05:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36870 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab1BYLFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:05:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ENtLLWuQZDn1qMMgTZIPXDNT/3oX1s8Qe0O5vldeMNSMRk+x5ap2dfgfb3inGmY4k8
         5ZCcTcZzOJFxeTo4grxYu1mdNAIn1S0jpj0ek0lMZxQg4xp18Hq0D/Rk44z2oD3jqzvi
         tt0cHTPUg06mrJFJ+rQ51mLTyUWry2c6lqAiA=
Date: Fri, 25 Feb 2011 12:05:37 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Fix size of numa_distance array
Message-ID: <20110225110537.GF24828@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <20110224193211.GC15498@elte.hu>
 <AANLkTimvJ=BLDjoRDXg_TRSepd9GoDx-w_FonSCZtybi@mail.gmail.com>
 <alpine.DEB.2.00.1102241330270.28798@chino.kir.corp.google.com>
 <20110225090301.GB24828@htj.dyndns.org>
 <20110225105846.GE24828@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225105846.GE24828@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 11:58:46AM +0100, Tejun Heo wrote:
> On Fri, Feb 25, 2011 at 10:03:01AM +0100, Tejun Heo wrote:
> > > I'm running on a 64GB machine with CONFIG_NODES_SHIFT == 10, so 
> > > numa=fake=128M would result in 512 nodes.  That's going to require 2MB for 
> > > numa_distance (and that's not __initdata).  Before these changes, we 
> > > calculated numa_distance() using pxms without this additional mapping, is 
> > > there any way to reduce this?  (Admittedly real NUMA machines with 512 
> > > nodes wouldn't mind sacrificing 2MB, but we didn't need this before.)
> > 
> > We can leave the physical distance table unmodified and map through
> > emu_nid_to_phys[] while dereferencing.  It just seemed simpler this
> > way.  Does it actually matter?  Anyways, I'll give it a shot.  Do you
> > guys actually use 512 nodes?
> 
> So, the patch looks like the following and it even reduces LOC but I'm
> not sure whether I want to apply this.  Previously, once emluation
> step is complete, the rest of the system wouldn't care whether nodes
> are being emulated or not.  After this change, although it's still
> contained in numa_64.c, we end up with some configurations remapped
> and some still using physical nodes.  Unless someone tells me that
> 2MiB is frigging precious on machines with 512 emulated nodes, I don't
> think I'm gonna apply this one.

Also, the calculation isn't quite right.  If you have 512 nodes,
that's 2^9 * 2^9 entries and, with one byte per entry, 2^18 == 256KiB.
With 1024 nodes, it becomes 1MiB.  I suggest just swallowing it.  I
really want to avoid emulated/physical thing spilling out of emulation
code proper.

Thanks.

-- 
tejun
