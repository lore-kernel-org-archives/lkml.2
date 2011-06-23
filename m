Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1FWFDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 01:03:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51290 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1FWFDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 01:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=GSJMpNhnyBT1tbjU4DFroZ3sbMdzwM8vGobzy6CzvT+wCrSsHECtlgayveBQgGo+SS
         HTPmsuUmVsSH8hf/Wx02qs9Dky61gB0i9c7C7Iy5w8zqEM+0LAMiTpCEiLgcBx8wW2E0
         2SeO/w6QQd4kbauPD/JV4+YtZ1qEWbdEFjF6M=
MIME-Version: 1.0
In-Reply-To: <20110622164502.b5b19e6d.rdunlap@xenotime.net>
References: <BANLkTi=H17HC29bCTncSbXXm+RjwOCP49g@mail.gmail.com>
	<BANLkTikyjzQ-VZMn2_ZobEmHMLRafki9YQ@mail.gmail.com>
	<20110622132114.GA8656@dumpdata.com>
	<BANLkTi=v7i04JhXRaf18_=nXKSgwHMDJjg@mail.gmail.com>
	<BANLkTi=DagQzcXQnHsVWjR0SeDDPnizVfQ@mail.gmail.com>
	<20110622164502.b5b19e6d.rdunlap@xenotime.net>
Date: Wed, 22 Jun 2011 22:03:12 -0700
Message-ID: <BANLkTimHCQYE+YGKZzQbOMF__FN+7a_PFQ@mail.gmail.com>
Subject: Re: code sections beyond .text skipped from alternatives_smp_module_add
From: Deep Debroy <ddebroy@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kraxel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 4:45 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 22 Jun 2011 14:58:12 -0700 Deep Debroy wrote:
>
>> On Wed, Jun 22, 2011 at 10:27 AM, Deep Debroy <ddebroy@gmail.com> wrote:
>> > On Wed, Jun 22, 2011 at 6:21 AM, Konrad Rzeszutek Wilk
>> > <konrad.wilk@oracle.com> wrote:
>> >>> > Looking at the code, in module_finalize for x86, only .text seems to
>> >>> > be getting picked for the patching of lock prefixes while other
>> >>> > sections such as .exit.text or .init.text are not. Is there a reason
>> >>> > we skip the other *.text code sections from the lock patches? Would
>> >>> + Gerd Hoffmann who introduced the SMP patching code below back in Jan
>> >>> 2006 as part of 2.6.15.
>> >>
>> >> Whoa, long time ago.
>> >>
>> >>>
>> >>> Any comments on why patching of smp_lock prefixes should be restricted
>> >>> to .text and not other *.text code sections?
>> >>
>> >> It could be that at that time the .exit.text or .init.text did not exist.
>> >>
>> >> As in, the patching code just hasn't kept up. One way of checking that
>> >> is just finding the ancient 2.6.15 code and seeing if there is any
>> >> mention of those extra segments.
>> >>
>> >
>> > Thanks Konrad. One slight correction: after rechecking the kernel
>> > sources, it appears the smp lock prefix code first made it's
>> > appearance in the official trees during 2.6.18. In any case, going
>> > back even to 2.6.16 sources, layout_sections in module.c specially
>> > handled .init prefixed sections from the rest i.e. core sections.
>> > Further, the module struct in include/module/linux.h seems to have had
>> > members such as init_text_size which suggests atleast .init.text did
>> > exit back then as well. While I didn't find any crumbs in the code
>> > that point to the existence of a .exit.text (besides a function
>> > pointer called exit which most likely ended up in the .exit.text), the
>> > ELF headers for Centos 5.6 kernel objects (which uses the 2.6.18
>> > kernel) typically have a .exit.text.
>> >
>> >> Do you have a patch to fix this?
>> >>
>> >
>> > I can work on that. Just wanted to first make sure that there wasn't
>> > any specific reason to avoid patching non .text sections.
>> >
>> > Thanks,
>> > Deep
>> >
>>
>> Some further digging through messages revealed a patch from Randy
>> Dunlap in June 2006: "[PATCH] ignore smp_locks section warnings from
>> init/exit code." Given this patch came in after the smp locking
>> hotpatching mechanism was introduced, there may have been an
>> assumption that instructions that results in entries in smp_locks
>> relocations in the object file should not exist in the init/exit.text
>> sections.
>
> I don't quite see how this patch (below) would affect your problem
> description...
>

I didn't fully understand what the patch addressed. Initially I
thought if a ko had lock prefixed instructions in .init/.exit, it
would lead to entries in .smp_locks section but modpost would report
warnings in that situation. Since there would be these warnings, I
thought a module author would avoid lock prefixed instructions in
.init/.exit prior to the below patch. Sounds like that is not the
case?

>
> commit 35899c57516be6eaa42cc27151767c52d75b2979
> Author: Randy Dunlap <rdunlap@xenotime.net>
> Date:   Wed Jun 7 16:23:26 2006 -0700
>
>    kbuild: ignore smp_locks section warnings from init/exit code
>
>    Add ".smp_locks" section to whitelist as being safe from
>    init and exit sections.
>
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index d0f86ed..94047bc 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -821,6 +821,7 @@ static int init_section_ref_ok(const char *name)
>                ".pci_fixup_final",
>                ".pdr",
>                "__param",
> +               ".smp_locks",
>                NULL
>        };
>        /* Start of section names */
> @@ -892,6 +893,7 @@ static int exit_section_ref_ok(const char *name)
>                ".exitcall.exit",
>                ".eh_frame",
>                ".stab",
> +               ".smp_locks",
>                NULL
>        };
>        /* Start of section names */
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
