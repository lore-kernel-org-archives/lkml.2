Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0K3RB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:01:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab0K3RB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:01:27 -0500
Message-ID: <4CF52DDE.4070407@redhat.com>
Date: Tue, 30 Nov 2010 18:01:18 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [GIT PULL] Revert of the IO stat fix
References: <4CC49274.3030803@fusionio.com> <AANLkTik4qAzZPLO8HHBCM34_NLEEdPj04RyXPfeR-wSv@mail.gmail.com> <4CC49A4B.8010300@fusionio.com> <4CC49AAB.5090809@fusionio.com>
In-Reply-To: <4CC49AAB.5090809@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 10:44 PM, Jens Axboe wrote:
> diff --git a/block/genhd.c b/block/genhd.c
> index a8adf96..7d4d860 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -930,14 +930,9 @@ static void disk_free_ptbl_rcu_cb(struct rcu_head *head)
>  	struct disk_part_tbl *ptbl =
>  		container_of(head, struct disk_part_tbl, rcu_head);
>  	struct gendisk *disk = ptbl->disk;
> -	struct request_queue *q = disk->queue;
> -	unsigned long flags;
>  
>  	kfree(ptbl);
> -
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	elv_quiesce_end(q);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> +	elv_quiesce_end(disk->queue);

Here, the queue may be already gone. We should check it is still here and alive:

static void disk_free_ptbl_rcu_cb(struct rcu_head *head)
{
	struct disk_part_tbl *ptbl =
		container_of(head, struct disk_part_tbl, rcu_head);
	struct gendisk *disk = ptbl->disk;
	struct request_queue *q = disk->queue;

	kfree(ptbl);
	if (q && !test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))
		elv_quiesce_end(q);
}


>  }
>  
>  /**
> @@ -962,10 +957,7 @@ static void disk_replace_part_tbl(struct gendisk *disk,
>  	if (old_ptbl) {
>  		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
>  
> -		spin_lock_irq(q->queue_lock);
>  		elv_quiesce_start(q);

Same as above.

I'm not sure that is enough, but on my test machine these changes fix the crash
at USB key device removal.

Regards,
Jerome

> -		spin_unlock_irq(q->queue_lock);
> -
>  		call_rcu(&old_ptbl->rcu_head, disk_free_ptbl_rcu_cb);
>  	}
>  }
