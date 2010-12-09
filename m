Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab0LIAD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 19:03:58 -0500
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:48352 "HELO
	web31809.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751725Ab0LIAD4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 19:03:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=eMFucT1iJ3T6v20kMytHfdt7yMEG5SmTMAJ4qLMX/9EtiSRs9y7HfcDr+j95hMSoCLyPC7hYVM3JjeD69GGWFZgSehg+VlrtT1K2PW+pT52N2mHg8JhcxAu+mLbtkVxsC0CqozmVVDvv55Bz2YfxEU6H8xNCaqoICUhWafJFrns=;
Message-ID: <866237.28356.qm@web31809.mail.mud.yahoo.com>
X-YMail-OSG: 7ZIezJUVM1nfsAcONmj5pX1xv_rMYsWfRGb5QyBb4pMqlWZ
 ZNBCOnoTgUsl.34VM.4PqG4tnH5vgHbo..hsnk5955ihCBBlUstoI5SgDk7n
 3ZeoUfLAXi427FE4KYz0EmfgZxEcnyiGKGjUCFQFSOlGvIazB_8K8Vmbnclo
 C019yj2FHRLsSQYZI1upXnabqkD_XECriCwiGjOdptMfAxDnMiKRWquqnuqi
 _z5ayP2_f2rI4PiKUjF6xxnA1FeNpq_OIRDPFPJWjPW_g_aI2hcYYPHs7Zbp
 evAupqdGJfvnsc1eEXXbFiY8AydXjbAAidb0XuLs3zhdy8ef6WK7_HGjdDY_
 pxvFDAnh8RF4FFxYYE51cotWW9IyyRI8CGYgbsg6r5UFn081vTsK8n9HnWRU
 g
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Wed, 8 Dec 2010 16:03:54 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH preliminary] [BLOCK] Preliminary increasing tag sequence implementation
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, jaxboe@fusionio.com, tj@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 12/6/10, Luben Tuikov <ltuikov@yahoo.com> wrote:
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  * This is a preliminary patch. Feel free to apply it for
>  inclusion and/or work/modify it to submit a more
>  atomically-correct version.
>  * Vendors: apply this to see an increasing sequence of
> tags
>  on the wire and at your device, so that error recovery
> doesn't
>  abort a task which isn't intended to be aborted especially
> in
>  full duplex protocols when the command status and TMF can
>  cross on the wire. See this thread: http://marc.info/?l=linux-scsi&m=128902337522893&w=2 
> 
>  block/blk-tag.c       
> |   15 +++++++++++++--
>  include/linux/blkdev.h |    1 +
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-tag.c b/block/blk-tag.c
> index ece65fc..f792e98 100644
> --- a/block/blk-tag.c
> +++ b/block/blk-tag.c
> @@ -130,6 +130,7 @@ init_tag_map(struct request_queue *q,
> struct blk_queue_tag *tags, int depth)
>      tags->max_depth = depth;
>      tags->tag_index = tag_index;
>      tags->tag_map = tag_map;
> +    tags->last_tag = 0;
>  
>      return 0;
>  fail:
> @@ -222,7 +223,7 @@ int blk_queue_resize_tags(struct
> request_queue *q, int new_depth)
>      struct blk_queue_tag *bqt =
> q->queue_tags;
>      struct request **tag_index;
>      unsigned long *tag_map;
> -    int max_depth, nr_ulongs;
> +    int max_depth, nr_ulongs, last_tag;
>  
>      if (!bqt)
>          return -ENXIO;
> @@ -251,6 +252,7 @@ int blk_queue_resize_tags(struct
> request_queue *q, int new_depth)
>      tag_index = bqt->tag_index;
>      tag_map = bqt->tag_map;
>      max_depth = bqt->real_max_depth;
> +    last_tag = bqt->last_tag;
>  
>      if (init_tag_map(q, bqt, new_depth))
>          return -ENOMEM;
> @@ -258,6 +260,7 @@ int blk_queue_resize_tags(struct
> request_queue *q, int new_depth)
>      memcpy(bqt->tag_index, tag_index,
> max_depth * sizeof(struct request *));
>      nr_ulongs = ALIGN(max_depth,
> BITS_PER_LONG) / BITS_PER_LONG;
>      memcpy(bqt->tag_map, tag_map,
> nr_ulongs * sizeof(unsigned long));
> +    bqt->last_tag = last_tag;
>  
>      kfree(tag_index);
>      kfree(tag_map);
> @@ -364,12 +367,20 @@ int blk_queue_start_tag(struct
> request_queue *q, struct request *rq)
>             
> return 1;
>      }
>  
> +    if (bqt->last_tag ==
> bqt->max_depth-1)
> +        bqt->last_tag =
> 0;
> +
>      do {
> -        tag =
> find_first_zero_bit(bqt->tag_map, max_depth);
> +        tag =
> find_next_zero_bit(bqt->tag_map,
> +           
>          max_depth,
> +           
>    
>      bqt->last_tag+1);
>          if (tag >=
> max_depth)
>             
> return 1;
>  
>      } while (test_and_set_bit_lock(tag,
> bqt->tag_map));
> +
> +    bqt->last_tag = tag;
> +
>      /*
>       * We need lock ordering
> semantics given by test_and_set_bit_lock.
>       * See blk_queue_end_tag for
> details.
> diff --git a/include/linux/blkdev.h
> b/include/linux/blkdev.h
> index 5027a59..955222e 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -224,6 +224,7 @@ struct blk_queue_tag {
>      int max_depth;   
>         /* what we will send
> to device */
>      int real_max_depth;   
>     /* what the array can hold */
>      atomic_t refcnt;   
>     /* map can be shared */
> +    int last_tag;
>  };
>  
>  #define BLK_SCSI_MAX_CMDS    (256)
> -- 
> 1.7.2.2.165.gbc382

A lot of bugs were discovered and are being discovered since this patch was applied. I'm tracking the Linux based ones at the moment as time permits (or at least trying to track them). Some of what I'm seeing is the same tag being issued for the subsequent command after an aborted command, and lookup failures occasionally (these depend on a lot of factors, for example how many LUs the device reports, how many streams are supported, whether the device runs in SS or HS mode, etc).

The purpose of the posting of this patch was to get people to either apply it or come up with a more atomically correct implementation, submit and apply it, so that everyone can 1) have correct sequence of tags on the wire and 2) discover more bugs (if any ;-) ).

Anyone?

   Luben

