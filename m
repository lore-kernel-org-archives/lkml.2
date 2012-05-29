Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2E2L6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 07:58:25 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:57894 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2E2L6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 07:58:23 -0400
Date: Tue, 29 May 2012 13:58:51 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120529115851.GB29157@aftab.osrc.amd.com>
References: <1337358773-6919-38-git-send-email-mchehab@redhat.com>
 <1337854460-25191-1-git-send-email-mchehab@redhat.com>
 <20120524105604.GC27063@aftab.osrc.amd.com>
 <4FBE5E1D.7070804@redhat.com>
 <20120524164554.GM27063@aftab.osrc.amd.com>
 <4FBE7755.2080301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBE7755.2080301@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 03:00:53PM -0300, Mauro Carvalho Chehab wrote:
> On the current drivers, the grain static. I'm not sure if the grain is really
> a per-memory controller or if this is again yet-another-issue with the way
> EDAC core handles such information.
> 
> I suspect that, on sophisticated memory controllers that can do any type of
> DIMM interleaving, including no interleave at all, the grain can vary from
> one memory address range to the other.

Ah, you suspect. Well, since you suspect, then it has to be true.

Granularity of reported error doesn't have anything direct to do with
memory interleaving.

> If we change the API to have an explicit sysfs node to express the grain,
> and latter we end by needing a per-address range grain, we'll need to break
> the kABI. 
> 
> So, keeping the grain information at the tracepoint is more flexible, as it
> can cover both situations.

And adding useless fields is bloating it.

> >>> But the more important question is: does the grain help us when handling
> >>> the error info in userspace?
> >>>
> >>> It tells us that at this physical address with "grain" granularity we
> >>> had an error. So?
> >>
> >> While a certain number of corrected errors that happened on different, sparsed,
> >> addresses may not mean a damaged memory, the same number of corrected errors
> >> happening at the same physical address/grain means that the DRAM chip that
> >> contains such address is damaged, so the corresponding DIMM needs to be 
> >> replaced.
> >>
> >> So, the address/grain can be used by userspace algorithms to increase the
> >> probability that a DIMM is damaged.
> > 
> > I have no idea what you're saying here.
> > 
> > The DIMM can be pinpointed using the address only, why do you need the
> > grain too?
> 
> You can pinpoint a DIMM but in order to pinpoint the affected MOSFET transistors,

The MOSFET transistors, every single one of them??! Wohahahah, this just
made my day!

> the address and address mask is needed, as most memory controllers can't point
> to a single address, because the register that stores the address doesn't have
> enough bits to store the full content of the instruction pointer register, or because
> of some other internal device issues.
> 
> So, two different "addresses" could atually point to the same group of transistors
> inside a DIMM.
> 
> Also, higher values of grains may affect the error statistics. For example, i3200_edac
> driver has a grain that can be 64 MB, while other devices have a grain of 1.

I think you mean

#define I3200_TOM_SHIFT         26      /* 64MiB grain */

which is the Top-Of-Memory shift value. How is that grain in the sense of error
granularity I can't fathom.

Oh, and by the way, this define is unused and can be removed.

So, to sum up, I'm still completely unconvinced 'grain' is needed so remove it.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
