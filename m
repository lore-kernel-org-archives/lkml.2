Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0JNWZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:25:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37628 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab0JNWZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fAcW7eWK1Fma90E2ojW4uPi165PF9LZE6AxnHUb1GV83bHaxVm/r8Qp8YsuYpjXcam
         QwCqpAStDDZC5DOWwGCB/7sw+w9bfUFsbDxSsseoQGK9oYs1AqJgVWMr5MugUfIEpQHi
         JnrgHmpatFjF5eVeXAKPyFYsSQazhSknHOOp8=
MIME-Version: 1.0
In-Reply-To: <4CB56F7A.8030702@cn.fujitsu.com>
References: <AANLkTi=8ArxUh2-8PJvD8paDGVBHdDjKk=xQDKo6i2==@mail.gmail.com>
	<4CB56F7A.8030702@cn.fujitsu.com>
Date: Thu, 14 Oct 2010 14:07:26 -0400
X-Google-Sender-Auth: QVz7GO5jKUBvRK8hnCfnkM24fuM
Message-ID: <AANLkTimnQboEwHV5LWvEa46LrRpwxmrWscJ2xGjO-Qjx@mail.gmail.com>
Subject: Re: [PATCHv2 4/5] sctp: a sample module of strict priority queue
From: Yaogong Wang <ywang15@ncsu.edu>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 4:36 AM, Shan Wei <shanwei@cn.fujitsu.com> wrote:
> Yaogong Wang wrote, at 09/12/2010 09:13 AM:
>> Provide a sample kernel module that uses the pluggable multistream
>> scheduling framework. This module implements strict priority queue.
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>>  net/sctp/Kconfig     |   12 ++++++
>>  net/sctp/Makefile    |    1 +
>>  net/sctp/sctp_prio.c |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 116 insertions(+), 0 deletions(-)
>>  create mode 100644 net/sctp/sctp_prio.c
>>
>> diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
>> index 126b014..85c8ded 100644
>> --- a/net/sctp/Kconfig
>> +++ b/net/sctp/Kconfig
>> @@ -37,6 +37,18 @@ menuconfig IP_SCTP
>>
>>  if IP_SCTP
>>
>> +config SCTP_SCHED_PRIO
>> +     tristate "SCTP Multistream Scheduling: Priority Queue"
>> +     default m
>> +     help
>> +       This module provides the ability to use priority queue
>> +       to schedule multiple streams within an association.
>> +
>> +       To compile this code as a module, choose M here: the
>> +       module will be called sctp_prio.
>> +
>> +       If in doubt, say N.
>> +
>>  config NET_SCTPPROBE
>>       tristate "SCTP: Association probing"
>>          depends on PROC_FS && KPROBES
>> diff --git a/net/sctp/Makefile b/net/sctp/Makefile
>> index 4e8b65d..89be03a 100644
>> --- a/net/sctp/Makefile
>> +++ b/net/sctp/Makefile
>> @@ -4,6 +4,7 @@
>>
>>  obj-$(CONFIG_IP_SCTP) += sctp.o
>>  obj-$(CONFIG_NET_SCTPPROBE) += sctp_probe.o
>> +obj-$(CONFIG_SCTP_SCHED_PRIO) += sctp_prio.o
>>
>>  sctp-y := sm_statetable.o sm_statefuns.o sm_sideeffect.o \
>>         protocol.o endpointola.o associola.o \
>> diff --git a/net/sctp/sctp_prio.c b/net/sctp/sctp_prio.c
>> new file mode 100644
>> index 0000000..11e7e11
>> --- /dev/null
>> +++ b/net/sctp/sctp_prio.c
>> @@ -0,0 +1,103 @@
>> +/*
>> + * SCTP multistream scheduling: priority queue
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/types.h>
>> +#include <linux/list.h>
>> +#include <net/sctp/sctp.h>
>> +
>> +static int prio_init(struct sctp_outq *q, gfp_t gfp)
>> +{
>> +     __u16 i;
>> +     q->out_chunk_list = kmalloc(q->asoc->c.sinit_num_ostreams
>> +                              * sizeof(struct list_head), gfp);
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
>
> User can using SCTP_SNDRCV option to specific stream number.
> So, It is necessary to check stream number with q->asoc->c.sinit_num_ostreams.

Isn't this check already performed in sctp_sendmsg() before it comes
to sctp_outq?

>
>> +     q->out_qlen += ch->skb->len;
>> +     return;
>> +}
>> +
>> +static void prio_enqueue_tail_data(struct sctp_outq *q, struct sctp_chunk *ch)
>> +{
>> +     list_add_tail(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_stream]);
>
> need to check too.
>
>
>
> --
> Best Regards
> -----
> Shan Wei
>
>



-- 
========================
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
========================
