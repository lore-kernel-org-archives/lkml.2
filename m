Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505Ab1ETAk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:40:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50247 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab1ETAk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qdbisMOKPWmFbm1Zh0Egm/WQbEaYZaI4rwT3qCfsZLdizJwYV9/G/BFMmIYTG/tmZ+
         H2LS+cz3zhb7EdZvwbFS0BewAoeIrhvKnFX2V+LTQ6GdjemymTuC8KvvHLH1AOyvVSoN
         728xncmzP3lvq0egzVqvjxh87cxQcMGWUeOy4=
MIME-Version: 1.0
In-Reply-To: <1305850920.22968.1089.camel@debian>
References: <1305009600.21534.587.camel@debian>
	<4DCC4340.6000407@fusionio.com>
	<1305247704.2373.32.camel@sli10-conroe>
	<1305255717.2373.38.camel@sli10-conroe>
	<1305533054.2375.45.camel@sli10-conroe>
	<1305535071.21534.2122.camel@debian>
	<1305612565.21534.2177.camel@debian>
	<4DD221BE.3040406@fusionio.com>
	<1305793580.22968.155.camel@debian>
	<4DD56104.6080801@fusionio.com>
	<1305850920.22968.1089.camel@debian>
Date: Fri, 20 May 2011 08:40:56 +0800
X-Google-Sender-Auth: ORfcDkvYLRIm2Kg-_VwOc4aeZj0
Message-ID: <BANLkTima6W5yAM_koArYaz57C3uzk=WwWQ@mail.gmail.com>
Subject: Re: Perfromance drop on SCSI hard disk
From: Shaohua Li <shaohua.li@intel.com>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Alex,Shi <alex.shi@intel.com>:
> On Fri, 2011-05-20 at 02:27 +0800, Jens Axboe wrote:
>> On 2011-05-19 10:26, Alex,Shi wrote:
>> >
>> >> I will queue up the combined patch, it looks fine from here as well.
>> >>
>> >
>> > When I have some time to study Jens and shaohua's patch today. I find a
>> > simpler way to resolved the re-enter issue on starved_list. Following
>> > Jens' idea, we can just put the starved_list device into kblockd if it
>> > come from __scsi_queue_insert().
>> > It can resolve the re-enter issue and recover performance totally, and
>> > need not a work_struct in every scsi_device. The logic/code also looks a
>> > bit simpler.
>> > What's your opinion of this?
>>
>> Isn't this _identical_ to my original patch, with the added async run of
>> the queue passed in (which is important, an oversight)?
>
> Not exactly same. It bases on your patch, but added a bypass way for
> starved_list device. If a starved_list device come from
> __scsi_queue_insert(), that may caused by our talking recursion, kblockd
> with take over the process.  Maybe you oversight this point in original
> patch. :)
>
> The different part from yours is below:
> ---
> static void __scsi_run_queue(struct request_queue *q, bool async)
>  {
>        struct scsi_device *sdev = q->queuedata;
>        struct Scsi_Host *shost;
> @@ -435,30 +437,35 @@ static void scsi_run_queue(struct request_queue
> *q)
>                                       &shost->starved_list);
>                        continue;
>                }
> -
> -               spin_unlock(shost->host_lock);
> -               spin_lock(sdev->request_queue->queue_lock);
> -               __blk_run_queue(sdev->request_queue);
> -               spin_unlock(sdev->request_queue->queue_lock);
> -               spin_lock(shost->host_lock);
> +               if (async)
> +                       blk_run_queue_async(sdev->request_queue);
> +               else {
> +                       spin_unlock(shost->host_lock);
> +                       spin_lock(sdev->request_queue->queue_lock);
> +                       __blk_run_queue(sdev->request_queue);
> +                       spin_unlock(sdev->request_queue->queue_lock);
> +                       spin_lock(shost->host_lock);
>>
I don't quite like this approach. blk_run_queue_async() could
introduce fairness issue as I said in previous mail, because we drop
the sdev from starved list but didn't run its queue immediately. The
issue exists before, but it's a bug to me.
Alex, is there any real advantage of your patch?

Thanks,
Shaohua
