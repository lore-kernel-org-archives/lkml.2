Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1JNLaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 07:30:46 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56083 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1JNLap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 07:30:45 -0400
Date: Fri, 14 Oct 2011 17:00:25 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        crash-utility@redhat.com, kexec@lists.infradead.org,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111014113025.GA20278@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004140437.GA28306@redhat.com>
 <20111005071844.GB2235@in.ibm.com>
 <20111005152537.GB30146@redhat.com>
 <20111007161218.GA2297@in.ibm.com>
 <20111010070725.GB11577@liondog.tnic>
 <20111011184434.GB32316@in.ibm.com>
 <20111012155144.GC12845@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012155144.GC12845@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 11:51:44AM -0400, Vivek Goyal wrote:
> On Wed, Oct 12, 2011 at 12:14:34AM +0530, K.Prasad wrote:
> > On Mon, Oct 10, 2011 at 09:07:25AM +0200, Borislav Petkov wrote:
> > > On Fri, Oct 07, 2011 at 09:42:19PM +0530, K.Prasad wrote:
[snipped]
> > 
> > ii) Scenario2: System with PG_hwpoison (or landmine!) pages crashes because
> > of a software bug. In this case, kexec kernel would normally reboot because
> > of reading the PG_poison page. I'll soon get a new version of the patchset
> > implementing this.
> > 
> > Solution: Maintain a linked list of PFNs when the corresponding 'struct page'
> > has been marked PG_hwpoison. We could export/put this list to use in
> > quite a few ways.
> 
> What's the need of a list and why do we have to export anything. Can't
> makedumpfile look at the struct page and then just not dump that page if
> hwpoison flag is set.
>

I'll respond to just this part of the comment for now, since I have a
few conflicting thoughts crossing my mind regarding the above suggestion
and thought I'll put it across to the community to get that clarified.

Using makedumpfile to actually identify and sidestep PG_hwpoison sounds
a bit dangerous. Let's for a moment that makedumpfile has this
capability, which is implemented as under.

- The list of nodes (pg_data_t) and all struct page's (through
  node_mem_map) are sent to makedumpfile using VMCOREINFO_SYMBOL().

- makedumpfile would use this information to go to the old kernel's
  memory, look at pg_data_t and then into each element of node_mem_map
  to then lookout for PG_hwpoison inside 'struct page'->flags. (Well,
  this method works for !SPARSEMEM. I'd like to know if I've overlooked
  any other better method. pfn_to_page() wouldn't work either, as it will
  give a 'struct page' of a PFN as seen by the kexec'd kernel and not
  the crashed kernel).

- If PG_hwpoison flag for the corresponding page is clear, then it
  will allow the copy operation.

- The problem comes when we actually land on a page with PG_hwpoison
  while carrying out the above 3 steps. For instance, if the page
  containing the pg_data_t and node_mem_map data structures themselves
  are marked hw-poisoned.

It's analogous to stepping inside a landmine territory to retrieve a map
containing the placement of landmines (we better have a copy of the map
before we enter :-)).

If we agree that this is going to be unsafe, then the question that
needs to be answered: "Is there a need for the kernel to allow read
operations on a page marked PG_hwpoison? If not, why doesn't the kernel
make it a policy to fail/disallow the read operations".

Thanks,
K.Prasad

