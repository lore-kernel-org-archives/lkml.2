Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab0E0RRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:17:23 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:41216 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759278Ab0E0RRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:17:07 -0400
Message-ID: <4BFEA911.40600@msgid.tls.msk.ru>
Date: Thu, 27 May 2010 21:17:05 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: personality(ADDR_LIMIT_3GB) results in EFAULT
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I noticed an.. interesting issue here.

Running a 32bit executable on a 64bit kernel,
and doing

  personality(ADDR_LIMIT_3GB);

That call succedes, but any further execve()
and friends results in EFAULT, unless whole
argv[] and envp[] are copied to a malloc'ed
space.  alloca sometimes helps and sometimes
not.

This simple program demonstrates the issue:


===== cut =====
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int main(int ac, char **av, char **ev) {
  int i;

  personality(ADDR_LIMIT_3GB);

  ++av; --ac;

  for (i = 0; i < ac; ++i)
    av[i] = strdup(av[i]);

  for(i = 0; ev[i]; ++i)
   ev[i] = strdup(ev[i]);

  execve(av[0], av, ev);
  printf("unable to execute %s: %m\n", av[0]);
  return 1;
}
===== cut =====

Run as ./a.out /bin/echo
(or any other 32bit program).

Without the two for() loops it fails with EFAULT
error.  Changing strdup into strdupa results in
it working in the above simplest case, but
failing in more complex situation as a part of
larger program.

For now, in order to set this personality, I use
a 64bit helper program that executes the 32bit
binary (for which that personality is important).
Which look a bit ugly, esp. since it is in a chain
of other, all 32bit, programs.

Is it easy enough to fix? :)

The issue here, original issue, is a need to run
some legacy application (oracle database v.8 in
in this particular example), so it's not very
interesting to fix.  But doing ugly workarounds
aren't good either :)

Thanks!

/mjt
