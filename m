Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab0KDNJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:09:47 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:45934 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0KDNJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:09:44 -0400
Message-ID: <8af4637640a0128476ac3b271f532f56.squirrel@webmail.greenhost.nl>
In-Reply-To: <20101104122056.GB11249@jasper.tkos.co.il>
References: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
    <e15f89ec737d2478bf5edd5369028554.squirrel@webmail.greenhost.nl>
    <20101104064643.GA11249@jasper.tkos.co.il>
    <d8ecdedc03353ad14daa29178528255e.squirrel@webmail.greenhost.nl>
    <20101104122056.GB11249@jasper.tkos.co.il>
Date: Thu, 4 Nov 2010 14:09:41 +0100 (CET)
Subject: Re: [PATCH] drivers/misc: Altera Cyclone active serial 
     implementation
From: "Indan Zupancic" <indan@nul.nu>
To: "Baruch Siach" <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
        "Alex Gershgorin" <agersh@rambler.ru>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 10fb2eeb1e6a32429c7ce102d6ec6cdf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Baruch,

On Thu, November 4, 2010 13:20, Baruch Siach wrote:
> I was wrong about this. I checked the spec again, and it seems that the 24bit
> PAGE_PROGRAM parameter is a byte pointer, not page pointer. So we can change
> page_count to u16 after all.

If it's a byte pointer, then isn't page_count totally wrong?
If it's not the page count, then it should be named differently.

For your next submission, can you test if this driver can successfully
program a FPGA? I mean, including a test to see if all the code made
it to the FPGA, to catch short writes. If the protocol doesn't allow
reads, how are you supposed to check if the programming was really
successful? Is there a CRC somewhere or anything?

I'd also get rid of "len" and use "count" directly. You have to
check if "count" and/or *ppos + count isn't too big anyway. Or
use len instead of page_count. I don't know. Maybe change the
while into a for loop?

+		ret = copy_from_user(page_buf, buf, AS_PAGE_SIZE);
+		if (ret == 0) {
+			buf += AS_PAGE_SIZE;
+			*ppos += AS_PAGE_SIZE;
+			len -= AS_PAGE_SIZE;
+		} else {
+			kfree(page_buf);
+			return -EFAULT;
+		}

I'd change that into:

+		ret = copy_from_user(page_buf, buf, AS_PAGE_SIZE);
+		if (ret) {
+			kfree(page_buf);
+			return -EFAULT;
+		}
+		buf += AS_PAGE_SIZE;
+		*ppos += AS_PAGE_SIZE;
+		len -= AS_PAGE_SIZE;

> OK. I'm now implementing this. Also, ignoring the return value of
> msleep_interruptible() is a terrible mistake. I've posted a patch
> earlier today that makes it __must_check.

Also if you don't care if it slept for shorter?

> I'm setting dev.platform_data somewhere under arch/ as follows:
>
> static struct cyclone_as_platform_data altera_prog_info = {
>         .data           = 102,
>         .nconfig        = 105,
>         .dclk           = 103,
>         .ncs            = 106,
>         .nce            = 104,
> };
>
> static struct platform_device fpga_prog_device = {
>         .name = "cyclone_as",
>         .dev = {
>                 .platform_data = &altera_prog_info,
>         }
> };
>
> And then:
>
>         platform_device_register(&fpga_prog_device);
>
> This is a very common patters in the arch/ underworld. I need struct
> cyclone_as_platform_data to be visible for this.

Thanks for the explanation.

I mixed up drvdata with pdata, so yeah, you're right.

Shouldn't you add this platform bit to the patch? A platform driver
with no users seems a bit useless.

>> >> Probably not high on your list, but what about suspend support?
>> >> Preventing suspend from succeeding seems like a good idea when
>> >> stuff is going on.
>> >
>> > I'm not sure we should impose a suspend prevention in this case. The user
>> > should bear the consequences if he/she decides to suspend the system in
>> the
>> > middle of FPGA programming. Maybe we should just warn.
>>
>> I don't think any user would ever want to suspend in the middle of
>> FPGA programming. So if it happens it's most likely a mistake or
>> some automatic suspend. Both should fail. The code to fail is
>> slightly simpler than the code to warn too. So I'd say either let
>> it fail or keep your code simpler and ignore it altogether.
>
> I think I'll go for the latter for now. This can always be added later.

As long as this isn't used for very expensive OTP FPGAs handling
suspend is not that important...

Greetings,

Indan


