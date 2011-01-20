Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1ATUcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:32:14 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:41781 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1ATUcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:32:12 -0500
Message-ID: <4D389BC0.8080900@free.fr>
Date: Thu, 20 Jan 2011 21:32:00 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: Valdis.Kletnieks@vt.edu, Ingo Molnar <mingo@elte.hu>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
References: <4CE2F914.9070106@free.fr>	<24422.1290656467@localhost>	<20101126182355.62615dff@mat-laptop>	<20101208221951.GO5750@outflux.net>	<20101211001857.4c5e0794@mat-laptop>	<20101222124019.GG10809@elte.hu>	<34428.1293053719@localhost> <AANLkTin55DXcQnK3NY7y-v8TXj5w-XT2rTJo9p90tj4g@mail.gmail.com>
In-Reply-To: <AANLkTin55DXcQnK3NY7y-v8TXj5w-XT2rTJo9p90tj4g@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050706020502070606060903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050706020502070606060903
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Xiaotian Feng a écrit :
> On Thu, Dec 23, 2010 at 5:35 AM,  <Valdis.Kletnieks@vt.edu> wrote:
>> On Wed, 22 Dec 2010 13:40:19 +0100, Ingo Molnar said:
>>> * mat <castet.matthieu@free.fr> wrote:
>>>
>>>> Le Wed, 8 Dec 2010 14:19:51 -0800,
>>>> Kees Cook <kees.cook@canonical.com> a écrit :
>>>>
>>>>> On Fri, Nov 26, 2010 at 06:23:55PM +0100, mat wrote:
>>>>>> could you try the attached patch ?
>>>>>>
>>>>>> on module load, we sort the __jump_table section. So we should make
>>>>>> it writable.
>>>>>>
>>>>>>
>>>>>> Matthieu
>>>>>> diff --git a/arch/x86/include/asm/jump_label.h
>>>>>> b/arch/x86/include/asm/jump_label.h index f52d42e..574dbc2 100644
>>>>>> --- a/arch/x86/include/asm/jump_label.h
>>>>>> +++ b/arch/x86/include/asm/jump_label.h
>>>>>> @@ -14,7 +14,7 @@
>>>>>>         do
>>>>>> {                                                       \ asm
>>>>>> goto("1:"                                       \
>>>>>> JUMP_LABEL_INITIAL_NOP                  \
>>>>>> -                       ".pushsection __jump_table,  \"a\" \n\t"\
>>>>>> +                       ".pushsection __jump_table,  \"aw\" \n\t"\
>>>>>>                         _ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
>>>>>>                         ".popsection \n\t"                      \
>>>>>>                         : :  "i" (key) :  : label);
>>>>>> \
>>>>> Acked-by: Kees Cook <kees.cook@canonical.com>
>>>>>
>>>>> Can this please get committed to tip?
>>>> I think it is not need anymore with  Steven Rostedt patch [1]
>>>>
>>>> Matthieu
>>>>
>>>> [1]
>>>>>> Here we set the text read only before we call the notifiers. The
>>>>>> function tracer changes the calls to mcount into nops via a notifier
>>>>>> call so this must be done after the module notifiers.
>>> What's the status of this bug?
>>>
>>> If we still need the patch then please submit it standalone with a proper subject
>>> line, with acks/signoffs added, etc.
>> Steve Rostedt's patch that moves the setting of the page permissions seems to
>> make this patch no longer necessary.  I tripped over this same issue, but the
>> version in the latest -mmotm does not need it, as it includes Steve's fix.
>>
> 
> I'm facing a boot failure (panic'ed on remove_jump_label_module_init)
> on 2.6.37 (latest commit 3c0cb7c), which is 100% reproducible.
> With this patch applied, I can boot my machine successfully, so I do
> think this patch is needed.
> 
Could you confirm that this patch fix the problem ?


Matthieu

--------------050706020502070606060903
Content-Type: text/x-diff;
 name="0001-Fix-jump-table-in-module-init-section.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Fix-jump-table-in-module-init-section.patch"

>From 0eeba453aaba0ebff86f0a7ad9bfb8afbde0c0dc Mon Sep 17 00:00:00 2001
From: Matthieu CASTET <castet.matthieu@free.fr>
Date: Thu, 20 Jan 2011 21:25:03 +0100
Subject: [PATCH] Fix jump table in module init section

If we use jump table in module init, there are marked
as removed in __jump_table section after init is done.

But we already applied ro permissions on the module, so
we can't modify a read only section (crash in
remove_jump_label_module_init).

Make the __jump_table section rw.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
---
 arch/x86/include/asm/jump_label.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index f52d42e..574dbc2 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -14,7 +14,7 @@
 	do {							\
 		asm goto("1:"					\
 			JUMP_LABEL_INITIAL_NOP			\
-			".pushsection __jump_table,  \"a\" \n\t"\
+			".pushsection __jump_table,  \"aw\" \n\t"\
 			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
 			".popsection \n\t"			\
 			: :  "i" (key) :  : label);		\
-- 
1.7.2.3


--------------050706020502070606060903--
