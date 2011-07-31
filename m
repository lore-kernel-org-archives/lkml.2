Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1GaTkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 15:40:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54289 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab1GaTkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 15:40:14 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MXeUiiQPc4t9bT7KuXuAjkN+t8eFn9SYOouPg-3hDgjWQ@mail.gmail.com>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<20110530072300.GA9802@elte.hu>
	<1306745835.2029.389.camel@i7.infradead.org>
	<20110530104231.GF17821@elte.hu>
	<20110530104656.GA19532@elte.hu>
	<E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	<20110530105809.GA20133@elte.hu>
	<1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	<alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	<20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	<alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	<1306795186.2029.459.camel@i7.infradead.org>
	<BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com>
	<1306856937.27477.3.camel@i7.infradead.org>
	<BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com>
	<4E0495F4.7080300@suse.cz>
	<1311986969.20983.52.camel@i7.infradead.org>
	<CACqU3MXeUiiQPc4t9bT7KuXuAjkN+t8eFn9SYOouPg-3hDgjWQ@mail.gmail.com>
Date: Sun, 31 Jul 2011 15:40:13 -0400
Message-ID: <CACqU3MVbFonB+qFyLNj2bKU9KLFx-buk7uv=cA_NGfL+4tP9uA@mail.gmail.com>
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid overriding CONFIG_64BIT
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 30, 2011 at 11:52 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Fri, Jul 29, 2011 at 8:49 PM, David Woodhouse <dwmw2@infradead.org> wrote:
>> I *frequently* waste a bunch of time when I take a 32-bit .config from a
>> test machine and try to build it on a faster 64-bit system, and its
>> existing setting of CONFIG_64BIT=n gets *changed* to match the build host.
>>
>> This is because the default setting for $ARCH when discovered from
>> 'uname' is one of the legacy pre-x86-merge values (i386 or x86_64),
>> which effectively force the setting of CONFIG_64BIT to match. We should
>> default to ARCH=x86 instead, finally completing the merge that we
>> started so long ago.
>>
>> This patch preserves the behaviour of the legacy ARCH settings for commands
>> such as:
>>
>>   make ARCH=x86_64 randconfig
>>   make ARCH=i386 randconfig
>>
>> ... although since my commit "Enable 'make CONFIG_FOO=y oldconfig'" those
>> would be better expressed as:
>>
>>   make CONFIG_64BIT=y randconfig
>>   make CONFIG_64BIT=n randconfig
>>
>> ... since that is a more generic way to set *any* config option, and
>> there's no other technical reason to keep the legacy ARCH values around
>> any more just to achieve that purpose; they could be removed at any
>> time.
>>
>> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>> Link: http://lkml.kernel.org/r/1306707270.2029.377.camel@i7.infradead.org
>> ---
>> v2: Explicitly turn off CONFIG_64BIT in i386_defconfig. The default for
>>    CONFIG_64BIT has *changed* (from n to y) for ARCH=x86, so it needs to
>>    be explicitly turned off or 'make i386_defconfig' will give you 64-bit.
>> v3: Same patch as before; just updated changelog.
>>
>>  Makefile                        |    3 ++-
>>  arch/x86/Kconfig                |    2 +-
>>  arch/x86/Makefile               |    4 ++++
>>  arch/x86/configs/i386_defconfig |    1 +
>>  4 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index d018956..303df9b 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -165,7 +165,8 @@ export srctree objtree VPATH
>>  # then ARCH is assigned, getting whatever value it gets normally, and
>>  # SUBARCH is subsequently ignored.
>>
>> -SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>> +SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
>> +                                 -e s/sun4u/sparc64/ \
>>                                  -e s/arm.*/arm/ -e s/sa110/arm/ \
>>                                  -e s/s390x/s390/ -e s/parisc64/parisc/ \
>>                                  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
> this is breaking ARCH=um.
>
FWIW, you are still breaking `scripts/checkstack.pl',
`scripts/tags.sh' (all UML related) and this change will lead users of
ARCH=i386 to trigger the cross-compile mode of modpost introduced in
4ce6efed48d736e3384c39ff87bda723e1f8e041.

 - Arnaud
