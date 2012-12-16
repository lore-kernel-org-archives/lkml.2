Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2LPWxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 17:53:15 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53590 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2LPWxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 17:53:13 -0500
MIME-Version: 1.0
In-Reply-To: <1355697606.2903.39.camel@mfleming-mobl1.ger.corp.intel.com>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4> <20121215163535.GB229@x4> <1355661820.2903.25.camel@mfleming-mobl1.ger.corp.intel.com>
 <20121216132521.GA251@x4> <1355669692.2903.33.camel@mfleming-mobl1.ger.corp.intel.com>
 <CA+55aFy_xU6FryKX+pJ697B3+jRjRTniEVxn4quCs-tB-Qz7rw@mail.gmail.com>
 <CA+55aFxJcyTdtO5SWQK0YZyO_tEqPmL17oa8t3pX2meu30HR+Q@mail.gmail.com> <1355697606.2903.39.camel@mfleming-mobl1.ger.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Dec 2012 14:52:51 -0800
X-Google-Sender-Auth: ENj8o_32UOHIUAjStHP0yqiM1uw
Message-ID: <CA+55aFyh2WVgoTtEjiDfLEuy+nuT2LxS3RDNwWQOPVurSM8CMQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
To: Matt Fleming <matt.fleming@intel.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 2:40 PM, Matt Fleming <matt.fleming@intel.com> wrote:
>
> Linus have you got a stacktrace for the oops (and maybe even a dmesg)? I
> suspect it won't tell us much, but any/all info we can gather will help.

Sadly, it starts scrolling away pretty quickly, and it really wasn't
very useful. None of the traces contained any of the new code.

The backtrace was something like "find_vma()" called by "do_munmap()".

I do have a phone picture of an earlier oops, which was similar. In
that case, the oops happened in "unmap_single_vma()", with the call
trace being

  unmap_vmas
  exit_mmap
  mmput
  do_exit
  do_group_exit
  get_signal_to_deliver
  do_signal
  do_notify_resume
  retint_signal

which looks rather similar: it's some kind of nasty vma list
corruption. The main difference being that the exit of the process
happened as a result of a signal rather than just a plain exit()
system call. Which is probably in turn the result of some corruption
of user-space data structures.

In some other cases, I've got quickly scrolling stuff that I couldn't
even guess at, or just a hung system at early boot.

> At this point, I'm wondering if insert_identity_mapping() is trashing
> valid mappings.

It does feel like *major* data corruption. As in "not just a bitflip
or two", but "megabytes of data is wrong".

                    Linus
