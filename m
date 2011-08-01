Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1HAQsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:48:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37987 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab1HAQsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:48:40 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUoxSNmcYsSF4zOTgADdedb7TcciPuBPMviG02M5oUPDQ@mail.gmail.com>
References: <1312042478-26012-1-git-send-email-zdevai@gmail.com>
 <20110801083614.GC15578@n2100.arm.linux.org.uk> <CAMuHMdUpTDSRP_JmWqcCBtYwzna0hwmaBshpiF8kgvqoNcqYZA@mail.gmail.com>
 <20110801101410.GE15578@n2100.arm.linux.org.uk> <CAMuHMdUiLjMVwOqKPF6tHLpPxROrx=rRf3ednfTLrwGuZ2VF7A@mail.gmail.com>
 <CACqU3MVUxTYmD+4VGBAeN8PTs83fR0xQQrQS5h4QGMZXgMxEvA@mail.gmail.com>
 <CAGZ=bqL=VAx5jnSBkE2q5KJSY_+An-VRTRAzJmJ3waQUvrRFFg@mail.gmail.com> <CACqU3MUoxSNmcYsSF4zOTgADdedb7TcciPuBPMviG02M5oUPDQ@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Mon, 1 Aug 2011 12:48:19 -0400
Message-ID: <CAGZ=bqLHjzpKQP63dnSK0fML2ZycmfFnSbiApV4naMCN_UrZdg@mail.gmail.com>
Subject: Re: [PATCH] Remove remaining references of CONFIG_GENERIC_TIME
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Zoltan Devai <zdevai@gmail.com>, linux-kernel@vger.kernel.org,
        chris@zankel.net, linux-am33-list@redhat.com, trivial@kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, cmetcalf@tilera.com,
        linux-arm-kernel@lists.infradead.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 12:08, Arnaud Lacombe <lacombar@gmail.com> wrote:
> On Mon, Aug 1, 2011 at 11:15 AM, Kyle Moffett <kyle@moffetthome.net> wrote:
>> On Mon, Aug 1, 2011 at 11:04, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>> On Mon, Aug 1, 2011 at 7:27 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>> On Mon, Aug 1, 2011 at 12:14, Russell King - ARM Linux
>>>>>>[...]
>>>>>>
>>>>>> Doesn't kconf error out when trying to select a non-existent symbol?
>>>>>
>>>>> Nope.
>>>>
>>>> You're right. So that's a bug.
>>>>
>>> depends on what you are trying to achieve and what the problem is.
>>>
>>> Internally kconfig will create a dummy symbol when it encounter a
>>> missing symbol so that arch/arm/Kconfig can reference a symbol which
>>> will be fully defined later on. I do not think you want to forward
>>> decl all the symbol which can be used. That'd be a mess. That said, we
>>> can come with a form of symbol deprecation that would error-out when
>>> used.
>>
>> Would it be possible instead to make Kconfig go through all the symbols
>> after everything is processed and identify any remaining "dummy symbols"
>> which were not actually declared anywhere?
>>
> this is software, everything is possible.
>
>> Right now if you typo a "select" statement you get no warnings that you
>> are selecting something that does not exist, which is probably a cause
>> of many kinds of errors beyond this particular one.
>>
> d'oh! ... I'm not sure we want that. Dummy symbol are heavily used
> internally, a trivial implementation[0] triggered:
>
> % make REGENERATE_PARSERS=y alldefconfig 2>&1 | grep 'defined without
> type' | wc -l
> 817
>
> Moreover, this approach is deemed to fail. The current symbol
> namespace is tied to an arch, so whenever you do:
>
> arch/arm/Kconfig:
> config FOO
>    bool
>
> config BAZ
>    bool
>
> drivers/cpufreq/Kconfig
> config BAR
>    depends on ARM && FOO
>    select BAZ
>
> You will end up triggering the warning for every ARCH != ARM...

Perhaps that's an argument for building a single Kconfig namespace?
At the very least, most of the architecture-generic warnings could be
worked around with trivial predeclarations in an "arch/Kconfig" file:

config ARM
        bool
[...]
config X86
        bool

There's probably technical issues that I'm missing that would make
that inordinately painful, but I can't see them right now... any ideas?

Cheers,
Kyle Moffett
