Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab0FEUDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:03:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59697 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab0FEUDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TWh8leIldTafmJvLeD4AagLS/SI/no2yBm2ux1aBs6LQ6rV1VQsHyFHnQDlgjslxN8
         rDac+TWrryJZLO4VUG2TPXLD9eDZtZjMDT+2y6/UzKFC9ipH8Du4Q8gAs7kPhJfirGGy
         NnVjfcA1ayR5YAtntxa0dK/tZx0LuuLcmIkKE=
MIME-Version: 1.0
In-Reply-To: <4C07D30C.5090101@hp.com>
References: <AANLkTikV9RSoTIjUNARyrXHG-BdulDR5zIdk8dIVVOHI@mail.gmail.com>
	<4C07D30C.5090101@hp.com>
Date: Sat, 5 Jun 2010 13:03:07 -0700
X-Google-Sender-Auth: i6NkJASavKkktTeLTE_Zdes_OaI
Message-ID: <AANLkTik5jr2ciX_7sT2uHIsNraZf-d0P_0HBLhln2RMT@mail.gmail.com>
Subject: Re: [PATCH 5/6] sctp multistream scheduling: a sample priority queue 
	scheduling module
From: Yaogong Wang <ywang15@ncsu.edu>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 9:06 AM, Vlad Yasevich <vladislav.yasevich@hp.com> wrote:
>
>
> Yaogong Wang wrote:
>> A sample priority queue scheduling module that uses our interface
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> p4/net/sctp/Kconfig p5/net/sctp/Kconfig
>> --- p4/net/sctp/Kconfig       2010-05-28 11:48:55.000000000 -0700
>> +++ p5/net/sctp/Kconfig       2010-05-28 14:43:17.000000000 -0700
>> @@ -37,6 +37,12 @@ menuconfig IP_SCTP
>>
>>  if IP_SCTP
>>
>> +config SCTP_SCHED_PRIO
>> +     tristate "SCTP Multistream Scheduling: Priority Queue"
>> +     default m
>> +     help
>> +       Use priority queue to schedule among multiple streams
>> +
>>  config SCTP_DBG_MSG
>>       bool "SCTP: Debug messages"
>>       help
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> p4/net/sctp/Makefile p5/net/sctp/Makefile
>> --- p4/net/sctp/Makefile      2010-05-28 11:48:55.000000000 -0700
>> +++ p5/net/sctp/Makefile      2010-05-28 14:48:08.000000000 -0700
>> @@ -11,6 +11,7 @@ sctp-y := sm_statetable.o sm_statefuns.o
>>         tsnmap.o bind_addr.o socket.o primitive.o \
>>         output.o input.o debug.o ssnmap.o auth.o sched.o
>>
>> +obj-$(CONFIG_SCTP_SCHED_PRIO) += sctp_prio.o
>>  sctp-$(CONFIG_SCTP_DBG_OBJCNT) += objcnt.o
>>  sctp-$(CONFIG_PROC_FS) += proc.o
>>  sctp-$(CONFIG_SYSCTL) += sysctl.o
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> p4/net/sctp/sctp_prio.c p5/net/sctp/sctp_prio.c
>> --- p4/net/sctp/sctp_prio.c   1969-12-31 16:00:00.000000000 -0800
>> +++ p5/net/sctp/sctp_prio.c   2010-06-02 13:09:33.000000000 -0700
>> @@ -0,0 +1,108 @@
>> +/*
>> + * Priority queue scheduling among multiple SCTP streams
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/types.h>
>> +#include <linux/list.h>
>> +#include <net/sctp/sctp.h>
>> +
>> +static int zero_high_prio = 1;
>> +module_param(zero_high_prio, int, 0644);
>> +MODULE_PARM_DESC(zero_high_prio, "zero indicates highest priority?");
>> +
>> +static int prio_init(struct sctp_outq *q, gfp_t gfp)
>> +{
>> +     __u16 i;
>> +     q->out_chunk_list = kmalloc(q->asoc->c.sinit_num_ostreams
>> +                              * sizeof(struct list_head), gfp);
>
> This could end up wasting quite a lot of space since the queue is initialized
> prior to ostreams negotiation.
>

I agree. Refer to my discussion on the design issue of when to set the
socket option.

>
>> +     if (!q->out_chunk_list)
>> +             return -ENOMEM;
>> +     for (i = 0; i < q->asoc->c.sinit_num_ostreams; i++)
>> +             INIT_LIST_HEAD(&q->out_chunk_list[i]);
>> +
>> +     return 0;
>> +}
>> +
>> +static void prio_release(struct sctp_outq *q)
>> +{
>> +     kfree(q->out_chunk_list);
>> +     return;
>> +}
>> +
>> +static void prio_enqueue_head_data(struct sctp_outq *q,
>> +                                     struct sctp_chunk *ch)
>> +{
>> +     list_add(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_stream]);
>> +     q->out_qlen += ch->skb->len;
>> +     return;
>> +}
>> +
>> +static void prio_enqueue_tail_data(struct sctp_outq *q, struct sctp_chunk *ch)
>> +{
>> +     list_add_tail(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_stream]);
>> +     q->out_qlen += ch->skb->len;
>> +     return;
>> +}
>> +
>> +static struct sctp_chunk *prio_dequeue_data(struct sctp_outq *q)
>> +{
>> +     struct sctp_chunk *ch = NULL;
>> +     __u16 prio = 0, i, cur = 0;
>> +     int flag = 0;
>> +
>> +     for (i = 0; i < q->asoc->c.sinit_num_ostreams; i++) {
>> +             if (!list_empty(&q->out_chunk_list[i]) && (flag == 0
>> +                     || (zero_high_prio ? q->asoc->sched_priv[i] < prio
>> +                     : q->asoc->sched_priv[i] > prio))) {
>
> Can you please simplify this conditional.  Also, the logical operands
> typically end the line, not start it.

will do it

>
>> +                             cur = i;
>> +                             flag = 1;
>> +                             prio = q->asoc->sched_priv[i];
>> +             }
>> +     }
>> +
>
> It might be nice to cache the asoc so you don't have to keep dereferencing the
> queue.
>

If I move sched_ops from sctp_association to sctp_outq as per your
suggestion, the problem is automatically solved.

> Also, isn't there a strong starvation possibility if a higher priority queue
> gets most of data?
>

Yes, starvation is possible in this algorithm. However, the philosophy
is that, as the user chooses the scheduling algorithm, he should be
aware of this. If he doesn't want this, he may use other scheduling
algorithms or implement his own. We provide mechanism. The user
decides his policy.

Yaogong

> -vlad
>
>> +     if (flag) {
>> +             struct list_head *entry = q->out_chunk_list[cur].next;
>> +             ch = list_entry(entry, struct sctp_chunk, list);
>> +             list_del_init(entry);
>> +             q->out_qlen -= ch->skb->len;
>> +     }
>> +     return ch;
>> +}
>> +
>> +static inline int prio_is_empty(struct sctp_outq *q)
>> +{
>> +     __u16 i;
>> +     for (i = 0; i < q->asoc->c.sinit_num_ostreams; i++)
>> +             if (!list_empty(&q->out_chunk_list[i]))
>> +                     return 0;
>> +     return 1;
>> +}
>> +
>> +static struct sctp_sched_ops sctp_prio = {
>> +     .name                   = "prio",
>> +     .owner                  = THIS_MODULE,
>> +     .init                   = prio_init,
>> +     .release                = prio_release,
>> +     .enqueue_head_data      = prio_enqueue_head_data,
>> +     .enqueue_tail_data      = prio_enqueue_tail_data,
>> +     .dequeue_data           = prio_dequeue_data,
>> +     .is_empty               = prio_is_empty,
>> +};
>> +
>> +static int __init sctp_prio_register(void)
>> +{
>> +     return sctp_register_sched(&sctp_prio);
>> +}
>> +
>> +static void __exit sctp_prio_unregister(void)
>> +{
>> +     sctp_unregister_sched(&sctp_prio);
>> +}
>> +
>> +module_init(sctp_prio_register);
>> +module_exit(sctp_prio_unregister);
>> +
>> +MODULE_AUTHOR("Yaogong Wang");
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("SCTP Multistream Scheduling: Priority Queue");
>>
>
>



-- 
========================
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
========================
