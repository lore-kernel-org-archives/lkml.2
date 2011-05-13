Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab1EMPA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:00:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55353 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068Ab1EMPA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:00:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iHjt6l89bV2g0TVlZVsZAkw3zKvd+loSA8fYp6X+1oIkO9HYqjDmi5kcFuh2vTwKFY
         sH7Wie0tfEL2Esa9iqKKvsdvwZpt8AS+XBGt37/49AeogO6fnprZPqyLXRDioqwnlnNR
         c5UqrBtdrHJVgPw2h/vsVnwI1OObT47JGVR/A=
MIME-Version: 1.0
In-Reply-To: <20110513142057.GC8970@sortiz-mobl>
References: <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
	<1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
	<1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
	<20110513142057.GC8970@sortiz-mobl>
Date: Fri, 13 May 2011 23:00:24 +0800
Message-ID: <BANLkTikfh6c_kFom+2MHx+QTuZxVJH0svA@mail.gmail.com>
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

On Fri, May 13, 2011 at 10:20 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Haojian,
>
> On Fri, May 06, 2011 at 05:21:22PM +0800, Haojian Zhuang wrote:
>> Accessing test page in 88pm860x is a sequence of read/write on i2c bus.
>> Bus lock is used in each small i2c transaction. But it may result the
>> whole sequence interrupted by other i2c client transaction.
> Sure, but what you mainly want is your MFD i2c IO calls to be serialized, and
> that's already being taken care of by the current code.
> Are other i2c clients (non MFD ones) touching the same i2c registers than the
> MFD ones ?
>
Other process may not access the same register. But they may access same i2c
bus. What I did is used to protect bus operation.

Even accessing one register in test page is composed by a sequence of accessing
test page.

For example, read one byte of 0xbc in test page.
1) i2c read zero byte from 0xFA
2) i2c read zero byte from 0xFB
3) i2c read zero byte from 0xFF
4) i2c read one byte from 0xbc (desired operation)
5) i2c read zero byte from 0xFC

Step #1 to #3 is used to enter test page mode. Step 4 is used to read
desired data.
Step #5 is used to exit test page mode. If all these five steps are
using standard
i2c read operation, bus lock in i2c driver will be held and released
five times. If another
process is also accessing i2c bus, it may interrupt the sequence and
import error to
pmic.

So the potential issue is releasing bus lock too early. If I just add
bus lock protection
in test page operation, I'll meet dead lock issue since bus lock will
be used in standard
i2c operation. I have to implement my i2c frame and send it out directly.

Best Regards
Haojian
