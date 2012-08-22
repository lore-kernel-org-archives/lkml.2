Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2HVT6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:58:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2HVT6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:58:06 -0400
Date: Wed, 22 Aug 2012 12:58:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: mmu_notifier: fix inconsistent memory between
 secondary MMU and host
Message-Id: <20120822125805.9c62aa79.akpm@linux-foundation.org>
In-Reply-To: <20120822195043.GA8107@redhat.com>
References: <503358FF.3030009@linux.vnet.ibm.com>
	<20120821150618.GJ27696@redhat.com>
	<5034763D.60508@linux.vnet.ibm.com>
	<20120822162955.GT29978@redhat.com>
	<20120822121535.8be38858.akpm@linux-foundation.org>
	<20120822195043.GA8107@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012 21:50:43 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> Hi Andrew,
> 
> On Wed, Aug 22, 2012 at 12:15:35PM -0700, Andrew Morton wrote:
> > On Wed, 22 Aug 2012 18:29:55 +0200
> > Andrea Arcangeli <aarcange@redhat.com> wrote:
> > 
> > > On Wed, Aug 22, 2012 at 02:03:41PM +0800, Xiao Guangrong wrote:
> > > > On 08/21/2012 11:06 PM, Andrea Arcangeli wrote:
> > > > > CPU0  		    	    	CPU1
> > > > > 				oldpage[1] == 0 (both guest & host)
> > > > > oldpage[0] = 1
> > > > > trigger do_wp_page
> > > > 
> > > > We always do ptep_clear_flush before set_pte_at_notify(),
> > > > at this point, we have done:
> > > >   pte = 0 and flush all tlbs
> > > > > mmu_notifier_change_pte
> > > > > spte = newpage + writable
> > > > > 				guest does newpage[1] = 1
> > > > > 				vmexit
> > > > > 				host read oldpage[1] == 0
> > > > 
> > > >                   It can not happen, at this point pte = 0, host can not
> > > > 		  access oldpage anymore, host read can generate #PF, it
> > > >                   will be blocked on page table lock until CPU 0 release the lock.
> > > 
> > > Agreed, this is why your fix is safe.
> > > 
> > > ...
> > >
> > > Thanks a lot for fixing this subtle race!
> > 
> > I'll take that as an ack.
> 
> Yes thanks!
> 
> I'd also like a comment that explains why in that case the order is
> reversed. The reverse order immediately rings an alarm bell otherwise
> ;). But the comment can be added with an incremental patch.

If you can suggest some text I'll type it in right now.

> > Unfortunately we weren't told the user-visible effects of the bug,
> > which often makes it hard to determine which kernel versions should be
> > patched.  Please do always provide this information when fixing a bug.
> 
> This is best answered by Xiao who said it's a testcase triggering
> this.
> 
> It requires the guest reading memory on CPU0 while the host writes to
> the same memory on CPU1, while CPU2 triggers the copy on write fault
> on another part of the same page (slightly before CPU1 writes). The
> host writes of CPU1 would need to happen in a microsecond window, and
> they wouldn't be immediately propagated to the guest in CPU0. They
> would still appear in the guest but with a microsecond delay (the
> guest has the spte mapped readonly when this happens so it's only a
> guest "microsecond delayed reading" problem as far as I can tell). I
> guess most of the time it would fall into the undefined by timing
> scenario so it's hard to tell how the side effect could escalate.

OK, thanks.  For this sort of thing I am dependent upon KVM people to
suggest whether the fix should be in 3.6 and whether -stable needs it.

