Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab2EPMo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:44:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44735 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab2EPMoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:44:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120516061416.GB18058@lizard>
References: <20120512001506.GA8653@lizard>
	<20120512001840.GJ14782@lizard>
	<CAGXu5j+BPHPCnJ+ont8CGuUjjEYB_d6K-YtVJgNA7uwkpbfDoQ@mail.gmail.com>
	<20120516061416.GB18058@lizard>
Date: Wed, 16 May 2012 05:44:23 -0700
X-Google-Sender-Auth: Ewy9r3MbWun-xcyHp2xa50hp_kA
Message-ID: <CAGXu5jLtEk_64NoED1XrwtMuoNYUddAxryVT5XQ2nmj-GM1voQ@mail.gmail.com>
Subject: Re: [PATCH 10/11] pstore/ram: Switch to persistent_ram routines
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 11:14 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Hello Kees,
>
> On Mon, May 14, 2012 at 03:21:17PM -0700, Kees Cook wrote:
> [...]
>> > -       buf = cxt->virt_addr + (id * cxt->record_size);
>> > -       memset(buf, '\0', cxt->record_size);
>> > +       persistent_ram_free_old(cxt->przs[id]);
>>
>> Hm, I don't think persistent_ram_free_old() is what's wanted here.
>> That appears to entirely release the region? I want to make sure the
>> memory is cleared first. And will this area come back on a write, or
>> does it stay released?
>
> It just releases ECC-restored memory region (a copy). The original
> (persistent) region is still fully reusable after that call.

Ah-ha, okay. So this still needs to clear the memory in the "real"
copy then. Thanks for the clarification.

>> > +       }
>> > +
>> > +       for (i = 0; i < cxt->max_count; i++) {
>> > +               size_t sz = cxt->record_size;
>> > +               phys_addr_t start = cxt->phys_addr + sz * i;
>> > +
>> > +               cxt->przs[i] = persistent_ram_new(start, sz, 0);
>>
>> persistent_ram_new() is marked as __init, so this is unsafe to call if
>> built as a module. I think persistent_ram_new() will need to lose the
>> __init marking, or I'm misunderstanding something.
>
> Um. ramoops' probe routine is also __init. persistent_ram_new is a
> part of ramoops module, so their __init functions will be discarded
> at the same time.
>
> ram_console can't be a module, so it is also fine.
>
> So I think it's all fine.

This is what I get for staring at patches instead of applying them. :)
Yeah, if it's all built together, it's no problem. It looked to me
like they were in different modules.

>> > +fail_przs:
>> > +       for (i = 0; cxt->przs[i]; i++)
>> > +               persistent_ram_free(cxt->przs[i]);
>>
>> This can lead to a BUG, since persistent_ram_free() doesn't handle
>> NULL arguments.
>
> The for loop has 'cxt->przs[i]' condition. :-)

Okay, fair enough. :)

> Thanks for the review!

Sure thing! Thanks for doing this work; I'm excited to have access in
ramoops to the new interfaces. :)

-Kees

-- 
Kees Cook
Chrome OS Security
