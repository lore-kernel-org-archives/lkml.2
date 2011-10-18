Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab1JRRlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:41:49 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42479 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570Ab1JRRls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:41:48 -0400
Date: Tue, 18 Oct 2011 23:11:22 +0530
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
Message-ID: <20111018174122.GB2283@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111003073203.GA22694@in.ibm.com>
 <20111004140437.GA28306@redhat.com>
 <20111005071844.GB2235@in.ibm.com>
 <20111005152537.GB30146@redhat.com>
 <20111007161218.GA2297@in.ibm.com>
 <20111010070725.GB11577@liondog.tnic>
 <20111011184434.GB32316@in.ibm.com>
 <20111012155144.GC12845@redhat.com>
 <20111014113025.GA20278@in.ibm.com>
 <20111014141450.GB4142@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014141450.GB4142@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11101807-5140-0000-0000-000000145E77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 10:14:50AM -0400, Vivek Goyal wrote:
> On Fri, Oct 14, 2011 at 05:00:25PM +0530, K.Prasad wrote:
> > On Wed, Oct 12, 2011 at 11:51:44AM -0400, Vivek Goyal wrote:
> > > On Wed, Oct 12, 2011 at 12:14:34AM +0530, K.Prasad wrote:
> > > > On Mon, Oct 10, 2011 at 09:07:25AM +0200, Borislav Petkov wrote:
> > > > > On Fri, Oct 07, 2011 at 09:42:19PM +0530, K.Prasad wrote:
> > [snipped]
> > > > 
> > > > ii) Scenario2: System with PG_hwpoison (or landmine!) pages crashes because
> > > > of a software bug. In this case, kexec kernel would normally reboot because
> > > > of reading the PG_poison page. I'll soon get a new version of the patchset
> > > > implementing this.
> > > > 
> > > > Solution: Maintain a linked list of PFNs when the corresponding 'struct page'
> > > > has been marked PG_hwpoison. We could export/put this list to use in
> > > > quite a few ways.
> > > 
> > > What's the need of a list and why do we have to export anything. Can't
> > > makedumpfile look at the struct page and then just not dump that page if
> > > hwpoison flag is set.
> > >
> > 
> > I'll respond to just this part of the comment for now, since I have a
> > few conflicting thoughts crossing my mind regarding the above suggestion
> > and thought I'll put it across to the community to get that clarified.
> > 
> > Using makedumpfile to actually identify and sidestep PG_hwpoison sounds
> > a bit dangerous. Let's for a moment that makedumpfile has this
> > capability, which is implemented as under.
> > 
> > - The list of nodes (pg_data_t) and all struct page's (through
> >   node_mem_map) are sent to makedumpfile using VMCOREINFO_SYMBOL().
> > 
> > - makedumpfile would use this information to go to the old kernel's
> >   memory, look at pg_data_t and then into each element of node_mem_map
> >   to then lookout for PG_hwpoison inside 'struct page'->flags. (Well,
> >   this method works for !SPARSEMEM. I'd like to know if I've overlooked
> >   any other better method. pfn_to_page() wouldn't work either, as it will
> >   give a 'struct page' of a PFN as seen by the kexec'd kernel and not
> >   the crashed kernel).
> > 
> > - If PG_hwpoison flag for the corresponding page is clear, then it
> >   will allow the copy operation.
> > 
> > - The problem comes when we actually land on a page with PG_hwpoison
> >   while carrying out the above 3 steps. For instance, if the page
> >   containing the pg_data_t and node_mem_map data structures themselves
> >   are marked hw-poisoned.
> 
> I think it can happen and in that case we don't capture the dump.

(edited)

This
> is similar to possibility of running into a accessing a poisoned page
> while you are trying to same the final note which will contain the
> MCE info or list of poisoned pages.
>

Actually this is less likely a possibility, given that we would have
crashed in the first kernel itself if the page to be populated with the
elf-note was marked as hw-poisoned. The kernel would have attempted a
write and would have crashed, even before the list is passed down to
second kernel.
 
> Even if you export the list successfuly and you find pd_data_t pages
> are poisoned, what would you do? Not do filtering and save tera bytes
> of dump.
> 

If we export a list of PFNs, we don't have to access the pg_data_t of
the old kernel. We could use the PFNs as is, through pfn_to_page and
then avert the read operation.

> I think you are just trying to solve every corner case which might
> not even be required in practice. Kdump is our best effort to capture
> the dump and there are so many corner cases where it will not work.
> 

True. The above scenario is a corner case but I was using it as an
argument towards what approach is better when trying to side-step
PG_hwpoison pages.

> So I would suggest that lets us not make the whole thing too complicated
> now. If the scenario you are describing becomes common enough that
> it start bothering, we can look into exporting the poisoned pages list.
>

At this moment, I'm unsure if, for side-stepping PG_hwpoison pages, it
would be easier to parse through the list of page data structures from
user-space (makedumpfile) or avail kernel-assistance + new elf-note (I
suspect the latter though). I'll prototype some code for the first
approach and keep this list posted with developments.

However for now, I'll address the first part of the problem i.e. kdump
behaviour when kernel crashes due to unrecoverable MCE and send out a
revised patch for the same that uses VMCOREINFO elf-note.

Thanks to all for suggestions.

-- K.Prasad

