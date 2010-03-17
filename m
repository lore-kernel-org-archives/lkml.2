Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0CQNXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 09:23:01 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:19435 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0CQNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:23:00 -0400
Subject: Re: [PATCH v1 2/3] x86/PCI: trim _CRS windows when they conflict
	with	previous reservations
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
In-Reply-To: <4BA0973A.5070701@jp.fujitsu.com>
References: <20100311235954.4355.23100.stgit@bob.kio>
	 <20100312000114.4355.58189.stgit@bob.kio> <4BA04BB9.2090501@jp.fujitsu.com>
	 <1268799725.13147.29.camel@dc7800.home> <4BA0973A.5070701@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 17 Mar 2010 07:15:30 -0600
Message-Id: <1268831730.13147.37.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 17:47 +0900, Kenji Kaneshige wrote:
> Bjorn Helgaas wrote:
> > On Wed, 2010-03-17 at 12:25 +0900, Kenji Kaneshige wrote:
> >> Bjorn Helgaas wrote:
> >>> Yanko's GA-MA78GM-S2H (BIOS F11) reports a host bridge window that overlaps
> >>> system memory:
> >>>
> >>>     PCI window: [mem 0xcff00000-0x10ed0ffff]
> >>>     System RAM: [mem 0x100000000-0x22fffffff]
> >>>
> >>> We can be pretty confident that the System RAM region is correct (if it
> >>> were wrong, we'd crash as soon as we tried to use any memory in that area),
> >>> so this patch tries to correct the PCI window by trimming it so it doesn't
> >>> conflict with any previous reservations.
> >> Though I might misunderstand something, it looks Yanko's machine specific
> >> workaround. I'm wondering if trimming _CRS is a generic workaround for
> >> broken _CRS machine.
> >>
> >> How about doing this when GA-MA78GM-S2H (BIOS F11) (and known machines
> >> that have the same problem) is detected? Or how about switching nocrs
> >> mode if the problem (resource conflict) is detected?
> > 
> > It's certainly a possibility to do this only for specific machines, but
> > I'd like to avoid tripping over issues one-by-one.
> > 
> > I think there are three ways to address BIOS _CRS defects:
> > 
> >   1) Ship an OEM-specific host bridge driver
> >   2) Put a platform- or BIOS-specific quirk into Windows
> 
> "into Linux"?

No, I forgot to say that all this is my speculation about how Windows
works.  I really can't imagine OEMs shipping OEM-specific host bridge
drivers for Windows, because I think it would make it to painful to
install.  And I don't think Windows quirks would really be practical
either, because it would take so long for a new Windows release
containing the quirk to appear that the OEM could never wait for it.

So I think that if we can make Linux parse _CRS in the same way Window
does, we should be able to handle most or all machines in the field
without a lot of quirks.

Of course, this is all pure speculation on my part; I've never worked on
Windows.

Bjorn

> >   3) Change the BIOS
> > 
> > The first two sound like such a hassle to me that I doubt they would be
> > practical.
> 
> I agree.
> For 1), we need OEM-specific driver, not chipset specific driver.
> 
> For 2), I thought it depends on how many machines with broken _CRS are
> there, and I didn't think there are so many, but...
> 
> > 
> > But it's clear that there are systems like this with what appear to be
> > _CRS defects.  It's quite possible that it's not really a defect, and we
> > just don't understand how to parse _CRS correctly yet.  Or, Windows
> > might have a few heuristics to clean up obvious errors.
> 
> Indeed, it might be true. Now I realize I need to change my opinion
> about 2).
> 
> > 
> > For example, I think Windows aligns host bridge windows, as documented
> > here: http://bugzilla.kernel.org/show_bug.cgi?id=14337
> > 
> > I think Windows also knows to ignore the Consumer/Producer bit in
> > Address Space Descriptors, and assume that all resources on bridges are
> > Producers.
> > 
> > Hmm, what we really need is a way to run Windows in a virtualized
> > environment where we could manipulate the _CRS method and see what
> > Windows does with it...
> > 
> > Anyway, I'd like to make Linux behave as much like Windows as possible
> > in this area so we can take advantage of all the testing that's done
> > with Windows.
> 
> Okey, thank you very much for explanation. I understood the background
> of your change.
> 
> Thanks,
> Kenji Kaneshige
> 
> 
> 

