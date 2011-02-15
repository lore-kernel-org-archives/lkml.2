Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1BOLsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 06:48:31 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39564 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab1BOLsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 06:48:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OC2f7BQ6Gch1bt/HZcIuRFruV060xG+MM1++KB6SA8lbhN5XJfjRgWY2ltQ/7FWAs+
         v+sgYwZQ6ywXN9AjCVuiSTnykak3rrjIHh/YTE5/kVIY3uQdE/dicI7T2tb3w4nZRmYd
         mMKXiQHosFVKfgkTOa8+hB3Vm2qQ6XYiGY0RM=
MIME-Version: 1.0
In-Reply-To: <4D59A93A.7090800@metafoo.de>
References: <1297539554-13957-8-git-send-email-lars@metafoo.de>
	<1297652493-7207-1-git-send-email-lars@metafoo.de>
	<AANLkTimn2JYtUSUrJBQKzXrw+URD5n0Y2h7QMaFzKFdY@mail.gmail.com>
	<4D59A93A.7090800@metafoo.de>
Date: Tue, 15 Feb 2011 13:48:28 +0200
Message-ID: <AANLkTi=RJfYEoiCPgesmZUoeOy+MehZQWeWDCWoW7vnh@mail.gmail.com>
Subject: Re: [PATCH 07/14 v3] bq27x00: Cache battery registers
From: Grazvydas Ignotas <notasas@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Pali Rohar <pali.rohar@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 12:14 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 02/14/2011 10:58 PM, Grazvydas Ignotas wrote:
>> On Mon, Feb 14, 2011 at 5:01 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>>
>>> -       ret = bq27x00_read(di, BQ27x00_REG_AI, &curr, false);
>>> -       if (ret) {
>>> -               dev_err(di->dev, "error reading current\n");
>>> -               return 0;
>>> -       }
>>> +       if (di->chip == BQ27500)
>>> +           curr = bq27x00_read(di, BQ27x00_REG_AI, false);
>>> +       else
>>> +           curr = di->cache.current_now;
>>> +
>>> +       if (curr < 0)
>>> +               return curr;
>>
>> This is wrong, as read function returns negative values for bq27500
>> when discharging. That's why read function used to pass value through
>> argument before your series (return value was for error code).
>
> I don't think so. The register is 16bit wide and it is read as a unsigned. So
> in the non error case bq27x00_read will always return >= 0.
> The value is later reinterpreted as a signed 16bit.(See the other lines you
> quoted underneath).

Hmh, right..

> Did you experience any actual problem with current being wrong?

Yes, the returned current values were randomly jumping between -500000
and 600000 while the device was discharging, so I thought
uninitialized values were being returned (this never happened before
the series; no errors in dmesg). I'll need to debug a bit more I
guess..
