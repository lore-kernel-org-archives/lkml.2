Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab2IMNyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:54:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47881 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2IMNx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:53:58 -0400
Subject: Re: [PATCH] sch_red: fix weighted average calculation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        david.ward@ll.mit.edu, jdowdal@ti.com, paul.gortmaker@windriver.com
In-Reply-To: <1347543820-27548-1-git-send-email-cyril@ti.com>
References: <1347543820-27548-1-git-send-email-cyril@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Sep 2012 15:53:51 +0200
Message-ID: <1347544431.13103.1557.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 09:43 -0400, Cyril Chemparathy wrote:
> This patch fixes an apparent bug in the running weighted average calculation
> used in the RED algorithm.
> 
> Going by the described formula:
> 	   qavg = qavg*(1-W) + backlog*W
> 	=> qavg = qavg + (backlog - qavg) * W
> 
> ... with W converted to a pre-calculated shift, this then becomes:
> 	qavg = qavg + (backlog - qavg) >> logW
> 
> ... giving the modified expression introduced by this patch.
> 
> Signed-off-by: John Dowdal <jdowdal@ti.com>
> ---
>  include/net/red.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/red.h b/include/net/red.h
> index ef46058..05960a4 100644
> --- a/include/net/red.h
> +++ b/include/net/red.h
> @@ -287,7 +287,7 @@ static inline unsigned long red_calc_qavg_no_idle_time(const struct red_parms *p
>  	 *
>  	 * --ANK (980924)
>  	 */
> -	return v->qavg + (backlog - (v->qavg >> p->Wlog));
> +	return v->qavg + (backlog - v->qavg) >> p->Wlog;
>  }
>  
>  static inline unsigned long red_calc_qavg(const struct red_parms *p,

This is going to be a FPP (Frequently Posted Patch)

Current formulae is fine.

Thats because backlog, at start of red_calc_qavg_no_idle_time() is not
yet scaled by p->Wlog. v->avg is scaled, but not backlog.

Have you tested RED after your patch ?


