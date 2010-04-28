Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0D1PgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:36:10 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45249 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab0D1PgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=fndL1CEvL2S0dvvdTIj/TcpfyzKzB1DJ9XnCh9i5MTQtOJGfajkH0wu/t8AGSqZ7Vo
         YtdSUKWT+yRCA5X/OUPLizWwDEVYhnQNcRSRoFLJNc5IMgRYNScJChTdmKHgKBPuX7SB
         7ymo8fD6d+wWpvxtgq5nMjP7DvcXJNHEqd+3s=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: CFQ is broken for CONFIG_BLK_CGROUP=y, CFQ_GROUP_IOSCHED=n
References: <877hnrg30c.fsf@openvz.org> <20100428150959.GA16033@redhat.com>
Date: Wed, 28 Apr 2010 19:36:02 +0400
In-Reply-To: <20100428150959.GA16033@redhat.com> (Vivek Goyal's message of
	"Wed, 28 Apr 2010 11:09:59 -0400")
Message-ID: <87ljc7egil.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Apr 28, 2010 at 04:44:51PM +0400, Dmitry Monakhov wrote:
>> 
>> I've had an  oops on kernel boot due to NULL pointer deference
>> linux-2.6-block/for-next HEAD:7eaed1226ab411ee5dc8c34fc0d8034e4c98e3c6
>> I've enabled CONFIG_BLK_CGROUP, but not CFQ_GROUP_IOSCHED
>> In this case cfq_ref_get_cfqg() defined as 
>> static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
>> {
>>         return NULL;
>> }
>> So following call trace is simply NOOP
>> cfq_set_request()
>>  rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
>> 
>> Which later result in OOPS on bio insertion
>> cfq_insert_request
>>  -> blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,...)
>>     -> spin_lock_irqsave(&blkg->stats_lock, flags);
>> 
>> Bad commit.
>> >From 7f1dc8a2d2f45fc557b27fd56115338b1d34fc24 Mon Sep 17 00:00:00 2001
>> From: Vivek Goyal <vgoyal@redhat.com>
>> Date: Wed, 21 Apr 2010 17:44:16 +0200
>> Subject: [PATCH] blkio: Fix blkio crash during rq stat update
>
> Dmitry, this patch should fix the issue. Can you please give it a try.
Yes. the issue is gone.
>
> Jens, I know you don't like this form of cfq_ref_get_cfqg(), but this
> seems to be the simplest solution to fix it.
IMHO following fix is simpler, and cleaner.

--=-=-=
Content-Disposition: inline; filename=diff

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 286008c..0f3eb70 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1094,7 +1094,7 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 
 static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
 {
-	return NULL;
+	return cfqg;
 }
 
 static inline void

--=-=-=--
