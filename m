Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1GaUwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 16:52:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:49291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1GaUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 16:52:43 -0400
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid
 overriding CONFIG_64BIT
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        hpa@zytor.com
Date: Sun, 31 Jul 2011 21:51:34 +0100
In-Reply-To: <CACqU3MVTF6HWk=xw4V6Zu_4wrEJnLJs9bd1NJK675Ly=6w4ibg@mail.gmail.com>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu>
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
	 <4E0495F4.7080300@suse.cz> <1311986969.20983.52.camel@i7.infradead.org>
	 <CACqU3MXeUiiQPc4t9bT7KuXuAjkN+t8eFn9SYOouPg-3hDgjWQ@mail.gmail.com>
	 <CACqU3MVbFonB+qFyLNj2bKU9KLFx-buk7uv=cA_NGfL+4tP9uA@mail.gmail.com>
	 <1312142430.12369.21.camel@i7.infradead.org>
	 <CACqU3MVTF6HWk=xw4V6Zu_4wrEJnLJs9bd1NJK675Ly=6w4ibg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1312145496.18010.13.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 16:24 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Sun, Jul 31, 2011 at 4:00 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> > On Sun, 2011-07-31 at 15:40 -0400, Arnaud Lacombe wrote:
> >> FWIW, you are still breaking `scripts/checkstack.pl',
> >> `scripts/tags.sh' (all UML related)
> >
> > Can you explain the nature of the breakage? It's probably also easy to
> > fix (or was already arguably broken), but it would be helpful if you'd
> > point at what you think is wrong rather than making me guess.
> >
> scripts/tags.sh:
> [...]
> # Support um (which uses SUBARCH)
> if [ "${ARCH}" = "um" ]; then
>         if [ "$SUBARCH" = "i386" ]; then
>                 archinclude=x86
>         elif [ "$SUBARCH" = "x86_64" ]; then
>                 archinclude=x86
>         else
>                 archinclude=${SUBARCH}
>         fi
> fi
> 
> So this one is not broken, but the conditionals are deadcode. I wonder
> if it should not just use ${SRCARCH}.

Ah yes, I'd actually looked at that one yesterday since I saw it
referenced from somewhere in the um code that I was looking at. It's not
*quite* deadcode yet — remember, we're not talking about *removing* the
legacy ARCH=i386 and ARCH=x86_64 yet; just making them no longer the
*default*, and making ARCH=x86 the default instead (when on an x86 box).

There are three phases, which we've been through for the various other
architectures that merged 32 and 64 bit code already:

 1. Make ARCH=x86 work.
 2. Make ARCH=x86 the default.
 3. Remove the legacy ARCH= values.

We *thought* we'd fairly much finished #1 in 2007, with commit
208652d6... but evidently there are a couple of things we still need to
fix. As I said, thanks for helping to find those.

My patch is doing #2, since it seems the best and cleanest way to fix
the bug that keeps biting. It's not only "a" fix; it's the *right* thing
to do.

I'm not touching #3 yet; people are still clinging to the old crap as if
the world will end if they have to type 'make CONFIG_64BIT=n oldconfig'
instead of 'make ARCH=i386 oldconfig', because the extra few characters
will give them RSI and then they'll have to quit their nice computer job
and then they'll have to sell their body to make ends meet. Or something
like that. But I'm making the CONFIG_64BIT=n thing work anyway :)



> Makefile:
> ifeq ($(ARCH), um)
> CHECKSTACK_ARCH := $(SUBARCH)
> else
> CHECKSTACK_ARCH := $(ARCH)
> endif
> checkstack:
>         $(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
>         $(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
> 
> scripts/checkstack.pl:
> my (@stack, $re, $dre, $x, $xs);
> {
>         my $arch = shift;
>         if ($arch eq "") {
>                 $arch = `uname -m`;
>                 chomp($arch);
>         }
> [...]
>         } elsif ($arch eq 'x86_64') {
>                 #    2f60:      48 81 ec e8 05 00 00    sub    $0x5e8,%rsp
>                 $re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%rsp$/o;
>                 $dre = qr/^.*[as][du][db]    (\%.*),\%rsp$/o;
> 
> this one actually is broken:
> 
> % perl scripts/checkstack.pl x86
> wrong or unknown architecture "x86"

OK, I'll go poke at that; it definitely *should* have been working and
could be considered 'broken' since 2007. It's part of phase 1.

This should probably fix it.... I'll test a bit more and send a real
patch. Thanks for pointing it out.

diff --git a/scripts/checkstack.pl b/scripts/checkstack.pl
index 17e3843..2c5c869 100755
--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -59,6 +59,10 @@ my (@stack, $re, $dre, $x, $xs);
 		#    2f60:	48 81 ec e8 05 00 00 	sub    $0x5e8,%rsp
 		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%rsp$/o;
 		$dre = qr/^.*[as][du][db]    (\%.*),\%rsp$/o;
+	} elsif ($arch eq 'x86') {
+		#    2f60:	48 81 ec e8 05 00 00 	sub    $0x5e8,%rsp
+		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%[er]sp$/o;
+		$dre = qr/^.*[as][du][db]    (\%.*),\%[er]sp$/o;
 	} elsif ($arch eq 'ia64') {
 		#e0000000044011fc:       01 0f fc 8c     adds r12=-384,r12
 		$re = qr/.*adds.*r12=-(([0-9]{2}|[3-9])[0-9]{2}),r12/o;


-- 
dwmw2

