Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3ABEj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 23:39:26 -0500
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:56777
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537Ab3ABEjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 23:39:24 -0500
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2013 23:39:23 EST
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20707.47067.474241.813195@gargle.gargle.HOWL>
Date: Wed, 2 Jan 2013 10:00:19 +0530
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Stable <stable@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        ath9k-devel@lists.ath9k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Fix skb leaks
In-Reply-To: <1357098567-8558-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1357098567-8558-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: VM 8.2.0b under 24.2.2 (x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
> index 4a9570d..a304748 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -278,10 +278,12 @@ int htc_connect_service(struct htc_target *target,
>  	if (!time_left) {
>  		dev_err(target->dev, "Service connection timeout for: %d\n",
>  			service_connreq->service_id);
> -		return -ETIMEDOUT;
> +		ret = -ETIMEDOUT;
> +		goto err;
>  	}
>  
>  	*conn_rsp_epid = target->conn_rsp_epid;
> +	kfree_skb(skb);
>  	return 0;
>  err:
>  	kfree_skb(skb);

The allocated skb should be freed in the TX completion hander,
ath9k_htc_txcompletion_cb() - doing it in htc_connect_service() is wrong, I think.

Sujith
