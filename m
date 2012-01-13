Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab2AMPgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:36:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43359 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab2AMPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:36:14 -0500
Date: Fri, 13 Jan 2012 15:35:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, moussaba@micron.com,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH] proc: clear_refs: do not clear reserved pages
Message-ID: <20120113153556.GY1068@n2100.arm.linux.org.uk>
References: <1326467587-22218-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326467587-22218-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 03:13:07PM +0000, Will Deacon wrote:
> /proc/pid/clear_refs is used to clear the Referenced and YOUNG bits for
> pages and corresponding page table entries of the task with PID pid,
> which includes any special mappings inserted into the page tables in
> order to provide things like vDSOs and user helper functions.
> 
> On ARM this causes a problem because the vectors page is mapped as a
> global mapping and since ec706dab ("ARM: add a vma entry for the user
> accessible vector page"), a VMA is also inserted into each task for this
> page to aid unwinding through signals and syscall restarts. Since the
> vectors page is required for handling faults, clearing the YOUNG bit
> (and subsequently writing a faulting pte) means that we lose the vectors
> page *globally* and cannot fault it back in. This results in a system
> deadlock on the next exception.
> 
> This patch avoids clearing the aforementioned bits for reserved pages,
> therefore leaving the vectors page intact on ARM. Since reserved pages
> are not candidates for swap, this change should not have any impact on
> the usefulness of clear_refs.

Having just looked at mm/swapfile.c, what ensures that we don't try to swap
the vectors page out?

I thought that VM_IO or VM_RESERVED once guaranteed that the vma wouldn't
be scanned, but I don't see anything in there which tests these flags.
As a result, it seems to me that the original patch is wrong, and we need
to keep the vectors page completely out of the vma list to prevent it
ever being made old.

Maybe the MM gurus can comment?
