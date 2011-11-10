Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab1KJIPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:15:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34927 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab1KJIPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:15:17 -0500
X-AuditID: cbfee60e-b7bc4ae000007958-be-4ebb88131b0e
Date: Thu, 10 Nov 2011 08:15:15 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] devfreq: fix use after free in devfreq_remove_device
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Kevin Hilman <khilman@ti.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Mike Turquette <mturquette@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111110081214819@myungjoo.ham
Msgkey: 20111110081214819@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111110081214819@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29486171.446861320912914822.JavaMail.weblogic@epml06>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAA8FU1R001704

Sender : Axel Lin<axel.lin@gmail.com> Date : 2011-11-10 16:28 (GMT+09:00)
> In devfreq_remove_device, calling _remove_devfreq will also free devfreq.
> Don't dereference devfreq->governor->no_central_polling after _remove_devfreq.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thank you for finding that out.

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
> drivers/devfreq/devfreq.c |    8 ++++++--
> 1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index d065925..59d24e9 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -418,10 +418,14 @@ out:
>   */
> int devfreq_remove_device(struct devfreq *devfreq)
> {
> + bool central_polling;
> +
> if (!devfreq)
> return -EINVAL;
> 
> - if (!devfreq->governor->no_central_polling) {
> + central_polling = !devfreq->governor->no_central_polling;
> +
> + if (central_polling) {
> mutex_lock(&devfreq_list_lock);
> while (wait_remove_device == devfreq) {
> mutex_unlock(&devfreq_list_lock);
> @@ -433,7 +437,7 @@ int devfreq_remove_device(struct devfreq *devfreq)
> mutex_lock(&devfreq->lock);
> _remove_devfreq(devfreq, false); /* it unlocks devfreq->lock */
> 
> - if (!devfreq->governor->no_central_polling)
> + if (central_polling)
> mutex_unlock(&devfreq_list_lock);
> 
> return 0;
> -- 
> 1.7.5.4

 MyungJoo Ham (ÇÔ¸íÁÖ)

Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
