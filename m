Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab0GMQxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:53:51 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:53043 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0GMQxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:53:50 -0400
Date: Tue, 13 Jul 2010 18:53:48 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Avi Kivity <avi@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization
	point for pvclock
Message-ID: <20100713165348.GD15122@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Glauber Costa <glommer@redhat.com>,
	Zachary Amsden <zamsden@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org> <4C359D5A.1050906@redhat.com> <20100713102350.GW15122@anguilla.noreply.org> <4C3C68C8.4060409@redhat.com> <20100713141902.GB15122@anguilla.noreply.org> <4C3C8CE5.1080705@redhat.com> <20100713162207.GC15122@anguilla.noreply.org> <4C3C9589.4090602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4C3C9589.4090602@redhat.com>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Avi Kivity wrote:

>> The same:
>>
>> [git|v2.6.32.16] weasel@thelma:/scratch/kernel/2.6.32.16$ nm arch/x86/kernel/pvclock.o
>> 0000000000000000 r last_value
>>                   U native_read_tsc
>> 0000000000000040 T pvclock_clocksource_read
>> 0000000000000100 T pvclock_read_wallclock
>> 0000000000000000 T pvclock_tsc_khz
>>                   U set_normalized_timespec
>>    
>
> But it's
>
>>
>> static atomic64_t last_value = ATOMIC64_INIT(0);
>>
>
> Doesn't make any sense.
>
> Let's try to see if the toolchain is confused:
>
> - rename last_value to some random name

0000000000000000 r some_random_name

> - drop the 'static' qualifier

0000000000000000 B last_value

> - drop the '= ATOMIC64_INIT(0)'

0000000000000000 b last_value

> - all of the above

0000000000000000 B some_random_name




make -f scripts/Makefile.build obj=arch/x86/kernel arch/x86/kernel/pvclock.o
  gcc -Wp,-MD,arch/x86/kernel/.pvclock.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.3.2/include -Iinclude  -I/scratch/kernel/2.6.32.16/arch/x86/include -include include/linux/autoconf.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -m64 -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(pvclock)"  -D"KBUILD_MODNAME=KBUILD_STR(pvclock)"  -c -o arch/x86/kernel/pvclock.o arch/x86/kernel/pvclock.c

[git|v2.6.32.16] weasel@thelma:/scratch/kernel/2.6.32.16$ gcc --version
gcc (Debian 4.3.2-1.1) 4.3.2
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Using -O0 also results in a writeable last_value (b).

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
