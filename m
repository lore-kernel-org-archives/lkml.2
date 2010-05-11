Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab0EKRpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:45:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347Ab0EKRpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:45:34 -0400
Date: Tue, 11 May 2010 10:42:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
In-Reply-To: <20100511172543.GA17868@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005111031260.3711@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org> <20100507061203.GA8779@srcf.ucam.org> <alpine.LFD.2.00.1005071402080.901@i5.linux-foundation.org> <20100507211331.GA28906@srcf.ucam.org>
 <alpine.LFD.2.00.1005071418200.901@i5.linux-foundation.org> <20100507213600.GC28906@srcf.ucam.org> <20100511172543.GA17868@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 May 2010, Matthew Garrett wrote:
> 
> I've now checked the behaviour of Windows. It turns out that it never 
> makes the ACPI enable SMM call on resume. This is consistent with 
> http://bugzilla.kernel.org/show_bug.cgi?id=13745 which shows a bug 
> being introduced by us making the enable call in the first place. 
> Merging my patch and removing the blacklist would re-break these 
> machines. Instead, we should just unconditionally set SCI_EN since this 
> is the tested configuration. I'll send a followup patch.

Hmm. But that's the thing that Rafael claims doesn't work on his machine. 

Maybe windows does something else? Or do you _see_ windows doing that 
write?

Note that our acpi_enable() won't do anything either if the machine comes 
up in ACPI mode, so maybe you checked the behavior on that kind of 
machine, and Windows does the same? IOW, if acpi_hw_get_mode() already 
returns ACPI_SYS_MODE_ACPI, the whole thing is a no-op.

Finally, it's possible that we really should just write the dang SCI_EN 
bit directly, but that what we do wrong is that doing so with

	acpi_write_bit_register()

will write it _even_if_ the bit was already set. That could explain 
Rafael's problems too - writing the register directly may be the 
RightThing(tm), but writing it if the bit was already set may well cause 
some confusion.

				Linus
