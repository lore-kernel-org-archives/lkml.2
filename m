Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab2JCNsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:48:09 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37179 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2JCNsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:48:07 -0400
Date: Wed, 3 Oct 2012 06:47:57 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCHv2 00/14] perf diff: Factor diff command
Message-ID: <20121003134757.GA18700@ghostprotocols.net>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
 <20120927213102.GO16230@one.firstfloor.org>
 <20121001081631.GB991@krava.brq.redhat.com>
 <20121002163002.GD16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002163002.GD16230@one.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 02, 2012 at 06:30:02PM +0200, Andi Kleen escreveu:
> The other problem I ran into is that perf archive doesn't seem to work very
> well with kernels, so it's hard to move profiles from different kernels
> around to diff them (e.g. for a performance regression) One way around this
> would be options to diff to specify the vmlinux etc.  manually

Can you describe more precisely what is not working well with 'archive'
and build ids?

When you do a 'perf record', at the end of the session, it traverses the
samples looking for DSOs with hits, and then stashes a copy (or a
hardlink, if possible) of these DSOs in your ~/.cache/, keyed by its
build id.

Later, when you do a perf archive, it will look again at your perf.data
files, look again for DSOs with hits and pass them on a tar command
line, you transfer those tarballs to your analysis machine and it should
just work.

To debug you may follow some of these steps:

[root@sandy linux]# perf record -a usleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.447 MB perf.data (~19534 samples) ]
[root@sandy linux]# perf buildid-list 
62b97af6897371571caef35fd5ae88e29bde5e89 [kernel.kallsyms]
[root@sandy linux]# ls -la ~/.debug/.build-id/62/b97af6897371571caef35fd5ae88e29bde5e89 
lrwxrwxrwx. 1 root root 64 Oct  3 10:41 /root/.debug/.build-id/62/b97af6897371571caef35fd5ae88e29bde5e89 -> ../../[kernel.kallsyms]/62b97af6897371571caef35fd5ae88e29bde5e89
[root@sandy linux]# perf buildid-list --hell
  Error: unknown option `hell'

 usage: perf buildid-list [<options>]

    -H, --with-hits       Show only DSOs with hits
    -i, --input <file>    input file name
    -f, --force           don't complain, do it
    -k, --kernel          Show current kernel build id
    -v, --verbose         be more verbose

[root@sandy linux]# perf buildid-list -k
62b97af6897371571caef35fd5ae88e29bde5e89
[root@sandy linux]# perf archive
Now please run:

$ tar xvf perf.data.tar.bz2 -C ~/.debug

wherever you need to run 'perf report' on.
[root@sandy linux]# tar tvf perf.data.tar.bz2
lrwxrwxrwx root/root         0 2012-10-03 10:41 .build-id/62/b97af6897371571caef35fd5ae88e29bde5e89 -> ../../[kernel.kallsyms]/62b97af6897371571caef35fd5ae88e29bde5e89
-rw-r--r-- root/root   4115683 2012-10-03 10:41 [kernel.kallsyms]/62b97af6897371571caef35fd5ae88e29bde5e89
[root@sandy linux]# 

[root@sandy linux]# sha256sum /root/.debug/.build-id/62/b97af6897371571caef35fd5ae88e29bde5e89 /proc/kallsyms 
43724edebe7f144d43a8664e237fa14df96bb79943002f1f17f45379a16418bf  /root/.debug/.build-id/62/b97af6897371571caef35fd5ae88e29bde5e89
43724edebe7f144d43a8664e237fa14df96bb79943002f1f17f45379a16418bf  /proc/kallsyms
[root@sandy linux]# 

- Arnaldo
