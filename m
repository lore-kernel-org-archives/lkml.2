Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab1JEHbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:31:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51066 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1JEHbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:31:18 -0400
Date: Wed, 5 Oct 2011 09:31:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        crash-utility@redhat.com, kexec@lists.infradead.org,
        Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005073111.GA13478@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"K.Prasad" <prasad@linux.vnet.ibm.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, crash-utility@redhat.com,
	kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	"Luck, Tony" <tony.luck@intel.com>, anderson@redhat.com,
	tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <m162k64c7w.fsf@fess.ebiederm.org>
 <20111003120336.GK2223@in.ibm.com>
 <20111004063440.GB5723@liondog.tnic>
 <20111005070728.GA2235@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111005070728.GA2235@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 12:37:28PM +0530, K.Prasad wrote:
> > Well, there are MCE types for which we need to panic but we don't
> > necessarily corrupt memory. Your approach is to unconditionally avoid
> > dumping core whenever we panic while you should look at the MCE
> > signature and decide then whether to capture crashed kernel memory or
> > not.
> > 
> > For example, if the MCE signature says UC DRAM error, then you can
> > be pretty sure that there is a landmine somewhere in the DRAM region
> > mapping the crashed kernel. If it is, say, a UC when doing data fills
> > from L2 to L1, that doesn't necessarily mean that DRAM is corrupted. But
> > even in the first case, you can evaluate the MCi_ADDR reported with the
> > UC DRAM error and simply skip that particular cacheline when dumping the
> > core instead of not capturing anything at all.
> > 
> 
> True. Like stated by me earlier, there could be two possible outcomes
> from capturing memory dump in such cases - they're either dangerous or
> doesn't make sense.

Why, in the second example the only corruption is to the L2 cache so
your memory image is intact. Why wouldn't you want to capture a memory
dump then? It is business as usual in that case.

> It is best to avoid a normal kdump in both cases,
> although the elf-note doesn't distinguish between the two.
> 
> NT_NOCOREDUMP, in my opinion, is just the first step towards introducing
> a framework where different code paths that lead to panic() can
> 'opt-out' from kdump by adding an elf-note.
> 
> We can modify this to add more fine-grained messages using different elf-note
> types (or use the elf-note name under the NT_NOCOREDUMP type) to
> indicate the cause/type of crash.
> 
> I'd like to hear further from you and the rest of the community to see if
> there's a need felt for such a change.

I'd make this conditional on whether you have had memory corruption or
not by evaluating MCE signatures and acting accordingly.

> > Btw, the doublefault example you give above - is this something you
> > experience on real hardware or just a theoretical thing?
> >
> 
> Unfortunately, I still haven't been able to try injecting memory errors
> and study the behaviour (trying to get access to machine with
> appropriate firmware). I'll have a reply to this after some experiments
> with memory error injection.

Right, this might be much more helpful than theoretical discussions on
what to do. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.
