Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1JLPw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:52:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab1JLPw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:52:56 -0400
Date: Wed, 12 Oct 2011 11:51:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        crash-utility@redhat.com, kexec@lists.infradead.org,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111012155144.GC12845@redhat.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004140437.GA28306@redhat.com>
 <20111005071844.GB2235@in.ibm.com>
 <20111005152537.GB30146@redhat.com>
 <20111007161218.GA2297@in.ibm.com>
 <20111010070725.GB11577@liondog.tnic>
 <20111011184434.GB32316@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011184434.GB32316@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 12:14:34AM +0530, K.Prasad wrote:
> On Mon, Oct 10, 2011 at 09:07:25AM +0200, Borislav Petkov wrote:
> > On Fri, Oct 07, 2011 at 09:42:19PM +0530, K.Prasad wrote:
> > > The problem, as pointed out by Borislav Petkov in a different mail, is that
> > > we might end up capturing a vmcore containing corrupted data when the
> > > same is not required for analysing the cause of the crash.
> > > 
> > > Of course, all this is assuming that reading the faulty memory with MCE
> > > disabled is harmless. However, the effect of a read operation in this
> > > case is undefined.
> > 
> > Frankly, I don't think that it is undefined - you basically should be
> > able to read DRAM albeit with the corrupted data in it. However, you
> > probably best disable the whole DRAM error detection first by clearing
> > a couple of bits in MC4_CTL_MASK (at least on AMD that should work, I
> > dunno how Intel does that).
> > 
> 
> The MC4_CTL_MASK doesn't appear to be defined in the kernel. Looking at
> http://support.amd.com/us/Processor_TechDocs/26094.PDF, Page 196, it
> states that "This register is typically programmed by BIOS and not by
> the Kernel software".
> 
> So, in any case we may not be able to disable machine-check exceptions
> (MCEs) only within the context of kexec'ed kernel. Let me know if I've
> missed something here.
> 
> > But, regardless, according to Vivek, the "makedumpfile" tool should be
> > able to jump over poisoned pages and you don't need all the hoopla above
> > at all, right?
> >
> 
> In short, the answer is yes. We could add a new string, say
> "CRASH_REASON=PANIC_MCE" to VMCOREINFO elf-note which can be parsed by
> 'makedumpfile' and get away without adding the new NT_NOCOREDUMP
> elf-note. Parsing through the log_buf to lookout for panic string from
> inside 'makedumpfile' appears to be a clumsy solution though.
> 
> The suggestion to make NT_NOCOREDUMP to contain more fine-granular
> information can be met by using meaningful strings for VMCOREINFO.

I guess we don't have to overload VMCOREINFO with more fine grained info
about MCE. kernel log buf should have that info. So makedumpfile can just
extract and save kernel buf and save it on disk and user can get all the
MCE info from that.

> 
> ---
> 
> In this context, I wish to quickly recollect the issues we've discussed
> thus far, their proposed solutions and re-evaluate the need for new elf-note.
> 
> i) Scenario1: System crashes because of a fatal MCE
> 
> Proposed Solution: Add a new string in the VMCOREINFO elf-note from
> within the MCE panic path to indicate cause of crash. 'makedumpfile'
> recognises this string to collect a slimdump instead of the normal dump.

What is slimdump? Why to define a new format and extra note in the vmcore.
Just simply save kernel log buf if you encounter PANIC_MCE.

> 
> ii) Scenario2: System with PG_hwpoison (or landmine!) pages crashes because
> of a software bug. In this case, kexec kernel would normally reboot because
> of reading the PG_poison page. I'll soon get a new version of the patchset
> implementing this.
> 
> Solution: Maintain a linked list of PFNs when the corresponding 'struct page'
> has been marked PG_hwpoison. We could export/put this list to use in
> quite a few ways.

What's the need of a list and why do we have to export anything. Can't
makedumpfile look at the struct page and then just not dump that page if
hwpoison flag is set.

Thanks
Vivek
