Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1FJFQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 01:16:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1FJFQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 01:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=onEyYN14rBRttaIm227P6ZH6fXcB6ffeEB3U5e1xfvh0r8i1dzkDqvoakVcNZb0HZU
         X306pua3xuB4JW2LjQQz1ccg5UOWmwezDZWpurYH7t5DJqf2mMIZAVgT6kOfzcGOeqe6
         AjE8us9fi49jEQvlUe1b52weFz/q/PniVGxOo=
MIME-Version: 1.0
In-Reply-To: <BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
References: <20110609214241.GA4849@sepie.suse.cz>
	<BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
	<BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com>
	<BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
	<BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com>
	<BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
Date: Fri, 10 Jun 2011 01:16:13 -0400
Message-ID: <BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes for 3.0
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 9, 2011 at 11:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jun 9, 2011 at 8:45 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>
>> For the record, this should have been fixed by Michal in:
>
> You're missing the problem: we can't assume that people have updated user land.
>
I absolutely agree with you. But I am not the one about to decide to
break a 15 years old interface :) [I gave me a 5 year delta as I have
no idea how the version number was at that time; moreover, do not get
me wrong, I do not really care about the kernel version being 2 or 3
digits.].

> Furthermore, the very pull request I'm responding to actually tries to
> handle this, see commit bfe5424a8b31 ("kbuild: Hack for depmod not
> handling X.Y versions"), but it's just not working for me.
>
> And it's not working, because it only handles the "modules_install"
> case, not the case where the system install scripts do their own
> depmod.
>
I totally agree! But, it is a technical challenge to give a 2 digit
version number to an application expecting a 3 digit version number
without much control over its environment.

Beside that, no matter what, you are about to break
`/usr/sbin/sensors-detect' (from my Fedora 14), which rely on a 3
digits version number:

# [0] -> VERSION
# [1] -> PATCHLEVEL
# [2] -> SUBLEVEL
# [3] -> EXTRAVERSION
#
use vars qw(@kernel_version $kernel_arch);

sub initialize_kernel_version
{
        `uname -r` =~ /(\d+)\.(\d+)\.(\d+)(.*)/;
        @kernel_version = ($1, $2, $3, $4);
        chomp($kernel_arch = `uname -m`);

        # We only support kernels >= 2.6.5
        if (!kernel_version_at_least(2, 6, 5)) {
                print "Kernel version is unsupported (too old, >=
2.6.5 needed)\n";
                exit -1;
        }
}

sub kernel_version_at_least
{
        my ($vers, $plvl, $slvl) = @_;
        return 1 if ($kernel_version[0] > $vers ||
                     ($kernel_version[0] == $vers &&
                      ($kernel_version[1] > $plvl ||
                       ($kernel_version[1] == $plvl &&
                        ($kernel_version[2] >= $slvl)))));
        return 0;
}

would fail with:

Kernel version is unsupported (too old, >= 2.6.5 needed)

with "uname -r" being "3.0-rc2"

 - Arnaud
