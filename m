Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2IQKAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:00:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21190 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2IQKAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:00:47 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-93-5056f35edc85
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Peter Senna Tschudin'" <peter.senna@gmail.com>, cjb@laptop.org
Cc: will.newton@imgtec.com, jh80.chung@samsung.com, kyungmin.park@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
In-reply-to: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
Subject: RE: [PATCH 1/4] drivers/mmc/host/dw_mmc.c: fix error return code
Date: Mon, 17 Sep 2012 18:54:37 +0900
Message-id: <016401cd94ba$733937d0$59aba770$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2UrKGYHplILCNSQMyE84ajzMYStQADFbIg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jAd24z2EBBhu/iVlsvSVtcXnXHDaL
	I//7GR2YPT5vkgtgjOKySUnNySxLLdK3S+DKOHb1E3PBGp6KGfsWMTUwvuLsYuTkkBAwkXh/
	dCsjhC0mceHeerYuRi4OIYFFjBI3L3cwQzh/GCUuHTjCDlLFJqAl8ffNG2YQW0TASeLrzK8s
	IEXMAqsZJWb1vGYDSQgJuEj8broC1sAp4CrR9WkDE4gtLOApsXX1IrB1LAKqEvumPgWr4RWw
	ldi/7AmULSjxY/I9FhCbWcBA4v2sPlYIW15i85q3QIs5gE5Vl3j0VxfiBiOJHdfuM0GUiEjs
	e/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO7mdS
	OxhXNlgcYhTgYFTi4TWcFBYgxJpYVlyZe4hRgoNZSYT3wRugEG9KYmVValF+fFFpTmrxIUZp
	DhYlcV7hT4EBQgLpiSWp2ampBalFMFkmDk6pBkY/1f+K5459Prr1hZ5qusEEL2HjD99nbrly
	SkFEMkv6xAddlvlSklcv9Ykd0N+4VaqH95iyWNc7trlMHu2GEU8mb3FeIBJSr/p/DnPMbPFW
	73fqx2MXWfVYia5XzFBe/UcxXe3LiYXpLxXSl2dp39G6tiXVq36q8/n6DL4/21pvr/h48Kt9
	4n8lluKMREMt5qLiRABqRmkJagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 17, 2012, Peter Senna Tschudin <peter.senna@gmail.com> wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  drivers/mmc/host/dw_mmc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 36f98c0..7ad5176 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2039,8 +2039,10 @@ int dw_mci_probe(struct dw_mci *host)
>  	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
>  	host->card_workqueue = alloc_workqueue("dw-mci-card",
>  			WQ_MEM_RECLAIM | WQ_NON_REENTRANT, 1);
> -	if (!host->card_workqueue)
> +	if (!host->card_workqueue) {
> +		err = -ENOMEM;
ret is expected instead of err.
err isn't defined.

Thanks,
Seungwon Jeon

>  		goto err_dmaunmap;
> +	}
>  	INIT_WORK(&host->card_work, dw_mci_work_routine_card);
>  	ret = request_irq(host->irq, dw_mci_interrupt, host->irq_flags, "dw-mci", host);
>  	if (ret)
> --
> 1.7.11.4

