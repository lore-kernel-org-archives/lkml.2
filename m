Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab1FPTTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:19:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37014 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab1FPTTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:19:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AbPOncUSly8/2oM4pXBzmlYmhvKocLxu43xkI9mgK5W+jtnOB6TP/jaMFCa+nVFI0d
         aPAApyxN/hbb10cv4yIkFNQbLZJLZankDNvIcaLsflt/pQozIBuoFWXlmmhYhxbknhlz
         ul+Nie89vdwzHdb9/XXXrOXvaE2n1XCXTHaHU=
MIME-Version: 1.0
In-Reply-To: <4DFA4672.5080307@lwfinger.net>
References: <BANLkTikXUd8uorD+juMDvFubr3cz+OZnaQ@mail.gmail.com>
	<BANLkTinUxRGkXeOtBSKi51n3Q_rZEp1gUg@mail.gmail.com>
	<4DFA4672.5080307@lwfinger.net>
Date: Thu, 16 Jun 2011 21:19:04 +0200
Message-ID: <BANLkTi=-wXnXNJY3R+3Q+KSaJhtxHgrhZw@mail.gmail.com>
Subject: Re: Faking MMIO ops? Fooling a driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pekka Paalanen <pq@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 16 czerwca 2011 20:07 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 06/16/2011 12:20 PM, Rafał Miłecki wrote:
>>
>> W dniu 16 czerwca 2011 16:44 użytkownik Rafał Miłecki
>> <zajec5@gmail.com>  napisał:
>>>
>>> I analyze MMIO dumps of closed source driver and found such a place:
>>> W 2 3855.911536 9 0xb06003fc 0x810 0x0 0
>>> R 2 3855.911540 9 0xb06003fe 0x0 0x0 0
>>> W 2 3855.911541 9 0xb06003fe 0x0 0x0 0
>>>
>>> After translation:
>>>  phy_read(0x0810) ->  0x0000
>>> phy_write(0x0810)<- 0x0000
>>>
>>> So it's quite obvious, the driver is reading PHY register, masking it
>>> and writing masked value. Unfortunately from just looking at such
>>> place we can not guess the mask driver uses.
>>>
>>> I'd like to fake value read from 0xb06003fe to be 0xFFFF.
>>> Is there some ready method for doing such a trick?
>>>
>>> Dump comes from Kernel hacking → Tracers → MMIO and ndiswrapper.
>>
>> I can see values in MMIO trace struct are filled in
>> arch/x86/mm/mmio-mod.c in "pre" and "post". However still no idea how
>> to hack the returned value.
>>
>> Should I try hacking read[bwl] instead? :|
>
> Probably. I do not see any way to trace and modify the results for a
> particular address without special code.

Did you success with writing some special code? Following patch does
not seem to work for me:


diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index e0ffa3d..448e4ff 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -23,6 +23,8 @@
 #define mmiowb() do {} while (0)
 #endif

+static int zajec = 0;
+
 /*****************************************************************************/
 /*
  * readX/writeX() are used to access memory mapped devices. On some
@@ -40,6 +42,11 @@ static inline u8 __raw_readb(const volatile void
__iomem *addr)
 #ifndef __raw_readw
 static inline u16 __raw_readw(const volatile void __iomem *addr)
 {
+	if (zajec++ < 10)
+		printk(KERN_INFO "[ZAJEC] %d\n", *addr);
+	if (*addr == 0xfaafc000)
+		printk(KERN_INFO "[ZAJEC] Bingo!\n");
+	//0x1381a8d8
 	return *(const volatile u16 __force *) addr;
 }
 #endif

Should I modify different readw? Path include/asm-generic/io.h sounds
sane to me, so I modified this one.


> FYI, my reference driver for reverse engineering has no instance of a
> read/modify/write for PHY register 0x810. Is the code in question for a PHY
> type > 6?

This is for PHY type 7, AKA "HT".

-- 
Rafał
