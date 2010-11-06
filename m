Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0KFPHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 11:07:55 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43952 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0KFPHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 11:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type:content-transfer-encoding;
        b=JjepFzJDYrERecpsvXU+Npnh+VEUENDbQHG9lDPyqKAVu1f7v3NukyoPCEgaNJpfbs
         njtGlW9SxlpJ2onta3ShDrFEs4hrWp4D3bNmGneQyjZTNKLsCcLgFFd2TGhYzQHFMPy/
         Mt1sbjUGl6Pc18/M+CasbB5TONL6Krna/gNwE=
From: Ben Gamari <bgamari.foss@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Bus error on make allyesconfig, kernelbuild with HEAD
In-Reply-To: <20100730084353.GB5638@cr0.nay.redhat.com>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de> <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com> <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de> <20100730084353.GB5638@cr0.nay.redhat.com>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sat, 06 Nov 2010 11:07:48 -0400
Message-ID: <87d3qicwxn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 16:43:53 +0800, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> This is useful. :) Looks like parse_dep_file() accesses out of
> the mmap'ed memory range...
> 
Did anything ever happen with this? I seem to be experiencing similar
issues while cross-compiling for ARM on x86-64. All tested kernels
(v2.6.35 to master) fail with,

$ make
  HOSTCC  scripts/basic/fixdep
In file included from /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/stdlib.h:903,
                 from scripts/basic/fixdep.c:112:
/usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/stdlib.h:65:  warning: no previous prototype for ‘ptsname_r’
/bin/sh: line 1: 20831 Bus error               scripts/basic/fixdep  scripts/basic/.fixdep.d scripts/basic/fixdep 'gcc  -Wp,-MD,scripts/basic/.fixdep.d -Wall -Wmissing-prototypes  -Wstrict-prototypes -O2 -fomit-frame-pointer     -o  scripts/basic/fixdep scripts/basic/fixdep.c  ' >  scripts/basic/.fixdep.tmp
make[2]: *** [scripts/basic/fixdep] Error 135
make[1]: *** [scripts_basic] Error 2
make: *** No rule to make target `include/config/auto.conf', needed by  `include/config/kernel.release'.  Stop.

This seems to be the result of the same mmap misstep,

$  scripts/basic/fixdep scripts/basic/.fixdep.d scripts/basic/fixdep 'gcc -Wp,-MD,scripts/basic/.fixdep.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer     -o scripts/basic/fixdep scripts/basic/fixdep.c  ' >| scripts/basic/.fixdep.tmp
fixdep: mmap: Cannot allocate memory

Which valgrind reports as,

==20634== Process terminating with default action of signal 7 (SIGBUS)
==20634==  Non-existent physical address at address 0x51B2000
==20634==    at 0x400F30: parse_dep_file (in /home/bgamari/linux/scripts/basic/fixdep)
==20634==    by 0x401285: main (in /home/bgamari/linux/scripts/basic/fixdep)
==20634== 

Any ideas?

- Ben
