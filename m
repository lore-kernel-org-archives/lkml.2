Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1GaRWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 13:22:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44362 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1GaRWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 13:22:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1107311300190.16802@linux>
References: <alpine.LNX.2.00.1107311134490.30666@linux>
	<CACqU3MX7f2oNpDf6W124tfROfKq4PFsyvxiq=VtPJfv-gqUrww@mail.gmail.com>
	<CACqU3MU9BBsXjevz617v7YOBm+9RR1Wm49gi0jvs95yneQ2Yrg@mail.gmail.com>
	<alpine.LNX.2.00.1107311300190.16802@linux>
Date: Sun, 31 Jul 2011 13:22:29 -0400
Message-ID: <CACqU3MVHVMU=KnBXSOWgYip5BydfNj0xQPL6JLgPkeEDS9Rjnw@mail.gmail.com>
Subject: Re: kbuild: prevent make from deleting _shipped files
From: Arnaud Lacombe <lacombar@gmail.com>
To: Peter Foley <pefoley2@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 31, 2011 at 1:08 PM, Peter Foley <pefoley2@verizon.net> wrote:
> On Sun, 31 Jul 2011, Arnaud Lacombe wrote:
>
>> Hi,
>>
>> On Sun, Jul 31, 2011 at 12:21 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> > Hi,
>> >
>> > On Sun, Jul 31, 2011 at 11:37 AM, Peter Foley <pefoley2@verizon.net> wrote:
>> >> commit 7373f4f (kbuild: add implicit rules for parser generation)
>> >> created a implicit rule chain (%.c: %.c_shipped: %.y). This causes make to delete the _shipped files
>> >> because it considers them intermediate files. Mark the _shipped files PRECIOUS
>> >> to prevent make from deleting them.
>> >>
>> >> Signed-off-by: Peter Foley <pefoley2@verizon.net>
>> > What make are you using, and what command triggers the issue ?
>> >
>> > Those rules should only be visible on parser regeneration (ie.
>> > REGENERATE_PARSERS defined). make 3.82 does not seem to trigger the
>> > issue:
>> >
>> > % make -v
>> > GNU Make 3.82
>> >
>> > % make REGENERATE_PARSERS=y defconfig
>> >  HOSTCC  scripts/basic/fixdep
>> >  HOSTCC  scripts/kconfig/conf.o
>> >  SHIPPED scripts/kconfig/zconf.tab.c
>> >  SHIPPED scripts/kconfig/zconf.lex.c
>> >  SHIPPED scripts/kconfig/zconf.hash.c
>> >  HOSTCC  scripts/kconfig/zconf.tab.o
>> >  HOSTLD  scripts/kconfig/conf
>> > *** Default configuration is based on 'x86_64_defconfig'
>> > [...]
>> >
>> > The shipped file are still there:
>> >
>> > % ls scripts/kconfig/*_shipped
>> > scripts/kconfig/zconf.hash.c_shipped
>> > scripts/kconfig/zconf.lex.c_shipped
>> > scripts/kconfig/zconf.tab.c_shipped
>> >
>> a bare make-3.81 from ftp.gnu.org built on a Fedora 14 behave the same.
>>
>> I definitively needs enlightenment on this one :)
>>
>> Thanks,
>>  - Arnaud
>
> The problem only appears when the parsers are actually rebuilt.
> rm scripts/kconfig/*_shipped
> make REGENERATE_PARSERS=1 defconfig
>
>  HOSTCC  scripts/basic/fixdep
>  HOSTCC  scripts/kconfig/conf.o
>  YACC    scripts/kconfig/zconf.tab.c_shipped
>  SHIPPED scripts/kconfig/zconf.tab.c
>  LEX     scripts/kconfig/zconf.lex.c_shipped
>  SHIPPED scripts/kconfig/zconf.lex.c
>  GPERF scripts/kconfig/zconf.hash.c_shipped
>  SHIPPED scripts/kconfig/zconf.hash.c
>  HOSTCC  scripts/kconfig/zconf.tab.o
> scripts/kconfig/zconf.tab.c: In function 'header_print_comment':
> scripts/kconfig/confdata.c:551:10: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result [-Wunused-result]
> scripts/kconfig/zconf.tab.c: In function 'kconfig_print_comment':
> scripts/kconfig/confdata.c:467:10: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result [-Wunused-result]
>  HOSTLD  scripts/kconfig/conf
> *** Default configuration is based on 'x86_64_defconfig'
> #
> # configuration written to .config
> #
> rm scripts/kconfig/zconf.hash.c_shipped scripts/kconfig/zconf.tab.c_shipped scripts/kconfig/zconf.lex.c_shipped
>
What version of make are you using ?

I still can not reproduce with either make-3.81 or make-3.82:

% touch scripts/kconfig/*.[ylg]*
% make-3.81 REGENERATE_PARSERS=y defconfig
  YACC    scripts/kconfig/zconf.tab.c_shipped
  SHIPPED scripts/kconfig/zconf.tab.c
  GPERF scripts/kconfig/zconf.hash.c_shipped
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
*** Default configuration is based on 'x86_64_defconfig'
#
# configuration written to .config
#

% touch scripts/kconfig/*.[ylg]*
% make REGENERATE_PARSERS=y defconfig
  YACC    scripts/kconfig/zconf.tab.c_shipped
  SHIPPED scripts/kconfig/zconf.tab.c
  GPERF scripts/kconfig/zconf.hash.c_shipped
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
*** Default configuration is based on 'x86_64_defconfig'
#
# configuration written to .config
#

Thanks,
 - Arnaud

> Thanks,
>
> Peter
