Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1FHUGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:06:01 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33398 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1FHUF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=E3QKdPEvR75QqHNp0qsV6H8N1WQLbYKjJcXc1+mz9MK4C2u2hzirJwt9qwyIuLQ/Dt
         oVBRi6efEEG1iI1FZ6j8GnZl510deu0YKlao0U0E59TEUjiGQBJBd/SsDAzMdVcmCazo
         tkltwFo047LDT8gVMrUKlnv2GJsHMoW2xeL7c=
MIME-Version: 1.0
In-Reply-To: <20110608160844E.fujita.tomonori@lab.ntt.co.jp>
References: <BANLkTin7mqqTsosPHbztaPfL7s_TUGT1qg@mail.gmail.com>
	<20110608142121T.fujita.tomonori@lab.ntt.co.jp>
	<BANLkTi=FcNncT_6HpvB_6OnQ94f0_sz7Gw@mail.gmail.com>
	<20110608160844E.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 8 Jun 2011 13:05:57 -0700
X-Google-Sender-Auth: vucRMibKx0njDzS2eSjzyJEM12s
Message-ID: <BANLkTikFKr+3Qph+CR40SUV-DCir1v=KBg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dmaengine: add new dma API for max_segment_number
From: Dan Williams <dan.j.williams@intel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: cjb@laptop.org, linux@arm.linux.org.uk, patches@linaro.org,
        vinod.koul@intel.com, gregkh@suse.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 12:10 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Tue, 7 Jun 2011 23:56:21 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> > The dma parameter restriction could be due to software (HBA drivers,
>> > or subsystem). The value should be whatever the dma device driver says
>> > it is in such case?
>>
>> I'm assuming that the dma driver is taking responsibility for setting
>> this correctly.  How would this work otherwise... HBA driver or
>> subsystem queries the dmaengine device and then sets this parameter on
>> its behalf?  In other words dmanengine *is* the subsystem, if I am
>> understanding your definition.
>
> Oops, I meant that the subsystem is software layer above
> dmaengine. For example, SCSI subsystem sets the limit of max number of
> sglist entries. That is, it is possible that software layer above
> dmaengine could set dma limit, which is smaller than the limit of
> dmaengine?
>

Perhaps, but this sounds like the reverse of what happens today where
scsi device drivers with knowledge of their own hardware will tell the
midlayer/subsystem the restriction.  The change with regard to this
patch is that the scsi device driver (for example) will recognize that
the device it is driving will not be a bus master and will arrange to
allocate a dma channel from dmaengine.  When said scsi driver reports
the dma restrictions to the subsystem it will borrow the parameters
from the dma channel, not the scsi device.  So yes, I still think it
should be whatever the dma channel says.

Although, you've been doing scsi work longer than I, so maybe I'm
overlooking something...?

Are there any cases today where the subsystem imposes tighter
restrictions on the dma geometry than what the device reports?  Even
if that were the case it would be same situation that the scsi device
driver reports maximum parameters, but the subsystem opts for
something tighter.  Whether the maximal parameters come from the scsi
device or the dma channel is moot.
