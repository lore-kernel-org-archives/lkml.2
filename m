Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab1ARN5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 08:57:10 -0500
Received: from mail-yi0-f42.google.com ([209.85.218.42]:44817 "EHLO
	mail-yi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1ARN5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 08:57:08 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2011 08:57:08 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=xoQn6N+DYnfS872xpAXY6adRxn86OCf205o1MClpgAhnOlBPqsDNqEgrX4xbhLVE50
         r7muZX3hUjDb+BQfDXylM1UhjaixkRechmhUkK1veH75wLsYWAgbqEGKBAYPUn77c30T
         PvIYVsMfsSpHpE1pXqxr/9VX21tSqNmvTYdFA=
MIME-Version: 1.0
In-Reply-To: <AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
References: <20110110223154.GA9739@merz.inka.de>
	<AANLkTi=hnWtpHgv-j0u3n5sG4T-GU0KG_vAMe4vevY05@mail.gmail.com>
	<20110111130959.GA19003@merz.inka.de>
	<AANLkTimViOqKP9aw28PVt0_2LcH_OuruS736fickb_jp@mail.gmail.com>
	<20110114140458.GA7558@merz.inka.de>
	<AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
Date: Tue, 18 Jan 2011 15:49:44 +0200
X-Google-Sender-Auth: vj56fL5kM2O_G7QOMSMyqx563CE
Message-ID: <AANLkTi=UVBTc-GacHuRKda7oo+kGcuoE52ZgCYUj0WnM@mail.gmail.com>
Subject: Re: Regression in linux 2.6.37: failure on remount / (ext4) rw
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: Matthias Merz <linux@merz-ka.de>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ Hey, why was I dropped from the CC? ]

On Mon, Jan 17, 2011 at 2:32 PM, Brian Gerst <brgerst@gmail.com> wrote:
> On Fri, Jan 14, 2011 at 9:04 AM, Matthias Merz <linux@merz-ka.de> wrote:
>> Hello,
>>
>> Am Mi, 12.01.2011 09:03 schrieb Pekka Enberg
>>> On Tue, Jan 11, 2011 at 3:09 PM, Matthias Merz <linux@merz-ka.de> wrote:
>>> > Am Di, 11.01.2011 09:50 schrieb Pekka Enberg
>>> >> On Tue, Jan 11, 2011 at 12:31 AM, Matthias Merz <linux@merz-ka.de> wrote:
>>> >> > This morning I tried vanilla 2.6.37 on my Desktop system, which
>>> >> > failed to boot but continued displaying Debug-Messages too fast
>>> >> > to read. Using netconsole I was then able to capture them [see
>>> >> > below]. I was able to trigger this bug even with init=/bin/bash
>>> >> > by a simple call of "mount -o remount,rw /" with my / being an
>>> >> > ext4 filesystem.
>>> > [erroneous bisecting] I assume some "hardware state" influeces
>>> > triggering of this bug
>>
>>> Would it be possible for you to try to bisect it again? The oops you
>>> report looks slightly obscure (at least to me) so it might be
>>> difficult to find someone to fix it.
>>
>> Calling back after some time. Now I seem to have worked out a way to
>> tell which versions are bad: After having booted a "good" version, a
>> Power-down for a period of several minutes is needed (about 15 or so) or
>> every version will be "good". So I checked by first booting a "known
>> bad" 2.6.37. If that boot failed, I booted the version I wished to
>> check, which seems to have produced usable results. So I was/am pretty
>> convinced that something during "hardware setup" has changed which will
>> survive a normal reset due to capacitances not fully discharged or
>> something like that.
>>
>>
>> git bisect now told me "22d4cd4c4dce6d7b7d9a7e396aa4f87fe7a649b1 is the
>> first bad commit", which is titled: "x86-32: Allocate irq stacks
>> seperate from percpu area".
>>
>> I reverted this change (and following 47f19a0814 due to #defines) and
>> waited over the night until this morning. That revert really seems to
>> fix my problem. So maybe in my special case something goes wrong with
>> the new method?
>
> Does this patch fix the problem?
>
> Subject: [PATCH] x86: Clear irqstack thread_info
>
> Make sure that the thread_info part of the irqstack is initialized
> to zeroes.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
