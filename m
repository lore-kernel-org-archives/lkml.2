Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935266Ab1JESAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:00:36 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:57410 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935124Ab1JESAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:00:35 -0400
Date: Wed, 05 Oct 2011 14:00:09 -0400 (EDT)
From: Dave Anderson <anderson@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Andi Kleen <andi@firstfloor.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type NT_NOCOREDUMP to capture slimdump
Message-ID: <67cddd75-90d7-49b8-83ff-c677101b37b3@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20111005172912.GI30146@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.11.8.17]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On Wed, Oct 05, 2011 at 07:20:37PM +0200, Borislav Petkov wrote:
> > On Wed, Oct 05, 2011 at 01:10:07PM -0400, Vivek Goyal wrote:
> > > On Wed, Oct 05, 2011 at 08:58:53AM -0700, Luck, Tony wrote:
> > > > > > The plan is to pass-down the list of poisoned memory pages
> > > > > > to the second
> > > > > > kernel using an elf-note so that these pages are left
> > > > > > untouched during
> > > > > > dump capture. I'm working on an implementation of the same
> > > > > > and should
> > > > > > have patches soon.
> > > > >
> > > > > I would say let us first figure out what happens while
> > > > > reading a poisoned
> > > > > page and is this a problem before working on a solution.
> > > > 
> > > > If the page is poisoned because of a real uncorrectable error
> > > > in memory
> > > > (reported as SRAO machine check today, or by SRAR
> > > > real-soon-now). Then
> > > > accessing the page from the processor while taking a memory
> > > > dump will
> > > > result in a machine check.
> > > > 
> > > > Note that a large memory system that had been running for a
> > > > long time
> > > > may have built up a small stash of these land-mine pages - and
> > > > we need
> > > > to worry about them even in the case where the panic is not
> > > > machine
> > > > check related (in fact especially in this case ... we are in a
> > > > case
> > > > where we actually do want the dump to diagnose the cause of the
> > > > panic,
> > > > and we don't want to risk losing the crash dump because we
> > > > aborted when
> > > > touching a page that the OS had safely avoided for
> > > > days/weeks/months).
> > > > 
> > > > So passing a list of poisoned pages from the old kernel to the
> > > > new kernel
> > > > is a good idea - and is independent of the cause of the crash
> > > > (except that
> > > > in the fatal machine check case due to memory error the list is
> > > > guaranteed
> > > > to be non-empty).
> > > 
> > > Whre is this poisoned page info stored? In struct page? If yes, then
> > > user space can walk through it and make sure not to touch poisoned pages.
> > > Anyway user space filtering utility "makedumpfile" walks through struct
> > > pages to filter out the pages. It should be able to filter out
> > > poisoned pages unconditionally. So there should be no need for kernel
> > > to export a list of these pages.
> > 
> > Does this utility work on a vmcore dump? If so, Tony refers to the
> > creation of the vmcore itself from the memory used by the first
> > kernel.
> 
> No, this utitlity can directly work on /proc/vmcore where first kernel's
> image is still in memory and not on disk.
> 
> > If there are poisoned pages, merely accessing that portion of DRAM
> > containing the poisoned data would cause further MCEs in the freshly
> > booted kernel so you won't be able to finish creating the dump.
> 
> As long as you can get to your struct page arrays, one should be able
> to filter out poisoned pages without saving the whole dump.

It's still going to require a minimal kernel change because the
PG_hwpoison flag's bit number differs depending upon the kernel
configuration, if it exists at all.  An additional vmcoreinfo item
probably...

Dave
  
