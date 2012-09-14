Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2INNBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:01:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37232 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab2INNBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:01:20 -0400
From: "Dowdal, John" <jdowdal@ti.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, "Chemparathy, Cyril" <cyril@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "david.ward@ll.mit.edu" <david.ward@ll.mit.edu>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>
Subject: RE: [PATCH] sch_red: fix weighted average calculation
Thread-Topic: [PATCH] sch_red: fix weighted average calculation
Thread-Index: AQHNkbXNoKB7JQ9aeEuY08ljyh27ZZeIns+AgAEvUrA=
Date: Fri, 14 Sep 2012 13:01:12 +0000
Message-ID: <2D29FFBF554947468515B8EF6C733BB72E564F65@DLEE09.ent.ti.com>
References: <1347543820-27548-1-git-send-email-cyril@ti.com>
 <1347544431.13103.1557.camel@edumazet-glaptop>
In-Reply-To: <1347544431.13103.1557.camel@edumazet-glaptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8ED1Si5010131

Eric, thank you for reviewing the code.  I now see the problem with the patch since backlog is an integer and qavg is a fixed point number at logW.  

We are considering another patch to update the comments to this code (with the actual C code change reverted) to stop the FPP by showing the derivation of the equation in the comments.  Does this sound good?


-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
Sent: Thursday, September 13, 2012 9:54 AM
To: Chemparathy, Cyril
Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; davem@davemloft.net; david.ward@ll.mit.edu; Dowdal, John; paul.gortmaker@windriver.com
Subject: Re: [PATCH] sch_red: fix weighted average calculation

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


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
