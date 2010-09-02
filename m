Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0IBJcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 05:32:18 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:45995 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0IBJcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 05:32:17 -0400
X-Greylist: delayed 1413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2010 05:32:17 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [patch v2 5/5] ntfs: remove dependency on __GFP_NOFAIL
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <alpine.DEB.2.00.1009011801050.24694@chino.kir.corp.google.com>
Date: Thu, 2 Sep 2010 10:08:28 +0100
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Altaparmakov <aia21@cantab.net>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A326B3E1-DB22-4C25-9ED5-C6A5F25BF15E@cam.ac.uk>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com> <alpine.DEB.2.00.1009011801050.24694@chino.kir.corp.google.com>
To: David Rientjes <rientjes@google.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 2 Sep 2010, at 02:03, David Rientjes wrote:
> Reimplement ntfs_malloc_nofs_nofail() to loop forever calling
> ntfs_malloc_nofs() until the allocation succeeds.
> 
> If the first allocation attempt fails because the page allocator doesn't
> implicitly loop, a warning will be emitted, including a call trace.
> Subsequent failures will suppress this warning.
> 
> This was added as a helper function for documentation and auditability.
> No future callers should be added.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
> fs/ntfs/malloc.h |   12 ++++++++++--
> 1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ntfs/malloc.h b/fs/ntfs/malloc.h
> --- a/fs/ntfs/malloc.h
> +++ b/fs/ntfs/malloc.h
> @@ -76,11 +76,19 @@ static inline void *ntfs_malloc_nofs(unsigned long size)
>  * This function guarantees that the allocation will succeed.  It will sleep
>  * for as long as it takes to complete the allocation.
>  *
> - * If there was insufficient memory to complete the request, return NULL.
> + * NOTE: no new callers of this function should be implemented!
> + * All memory allocations should be failable whenever possible.
>  */
> static inline void *ntfs_malloc_nofs_nofail(unsigned long size)
> {
> -	return __ntfs_malloc(size, GFP_NOFS | __GFP_HIGHMEM | __GFP_NOFAIL);
> +	void *ret;
> +
> +	for (;;) {
> +		ret = ntfs_malloc_nofs(size);
> +		if (ret)
> +			return ret;
> +		WARN_ON_ONCE(get_order(size) > PAGE_ALLOC_COSTLY_ORDER);

What is the relevance of the above get_order check?  ntfs_malloc_nofs() does a vmalloc() if size >= PAGE_SIZE so I cannot see how that has anything to do with get_order()?

Other than that patch looks fine.

Note the _nofail function is only called from one place and there will be no more call sites for it.  One day we ought to work something out so it is not needed at all but given it only gets called in very obscure circumstances (definitely not in the general code paths) it shouldn't matter too much...

Best regards,

	Anton


> +	}
> }
> 
> static inline void ntfs_free(void *addr)

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

