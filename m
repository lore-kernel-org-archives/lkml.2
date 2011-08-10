Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1HJOQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:16:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54899 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1HJOP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:15:57 -0400
MIME-Version: 1.0
In-Reply-To: <1312981658.2989.39.camel@i7.infradead.org>
References: <1312067499.22074.59.camel@i7.infradead.org>
	<1312067670.22074.61.camel@i7.infradead.org>
	<CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	<4E34998D.8060806@zytor.com>
	<CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	<4E4140B3.7090802@suse.cz>
	<CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
	<4E4280BA.9050109@suse.cz>
	<1312981658.2989.39.camel@i7.infradead.org>
Date: Wed, 10 Aug 2011 10:15:55 -0400
Message-ID: <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 10, 2011 at 9:07 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2011-08-10 at 14:59 +0200, Michal Marek wrote:
>> I wasn't talking about the env= syntax, but about
>>
>> make CONFIG_EXT2_FS=m all
>> which makes kbuild visit fs/ext2 even if CONFIG_EXT2_FS is disabled in
>> .config. With no update of the configuration or checking the dependencies.
>>
>> Hm, actually this would be a problem even if kconfig does read the
>> CONFIG_* variables from the environment, because it could result in a
>> mismatch if kconfig determines that the variable cannot be set, but make
>> still sees it in the environment. So we would have to use 'undefine
>> CONFIG_FOO' instead of '# CONFIG_FOO is not set' in
>> include/config/auto.conf, to be able to properly support make CONFIG_FOO=y.
>
> That's always been true; it's *always* been broken like that.
>
> But now we're actually *encouraging* people to start setting
> CONFIG_FOO=y in the environment or the make command line, so we should
> certainly make it more robust.
>
who is "we" ?

> It should be simple enough to force a reconfig if CONFIG_* is specified
> in the environment.
>
which is broken, the complete kernel Kconfig tree and all
inter-dependency cannot be fully understood, especially by
non-developer. So what you ask for is either not doing what the user
wants, but respecting dependency, or doing what the user want, but not
respecting dependency, and by the same, creating illegal
configuration.

> Actually, while we're at it let's stop just picking it up from the
> environment and pick it up *only* if it's overridden in the make flags.
>
again, who's "we" ?

> Something like this will list the variables which are overridden on the
> command line:
>
> CONFIG_OVERRIDES := $(patsubst line:%,%,$(filter line:%,$(foreach var, $(filter CONFIG_%,$(.VARIABLES)), $(origin $(var)):$(var))))
>
> Then we can make auto.conf.cmd trigger a reconfig if it's non-empty, and
> make the kconfig tool allow overrides *only* for those variables
> specified in $CONFIG_OVERRIDES... which avoids any worries about "stray"
> environment variables too.
>
> I'll see if I can clean the above expression up and do that.
>
hum, let's take a real life example: user foo wants his config to
enable CONFIG_WIRELESS_EXT, so with what you propose, he would do:

# make CONFIG_WIRELESS_EXT=y allmodconfig

currently, this would _never_ work, unless one of the symbol selected
by `allmodconfig' selects it, as WIRELESS_EXT is defined the
following:

config WIRELESS_EXT
    bool

I suspect there also an implicit dependency to WIRELESS.

Now, you cannot just force WIRELESS_EXT to 'y', as there would be room
for illegal configuration, or it might just never be built. Moreover,
even if you did that, you would not just have to toggle the value, but
to act as the 'select' do, ie. create a reverse dependency. If that
was working, I would expect that you could do the opposite, that is:

# make CONFIG_WIRELESS_EXT=n allyesconfig

but again, behind implementation details, that might create an illegal
configuration. There is a reason wireless chip select that symbol,
that reason is only known by the wireless folks, so I do not see why
the user should be allowed to go against. That said, if you want to
hack around that, just edit net/wireless/Kconfig, that will be faster
than trying to understand the whole thing.

Btw, warning about potential missing dependencies are useless[0],
user, even kernel hacker do _not_ read them. We spent a few day
tracking down a build failure on powerpc triggered because SND_ISA was
selected without ISA_DMA_API, a warning was present, but nobody cared
about it.

 - Arnaud

> --
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
>
>
