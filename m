Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1FIGRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 02:17:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49129 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab1FIGRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 02:17:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=QYm/TpDV59U2JvmlqlWTtxlGOf1yxPcKVIeqS2Tcji2u2w5M3Auqb7wAgT2W2Q2tTX
         M2MFWcurBXs5mmO+I7Kkk09LVLIb738ufTaFTf045cdArmkReaUjWjW1ChbU5C5Y29eV
         A3EatOa3Angq8fpnHx8g7G/pM5DabpxtaO6LY=
MIME-Version: 1.0
In-Reply-To: <20110609052509.GA3997@gmail.com>
References: <20110609030401.GA2615@gmail.com>
	<BANLkTim_=2kWXAzkECC4A3t9uxGERwBU7g@mail.gmail.com>
	<20110609052509.GA3997@gmail.com>
Date: Wed, 8 Jun 2011 23:17:21 -0700
Message-ID: <BANLkTin-iC8HFm2dmCmRTfYcBDDRbjZnFw@mail.gmail.com>
Subject: Re: [PATCH RESEND]Remove a warning for drivers/edac/i82975x_edac.c
From: Connor Hansen <cmdkhh@gmail.com>
To: Connor Hansen <cmdkhh@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, randy.dunlap@oracle.com, greg@kroah.com,
        joe@perches.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 10:25 PM, Harry Wei <jiaweiwei.xiyou@gmail.com> wrote:
> On Wed, Jun 08, 2011 at 09:26:46PM -0700, Connor Hansen wrote:
>> When I compile 3.0.0-rc2+ I don't get this warning.
>> please make sure this issue still exists.
> I have not compiled 3.0.0-rc2+, but
> i fetch portions of drivers/edac/i82975x_edac.c
> of 3.0.0-rc2+ like below.
>
> [...]
> 296         page = (unsigned long) info->eap;
> 297         if (info->xeap & 1)
> 298                 page |= 0x100000000ul;
> 299         chan = page & 1;
> 300         page >>= 1;
> [...]
>

this code is the same in 3.0.0-rc2+ but produces no warning.

> The following codes prove this warning
> remians.
>
> #include <stdio.h>
>
> int main(void)
> {
>        unsigned long a;
>
>        a = 0x100000000ul;
>        printf("%lu\n", a);
>        return 0;
> }

this is not what the code you are changing does.

the code is not assigned that value, its or'd with it.

a test would be more like.

#include <stdio.h>
int main()
{
        unsigned long page;  //page
        unsigned int b = 5;  //info->eap is u32 = unsigned int
                                       // typedef unsigned int __u32;
        page = (unsigned long) b;
        page |= 0x10000000ul;

        printf("%lu\n",page);

        return 0;
}

This produces no warning.
$ gcc -g test.c && ./a.out
268435461
$

0x10000000
10000000000000000000000000000
5
00000000000000000000000000101
0x10000000 | 5 =
10000000000000000000000000101
268435461

I am green to kernel development so I will wait for someone with a bit
more knowledge to
chime in, or verify this warning.
Connor

>
> jiawei@jiawei-laptop:~/GTK$ gcc 5.c -Wall -o 1
> 5.c: In function ‘main’:
> 5.c:7: warning: integer constant is too large for ‘unsigned long’ type
> 5.c:7: warning: large integer implicitly truncated to unsigned type
>
> But if you program it like below, it is well for us.
>
> #include <stdio.h>
>
> int main(void)
> {
>        unsigned long long a;
>
>        a = 0x100000000ull;
>        printf("%llu\n", a);
>        return 0;
> }
>
> Thanks
> Harry Wei
>> Connor
>>
>> On Wed, Jun 8, 2011 at 8:04 PM, Harry Wei <jiaweiwei.xiyou@gmail.com> wrote:
>> > From: Harry Wei <harryxiyou@gmail.com>
>> >
>> > When i compile 2.6.39.1, a warning shows like below.
>> > This patch can fix the warning. And i works well with
>> > my PC.
>> >
>> > [...]
>> > CC [M] ??drivers/edac/e752x_edac.o
>> > CC [M] ??drivers/edac/i82875p_edac.o
>> > CC [M] ??drivers/edac/i82975x_edac.o
>> > drivers/edac/i82975x_edac.c: In function ?????????i82975x_process_error_info?????????:
>> > drivers/edac/i82975x_edac.c:298: warning: integer constant is too large for ?????????unsigned long????????? type
>> > CC [M] ??drivers/edac/i3000_edac.o
>> > CC [M] ??drivers/edac/i3200_edac.o
>> > CC [M] ??drivers/edac/x38_edac.o
>> > CC [M] ??drivers/edac/i82860_edac.o
>> > [...]
>> >
>> >
>> > Signed-off-by: Harry Wei <harryxiyou@gmail.com>
>> > Index: prj/drivers/edac/i82975x_edac.c
>> > ===================================================================
>> > --- prj.orig/drivers/edac/i82975x_edac.c ?? ?? ?? ??2011-06-04 10:09:55.351174516 +0800
>> > +++ prj/drivers/edac/i82975x_edac.c ?? ?? 2011-06-04 10:10:30.875168437 +0800
>> > @@ -293,9 +293,9 @@
>> > ?? ?? ?? ?? ?? ?? ?? ??info->errsts = info->errsts2;
>> > ?? ?? ?? ??}
>> >
>> > - ?? ?? ?? page = (unsigned long) info->eap;
>> > + ?? ?? ?? page = (unsigned long long) info->eap;
>> > ?? ?? ?? ??if (info->xeap & 1)
>> > - ?? ?? ?? ?? ?? ?? ?? page |= 0x100000000ul;
>> > + ?? ?? ?? ?? ?? ?? ?? page |= 0x100000000ull;
>> > ?? ?? ?? ??chan = page & 1;
>> > ?? ?? ?? ??page >>= 1;
>> > ?? ?? ?? ??offst = page & ((1 << PAGE_SHIFT) - 1);
>> > --
>
