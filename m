Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2GaGrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:47:40 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46796 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2GaGrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:47:39 -0400
Date: Tue, 31 Jul 2012 12:17:30 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: mmap_region() corrupts mm->mm_rb if
 uprobe_mmap() fails
Message-ID: <20120731064730.GB5087@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120728163157.GA22719@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120728163157.GA22719@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073106-6148-0000-0000-0000082D7C2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> If mmap_region()->uprobe_mmap() fails, unmap_and_free_vma path
> does unmap_region() but does not remove the soon-to-be-freed vma
> from rb tree (actually there are more problems).
> 
> Perhaps we could do do_munmap() + return in this case, but in fact
> it is simply wrong to abort if uprobe_mmap() fails. Until at least
> we move the !UPROBE_COPY_INSN code from install_breakpoint() to
> uprobe_register().
> 
> For example, uprobe_mmap()->install_breakpoint() can fail if the
> probed insn is not supported (remember, uprobe_register() succeeds
> if nobody mmaps inode/offset), mmap() should not fail in this case.
> 
> dup_mmap()->uprobe_mmap() is wrong too by the same reason, fork()
> can race with uprobe_register() and fail for no reason if it wins
> the race and does install_breakpoint() first.
> 
> Change mmap_region() and dup_mmap() to ignore the error code from
> uprobe_mmap().
> 
> Reported-by: William Cohen <wcohen@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: <stable@vger.kernel.org> # v3.5
> ---
>  kernel/fork.c |    4 ++--
>  mm/mmap.c     |    5 ++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index ab5211b..54bb88a 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -454,8 +454,8 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  		if (retval)
>  			goto out;
> 
> -		if (file && uprobe_mmap(tmp))
> -			goto out;
> +		if (file)
> +			uprobe_mmap(tmp);

I am not comfortable with this fix.

Lets say there were 10 probes that were to be installed in that vma.
we were able to install five probes and the 6th one happened to fail
because of invalid instruction; we dont continue with the registering
probes for the remaining 4 probes.

Your fix allows probe hits for 5 registered probes that can lead to
misleading analysis. For example if one of the first five probes was a
malloc and the probe at free() was one of the last probes which wasnt
registered, then a person doing an analysis based on probes can say
there was a memory leak.

The intention behind failing mmap()/fork() if uprobe_mmap failed,
was to make sure that we always report the correct number of events.

Infact this was something that Peter advocated very strongly
http://article.gmane.org/gmane.linux.kernel.mm/59956

I think the long term solution is as you mentioned, move the
instruction analysis to register.

Till then should we just ignore invalid instruction probes similar to 
existing probes. i.e we return -ESRCH or some such which is ignored in
uprobe_mmap(), but is taken care of in the uprobe_register path.

The above may not be an elegant solution but.. 

-- 
thanks and regards
Srikar

