Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1GGSsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:48:54 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:27397 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755519Ab1GGSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:48:53 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: LvZLCjQVM1mIbwzawevZTEqTHCInU7_a3Wl4rakPqQONeZE
 tSQwLMG07cppV.FAc42yMNnmvZixh.aG9tdHvq6sqp8d8G0BKS21Tp8c8a7q
 pBf5rflhFoJPQd.NQnrEeDN5t4C8wO.6MoePoYg3PgTmaLt0UPgZEq5LqXDF
 L_fYrZ8l9ktRJrNxu6L_UF84fm1SjynkBOJeKzjM776BDOxmTpdmIoGOuIZr
 WHW0vBTAb1S_NC8Va6PTPtJWcB5zyCHQYn7l7MWw_1Ojhw63KY7BrJEvlKnC
 WSXIase4disn2i2nFcxAt56JbkOdzxwMt2L2EhVzwT0jpsrG2VQsbDbqVSlg
 a0.iYPAotZWs1422_UPWzm5Qn
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Jul 2011 13:48:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ben Greear <greearb@candelatech.com>
cc: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] slub:  Add method to verify memory is not
 freed.
In-Reply-To: <1310063797-14914-2-git-send-email-greearb@candelatech.com>
Message-ID: <alpine.DEB.2.00.1107071347220.21719@router.home>
References: <1310063797-14914-1-git-send-email-greearb@candelatech.com> <1310063797-14914-2-git-send-email-greearb@candelatech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, greearb@candelatech.com wrote:

> +	struct page *page;
> +	void *object = (void *)x;
> +	unsigned long flags;
> +	bool rv;
> +
> +	if (unlikely(ZERO_OR_NULL_PTR(x)))
> +		return false;
> +
> +	local_irq_save(flags);
> +
> +	page = virt_to_head_page(x);
> +	if (unlikely(!PageSlab(page))) {
> +		/* maybe it was from stack? */

Or it is a compound page that was used because the allocation was larger
than an order 2 alloc. Same result though.

> +		rv = true;
> +		goto out_unlock;
> +	}
> +
> +	slab_lock(page);
> +	if (on_freelist(page->slab, page, object)) {
> +		object_err(page->slab, page, object, "Object is on free-list");
> +		rv = false;
> +	} else {
> +		rv = true;
> +	}
> +	slab_unlock(page);
> +
> +out_unlock:
> +	local_irq_restore(flags);
> +	return rv;
> +}
> +EXPORT_SYMBOL(verify_mem_not_deleted);
> +#endif
> +
>  void kfree(const void *x)
>  {
>  	struct page *page;
>

Acked-by: Christoph Lameter <cl@linux.com>

