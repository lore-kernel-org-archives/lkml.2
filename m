Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab2INPkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:40:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859Ab2INPkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:40:21 -0400
Date: Fri, 14 Sep 2012 17:39:52 +0200
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, tzanussi@gmail.com
Subject: perf script: rwtop: SIGALRM and pipe read race
Message-ID: <20120914153952.GA8834@turtle.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I recently tried 'perf script rwtop', and it immediately failed with
'failed to read event header'. Running it through strace I found that the
when rwtop.pl is reading from the pipe, and gets one of it's alarms, that
the ERESTARTSYS seems to confuse it - causing it to fail. It also appears
that the problem only happens early in execution, or not at all. If I get
lucky and don't hit the problem right away, then rwtop will run fine as
long as I want, without any ERESTARTSYS's in its trace. I also found that
I can avoid hitting the problem by throwing a 'pv -q' in front of the perf
command in tools/perf/scripts/perl/bin/rwtop-report. Which I guess slows
things down in the reader enough to always avoid the race.

Sorry I don't have a solution (patch). I'll look at it more as time
permits, but I thought I'd get it reported for starters though.

Drew

Partial strace below

16774 read(0,  <unfinished ...>
16772 <... getdents resumed> /* 0 entries */, 32768) = 0
16774 <... read resumed>
"\206A\0\0\206A\0\0perf\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 48) =
48
16772 close(70 <unfinished ...>
16774 read(0,  <unfinished ...>
16772 <... close resumed> )             = 0
16772 open("/proc/16774/maps", O_RDONLY) = 70
16772 fstat(70, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
16772 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0x7f76c6b5b000
16772 read(70, "00400000-00582000 r-xp 00000000 "..., 1024) = 1024
16774 <... read resumed> 0x28598e0, 8)  = ? ERESTARTSYS (To be restarted
if SA_RESTART is set)
16772 write(1, "\1\0\0\0\2\0p\0\206A\0\0\206A\0\0\0\0@\0\0\0\0\0\0
\30\0\0\0\0\0"..., 112 <unfinished ...>
16774 --- SIGALRM {si_signo=SIGALRM, si_code=SI_KERNEL} ---
16772 <... write resumed> )             = 112
16774 rt_sigreturn( <unfinished ...>
16772 write(1,
"\1\0\0\0\2\0`\0\206A\0\0\206A\0\0\0\0\240\0072\0\0\0\0\0\2\0\0\0\0\0"...,
96 <unfinished ...>
16774 <... rt_sigreturn resumed> )      = -1 EINTR (Interrupted system
call)
16772 <... write resumed> )             = 96
16774 write(2, "failed to read event header\n", 28 <unfinished ...>
