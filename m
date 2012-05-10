Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2EJKit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:38:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758825Ab2EJKir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:38:47 -0400
Date: Thu, 10 May 2012 12:38:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Caspar Zhang <czhang@redhat.com>
Subject: Re: [PATCHv3 0/5] perf, tool: Fix endian issues
Message-ID: <20120510103825.GA4283@m.brq.redhat.com>
References: <1336390149-2970-1-git-send-email-jolsa@redhat.com>
 <4FA897BD.4000304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA897BD.4000304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 09:49:17PM -0600, David Ahern wrote:
> On 5/7/12 5:29 AM, Jiri Olsa wrote:
> >Tested by running following usecase:
> >   - origin system:
> >     # perf record -a -- sleep 10 (any perf record will do)
> >     # perf report>  report.origin
> >     # perf archive perf.data
> >
> >   - copy the perf.data, report.origin and perf.data.tar.bz2
> >     to a target system and run:
> >     # tar xjvf perf.data.tar.bz2 -C ~/.debug
> >     # perf report>  report.target
> >     # diff -u report.origin report.target
> >
> >   - the diff should produce no output
> >     (besides some white space stuff and possibly different
> >      date/TZ output)
> >
> >Tested by above usecase cross following architectures:
> >   i386, x86_64, s390x, ppc64
> 
> Short answer: Now that I have perf compiling in a 32-bit PPC VM,
> applied the patchset and rebuilding -- it does not work for me.

hi,
Could I ask what VM did you use? My qemu setup does not seem
to offer this one.

so it's [32 bits big endian] into [64 bits small endian]

I tested i386 to ppc64. The endianity is the other way round,
I wonder whats wrong with your tested direction.

hunting testing machine ;)

Also I did not test older versions.

thanks,
jirka

> 
> Long answer to reproduce:
> 
> In the PPC VM:
> 1. build perf without your patches
> 
> 2. perf record -ag -fo /tmp/perf.data -- sleep 1
> 
> 
> In the host (x86_64) using the same code base:
> 1. build perf without your patches
> 
> 2. mount ppc filesystem (e.g.,
> sshfs root@172.16.128.67:/ /tmp/f12-ppc/ -o direct_io)
> 
> 3. analyze ppc file. Verify life is good:
> /tmp/jiri/perf script --symfs /tmp/f12-ppc \
>     -I -i /tmp/f12-ppc/tmp/perf.data \
>      --kallsyms /tmp/f12-ppc/proc/kallsyms
> 
> 
> # ========
> # captured on: Mon May  7 21:32:15 2012
> # hostname : f12-ppc
> # os release : 2.6.32.26-175.fc12.ppc
> # perf version : 3.4.0-rc2
> # arch : ppc
> # nrcpus online : 1
> # nrcpus avail : 1
> # cpudesc : 740/750
> # cpuid : 8,769
> # total memory : 1024572 kB
> # cmdline : /tmp/pbuild/perf record -ag -fo /tmp/perf.data -v -e
> cpu-clock -- sleep 5
> # event : name = cpu-clock, type = 1, config = 0x0, config1 = 0x0,
> config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 6 }
> # ========
> #
> ...
> 
> Apply your patches and rebuild the host (x86_64 version). Life is
> not so good:
> 
> /tmp/jiri/perf script --symfs /tmp/f12-ppc \
>     -I -i /tmp/f12-ppc/tmp/perf.data \
>      --kallsyms /tmp/f12-ppc/proc/kallsyms
> 
> # ========
> # captured on: Mon May  7 21:32:15 2012
> # ========
> #
> 
> 
> i.e, all the feature data has gone missing.
> 
> David
> 
