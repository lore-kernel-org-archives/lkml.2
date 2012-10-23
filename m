Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab2JWWgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:36:49 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:52333 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933560Ab2JWWgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:36:47 -0400
Subject: Re: [PATCH 13/23] tuners/xc2028: Replace memcpy with struct
 assignment
From: Andy Walls <awalls@md.metrocast.net>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Date: Tue, 23 Oct 2012 18:36:37 -0400
In-Reply-To: <1351022246-8201-13-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
	 <1351022246-8201-13-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1351031798.2459.31.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-23_07:2012-10-23,2012-10-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1210230293
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 16:57 -0300, Ezequiel Garcia wrote:
> This kind of memcpy() is error-prone. Its replacement with a struct
> assignment is prefered because it's type-safe and much easier to read.
> 
> Found by coccinelle. Hand patched and reviewed.
> Tested by compilation only.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier struct_name;
> struct struct_name to;
> struct struct_name from;
> expression E;
> @@
> -memcpy(&(to), &(from), E);
> +to = from;
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>  drivers/media/tuners/tuner-xc2028.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
> index 7bcb6b0..0945173 100644
> --- a/drivers/media/tuners/tuner-xc2028.c
> +++ b/drivers/media/tuners/tuner-xc2028.c
> @@ -870,7 +870,7 @@ check_device:
>  	}
>  
>  read_not_reliable:
> -	memcpy(&priv->cur_fw, &new_fw, sizeof(priv->cur_fw));
> +	priv->cur_fw = new_fw;

This memcpy() can get called almost every time
tuner-xc2028.c:generic_set_freq() is called.  

This copies a 32 byte (I think) structure on a 32 bit machine.

I am assuming the difference in performance between the memcpy and
assignment operator is negligible.

Regards,
Andy


>  	/*
>  	 * By setting BASE in cur_fw.type only after successfully loading all


