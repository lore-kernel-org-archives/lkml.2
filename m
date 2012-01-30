Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2A3RQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:16:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64522 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab2A3RQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:16:04 -0500
Date: Mon, 30 Jan 2012 09:15:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
Message-ID: <20120130171558.GB3355@google.com>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 12:37:34PM +0400, Dmitry Antipov wrote:
> Fix pcpu_alloc() to return ZERO_SIZE_PTR if requested size is 0;
> fix free_percpu() to check passed pointer with ZERO_OR_NULL_PTR.
> 
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> ---
>  mm/percpu.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index f47af91..e903a19 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -702,7 +702,8 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
>   * Does GFP_KERNEL allocation.
>   *
>   * RETURNS:
> - * Percpu pointer to the allocated area on success, NULL on failure.
> + * ZERO_SIZE_PTR if @size is zero, percpu pointer to the
> + * allocated area on success or NULL on failure.
>   */
>  static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
>  {
> @@ -713,7 +714,10 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
>  	unsigned long flags;
>  	void __percpu *ptr;
>  
> -	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
> +	if (unlikely(!size))
> +		return ZERO_SIZE_PTR;

Percpu pointers are in a different address space and using
ZERO_SIZE_PTR directly will trigger sparse address space warning.
Also, I'm not entirely sure whether 16 is guaranteed to be unused in
percpu address space (maybe it is but I don't think we have anything
enforcing that).

Thanks.

-- 
tejun
