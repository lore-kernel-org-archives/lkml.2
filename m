Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2EaJ7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:59:40 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:41365 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2EaJ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:59:38 -0400
Date: Thu, 31 May 2012 12:00:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120531100005.GC14074@aftab.osrc.amd.com>
References: <1337854460-25191-1-git-send-email-mchehab@redhat.com>
 <20120524105604.GC27063@aftab.osrc.amd.com>
 <4FBE5E1D.7070804@redhat.com>
 <20120524164554.GM27063@aftab.osrc.amd.com>
 <4FBE7755.2080301@redhat.com>
 <20120529115851.GB29157@aftab.osrc.amd.com>
 <4FC4D6E2.9060501@redhat.com>
 <20120529145245.GG29157@aftab.osrc.amd.com>
 <4FC4E9EB.5030801@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:24:41PM +0000, Luck, Tony wrote:
> >         u32 grain;              /* granularity of reported error in bytes */
> > 				   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> >> 			dimm->grain = nr_pages << PAGE_SHIFT;
> 
> I'm not at all sure what we'll see digging into the chipset registers
> like EDAC does - but we do have different granularity when reporting
> via machine check banks.  That's why we have this code:
> 
>                 /*
>                  * Mask the reported address by the reported granularity.
>                  */
>                 if (mce_ser && (m->status & MCI_STATUS_MISCV)) {
>                         u8 shift = MCI_MISC_ADDR_LSB(m->misc);
>                         m->addr >>= shift;
>                         m->addr <<= shift;

That's 64 bytes max, IIRC.

> in mce_read_aux().  In practice right now I think that many errors will
> report with cache line granularity,

Yep.

> while a few (IIRC patrol scrub) will report with page (4K)
> granularity. Linux doesn't really care - they all have to get rounded
> up to page size because we can't take away just one cache line from a
> process.

I'd like to see that :-)

> > @Tony: Can you ensure us that, on Intel memory controllers, the address
> > mask remains constant at module's lifetime, or are there any events that
> > may change it (memory hot-plug, mirror mode changes, interleaving 
> > reconfiguration, ...)?
> 
> I could see different controllers (or even different channels) having
> different setup if you have a system with different size/speed/#ranks
> DIMMs ... most systems today allow almost arbitrary mix & match, and the
> BIOS will decide which interleave modes are possible based on what it
> finds in the slots.  Mirroring imposes more constraints, so you will
> see less crazy options. Hot plug for Linux reduces to just the hot add
> case (as we still don't have a good way to remove DIMM sized chunks of
> memory) ... so I don't see any clever reconfiguration possibilities
> there (when you add memory, all the existing memory had better stay
> where it is, preserving contents).

You're funny :-)

> Perhaps the only option where things might change radically is socket
> migration ... where the constraint is only that the target of the
> migration have >= memory of the source. So you might move from some
> weird configuration with mixed DIMM sizes and thus no interleave, to a
> homogeneous socket with matched DIMMs and full interleave. But from an
> EDAC level, this is a new controller on a new socket ... not a changed
> configuration on an existing socket.

Right, from the frequency of such events happening, it still sounds to
me like the perfect place for the grain value is in sysfs.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
