Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab2AMWna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:43:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365Ab2AMWn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:43:29 -0500
Date: Fri, 13 Jan 2012 14:43:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@fluxnic.net>, moussaba@micron.com,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC PATCH] proc: clear_refs: do not clear reserved pages
Message-Id: <20120113144328.564cb50e.akpm@linux-foundation.org>
In-Reply-To: <20120113153556.GY1068@n2100.arm.linux.org.uk>
References: <1326467587-22218-1-git-send-email-will.deacon@arm.com>
	<20120113153556.GY1068@n2100.arm.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012 15:35:56 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, Jan 13, 2012 at 03:13:07PM +0000, Will Deacon wrote:
> > /proc/pid/clear_refs is used to clear the Referenced and YOUNG bits for
> > pages and corresponding page table entries of the task with PID pid,
> > which includes any special mappings inserted into the page tables in
> > order to provide things like vDSOs and user helper functions.
> > 
> > On ARM this causes a problem because the vectors page is mapped as a
> > global mapping and since ec706dab ("ARM: add a vma entry for the user
> > accessible vector page"), a VMA is also inserted into each task for this
> > page to aid unwinding through signals and syscall restarts. Since the
> > vectors page is required for handling faults, clearing the YOUNG bit
> > (and subsequently writing a faulting pte) means that we lose the vectors
> > page *globally* and cannot fault it back in. This results in a system
> > deadlock on the next exception.
> > 
> > This patch avoids clearing the aforementioned bits for reserved pages,
> > therefore leaving the vectors page intact on ARM. Since reserved pages
> > are not candidates for swap, this change should not have any impact on
> > the usefulness of clear_refs.
> 
> Having just looked at mm/swapfile.c, what ensures that we don't try to swap
> the vectors page out?

Scanning and swapout access the page via the vm's page LRU lists. 
These magical pages shouldn't be on the LRU, so the VM won't pester
them.  If those pages did get added to the LRU somwhoe then yes,
there's a problem.

> I thought that VM_IO or VM_RESERVED once guaranteed that the vma wouldn't
> be scanned, but I don't see anything in there which tests these flags.
> As a result, it seems to me that the original patch is wrong, and we need
> to keep the vectors page completely out of the vma list to prevent it
> ever being made old.
> 
> Maybe the MM gurus can comment?

The MM guru is Hugh.
