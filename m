Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0FAFGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:06:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53213 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0FAFGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qDZArL7sNRC2K/2haSMM/EZo43FK+E0Tse9PimjStW+f6k+viM3ATWMhIkCIIDgIsu
         S7OHLyBOEW0q3/3r9hRjHagj9Ggu+Qz0hfWVd9/v3dcm9wjrpE/skm0JcY8S/+HJeZbT
         q38rNu0b19ibIPWka+YnAdT69ws88xZWBkK9c=
MIME-Version: 1.0
In-Reply-To: <AANLkTilrjgoGLaXsaDhCxKwgw6d71wnO4X7O9_lR1wfD@mail.gmail.com>
References: <AANLkTilqsIdlzZgUf7TMLHYKqHDZoVkcs42vcG8wXKEr@mail.gmail.com>
	<4C0493C0.7000703@gmail.com>
	<AANLkTilrjgoGLaXsaDhCxKwgw6d71wnO4X7O9_lR1wfD@mail.gmail.com>
Date: Mon, 31 May 2010 23:06:46 -0600
Message-ID: <AANLkTilqe7vUrZubT65uGj363VwQSsY5CROV2lnBVNkU@mail.gmail.com>
Subject: Re: SSD + sata_nv + btrfs oops
From: Robert Hancock <hancockrwd@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 11:02 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Tue, Jun 1, 2010 at 2:59 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
>> On 05/31/2010 09:04 PM, Dave Airlie wrote:
>>>
>>> Hi guys,
>>>
>>> I've been running an Intel SSD (the KS one) on my Dell XPS710 desktop
>>> machine, with btrfs on it.
>>>
>>> I'm not sure the btrfs oops isn't due to the disk/controller doing
>>> something bad (almost guaranteed).
>>>
>>> Attached the dmesg + config, using 2.6.34 + only drm patches.
>>>
>>> Jeff I'd be interested in knowing what is happening to the disk before
>>> btrfs oops.
>>
>> ata2: EH in SWNCQ mode,QC:qc_active 0x7FFFFE03 sactive 0x7FFFFE03
>> ata2: SWNCQ:qc_active 0xFE00 defer_bits 0x7FFF0003 last_issue_tag 0xf
>>  dhfis 0x7E00 dmafis 0x200 sdbfis 0x0
>> ata2: ATA_REG 0x40 ERR_REG 0x0
>> ata2: tag : dhfis dmafis sdbfis sacitve
>> ata2: tag 0x9: 1 1 0 1
>> ata2: tag 0xa: 1 0 0 1
>> ata2: tag 0xb: 1 0 0 1
>> ata2: tag 0xc: 1 0 0 1
>> ata2: tag 0xd: 1 0 0 1
>> ata2: tag 0xe: 1 0 0 1
>> ata2: tag 0xf: 0 0 0 1
>> ata2.00: exception Emask 0x0 SAct 0x7ffffe03 SErr 0x1800000 action 0x6
>> frozen
>> ata2: SError: { LinkSeq TrStaTrns }
>>
>> Last line is probably the most informative, SATA link sequence error and
>> transport state transition error. That's probably something bad happening at
>> the low level between the controller and drive. Is this happening
>> repeatedly?
>>
>
> from another boot I do see another one.
>
> ata2: EH in SWNCQ mode,QC:qc_active 0x1FF sactive 0x1FF
> ata2: SWNCQ:qc_active 0x7F defer_bits 0x180 last_issue_tag 0x6
>  dhfis 0x3F dmafis 0x8 sdbfis 0x0
> ata2: ATA_REG 0x41 ERR_REG 0x84
> ata2: tag : dhfis dmafis sdbfis sacitve
> ata2: tag 0x0: 1 0 0 1
> ata2: tag 0x1: 1 0 0 1
> ata2: tag 0x2: 1 0 0 1
> ata2: tag 0x3: 1 1 0 1
> ata2: tag 0x4: 1 0 0 1
> ata2: tag 0x5: 1 0 0 1
> ata2: tag 0x6: 0 0 0 1
> ata2.00: exception Emask 0x1 SAct 0x1ff SErr 0x3800000 action 0x6 frozen
>
> So yes it seems to happen quite a bit, I'm wondering is SWNCQ is
> something I should be disabling for this controller.

Wouldn't hurt to try (swncq=0 module parameter). However, from some of
the later output in the log you posted, it seems like not only was
there some kind of hiccup resulting in a timeout, but later there were
more Serror flags raised like PHY ready change, CommWake, etc. and the
drive seemed to stop responding entirely. That does tend to smell like
some kind of hardware problem to me..

btrfs exploding is presumably a kernel problem, of course..
