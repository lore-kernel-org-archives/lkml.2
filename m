Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1GMPUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:20:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42332 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab1GMPUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <4E1D9C25.8080300@suse.cz>
References: <1305646532-29114-1-git-send-email-mmarek@suse.cz>
	<20110517195310.GA17003@merkur.ravnborg.org>
	<BANLkTikmO7D3kUgU62d4_VC2ZPZCnSEqKA@mail.gmail.com>
	<4E1D9C25.8080300@suse.cz>
Date: Wed, 13 Jul 2011 11:20:13 -0400
Message-ID: <CACqU3MXWH5mq1ycOoqH=1A_87Sn3tgOZU2om+0q=ZrEvnmKVrQ@mail.gmail.com>
Subject: Re: [PATCH] kconfig: Only generate config_is_xxx for bool and
 tristate options
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 13, 2011 at 9:22 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 18.5.2011 08:23, Arnaud Lacombe wrote:
>>
>> Hi,
>>
>> [added Valdis.Kletnieks@vt.edu to CC:]
>>
>> On Tue, May 17, 2011 at 3:53 PM, Sam Ravnborg<sam@ravnborg.org>  wrote:
>>>
>>> On Tue, May 17, 2011 at 05:35:32PM +0200, Michal Marek wrote:
>>>>
>>>> For strings and integers, the config_is_xxx macros are useless and
>>>> sometimes misleading:
>>>>
>>>>   #define CONFIG_INITRAMFS_SOURCE ""
>>>>   #define config_is_initramfs_source() 1
>>>
>>> I'm late with this comment....
>>> Could we introduce "config_is_foo" using a syntax that
>>> does not break grepability?
>>>
>>> Maybe a syntax like this?
>>>
>>>    #ifdef CONFIG_FOO
>>>
>>> and
>>>
>>>    if (KCONFIG_FOO())
>>>
>>> Grepping for the use of a symbol is a very typical thing,
>>> so we should try to keep this.
>>> And with the suggested syntax above I expect fixdep to
>>> catch up both usage types.
>>>
>> Actually, there is already an issue, on a much smaller scale, in the
>> current tree with NUMA_BUILD and COMPACTION_BUILD. The real way to fix
>> this would be to always defines CONFIG_FOO, its value being 1 or 0
>> depending on whether or not the symbol is selected. This is a
>> +35k/-35k change.
>>
>> Also, I find KCONFIG_FOO() is too specific to be in the kernel source,
>> and redundant with CONFIG_FOO.
>>
>> I've been playing a bit with the preprocessor, and reached that point:
>>
>> #define EXPAND(x)       __ ## x
>> #define CONFIGURED(x)   \
>>         ({  int __1 __maybe_unused = 1;         \
>>             int __ ## x __maybe_unused = 0;     \
>>             EXPAND(x); })
>>
>> I am not specifically proud of that, use case would be:
>>
>> extern func(void);
>> int fn()
>> {
>>         if(CONFIGURED(CONFIG_FOO))
>>                 func();
>> }
>
> I finally got round to revisit this. Your approach inspired me to a much
> simpler scheme: Instead of generating the config_is_xxx macros for direct
> use in the code, name them __enabled_CONFIG_XXX or similar and have a macro
> that expands given CONFIG_XXX symbol to the other form:
>
> /*
>  * Usage: ENABLED(CONFIG_FOO)
>  * Please do not use the __enabled_CONFIG_FOO defines directly to not break
>  * grepability of the code.
>  */
> #define ENABLED(x) __enabled_ ## x
>
> plus a checkpatch.pl check so that people do not use the
> __enabled_CONFIG_FOO macros in their code. git grep -w CONFIG_FOO continues
> to work, fixdep continues to work, it works with -O0 because it expands to a
> if(1) or if(0). Am I missing some obvious problem?
>
not I see immediately. ENABLED() will conflict with existing keyword
in the tree, so it might need tweaking.

Basically, you are taking the approach of always defining CONFIG_FOO
(to 0 or 1), but by introducing a new macro, you avoid to break #ifdef
usage in the tree.

Actually, with this approach, we can even see forward and start replacing:

#ifdef CONFIG_FOO

by

#if ENABLED(CONFIG_FOO)

In a couple of release, we mark the old #ifdef syntax as deprecated,
then after a couple of release, get rid of the duplicated macro
altogether.

You evil ! :-)

 - Arnaud

> Attached is my test program:
> $ gcc -Wall -O0 test.c
> $ ./a.out
> Foo1.0
> Foo1.1
> $ strings ./a.out | grep Foo
> Foo1.0
> Foo1.1
>
> Michal
>
