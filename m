Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab0FYJsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:48:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43007 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab0FYJsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AjLgpChW6FNQVK38xQWfzwa7qHbDP2Ut1rG/N1F/wibqicttKv/ypLkwf2BTommlAT
         SmlmFRPSfe/fFOgLt6tlgRxVMyHUKIbLTW7F8nMiu3l7AECug4yKT3H0YRVsfxIMDZSO
         y32L/q6PngudiktDZjXmFWDgRactW+HLBl1XE=
Message-ID: <4C247B54.2050900@garzik.org>
Date: Fri, 25 Jun 2010 05:48:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org>
In-Reply-To: <4C245E50.7090701@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 03:44 AM, Tejun Heo wrote:
> Hello, Jeff.
>
> On 06/25/2010 02:22 AM, Jeff Garzik wrote:
>>> @@ -4972,6 +4972,8 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
>>>    {
>>>        struct ata_port *ap = qc->ap;
>>>
>>> +    unexpect_irq(ap->irq_expect, false);
>>> +
>>>        /* XXX: New EH and old EH use different mechanisms to
>>>         * synchronize EH with regular execution path.
>>>         *
>>
>> Unconditional use of unexpect_irq() here seems incorrect for some cases,
>> such as sata_mv's use, where ata_qc_complete() is called multiple times
>> rather than a singleton ata_qc_complete_multiple() call.
>
> Indeed, sata_mv is calling ata_qc_complete() directly multiple times.
> I still think calling unexpect_irq() from ata_qc_complete() is correct
> as ata_qc_complete() is always a good indicator of completion events.

My basic point is that you are implicitly changing the entire 
ata_qc_complete() API, and associated underlying assumptions.

The existing assumption, since libata day #0, is that ata_qc_complete() 
works entirely within the scope of a single qc -- thus enabling multiple 
calls for a single controller interrupt.  Your change greatly widens the 
scope to an entire port.

This isn't just an issue with sata_mv, that was just the easy example I 
remember off the top of my head.  sata_fsl and sata_nv also make the 
same assumption.  And it's a reasonable assumption, IMO.

I think an unexpect_irq() call is more appropriate outside 
ata_qc_complete().

	Jeff



