Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0JNGHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 02:07:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33479 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab0JNGHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 02:07:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] blk: fix a wrong accounting of hd_struct->in_flight
Cc: kosaki.motohiro@jp.fujitsu.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CB40281.1020403@jp.fujitsu.com>
References: <4CB40281.1020403@jp.fujitsu.com>
Message-Id: <20101014150742.F9EC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Oct 2010 15:07:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> /proc/diskstats would display a strange output as follows.
> 
> $ cat /proc/diskstats |grep sda
>    8       0 sda 90524 7579 102154 20464 0 0 0 0 0 14096 20089
>    8       1 sda1 19085 1352 21841 4209 0 0 0 0 4294967064 15689 4293424691
>                                                 ~~~~~~~~~~
>    8       2 sda2 71252 3624 74891 15950 0 0 0 0 232 23995 1562390
>    8       3 sda3 54 487 2188 92 0 0 0 0 0 88 92
>    8       4 sda4 4 0 8 0 0 0 0 0 0 0 0
>    8       5 sda5 81 2027 2130 138 0 0 0 0 0 87 137

Hm, this is very nasty and crap.



> @@ -1268,7 +1270,17 @@ static int __make_request(struct request
>  		 * not touch req->buffer either...
>  		 */
>  		req->buffer = bio_data(bio);
> +		src_part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
>  		req->__sector = bio->bi_sector;
> +		dst_part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));

I think this is wrong. disk_map_sector_rcu() require
rcu read lock held (see function comment). all other call site take 
part_stat_lock() before disk_map_sector_rcu() call.



