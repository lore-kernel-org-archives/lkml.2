Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0DUPlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:41:06 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55581 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692Ab0DUPlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:41:03 -0400
Date: Wed, 21 Apr 2010 17:41:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Divyesh Shah <dpshah@google.com>, Nauman Rafique <nauman@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH V2] blkio: Fix blkio crash during rq stat update
Message-ID: <20100421154101.GV27497@kernel.dk>
References: <20100421153623.GD3275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421153623.GD3275@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21 2010, Vivek Goyal wrote:
> @@ -1001,6 +1002,11 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
>  	return cfqg;
>  }
>  
> +static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg) {
> +	atomic_inc(&cfqg->ref);
> +	return cfqg;
> +}
> +

Sorry to keep harping on this - style is still wrong, and:

> @@ -3560,6 +3574,9 @@ new_queue:
>  
>  	rq->elevator_private = cic;
>  	rq->elevator_private2 = cfqq;
> +	rq->elevator_private3 = cfqq->cfqg;
> +	/* rq reference on cfqg */
> +	cfq_ref_get_cfqg(RQ_CFQG(rq));
>  	return 0;

should be

        /* hold a reference to the cfqg */
        rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);

-- 
Jens Axboe

