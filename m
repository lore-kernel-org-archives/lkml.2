Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1EJXhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:37:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43405 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1EJXhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:37:11 -0400
Date: Tue, 10 May 2011 19:36:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hpa@linux.intel.com, hpa@zytor.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Linux 2.6.39-rc7
Message-ID: <20110510233644.GA23858@dumpdata.com>
References: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com>
 <20110510035356.GA6954@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510035356.GA6954@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DC9CC18.00BF:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 11:53:56PM -0400, Konrad Rzeszutek Wilk wrote: > On Mon, May 09, 2011 at 07:49:48PM -0700, Linus Torvalds wrote:
> > So things have been pretty quiet, and unless something major comes up
> > I believe that this will be the last -rc.
> 
> Oh no! I was hoping for an extra week!
> 
> The patch that I asked to be pulled: (a38647837a411f7df79623128421eef2118b5884)
> "xen/mmu: Add workaround "x86-64, mm: Put early page table high"
> 
> does not compleltly workaround the regression that the patch from Yinghai titled 
> 'x86-64, mm: Put early page table high" introduced wherein Linux can't boot under Xen.
> 
> The failure still encountered: https://lkml.org/lkml/2011/5/5/180, the
> previous git pull request with an outline of the problem https://lkml.org/lkml/2011/5/3/99
> and huge amount of details in http://marc.info/?i=1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com
> 
> I was hoping that the rc6 could stretch out so that by the time hpa came back from
> his travels he would have had a chance to look at: https://lkml.org/lkml/2011/5/5/226

I had a chance to briefly talk on IRC with hpa and he mentioned I should
send a note to Ingo about this since hpa won't be able to do anything until Friday.

Ingo,
Not sure how familiar you are with this issue, but let me briefly explain it.
Yinghai provided a patch, which calls memblock_find_in_range(), then calls
kernel_physical_mapping_init, which populates the pagetable between pgt_buf_start
and pgt_buf_top and once it is done, calls memblock_x86_reserve_range with pgt_buf_start
and pgt_buf_end (wherein pgt_buf_end <=  pgt_buf_top). The memory between pgt_buf_end
and pgt_buf_top can be re-used later on and it is by other subsystems - NUMA for
example uses it.

Under Xen, the pagetables end up being marked RO, so what ends up happening is that
some pages from pgt_buf_end through pgt_buf_top end up RO and the system crashes during
bootup as NUMA subsystem tries to write to that area. The fix is to essentially mark the
area from pgt_buf_end through pgt_buf_top to RW.

Stefano posted a patch, which was Acked by Yinghai, but not so by hpa. The concerns
were that the patch inserts a hook just for this single case and there should be a better
way of doing this - where we either don't need a hook or provide an semantic explanation
of the pagetable building and build the patch from there.

Sadly there was/is not enough time in the 2.6.39 train to actually do it properly.
So I provided another patch (which Linus merged) which crudely tries to mark the area from
pgt_buf_end through pgt_buf_top to RW and all is done within the Xen MMU code. Sadly it
does not work on all machines.

Without a resolution to this, the Linux x86_64 kernel cannot boot under Xen. There are two
options left right now:
 a). Revert 4b239f458c229de044d6905c2b0f9fe16ed9e01e (x86-64, mm: Put early page table high)
 b). or revert the workaround that Linus merged and pick the one that Stefano came up with.
     The patches are available in
     git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-for-rc6

     They touch the generic x86 MMU code.

