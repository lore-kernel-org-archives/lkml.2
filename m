Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab0EGGMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:12:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43161 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0EGGMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:12:12 -0400
Date: Fri, 7 May 2010 07:12:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
Message-ID: <20100507061203.GA8779@srcf.ucam.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 07:34:10PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 6 May 2010, Len Brown wrote:
> > 
> > The big DMI list in sleep.c a temporary brute force and low-risk workaround.
> > We will endeavor to delete it entirely in 2.6.35 with a clean fix
> > that was deemed too risky for this late in the .34 release cycle.
> 
> Btw, why don't we just force the SCI_EN by hand?

The spec says we can't. I've posted a patch to do so if it's still not 
set after we've tried doing it the right way, but I'm not keen on 
pushing it into a release at this point.

> There is _no_ reason not to force it. If the BIOS set it, it's a no-op. If 
> the BIOS didn't set it, it's a bug that _must_ be fixed.

Kind of. The "correct" way to do it is to write to an ioport, and doing 
that usually triggers an SMI. So writing the bit by hand without 
ensuring that we do that is a difference in behaviour, while we've 
simultaneously seen some evidence triggering that SMI may break some 
machines - it's conceivable that Windows does it on boot and writes it 
by hand on resume and so every machine in the real world would be fine 
with us doing it by hand, but we haven't tested that yet and it doesn't 
seem like a great risk to take at this point in the development cycle. 
But yes, that DMI list will go in .35. We'll figure out who breaks and 
why at that point.

> How could setting SCI_EN _ever_ be a bug? Seriously? Why are we doing this 
> conditionally, especially considering that even the commit message here 
> explicitly states that Windows does it unconditionally?

If the southbridge comes up with GPEs enabled in a way that expects one 
thing and we write the bit differently without SMM being involved in the 
process then there's potential misery. I suspect that any such misery is 
entirely due to BIOS vendors being insane, but unfortunately scientific 
testing has demonstrated that BIOS vendors are insane with a P of < 
0.001 and an N of MAX_INT.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
