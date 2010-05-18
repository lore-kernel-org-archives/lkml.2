Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0ERKYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:24:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:50999 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab0ERKYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:24:51 -0400
Message-ID: <4BF26AD9.5070601@kernel.org>
Date: Tue, 18 May 2010 12:24:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: imre.deak@nokia.com
CC: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] idr: fix backtrack logic in idr_remove_all
References: <319c869d40252c570a288166665635295d09108a.1273664539.git.imre.deak@nokia.com>
In-Reply-To: <319c869d40252c570a288166665635295d09108a.1273664539.git.imre.deak@nokia.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 10:24:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/12/2010 01:47 PM, imre.deak@nokia.com wrote:
> The fix changes how we determine the number of levels to step back.
> Instead of deducting this merely from the msb of the current ID, we
> should really check if advancing the ID causes an overflow to a bit
> position corresponding to a given layer. In the above example overflow
> from bit 0 to bit 1 should mean stepping back 1 level. Overflow from
> bit 1 to bit 2 should mean stepping back 2 level and so on.
> 
> The fix was tested with elements up to 1 << 20, which corresponds to
> 4 layers on 32 bit systems.
> 
> Signed-off-by: Imre Deak <imre.deak@nokia.com>
> ---
>  lib/idr.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/idr.c b/lib/idr.c
> index 9042a56..931d9d0 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -445,6 +445,7 @@ EXPORT_SYMBOL(idr_remove);
>  void idr_remove_all(struct idr *idp)
>  {
>  	int n, id, max;
> +	int bt_mask;
>  	struct idr_layer *p;
>  	struct idr_layer *pa[MAX_LEVEL];
>  	struct idr_layer **paa = &pa[0];
> @@ -462,8 +463,9 @@ void idr_remove_all(struct idr *idp)
>  			p = p->ary[(id >> n) & IDR_MASK];
>  		}
>  
> +		bt_mask = id;
>  		id += 1 << n;
> -		while (n < fls(id)) {
> +		while (n < fls(id & ~bt_mask)) {

Shouldn't this be id ^ bt_mask?  The above only detects 1 -> 0
transitions not the other way around.  I don't think it will free all
the layers in the middle.  Have you counted the number of frees match
the number of allocations?

Thanks.

-- 
tejun
