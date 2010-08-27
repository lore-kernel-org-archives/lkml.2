Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab0H0IT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:19:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54126 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab0H0ITy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r2+wpID1n8iGs1FEdpkK28Cwh+iFbFrctpTp14a4Qd1xIlZz1NmKSySVXPTbQ52QxJ
         hr8xR70TdxQhTA7lUlKQ==
MIME-Version: 1.0
In-Reply-To: <4C718115.8070103@garzik.org>
References: <4C702070.5020809@jungers.net>
	<4C71808B.7070704@garzik.org>
	<4C718115.8070103@garzik.org>
Date: Fri, 27 Aug 2010 01:19:49 -0700
Message-ID: <AANLkTi=fQsHVpNu2TZeDNdcofoorFFfsASU=XDqUB9b4@mail.gmail.com>
Subject: Re: possible esata regression in 2.6.35
From: Gwendal Grignou <gwendal@google.com>
To: Jeff Garzik <jeff@garzik.org>, kernel@teksavvy.com
Cc: Nicolas Jungers <nicolas@jungers.net>, linux-kernel@vger.kernel.org,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can reproduce the problem on uptsream-linux using a PC with Marvell
7042 controller and Sil3726 PMP. Without the SIl3726, it works fine.

What I can see on the SATA analyzer [I will send clean trace tomorrow]
is the disk send the DATA FIS back to the PMP, but the PMP does not
manage to have the data accepted by the host.

Non data commands work fine.

In dmesg:
[10058.404047] ata29: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10058.404742] ata29.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6
ports, feat 0x1/0x9
[10058.405250] ata29.00: hard resetting link
[10058.809151] ata29.00: link resume succeeded after 1 retries
[10058.911613] ata29.01: hard resetting link
[10059.217572] ata29.02: hard resetting link
[10059.523572] ata29.03: hard resetting link
[10059.829505] ata29.04: hard resetting link
[10060.134572] ata29.05: hard resetting link
[10065.440079] ata29.03: qc timeout (cmd 0xec)
[10065.440085] ata29.03: failed to IDENTIFY (I/O error, err_mask=0x4)
[10065.440092] ata29.15: hard resetting link
[10065.947049] ata29.15: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10065.947737] ata29.00: hard resetting link
[10066.352106] ata29.00: link resume succeeded after 1 retries
[10066.454616] ata29.01: hard resetting link
[10066.760591] ata29.02: hard resetting link
[10067.066570] ata29.03: hard resetting link
[10067.372505] ata29.05: hard resetting link
[10077.677071] ata29.03: qc timeout (cmd 0xec)
[10077.677076] ata29.03: failed to IDENTIFY (I/O error, err_mask=0x4)
[10077.677081] ata29.15: hard resetting link
[10078.184073] ata29.15: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10078.184783] ata29.00: hard resetting link
[10078.589185] ata29.00: link resume succeeded after 1 retries
[10078.691593] ata29.01: hard resetting link
[10078.997592] ata29.02: hard resetting link
[10079.303571] ata29.03: hard resetting link
[10079.609505] ata29.04: hard resetting link
[10079.914572] ata29.05: hard resetting link
[10110.220078] ata29.03: qc timeout (cmd 0xec)
[10110.220083] ata29.03: failed to IDENTIFY (I/O error, err_mask=0x4)
[10110.220087] ata29.03: failed to recover link after 3 tries, disabling
[10110.220094] ata29.15: hard resetting link
[10110.727044] ata29.15: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10111.033375] ata29.00: hard resetting link
[10111.338571] ata29.01: hard resetting link
[10111.644591] ata29.02: hard resetting link
[10111.950594] ata29.05: hard resetting link
[10112.256643] ata29: EH complete


Gwendal.




On Sun, Aug 22, 2010 at 12:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 08/22/2010 03:54 PM, Jeff Garzik wrote:
>>
>> On 08/21/2010 02:52 PM, Nicolas Jungers wrote:
>>>
>>> My arm box doesn't succeed to use my esata port multiplier (addonics
>>> sil3726 based). It was working well with 2.6.34.1 and 2.6.34.4 but not
>>> with both 2.6.35.2 and 2.6.35.3. I haven't test other kernels.
>>>
>>> The kernels are from http://sheeva.with-linux.com/sheeva/ with for
>>> example the following config
>>> http://sheeva.with-linux.com/sheeva/2.6.35.3/sheeva-2.6.35.3.config
>>>
>>> The symptoms are in the console a loop on the esata links. Here is the
>>> start of it:
>>>
>>> ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
>>> ata2: edma_err_cause=00000010 pp_flags=00000000, dev connect
>>> ata2: SError: { PHYRdyChg DevExch }
>>> ata2: hard resetting link
>>> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
>>> ata2.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>>
>> Can you post or link to the entire dmesg?
>>
>> Notably, we need to see the probe messages to determine what SATA chip
>> you are using... From the edma_err_cause config I'd guess sata_mv, but
>> more info would be useful.
>
> Nevermind, I see the reply (it got auto-sorted into the wrong folder
> locally).
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
