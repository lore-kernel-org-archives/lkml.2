Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007Ab2HVTPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:15:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917Ab2HVTPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:15:37 -0400
Date: Wed, 22 Aug 2012 12:15:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: mmu_notifier: fix inconsistent memory between
 secondary MMU and host
Message-Id: <20120822121535.8be38858.akpm@linux-foundation.org>
In-Reply-To: <20120822162955.GT29978@redhat.com>
References: <503358FF.3030009@linux.vnet.ibm.com>
	<20120821150618.GJ27696@redhat.com>
	<5034763D.60508@linux.vnet.ibm.com>
	<20120822162955.GT29978@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012 18:29:55 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Wed, Aug 22, 2012 at 02:03:41PM +0800, Xiao Guangrong wrote:
> > On 08/21/2012 11:06 PM, Andrea Arcangeli wrote:
> > > CPU0  		    	    	CPU1
> > > 				oldpage[1] == 0 (both guest & host)
> > > oldpage[0] = 1
> > > trigger do_wp_page
> > 
> > We always do ptep_clear_flush before set_pte_at_notify(),
> > at this point, we have done:
> >   pte = 0 and flush all tlbs
> > > mmu_notifier_change_pte
> > > spte = newpage + writable
> > > 				guest does newpage[1] = 1
> > > 				vmexit
> > > 				host read oldpage[1] == 0
> > 
> >                   It can not happen, at this point pte = 0, host can not
> > 		  access oldpage anymore, host read can generate #PF, it
> >                   will be blocked on page table lock until CPU 0 release the lock.
> 
> Agreed, this is why your fix is safe.
> 
> ...
>
> Thanks a lot for fixing this subtle race!

I'll take that as an ack.

Unfortunately we weren't told the user-visible effects of the bug,
which often makes it hard to determine which kernel versions should be
patched.  Please do always provide this information when fixing a bug.


