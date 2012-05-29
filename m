Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2E2OmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:42:10 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:26136 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753331Ab2E2OmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:42:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Uc9_qSYVM1lb3qCVEV7akOPOFZG5XhI45A_8emwn_Dy3e2V
 vZoOQ2Xiej8UNzgESi28KMg6WT8TOSyYWTyhx614bICvGnhbyEepMvAoRz1e
 a_etUUuaox2ElYS.7PLp1tln.afsAg6pWT4bAhlPYo4ZqW4kkQAMt57SttIU
 iUUAaS26tZV5yaOWeGILX1k3Ha4bz5ztgzpQAPy5aNxwLI3qeW_EGh.EwHeV
 FZD6Bd.k8UG_FETcCU2Z6azW0f2h0fo8fzm2bBjlrXSGemz87oclEY0nTLEv
 SaqbNfvDUBL7X1SUg5ACumNaZbDg9w1M4QBmxgromW.Kxts0_xNA8_CQkrRY
 yoy7OqM.mGQpT_T6QkecvAefBEI58Twre1vdRWFWE.HtyhgU35312VzvRWzT
 YgMjL2i52xNpmyziQ_djj3keNYfu_DjXAY44K
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 09:42:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 15/28] slub: always get the cache from its page in
 kfree
In-Reply-To: <1337951028-3427-16-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205290939540.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-16-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Glauber Costa wrote:

> struct page already have this information. If we start chaining
> caches, this information will always be more trustworthy than
> whatever is passed into the function

Yes but the lookup of the page struct also costs some cycles. SLAB in
!NUMA mode and SLOB avoid these lookups and can improve their freeing
speed because of that.

> diff --git a/mm/slub.c b/mm/slub.c
> index 0eb9e72..640872f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2598,10 +2598,14 @@ redo:
>  void kmem_cache_free(struct kmem_cache *s, void *x)
>  {
>  	struct page *page;
> +	bool slab_match;
>
>  	page = virt_to_head_page(x);
>
> -	slab_free(s, page, x, _RET_IP_);
> +	slab_match = (page->slab == s) | slab_is_parent(page->slab, s);
> +	VM_BUG_ON(!slab_match);

Why add a slab_match bool if you do not really need it?
