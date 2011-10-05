Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935222Ab1JER3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934481Ab1JER3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:29:53 -0400
Date: Wed, 5 Oct 2011 13:29:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "crash-utility@redhat.com" <crash-utility@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        "tachibana@mxm.nes.nec.co.jp" <tachibana@mxm.nes.nec.co.jp>,
        "oomichi@mxs.nes.nec.co.jp" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005172912.GI30146@redhat.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004143012.GB28306@redhat.com>
 <20111005074116.GC2235@in.ibm.com>
 <20111005154011.GD30146@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE62D58D@orsmsx505.amr.corp.intel.com>
 <20111005171007.GF30146@redhat.com>
 <20111005172036.GD18592@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005172036.GD18592@gere.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 07:20:37PM +0200, Borislav Petkov wrote:
> On Wed, Oct 05, 2011 at 01:10:07PM -0400, Vivek Goyal wrote:
> > On Wed, Oct 05, 2011 at 08:58:53AM -0700, Luck, Tony wrote:
> > > > > The plan is to pass-down the list of poisoned memory pages to the second
> > > > > kernel using an elf-note so that these pages are left untouched during
> > > > > dump capture. I'm working on an implementation of the same and should
> > > > > have patches soon.
> > > >
> > > > I would say let us first figure out what happens while reading a poisoned
> > > > page and is this a problem before working on a solution.
> > > 
> > > If the page is poisoned because of a real uncorrectable error in memory
> > > (reported as SRAO machine check today, or by SRAR real-soon-now). Then
> > > accessing the page from the processor while taking a memory dump will
> > > result in a machine check.
> > > 
> > > Note that a large memory system that had been running for a long time
> > > may have built up a small stash of these land-mine pages - and we need
> > > to worry about them even in the case where the panic is not machine
> > > check related (in fact especially in this case ... we are in a case
> > > where we actually do want the dump to diagnose the cause of the panic,
> > > and we don't want to risk losing the crash dump because we aborted when
> > > touching a page that the OS had safely avoided for days/weeks/months).
> > > 
> > > So passing a list of poisoned pages from the old kernel to the new kernel
> > > is a good idea - and is independent of the cause of the crash (except that
> > > in the fatal machine check case due to memory error the list is guaranteed
> > > to be non-empty).
> > 
> > Whre is this poisoned page info stored? In struct page? If yes, then
> > user space can walk through it and make sure not to touch poisoned pages.
> > Anyway user space filtering utility "makedumpfile" walks through struct
> > pages to filter out the pages. It should be able to filter out 
> > poisoned pages unconditionally. So there should be no need for kernel
> > to export a list of these pages.
> 
> Does this utility work on a vmcore dump? If so, Tony refers to the
> creation of the vmcore itself from the memory used by the first kernel.

No, this utitlity can directly work on /proc/vmcore where first kernel's
image is still in memory and not on disk.

> If there are poisoned pages, merely accessing that portion of DRAM
> containing the poisoned data would cause further MCEs in the freshly
> booted kernel so you won't be able to finish creating the dump.

As long as you can get to your struct page arrays, one should be able
to filter out poisoned pages without saving the whole dump.

Thanks
Vivek
