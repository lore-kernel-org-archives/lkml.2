Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0HaGJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:09:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39891 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0HaGJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:09:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ok8FH1iDEyVTr1U32ysUgyaApus4WTc48D6DeqCxb1Q9sWbZ1Mdp/A40beRciJ9818
         7NTYBSVmckbLZlpOMeyX8rGFhJ5vZSD5QJIMjrG8gQj2TU1JVCkc59kNUVU5o1Ro9HG2
         4tRX5BumtmWIxWApaxmu0G877BcEzzmUD7/sE=
MIME-Version: 1.0
In-Reply-To: <AANLkTikxOQnj=vKD8b0aZqZHNe4m-Y+o+620TBzMJCAW@mail.gmail.com>
References: <1282813649-8332-1-git-send-email-mark.brown314@gmail.com>
 <1282813649-8332-2-git-send-email-mark.brown314@gmail.com>
 <AANLkTi=GZ1p3MzibOEzhyD=Mv6d2x2nRh93D4bmtgcYE@mail.gmail.com>
 <AANLkTimwU17YS5Yk7y+13Dj9Ww4oPG0g4v5ZbvOVuQV6@mail.gmail.com> <AANLkTikxOQnj=vKD8b0aZqZHNe4m-Y+o+620TBzMJCAW@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 31 Aug 2010 14:08:54 +0800
Message-ID: <AANLkTik3cnE4HQ3hq3wfuxcept4BeTh+zZvNDbZ_b3O7@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: pxa168: fix corrected reset vector
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 2:04 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Tue, Aug 31, 2010 at 2:02 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
>> On Tue, Aug 31, 2010 at 1:48 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
>>> On Thu, Aug 26, 2010 at 5:07 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
>>>> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
>>>> ---
>>>>  arch/arm/mach-mmp/include/mach/system.h |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mach-mmp/include/mach/system.h b/arch/arm/mach-mmp/include/mach/system.h
>>>> index 4f5b0e0..926e9c0 100644
>>>> --- a/arch/arm/mach-mmp/include/mach/system.h
>>>> +++ b/arch/arm/mach-mmp/include/mach/system.h
>>>> @@ -16,6 +16,6 @@ static inline void arch_idle(void)
>>>>
>>>>  static inline void arch_reset(char mode, const char *cmd)
>>>>  {
>>>> -       cpu_reset(0);
>>>> +       cpu_reset(0xffff0000);
>>>
>>> Not sure if this correct. But normally reset jump happens after we turn
>>> off the MMU and so on. Ain't the BootROM starts from 0 ?
>>>
>>>>  }
>>>>  #endif /* __ASM_MACH_SYSTEM_H */
>>>> --
>>>> 1.7.0.4
>>>>
>>>>
>>>
>>
>> Eric, the boot-rom for pxa168 starts at 0xffff_0000. I am pretty sure
>> about that! If you set the reset vector to 0x0 it will crash during
>> reboot. I will send you xdb snapshots if you need me to.
>>
>
> OK, you are expert on this :-)
>
> Applied to 'fix'.
>

One moment. Since this is really global to pxa910 and mmp2, so I
suggest this being fixed for pxa168 only first. How about this:

    ARM: pxa168: fix corrected reset vector

    Reset vector for pxa168 is 0xffff_0000 not 0x0. This fix allows
    reboot to work

    Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>

diff --git a/arch/arm/mach-mmp/include/mach/system.h
b/arch/arm/mach-mmp/include/mach/system.h
index 4f5b0e0..1a8a25e 100644
--- a/arch/arm/mach-mmp/include/mach/system.h
+++ b/arch/arm/mach-mmp/include/mach/system.h
@@ -9,6 +9,8 @@
 #ifndef __ASM_MACH_SYSTEM_H
 #define __ASM_MACH_SYSTEM_H

+#include <mach/cputype.h>
+
 static inline void arch_idle(void)
 {
 	cpu_do_idle();
@@ -16,6 +18,9 @@ static inline void arch_idle(void)

 static inline void arch_reset(char mode, const char *cmd)
 {
-	cpu_reset(0);
+	if (cpu_is_pxa168())
+		cpu_reset(0xffff0000);
+	else
+		cpu_reset(0);
 }
 #endif /* __ASM_MACH_SYSTEM_H */
