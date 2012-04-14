Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2DNCPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 22:15:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55289 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab2DNCPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:15:49 -0400
Date: Sat, 14 Apr 2012 11:15:44 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 03/16] KVM: MMU: properly assert spte on rmap walking
 path
Message-Id: <20120414111544.b3a4b9273fe84ddc33cb7e1c@gmail.com>
In-Reply-To: <4F87FBA5.3060203@linux.vnet.ibm.com>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
	<4F87FBA5.3060203@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 18:10:45 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

>  static u64 *rmap_get_next(struct rmap_iterator *iter)
>  {
> +	u64 *sptep = NULL;
> +
>  	if (iter->desc) {
>  		if (iter->pos < PTE_LIST_EXT - 1) {
> -			u64 *sptep;
> -
>  			++iter->pos;
>  			sptep = iter->desc->sptes[iter->pos];
>  			if (sptep)
> -				return sptep;
> +				goto exit;
>  		}
> 
>  		iter->desc = iter->desc->more;
> @@ -1028,11 +1036,14 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
>  		if (iter->desc) {
>  			iter->pos = 0;
>  			/* desc->sptes[0] cannot be NULL */
> -			return iter->desc->sptes[iter->pos];
> +			sptep = iter->desc->sptes[iter->pos];
> +			goto exit;
>  		}
>  	}
> 
> -	return NULL;
> +exit:
> +	WARN_ON(sptep && !is_shadow_present_pte(*sptep));
> +	return sptep;
>  }

This will, probably, again force rmap_get_next function-call even with EPT/NPT:
CPU cannot skip it by branch prediction.

	Takuya
