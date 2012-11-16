Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab2KPLRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 06:17:16 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52824 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPLRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:17:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6897"; a="7285678"
X-IronPort-AV: E=McAfee;i="5400,1158,6897"; a="1784717"
Message-ID: <50A620B0.6020007@qca.qualcomm.com>
Date: Fri, 16 Nov 2012 13:17:04 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: <kernel-janitors@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath6kl/wmi.c: eliminate possible double free
References: <1350816727-1381-1-git-send-email-Julia.Lawall@lip6.fr> <1350816727-1381-5-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1350816727-1381-5-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On 10/21/2012 01:52 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> This makes two changes.  In ath6kl_wmi_cmd_send, a call to dev_kfree_skb on
> the skb argument is added to the initial sanity check to more completely
> establish the invariant that ath6kl_wmi_cmd_send owns its skb argument.
> Then, in ath6kl_wmi_sync_point, on failure of the call to
> ath6kl_wmi_cmd_send, the clearing of the local skb variable is moved up, so
> that the error-handling code at the end of the function does not free it
> again.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> identifier f,free,a;
> parameter list[n] ps;
> type T;
> expression e;
> @@
> 
> f(ps,T a,...) {
>   ... when any
>       when != a = e
>   if(...) { ... free(a); ... return ...; }
>   ... when any
> }
> 
> @@
> identifier r.f,r.free;
> expression x,a;
> expression list[r.n] xs;
> @@
> 
> * x = f(xs,a,...);
>   if (...) { ... free(a); ... return ...; }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

I think this patch which is commited to ath6kl.git has fixed this.

commit 0616dc1f2bef563d7916c0dcedbb1bff7d9bd80b
Author: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Date:   Tue Aug 14 10:10:33 2012 +0530

    ath6kl: Fix potential skb double free in ath6kl_wmi_sync_point()

    skb given to ath6kl_control_tx() is owned by ath6kl_control_tx().
    Calling function should not free the skb for error cases.
    This is found during code review.

    kvalo: fix a checkpatch warning in ath6kl_wmi_cmd_send()

    Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

https://github.com/kvalo/ath6kl/commit/0616dc1f2bef563d7916c0dcedbb1bff7d9bd80b

If you have the time, I would appreciate if you could take a look and
confirm.

Kalle
