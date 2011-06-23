Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab1FWTuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:50:01 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:35664 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932892Ab1FWTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:49:59 -0400
Date: Thu, 23 Jun 2011 14:49:49 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH RFC] futex: Fix regression with read only mappings
Message-ID: <20110623194949.GA2083@BohrerMBP.rgmadvisors.com>
References: <4DF8FFF6.4060000@linux.intel.com>
 <1308770340-21895-1-git-send-email-sbohrer@rgmadvisors.com>
 <4E024D2D.6070308@linux.intel.com>
 <4E02AA40.30203@jp.fujitsu.com>
 <4E035B39.1080207@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E035B39.1080207@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 08:26:49AM -0700, Darren Hart wrote:
> 
> 
> On 06/22/2011 07:51 PM, KOSAKI Motohiro wrote:
> > (2011/06/23 5:14), Darren Hart wrote:
> >> Hi Shawn,
> >>
> >> Thanks for taking this up. Would you share your testcases as well?
> >>
> >> On 06/22/2011 12:19 PM, Shawn Bohrer wrote:
> >>> commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
> >>> parameter from get_futex_key()) in 2.6.33 introduced a user-mode
> >>> regression in that it additionally prevented futex operations on a
> >>> region within a read only memory mapped file.  For example this breaks
> >>> workloads that have one or more reader processes doing a FUTEX_WAIT on a
> >>> futex within a read only shared mapping, and a writer processes that has
> >>> a writable mapping issuing the FUTEX_WAKE.
> >>>
> >>> This fixes the regression for futex operations that should be valid on
> >>> RO mappings by trying a RO get_user_pages_fast() when the RW
> >>> get_user_pages_fast() fails so as not to slow down the common path of
> >>> writable anonymous maps and bailing when we used the RO path on
> >>> anonymous memory.
> >>>
> >>> Patch based on Peter Zijlstra's initial patch with modifications to only
> >>> allow RO mappings for futex operations that need VERIFY_READ access.
> >>>
> >>> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> >>> ---
> >>>
> >>> Interestingly this patch also allows doing a FUTEX_WAIT on a RO private
> >>> mapping.
> >>
> >> I don't see any harm in this.
> > 
> > Hi
> > 
> > I have no objection. However I'd like to explain why I decided to
> > prefer to refuse RO private mappings and used prefault.
> > 
> > private mapping semantics is, to write access makes process private pages
> > (ie PageAnon=1).
> > 
> > So, this patch introduce following another corner case.
> > 
> > Thread-A: call futex(FUTEX_WAIT, memory-region-A).
> >           get_futex_key() return inode based key.
> >           sleep on the key
> > Thread-B: call mprotect(PROT_READ|PROT_WRITE, memory-region-A)
> > Thread-B: write memory-region-A.
> >           COW happen. This process's memory-region-A become related
> >           to new COWed private (ie PageAnon=1) page.
> > Thread-B: call futex(FUETX_WAKE, memory-region-A).
> >           get_futex_key() return mm based key.
> >           IOW, we fail to wake up Thread-A.
> > 
> > It's unclear real world issue or not. But I hope everybody realize it.
> > So, Probably it would be great if you add some comments for this issue.
> > 
> > 2.6.18 had an another trick. It used vma walk for avoiding this issue.
> > and, unfortunately, it's slow.
> 
> 
> Let me try and restate, please tell me if I have this correct:
> 
> RO file backed private mappings can be converted to a RW mapping between
> FUTEX_WAIT and FUTEX_WAKE, resulting in the use of different keys (as
> the RO mapping finds an inode key and the RW mapping returns an
> anonymous key). The way to fix this is to use the virtual address
> instead of the physical address, like shared futexes, but this has to be
> done all the time as there is no way to know if the RO mapping will be
> changed after a key is looked up, so it would eliminate the gains of the
> private futexes.
> 
> A RO private mapping doesn't make a lot of sense to me since at least
> one thread of the process will have to have write permission in order
> for the mechanism to be useful,
<snip>

I agree that a RO private mapping doesn't make a lot of sense, even if
another thread/process has write access to the file.  My mmap man page
says:

       MAP_PRIVATE
                  Create  a  private  copy-on-write  mapping.   Stores
                  to  the region do not affect the original file.  It
                  is unspecified whether changes made to the file
                  after the mmap() call are visible in the mapped
                  region.

So apparently it is unspecified whether changes to the underlying file
will even be visible in the mapped region.  My quick tests so far
indicate that changes are visible, but it wouldn't surprise me if
there are cases where they are not.

> so the approach taken in the patch (EFAULT on RO anonymous private
> mappings) seems reasonable.

That sounds reasonable but the patch I sent doesn't appear to do this.
The patch I sent returns EFAULT on RO anonymous pages, but as KOSAKI
mentioned above (and from my testing) _write access_ makes the pages
of private mappings anonymous.  So if the private mapping is marked
read only it keys off the inode.

I actually don't know of a case where you would have a RO anonymous
page.  I tried using mmap with PROT_READ and MAP_ANONYMOUS, but I
believe this simply maps the zero page, and that does cause the
FUTEX_WAIT to hang with my patch.  Perhaps you can use mprotect to
mark normal anonymous pages RO?  And if you have a RO anonymous page
should FUTEX_WAIT return EFAULT?

I'd say a solution that allows RO shared mappings and rejects
RO private mappings would be ideal, but I currently don't see a way to
tell the difference.  You could also argue that users of private
mappings should understand the risks.

--
Shawn


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

