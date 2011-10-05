Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab1JEJri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:47:38 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:60148 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933732Ab1JEJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:47:37 -0400
Date: Wed, 5 Oct 2011 15:17:27 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        anderson@redhat.com, tachibana@mxm.nes.nec.co.jp,
        oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005094727.GB7485@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <m162k64c7w.fsf@fess.ebiederm.org>
 <20111003120336.GK2223@in.ibm.com>
 <20111004063440.GB5723@liondog.tnic>
 <20111005070728.GA2235@in.ibm.com>
 <20111005073111.GA13478@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005073111.GA13478@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 09:31:11AM +0200, Borislav Petkov wrote:
> On Wed, Oct 05, 2011 at 12:37:28PM +0530, K.Prasad wrote:
> > > Well, there are MCE types for which we need to panic but we don't
> > > necessarily corrupt memory. Your approach is to unconditionally avoid
> > > dumping core whenever we panic while you should look at the MCE
> > > signature and decide then whether to capture crashed kernel memory or
> > > not.
> > > 
> > > For example, if the MCE signature says UC DRAM error, then you can
> > > be pretty sure that there is a landmine somewhere in the DRAM region
> > > mapping the crashed kernel. If it is, say, a UC when doing data fills
> > > from L2 to L1, that doesn't necessarily mean that DRAM is corrupted. But
> > > even in the first case, you can evaluate the MCi_ADDR reported with the
> > > UC DRAM error and simply skip that particular cacheline when dumping the
> > > core instead of not capturing anything at all.
> > > 
> > 
> > True. Like stated by me earlier, there could be two possible outcomes
> > from capturing memory dump in such cases - they're either dangerous or
> > doesn't make sense.
> 
> Why, in the second example the only corruption is to the L2 cache so
> your memory image is intact. Why wouldn't you want to capture a memory
> dump then? It is business as usual in that case.
> 

We don't want to capture memory dump when the machine crashes due to
faulty cache, because the end-user derives no benefit by receiving a
bulky vmcore and running crash analysis tools over them. Instead a
'slimdump' that contains a meaningful message about the origin of crash
(and which can be understood by his analysis tools) would be better, or
so I thought.

There are possibly several hardware errors which cause system crash and
the kdump would capture full vmcore, although it doesn't make sense (I
wouldn't have cared about the second example, you cited, if they did not
generate MCE, but a different exception). In an ideal situation, each of
these error paths would 'subscribe' to slimdump and add a meaningful
message in the NT_NOCOREDUMP note instead of letting the user-space copy
the old kernel memory.

> > It is best to avoid a normal kdump in both cases,
> > although the elf-note doesn't distinguish between the two.
> > 
> > NT_NOCOREDUMP, in my opinion, is just the first step towards introducing
> > a framework where different code paths that lead to panic() can
> > 'opt-out' from kdump by adding an elf-note.
> > 
> > We can modify this to add more fine-grained messages using different elf-note
> > types (or use the elf-note name under the NT_NOCOREDUMP type) to
> > indicate the cause/type of crash.
> > 
> > I'd like to hear further from you and the rest of the community to see if
> > there's a need felt for such a change.
> 
> I'd make this conditional on whether you have had memory corruption or
> not by evaluating MCE signatures and acting accordingly.
>

Fine with me. I see that the various IA32_MCi_Status registers will hold
information about the error and use that to classify MCEs.

I think the best way to go about is to retain NT_NOCOREDUMP for non-DRAM
errors also, but use the note-name field in the elf-note and distinguish the
various types of errors...say, by using names such as "PANIC_MCE_DRAM",
"PANIC_MCE_CACHE", etc (similar to the error codes described in the Intel
manual). The upstream tools like 'makedumpfile' and 'crash' will have to
be taught to parse the elf-note name and act accordingly.

Thanks for your comments and review.

-- K.Prasad

