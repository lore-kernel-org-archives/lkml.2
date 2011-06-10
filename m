Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1FJQbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:31:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45317 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab1FJQa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:30:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mZqbJL6qj14OFyTduHEdBVmkCAf2+gw3ZlAj1V/42maDnh094uh0+VjDprVX7J5/Qx
         Oip+dOEdeetyCA9ZGzQbLeWo8A5zrqmhJOy3/+KasxiSEkhfrEUCpKQUUyaRr+uR2ZkO
         VG1hBVj3v/m5DfPWAltRh/iYQ+qQ8sFLnYX7w=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com>
References: <20110609214241.GA4849@sepie.suse.cz>
	<BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
	<BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com>
	<BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
	<BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com>
	<BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
	<BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com>
Date: Fri, 10 Jun 2011 12:30:59 -0400
Message-ID: <BANLkTinA2S55fn5nNb1WOo=T0dKX3cBzfQ@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes for 3.0
From: Arnaud Lacombe <lacombar@gmail.com>
To: lm-sensors@lm-sensors.org
Cc: Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[following-up to lm-sensors@lm-sensors.org for bug-report.]

On Fri, Jun 10, 2011 at 1:16 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Thu, Jun 9, 2011 at 11:57 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Jun 9, 2011 at 8:45 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>>
>>> For the record, this should have been fixed by Michal in:
>>
>> You're missing the problem: we can't assume that people have updated user land.
>>
> I absolutely agree with you. But I am not the one about to decide to
> break a 15 years old interface :) [I gave me a 5 year delta as I have
> no idea how the version number was at that time; moreover, do not get
> me wrong, I do not really care about the kernel version being 2 or 3
> digits.].
>
>> Furthermore, the very pull request I'm responding to actually tries to
>> handle this, see commit bfe5424a8b31 ("kbuild: Hack for depmod not
>> handling X.Y versions"), but it's just not working for me.
>>
>> And it's not working, because it only handles the "modules_install"
>> case, not the case where the system install scripts do their own
>> depmod.
>>
> I totally agree! But, it is a technical challenge to give a 2 digit
> version number to an application expecting a 3 digit version number
> without much control over its environment.
>
> Beside that, no matter what, you are about to break
> `/usr/sbin/sensors-detect' (from my Fedora 14), which rely on a 3
> digits version number:
>
> # [0] -> VERSION
> # [1] -> PATCHLEVEL
> # [2] -> SUBLEVEL
> # [3] -> EXTRAVERSION
> #
> use vars qw(@kernel_version $kernel_arch);
>
> sub initialize_kernel_version
> {
>        `uname -r` =~ /(\d+)\.(\d+)\.(\d+)(.*)/;
>        @kernel_version = ($1, $2, $3, $4);
>        chomp($kernel_arch = `uname -m`);
>
>        # We only support kernels >= 2.6.5
>        if (!kernel_version_at_least(2, 6, 5)) {
>                print "Kernel version is unsupported (too old, >=
> 2.6.5 needed)\n";
>                exit -1;
>        }
> }
>
`sensors-detect's kernel version detection regexp is unable to parse 2
digits kernel version number and dies with:

[From Fedora 14's /usr/sbin/sensors-detect]

Use of uninitialized value $kernel_version[0] in numeric gt (>) at
./sensors-detect line 2442.
Use of uninitialized value $kernel_version[0] in numeric eq (==) at
./sensors-detect line 2442.
Kernel version is unsupported (too old, >= 2.6.5 needed)

I just checked the SVN repository, the issue still seems to be
present. I am not sure if other lm-sensors part are affected. This
will becomes an issue with the upcoming 3.x kernel serie.

Regards,
 - Arnaud

> sub kernel_version_at_least
> {
>        my ($vers, $plvl, $slvl) = @_;
>        return 1 if ($kernel_version[0] > $vers ||
>                     ($kernel_version[0] == $vers &&
>                      ($kernel_version[1] > $plvl ||
>                       ($kernel_version[1] == $plvl &&
>                        ($kernel_version[2] >= $slvl)))));
>        return 0;
> }
>
> would fail with:
>
> Kernel version is unsupported (too old, >= 2.6.5 needed)
>
> with "uname -r" being "3.0-rc2"
>
>  - Arnaud
>
