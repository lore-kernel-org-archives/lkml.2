Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0H2AkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 20:40:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17388 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab0H2AkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 20:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=copDX43N7JKgIkDNamdOZqFLt6RrmsBALjv9PkGOIElg14CWPsgaauByn+N30r8eSS
         ZXE8cSDWMyUUlRbk2PXA==
MIME-Version: 1.0
In-Reply-To: <AANLkTim9daA5eoQDbtJSnMuoBOEkDV4Y_Z3GbcDxL7Rk@mail.gmail.com>
References: <4C702070.5020809@jungers.net>
	<4C71808B.7070704@garzik.org>
	<4C718115.8070103@garzik.org>
	<AANLkTi=fQsHVpNu2TZeDNdcofoorFFfsASU=XDqUB9b4@mail.gmail.com>
	<AANLkTi=deJbndavPJmFzEoy6kZQX8LdoAdE+QQN5if0=@mail.gmail.com>
	<AANLkTim9daA5eoQDbtJSnMuoBOEkDV4Y_Z3GbcDxL7Rk@mail.gmail.com>
Date: Sat, 28 Aug 2010 17:40:03 -0700
Message-ID: <AANLkTikBQATmDFsdqfc3hVA6QyDfpGfzetzVMJkxg5-Y@mail.gmail.com>
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

I submit a patch, but messed up with the --in-reply-to argument. Check
"libata-sff: Reenable Port Multiplier after libata-sff remodeling."
thread.

I can now see my drive:
Aug 27 17:42:36 halab-59 kernel: [  103.631293] ata_sff_exec_command:
ata5: cmd 0xEC
Aug 27 17:42:36 halab-59 kernel: [  103.634050] ata_sff_hsm_move:
ata5: protocol 2 task_state 2 (dev_stat 0x58)
Aug 27 17:42:36 halab-59 kernel: [  103.634053] ata_pio_sector: data read
Aug 27 17:42:36 halab-59 kernel: [  103.634228] ata_sff_hsm_move:
ata5: protocol 2 task_state 3 (dev_stat 0x50)
Aug 27 17:42:36 halab-59 kernel: [  103.634231] ata_sff_hsm_move:
ata5: dev 0 command complete, drv_stat 0x50

In general BMDMA does not support PMP, it assumes all qc are on ap->host.
sata_mv does it sometimes, I will submit a patch for that, after I
test the error path through-fully.

Gwendal.


On Fri, Aug 27, 2010 at 3:56 PM, Gwendal Grignou <gwendal@google.com> wrote:
> I found the problem: in ata_sff_pio_stack:
>
> struct ata_queued_cmd *qc = ap->port_task_data;
>
> has been replaced by:
>
> /* qc can be NULL if timeout occurred */
> qc = ata_qc_from_tag(ap, ap->link.active_tag);
> if (!qc)
>        return;
>
> That does not work in case of port multipler, because the link to look
> at is not ap->link. ap->link.active_tag is ATA_POISON.
>
> I will submit a patch where I re-introduce port_task_data, this time
> containing the link to to look at.
>
> Gwendal.
>
>
>
> On Fri, Aug 27, 2010 at 12:29 PM, Gwendal Grignou <gwendal@google.com> wrote:
>> I include the trace. You need windows and a lecroy satasuite to look
>> at the trace.
>>
>> Looking at extended traces, the identify never move in HSM:
>>
>> Aug 27 12:07:53 halab-59 kernel: [  548.613529] ata_sff_flush_pio_task: ENTER
>> Aug 27 12:07:53 halab-59 kernel: [  548.613561] ata_sff_exec_command:
>> ata13: cmd 0xE4
>> Aug 27 12:07:53 halab-59 kernel: [  548.613577] ata_sff_hsm_move:
>> ata13: protocol 1 task_state 3 (dev_stat 0x50)
>> Aug 27 12:07:53 halab-59 kernel: [  548.613580] ata_sff_hsm_move:
>> ata13: dev 0 command complete, drv_stat 0x50
>> Aug 27 12:07:53 halab-59 kernel: [  548.613605] ata_sff_flush_pio_task: ENTER
>> Aug 27 12:07:53 halab-59 kernel: [  548.613637] ata_sff_exec_command:
>> ata13: cmd 0xE4
>> Aug 27 12:07:53 halab-59 kernel: [  548.613654] ata_sff_hsm_move:
>> ata13: protocol 1 task_state 3 (dev_stat 0x50)
>> Aug 27 12:07:53 halab-59 kernel: [  548.613656] ata_sff_hsm_move:
>> ata13: dev 0 command complete, drv_stat 0x50
>> Aug 27 12:07:53 halab-59 kernel: [  548.613681] ata_sff_flush_pio_task: ENTER
>> Aug 27 12:07:53 halab-59 kernel: [  548.613688]
>> ata_eh_revalidate_and_attach: ENTER
>> Aug 27 12:07:53 halab-59 kernel: [  548.613691]
>> ata_eh_revalidate_and_attach: ENTER
>> Aug 27 12:07:53 halab-59 kernel: [  548.613693]
>> ata_eh_revalidate_and_attach: ENTER
>> Aug 27 12:07:53 halab-59 kernel: [  548.613694]
>> ata_eh_revalidate_and_attach: ENTER
>> Aug 27 12:07:53 halab-59 kernel: [  548.613725] ata_sff_exec_command:
>> ata13: cmd 0xEC
>> ...
>> Aug 27 12:08:23 halab-59 kernel: [  578.613048] __ata_port_freeze:
>> ata13 port frozen
>> Aug 27 12:08:23 halab-59 kernel: [  578.613058] ata13.03: qc timeout (cmd 0xec)
>> Aug 27 12:08:23 halab-59 kernel: [  578.613062] ata13.03: failed to
>> IDENTIFY (I/O error, err_mask=0x4)
>>
>>
>> On Fri, Aug 27, 2010 at 1:19 AM, Gwendal Grignou <gwendal@google.com> wrote:
>>> I can reproduce the problem on uptsream-linux using a PC with Marvell
>>> 7042 controller and Sil3726 PMP. Without the SIl3726, it works fine.
>>>
>>> What I can see on the SATA analyzer [I will send clean trace tomorrow]
>>> is the disk send the DATA FIS back to the PMP, but the PMP does not
>>> manage to have the data accepted by the host.
>>>
>>> Non data commands work fine.
>>>
>>> In dmesg:
>>> [10058.404047] ata29: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> [10058.404742] ata29.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6
>>> ports, feat 0x1/0x9
>>> [10058.405250] ata29.00: hard resetting link
>>> [10058.809151] ata29.00: link resume succeeded after 1 retries
>>> [10058.911613] ata29.01: hard resetting link
>>> [10059.217572] ata29.02: hard resetting link
>>> [10059.523572] ata29.03: hard resetting link
>>> [10059.829505] ata29.04: hard resetting link
>>> [10060.134572] ata29.05: hard resetting link
>>> [10065.440079] ata29.03: qc timeout (cmd 0xec)
>>> [10065.440085] ata29.03: failed to IDENTIFY (I/O error, err_mask=0x4)
>>> [10065.440092] ata29.15: hard resetting link
>>> [10065.947049] ata29.15: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> [10065.947737] ata29.00: hard resetting link
>>> [10066.352106] ata29.00: link resume succeeded after 1 retries
>>> [10066.454616] ata29.01: hard resetting link
>>> [10066.760591] ata29.02: hard resetting link
>>> [10067.066570] ata29.03: hard resetting link
>>> [10067.372505] ata29.05: hard resetting link
>>> [10077.677071] ata29.03: qc timeout (cmd 0xec)
>>> [10077.677076] ata29.03: failed to IDENTIFY (I/O error, err_mask=0x4)
>>> [10077.677081] ata29.15: hard resetting link
>>> [10078.184073] ata29.15: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> [10078.184783] ata29.00: hard resetting link
>>> [10078.589185] ata29.00: link resume succeeded after 1 retries
>>> [10078.691593] ata29.01: hard resetting link
>>> [10078.997592] ata29.02: hard resetting link
>>> [10079.303571] ata29.03: hard resetting link
>>> [10079.609505] ata29.04: hard resetting link
>>> [10079.914572] ata29.05: hard resetting link
>>> [10110.220078] ata29.03: qc timeout (cmd 0xec)
>>> [10110.220083] ata29.03: failed to IDENTIFY (I/O error, err_mask=0x4)
>>> [10110.220087] ata29.03: failed to recover link after 3 tries, disabling
>>> [10110.220094] ata29.15: hard resetting link
>>> [10110.727044] ata29.15: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> [10111.033375] ata29.00: hard resetting link
>>> [10111.338571] ata29.01: hard resetting link
>>> [10111.644591] ata29.02: hard resetting link
>>> [10111.950594] ata29.05: hard resetting link
>>> [10112.256643] ata29: EH complete
>>>
>>>
>>> Gwendal.
>>>
>>>
>>>
>>>
>>> On Sun, Aug 22, 2010 at 12:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>>> On 08/22/2010 03:54 PM, Jeff Garzik wrote:
>>>>>
>>>>> On 08/21/2010 02:52 PM, Nicolas Jungers wrote:
>>>>>>
>>>>>> My arm box doesn't succeed to use my esata port multiplier (addonics
>>>>>> sil3726 based). It was working well with 2.6.34.1 and 2.6.34.4 but not
>>>>>> with both 2.6.35.2 and 2.6.35.3. I haven't test other kernels.
>>>>>>
>>>>>> The kernels are from http://sheeva.with-linux.com/sheeva/ with for
>>>>>> example the following config
>>>>>> http://sheeva.with-linux.com/sheeva/2.6.35.3/sheeva-2.6.35.3.config
>>>>>>
>>>>>> The symptoms are in the console a loop on the esata links. Here is the
>>>>>> start of it:
>>>>>>
>>>>>> ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
>>>>>> ata2: edma_err_cause=00000010 pp_flags=00000000, dev connect
>>>>>> ata2: SError: { PHYRdyChg DevExch }
>>>>>> ata2: hard resetting link
>>>>>> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
>>>>>> ata2.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>>>>>
>>>>> Can you post or link to the entire dmesg?
>>>>>
>>>>> Notably, we need to see the probe messages to determine what SATA chip
>>>>> you are using... From the edma_err_cause config I'd guess sata_mv, but
>>>>> more info would be useful.
>>>>
>>>> Nevermind, I see the reply (it got auto-sorted into the wrong folder
>>>> locally).
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>
>
