Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0G0ATi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 20:19:38 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:40023 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab0G0ATg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 20:19:36 -0400
Date: Mon, 26 Jul 2010 20:19:10 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Yu, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: Re: [PATCH] ACPI: create "processor.bm_check_disable" boot param
In-reply-to: <87k4oiiu3x.fsf@basil.nowhere.org>
Message-id: <alpine.LFD.2.00.1007262007550.5292@localhost.localdomain>
References: <20100427124703.GA16706@jgarrett.org>
 <alpine.LFD.2.00.1004301218280.2489@sony>
 <20100430174447.GA14889@srcf.ucam.org>
 <d7f2dd35a4361e5156079278543769a0@localhost>
 <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
 <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
 <20100525124325.GC7876@srcf.ucam.org>
 <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
 <20100525185507.GA15997@srcf.ucam.org>
 <alpine.LFD.2.00.1007211729550.409@localhost.localdomain>
 <20100722074750.GA22520@one.firstfloor.org>
 <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain>
 <alpine.LFD.2.00.1007221720270.7970@localhost.localdomain>
 <alpine.LFD.2.00.1007221739260.7970@localhost.localdomain>
 <87k4oiiu3x.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Note also that an alternative for newer systems
> > is to use the intel_idle driver, which always
> > ignores BM_STS, relying Linux device drivers
> > to register constraints explicitly via PM_QOS.
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=15886
> 
> Thanks.  I don't fully understand why the check for this option
> is in a different place than the register check in the earlier patch? 

Technically, it could have been.

There are a comple of constraints in the layout of this code.

The _CST flag is x86 (actually Intel) specific -- so the detection
went into arch/x86/kernel/acpi/cstate.c

However, the operation of the that flag is per C-state,
not necessarily per system -- so we remember the flag
in in a cx->bm_sts_skip flag and check it in the 
'acpi generic' drivers/acpi/processor_idle.c

But we can't test a per cx flag inside acpi_idle_bm_check()
because it doesn't have access to the cx, so i put that
test at the site of its only caller.

In this 2nd patch...
we added a 'generic' ACPI bootparam that applies
to all C-states.  So it overrides any per-cstate flag
and it is static to the processor_idle.c file,
so it seemed cleanest (to me)
to push it down inside acpi_idle_bm_check()
rather than in its only caller.

> This needs to be also documented in Documentation/kernel-parameters.txt

I thought about that and decided against it.
While we do document some driver specific modparams
in kernel-parameters.txt, I do not expect this one to
be used that often -- mostly for diagnosis of BIOS bugs.
I know of two machines that need it,
and both of those machines have a BIOS update
or a BIOS update in progress that make it unnecessary.

thanks for caring.

Len Brown, Intel Open Source Technology Center.

