Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0FETLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:11:42 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36360 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0FETLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mRrdGL7OsoSYEhjeZ7my/HK0QdVIGyG5JNT/eW98hCPoA/2bCwEmfhuDCcbi+OPI3o
         SgsBPHoZf3NV7X2kcmpBia9r3fwDpSEuvjC3fEPHeT7iINgjRAmQJKe9kZ+aTl10eGrC
         sTjZmrmucUOrTXM/OZ3odha7wKZMUeqKybjI8=
MIME-Version: 1.0
In-Reply-To: <4C07C3B8.7020003@hp.com>
References: <AANLkTilgantV3v0T1-ef6ewyinddzfOs1PZW1Re9ZAyQ@mail.gmail.com>
	<4C07C3B8.7020003@hp.com>
Date: Sat, 5 Jun 2010 12:11:38 -0700
X-Google-Sender-Auth: 0rd61soRSQ3-l3A4VdQeJI6Cl3c
Message-ID: <AANLkTilnetlpc8IAkw9v072PZBAlVrdkXo9eKIeQw7Iu@mail.gmail.com>
Subject: Re: [PATCH 1/6] sctp multistream scheduling: declare sctp_sched_ops
From: Yaogong Wang <ywang15@ncsu.edu>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree that it's clearer to put sched_ops in sctp_outq. That way, the
data structure and the operations on it are put together. I'll make
the required changes.

Yaogong

On Thu, Jun 3, 2010 at 8:01 AM, Vlad Yasevich <vladislav.yasevich@hp.com> wrote:
>
>
> Yaogong Wang wrote:
>> Declare sctp_sched_ops structure and related functions
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> linux-2.6.32.8/include/net/sctp/structs.h
>> p1/include/net/sctp/structs.h
>> --- linux-2.6.32.8/include/net/sctp/structs.h 2010-02-09
>> 04:57:19.000000000 -0800
>> +++ p1/include/net/sctp/structs.h     2010-05-28 10:33:12.000000000 -0700
>> @@ -320,6 +320,9 @@ struct sctp_sock {
>>       /* Flags controlling Heartbeat, SACK delay, and Path MTU Discovery. */
>>       __u32 param_flags;
>>
>> +     /* Multistream scheduling  */
>> +     const struct sctp_sched_ops *sched_ops;
>> +
>>       struct sctp_initmsg initmsg;
>>       struct sctp_rtoinfo rtoinfo;
>>       struct sctp_paddrparams paddrparam;
>> @@ -534,6 +537,36 @@ static inline void sctp_ssn_skip(struct
>>  }
>>
>
> BTW, is there a reason you decided to through the sched_ops into the association
> and not the queue?  I seems to make more sense to me to put one into the other.
>
> -vlad
>
>>  /*
>> + * Interface for adding new SCTP scheduling handlers
>> + * This is similar to the pluggable TCP congestion control
>> + */
>> +struct sctp_sched_ops {
>> +     struct list_head        list;
>> +
>> +     /* initialize out_chunk_list (required) */
>> +     int (*init)(struct sctp_outq *q, gfp_t gfp);
>> +     /* cleanup out_chunk_list (required) */
>> +     void (*release)(struct sctp_outq *q);
>> +     /* enqueue head function (required) */
>> +     void (*enqueue_head_data)(struct sctp_outq *q, struct sctp_chunk *ch);
>> +     /* enqueue tail function (required) */
>> +     void (*enqueue_tail_data)(struct sctp_outq *q, struct sctp_chunk *ch);
>> +     /* dequeue function (required) */
>> +     struct sctp_chunk* (*dequeue_data)(struct sctp_outq *q);
>> +     /* is out_chunk_list empty? (required) */
>> +     int (*is_empty)(struct sctp_outq *q);
>> +
>> +     char            name[SCTP_SCHED_NAME_MAX];
>> +     struct module   *owner;
>> +};
>> +
>> +extern int sctp_register_sched(struct sctp_sched_ops *type);
>> +extern void sctp_unregister_sched(struct sctp_sched_ops *type);
>> +
>> +extern void sctp_cleanup_sched(struct sock *sk);
>> +extern int sctp_set_sched(struct sock *sk, const char *name);
>> +
>> +/*
>>   * Pointers to address related SCTP functions.
>>   * (i.e. things that depend on the address family.)
>>   */
>> @@ -1650,6 +1683,9 @@ struct sctp_association {
>>       /* The largest timeout or RTO value to use in attempting an INIT */
>>       unsigned long max_init_timeo;
>>
>> +     /* Multistream scheduling  */
>> +     const struct sctp_sched_ops *sched_ops;
>> +
>>       /* Heartbeat interval: The endpoint sends out a Heartbeat chunk to
>>        * the destination address every heartbeat interval. This value
>>        * will be inherited by all new transports.
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> linux-2.6.32.8/include/net/sctp/user.h p1/include/net/sctp/user.h
>> --- linux-2.6.32.8/include/net/sctp/user.h    2010-02-09 04:57:19.000000000 -0800
>> +++ p1/include/net/sctp/user.h        2010-05-28 10:52:57.000000000 -0700
>> @@ -171,6 +171,8 @@ struct sctp_initmsg {
>>       __u16 sinit_max_init_timeo;
>>  };
>>
>> +#define SCTP_SCHED_NAME_MAX  16
>> +
>>  /*
>>   * 5.2.2 SCTP Header Information Structure (SCTP_SNDRCV)
>>   *
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
========================
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
========================
