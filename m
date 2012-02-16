Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab2BPNvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:51:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:59011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2BPNvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:51:36 -0500
Message-ID: <1329400247.2293.219.camel@twins>
Subject: Re: [PATCH 01/11] perf: Push file_update_time() into
 perf_mmap_fault()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Thu, 16 Feb 2012 14:50:47 +0100
In-Reply-To: <1329399979-3647-2-git-send-email-jack@suse.cz>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
	 <1329399979-3647-2-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 14:46 +0100, Jan Kara wrote:
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  kernel/events/core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index ba36013..61a67f3 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3316,8 +3316,10 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	int ret = VM_FAULT_SIGBUS;
>  
>  	if (vmf->flags & FAULT_FLAG_MKWRITE) {
> -		if (vmf->pgoff == 0)
> +		if (vmf->pgoff == 0) {
>  			ret = 0;
> +			file_update_time(vma->vm_file);
> +		}
>  		return ret;
>  	}

Its an anon filedesc, there's no actual file and while I guess one could
probably call fstat() on it, people really shouldn't care.

So feel free to introduce this patch to the bitbucket.
