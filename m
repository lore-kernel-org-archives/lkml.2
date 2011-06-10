Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab1FJTcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 15:32:22 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44572 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJTcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 15:32:20 -0400
Date: Fri, 10 Jun 2011 21:31:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: lm-sensors@lm-sensors.org, Michal Marek <mmarek@suse.cz>,
        pefoley2@verizon.net, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [lm-sensors] [GIT] kbuild fixes for 3.0
Message-ID: <20110610213121.7aa12662@endymion.delvare>
In-Reply-To: <BANLkTinA2S55fn5nNb1WOo=T0dKX3cBzfQ@mail.gmail.com>
References: <20110609214241.GA4849@sepie.suse.cz>
	<BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
	<BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com>
	<BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
	<BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com>
	<BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
	<BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com>
	<BANLkTinA2S55fn5nNb1WOo=T0dKX3cBzfQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salut Arnaud,

On Fri, 10 Jun 2011 12:30:59 -0400, Arnaud Lacombe wrote:
> On Fri, Jun 10, 2011 at 1:16 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > I totally agree! But, it is a technical challenge to give a 2 digit
> > version number to an application expecting a 3 digit version number
> > without much control over its environment.
> >
> > Beside that, no matter what, you are about to break
> > `/usr/sbin/sensors-detect' (from my Fedora 14), which rely on a 3
> > digits version number:
> >
> > # [0] -> VERSION
> > # [1] -> PATCHLEVEL
> > # [2] -> SUBLEVEL
> > # [3] -> EXTRAVERSION
> > #
> > use vars qw(@kernel_version $kernel_arch);
> >
> > sub initialize_kernel_version
> > {
> >        `uname -r` =~ /(\d+)\.(\d+)\.(\d+)(.*)/;
> >        @kernel_version = ($1, $2, $3, $4);
> >        chomp($kernel_arch = `uname -m`);
> >
> >        # We only support kernels >= 2.6.5
> >        if (!kernel_version_at_least(2, 6, 5)) {
> >                print "Kernel version is unsupported (too old, >=
> > 2.6.5 needed)\n";
> >                exit -1;
> >        }
> > }
> >
> `sensors-detect's kernel version detection regexp is unable to parse 2
> digits kernel version number and dies with:
> 
> [From Fedora 14's /usr/sbin/sensors-detect]
> 
> Use of uninitialized value $kernel_version[0] in numeric gt (>) at
> ./sensors-detect line 2442.
> Use of uninitialized value $kernel_version[0] in numeric eq (==) at
> ./sensors-detect line 2442.
> Kernel version is unsupported (too old, >= 2.6.5 needed)
> 
> I just checked the SVN repository, the issue still seems to be
> present. I am not sure if other lm-sensors part are affected. This
> will becomes an issue with the upcoming 3.x kernel serie.

Does the following patch help?

Index: prog/detect/sensors-detect
===================================================================
--- prog/detect/sensors-detect	(révision 5979)
+++ prog/detect/sensors-detect	(copie de travail)
@@ -2462,8 +2462,8 @@
 
 sub initialize_kernel_version
 {
-	`uname -r` =~ /(\d+)\.(\d+)\.(\d+)(.*)/;
-	@kernel_version = ($1, $2, $3, $4);
+	`uname -r` =~ /(\d+)\.(\d+)(?:\.(\d+))?(.*)/;
+	@kernel_version = ($1, $2, $3 || 0, $4);
 	chomp($kernel_arch = `uname -m`);
 
 	# We only support kernels >= 2.6.5

I don't expect any other breakage in lm-sensors, but I certainly do in
other packages. For example the function above exists in script
i2c-stub-from-dump in package i2c-tools too.

Honestly, this whole 2-digit kernel version seems like a major and
better avoided pain. The first stable series kernel for 3.0 will be
3.0.1, so it will have 3 digits again. Which means that in practice,
most distributions and users will still be running kernels with 3-digit
versions. Breaking dozens of scripts for what will end up being a mere
corner case seems silly to me. We all have better things to do than to
fix random user-space scripts, don't we?

I fail to see how numbering the next kernel "3.0" will make it any
cooler than numbering it "3.0.0". Especially when nobody will run it
for longer than 2 weeks.

-- 
Jean Delvare
