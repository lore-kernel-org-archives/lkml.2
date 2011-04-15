Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1DOQxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:53:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:61694 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1DOQxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:53:34 -0400
Message-ID: <4DA877F0.1050100@windriver.com>
Date: Fri, 15 Apr 2011 12:53:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
        Andy Grover <andy.grover@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [74/74] net: fix rds_iovec page count overflow
References: <20110413155150.984826556@clark.kroah.org>
In-Reply-To: <20110413155150.984826556@clark.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2011 16:53:06.0394 (UTC) FILETIME=[97AE63A0:01CBFB8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-13 11:51 AM, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit 1b1f693d7ad6d193862dcb1118540a030c5e761f upstream.
> 
> As reported by Thomas Pollet, the rdma page counting can overflow.  We
> get the rdma sizes in 64-bit unsigned entities, but then limit it to
> UINT_MAX bytes and shift them down to pages (so with a possible "+1" for
> an unaligned address).
> 
> So each individual page count fits comfortably in an 'unsigned int' (not
> even close to overflowing into signed), but as they are added up, they
> might end up resulting in a signed return value. Which would be wrong.
> 
> Catch the case of tot_pages turning negative, and return the appropriate
> error code.
> 
> Reported-by: Thomas Pollet <thomas.pollet@gmail.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Andy Grover <andy.grover@oracle.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  net/rds/rdma.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- a/net/rds/rdma.c
> +++ b/net/rds/rdma.c
> @@ -473,6 +473,14 @@ static struct rds_rdma_op *rds_rdma_prep
>  
>  		max_pages = max(nr, max_pages);
>  		nr_pages += nr;
> +
> +		/*
> +		 * nr_pages for one entry is limited to (UINT_MAX>>PAGE_SHIFT)+1,
> +		 * so tot_pages cannot overflow without first going negative.
> +		 */
> +		if ((int)nr_pages < 0)

Sorry if this doesn't make the review cutoff; just noticed it now.

A cosmetic note -- I think the comment no longer matches the code for
the backport, in that it is now misleading, and should instead be:

	* nr for one entry is limited to (UINT_MAX>>PAGE_SHIFT)+1,
	* so nr_pages cannot overflow without first going negative.

For context, the original upstream was:

                tot_pages += nr_pages;
+
+               /*
+                * nr_pages for one entry is limited to (UINT_MAX>>PAGE_SHIFT)+1,
+                * so tot_pages cannot overflow without first going negative.
+                */
+               if ((int)tot_pages < 0)
+                       return -EINVAL;

Paul.
