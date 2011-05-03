Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1ECRzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:55:16 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:51953 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1ECRzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:55:13 -0400
X-WSS-ID: 0LKMSFZ-0B-9CF-02
X-M-MSG: 
X-Server-Uuid: 6BFC7783-7E22-49B4-B610-66D6BE496C0E
Message-ID: <4DC0415F.5020509@sandia.gov>
Date: Tue, 3 May 2011 11:54:39 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Thunderbird 2.0.0.24 (X11/20110128)
MIME-Version: 1.0
To: "James Bottomley" <James.Bottomley@suse.de>
cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.39-rc5+ BUG at scsi_run_queue+0x24/0xe3
References: <4DC0330F.6050906@sandia.gov>
 <1304442019.10982.7.camel@mulgrave.site> <4DC03B0A.50209@sandia.gov>
 <1304444251.10982.9.camel@mulgrave.site>
In-Reply-To: <1304444251.10982.9.camel@mulgrave.site>
X-Originating-IP: [134.253.95.179]
X-PMX-Version: 5.6.0.2009776, Antispam-Engine: 2.7.2.376379,
 Antispam-Data: 2011.5.3.174517
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS
 0, BODY_SIZE_7000_LESS 0, DATE_TZ_NA 0, WEBMAIL_SOURCE 0, WEBMAIL_XOIP
 0, WEBMAIL_X_IP_HDR 0, __BOUNCE_CHALLENGE_SUBJ 0,
 __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0,
 __HAS_MSGID 0, __HAS_XOIP 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0,
 __MOZILLA_MSGID 0, __RATWARE_X_MAILER_CS_B 0, __SANE_MSGID 0,
 __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS ,
 __USER_AGENT 0'
X-TMWD-Spam-Summary: TS=20110503175447; ID=1; SEV=2.3.1;
 DFV=B2011050317; IFV=NA; AIF=B2011050317; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230372E34444330343136382E303030373A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAABAJsKIgAAAAAAAAAAAAAAAAAAAH0=
X-MMS-Spam-Filter-ID: B2011050317_5.03.0010
X-WSS-ID: 61DE9EEF2K42837672-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2011-05-03 at 11:27 -0600, Jim Schutt wrote:
>> James Bottomley wrote:
>>> On Tue, 2011-05-03 at 10:53 -0600, Jim Schutt wrote:
>>>> Please let me know if what further information you need, or if there is
>>>> anything I can do, to help resolve this.
>>> I think this is the fix (already in rc-fixes):
>>>
>>> James
>>>
>>> ---
>>> From 3e85ea868dbd60a84240be5c1eebc36841b9c568 Mon Sep 17 00:00:00 2001
>>> From: James Bottomley <James.Bottomley@suse.de>
>>> Date: Sun, 1 May 2011 09:42:07 -0500
>>> Subject: [PATCH] [SCSI] fix oops in scsi_run_queue()
>>>
>>> The recent commit closing the race window in device teardown:
>>>
>>> commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
>>> Author: James Bottomley <James.Bottomley@suse.de>
>>> Date:   Fri Apr 22 10:39:59 2011 -0500
>>>
>>>     [SCSI] put stricter guards on queue dead checks
>>>
>>> is causing a potential NULL deref in scsi_run_queue() because the
>>> q->queuedata may already be NULL by the time this function is called.
>>> Since we shouldn't be running a queue that is being torn down, simply
>>> add a NULL check in scsi_run_queue() to forestall this.
>>>
>>> Signed-off-by: James Bottomley <James.Bottomley@suse.de>
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index e9901b8..03979f4 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -404,6 +404,10 @@ static void scsi_run_queue(struct request_queue *q)
>>>  	LIST_HEAD(starved_list);
>>>  	unsigned long flags;
>>>  
>>> +	/* if the device is dead, sdev will be NULL, so no queue to run */
>>> +	if (!sdev)
>>> +		return;
>>> +
>>>  	if (scsi_target(sdev)->single_lun)
>>>  		scsi_single_lun_run(sdev);
>>>  
>> Hmmm, with the above added, I still get BUGs.  Here's an
>> example:
>>
>> [   17.142931] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> [   17.143002] IP: [<ffffffffa01cf8c5>] scsi_run_queue+0x24/0xec [scsi_mod]
> 
> Ooh, compiler optimisation, I think; try this instead
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e9901b8..0bac91e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -400,10 +400,15 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
>  static void scsi_run_queue(struct request_queue *q)
>  {
>  	struct scsi_device *sdev = q->queuedata;
> -	struct Scsi_Host *shost = sdev->host;
> +	struct Scsi_Host *shost;
>  	LIST_HEAD(starved_list);
>  	unsigned long flags;
>  
> +	/* if the device is dead, sdev will be NULL, so no queue to run */
> +	if (!sdev)
> +		return;
> +
> +	shost = sdev->host;
>  	if (scsi_target(sdev)->single_lun)
>  		scsi_single_lun_run(sdev);
>  

Yes, that definitely fixes things for me.

Thanks!!

-- Jim

