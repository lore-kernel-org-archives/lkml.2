Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab1ENNkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 09:40:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46732 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab1ENNkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 09:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qdttN735R/CTYQ7QC2NHXeBgcjy2SKm8kZcBygUixJt61ri0UqRgX1VLlTfZRqke0+
         qIBDLHsxr+tQ/Fp889q1b9IQRnD8vOQ6PUOjBbBKRo2t1L51sevrLGiINtc4v9NuXu5O
         erK3pINmUAIUplpame7d7tYZ8lacrKoq2/wfM=
MIME-Version: 1.0
In-Reply-To: <20110513182731.GX8970@sortiz-mobl>
References: <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
	<1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
	<1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
	<20110513142057.GC8970@sortiz-mobl>
	<BANLkTikfh6c_kFom+2MHx+QTuZxVJH0svA@mail.gmail.com>
	<20110513182731.GX8970@sortiz-mobl>
Date: Sat, 14 May 2011 21:40:17 +0800
Message-ID: <BANLkTikg0_kotmqHqz4P2vBB=T84HopGFw@mail.gmail.com>
Subject: Re: [PATCH 3/6] mfd: 88pm860x: enhance lock on i2c transaction
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        a.zummo@towertech.it, khali@linux-fr.org, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 2:27 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Haojian,
>
> On Fri, May 13, 2011 at 11:00:24PM +0800, Haojian Zhuang wrote:
>> On Fri, May 13, 2011 at 10:20 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
>> > Hi Haojian,
>> >
>> > On Fri, May 06, 2011 at 05:21:22PM +0800, Haojian Zhuang wrote:
>> >> Accessing test page in 88pm860x is a sequence of read/write on i2c bus.
>> >> Bus lock is used in each small i2c transaction. But it may result the
>> >> whole sequence interrupted by other i2c client transaction.
>> > Sure, but what you mainly want is your MFD i2c IO calls to be serialized, and
>> > that's already being taken care of by the current code.
>> > Are other i2c clients (non MFD ones) touching the same i2c registers than the
>> > MFD ones ?
>> >
>> Other process may not access the same register. But they may access same i2c
>> bus. What I did is used to protect bus operation.
>>
>> Even accessing one register in test page is composed by a sequence of accessing
>> test page.
>>
>> For example, read one byte of 0xbc in test page.
>> 1) i2c read zero byte from 0xFA
>> 2) i2c read zero byte from 0xFB
>> 3) i2c read zero byte from 0xFF
>> 4) i2c read one byte from 0xbc (desired operation)
>> 5) i2c read zero byte from 0xFC
>>
>> Step #1 to #3 is used to enter test page mode. Step 4 is used to read
>> desired data.
>> Step #5 is used to exit test page mode. If all these five steps are
>> using standard
>> i2c read operation, bus lock in i2c driver will be held and released
>> five times. If another
>> process is also accessing i2c bus, it may interrupt the sequence and
>> import error to
>> pmic.
> I see. Wouldn't i2c_transfer() fix your problem then ?
>
No, i2c_transfer() can't fix my problem.

All atomic i2c frame are composed by start signal, i2c address, i2c
data (optional),
end signal. i2c_transfer() is used to send one i2c frame, so it only produce
one start signal and one end signal.

What I need is a sequence of i2c frames. Nearly five start signals and five end
signals should be produced in the sequence of test page. So i2c_transfer()
can't handle this scenario, and I have to use my i2c frames.

Best Regards
Haojian
