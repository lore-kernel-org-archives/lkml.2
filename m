Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1GaUYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 16:24:50 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43837 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1GaUYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 16:24:44 -0400
MIME-Version: 1.0
In-Reply-To: <1312142430.12369.21.camel@i7.infradead.org>
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
	<CACqU3MVbFonB+qFyLNj2bKU9KLFx-buk7uv=cA_NGfL+4tP9uA@mail.gmail.com>
	<1312142430.12369.21.camel@i7.infradead.org>
Date: Sun, 31 Jul 2011 16:24:43 -0400
Message-ID: <CACqU3MVTF6HWk=xw4V6Zu_4wrEJnLJs9bd1NJK675Ly=6w4ibg@mail.gmail.com>
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid overriding CONFIG_64BIT
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 31, 2011 at 4:00 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sun, 2011-07-31 at 15:40 -0400, Arnaud Lacombe wrote:
>> FWIW, you are still breaking `scripts/checkstack.pl',
>> `scripts/tags.sh' (all UML related)
>
> Can you explain the nature of the breakage? It's probably also easy to
> fix (or was already arguably broken), but it would be helpful if you'd
> point at what you think is wrong rather than making me guess.
>
scripts/tags.sh:
[...]
# Support um (which uses SUBARCH)
if [ "${ARCH}" = "um" ]; then
        if [ "$SUBARCH" = "i386" ]; then
                archinclude=x86
        elif [ "$SUBARCH" = "x86_64" ]; then
                archinclude=x86
        else
                archinclude=${SUBARCH}
        fi
fi

So this one is not broken, but the conditionals are deadcode. I wonder
if it should not just use ${SRCARCH}.

Makefile:
ifeq ($(ARCH), um)
CHECKSTACK_ARCH := $(SUBARCH)
else
CHECKSTACK_ARCH := $(ARCH)
endif
checkstack:
        $(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
        $(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)

scripts/checkstack.pl:
my (@stack, $re, $dre, $x, $xs);
{
        my $arch = shift;
        if ($arch eq "") {
                $arch = `uname -m`;
                chomp($arch);
        }
[...]
        } elsif ($arch eq 'x86_64') {
                #    2f60:      48 81 ec e8 05 00 00    sub    $0x5e8,%rsp
                $re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%rsp$/o;
                $dre = qr/^.*[as][du][db]    (\%.*),\%rsp$/o;

this one actually is broken:

% perl scripts/checkstack.pl x86
wrong or unknown architecture "x86"

 - Arnaud
