Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab2EHDtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:49:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50215 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2EHDtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:49:22 -0400
Message-ID: <4FA897BD.4000304@gmail.com>
Date: Mon, 07 May 2012 21:49:17 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Caspar Zhang <czhang@redhat.com>
Subject: Re: [PATCHv3 0/5] perf, tool: Fix endian issues
References: <1336390149-2970-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1336390149-2970-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/12 5:29 AM, Jiri Olsa wrote:
> Tested by running following usecase:
>    - origin system:
>      # perf record -a -- sleep 10 (any perf record will do)
>      # perf report>  report.origin
>      # perf archive perf.data
>
>    - copy the perf.data, report.origin and perf.data.tar.bz2
>      to a target system and run:
>      # tar xjvf perf.data.tar.bz2 -C ~/.debug
>      # perf report>  report.target
>      # diff -u report.origin report.target
>
>    - the diff should produce no output
>      (besides some white space stuff and possibly different
>       date/TZ output)
>
> Tested by above usecase cross following architectures:
>    i386, x86_64, s390x, ppc64

Short answer: Now that I have perf compiling in a 32-bit PPC VM, applied 
the patchset and rebuilding -- it does not work for me.

Long answer to reproduce:

In the PPC VM:
1. build perf without your patches

2. perf record -ag -fo /tmp/perf.data -- sleep 1


In the host (x86_64) using the same code base:
1. build perf without your patches

2. mount ppc filesystem (e.g.,
sshfs root@172.16.128.67:/ /tmp/f12-ppc/ -o direct_io)

3. analyze ppc file. Verify life is good:
/tmp/jiri/perf script --symfs /tmp/f12-ppc \
     -I -i /tmp/f12-ppc/tmp/perf.data \
      --kallsyms /tmp/f12-ppc/proc/kallsyms


# ========
# captured on: Mon May  7 21:32:15 2012
# hostname : f12-ppc
# os release : 2.6.32.26-175.fc12.ppc
# perf version : 3.4.0-rc2
# arch : ppc
# nrcpus online : 1
# nrcpus avail : 1
# cpudesc : 740/750
# cpuid : 8,769
# total memory : 1024572 kB
# cmdline : /tmp/pbuild/perf record -ag -fo /tmp/perf.data -v -e 
cpu-clock -- sleep 5
# event : name = cpu-clock, type = 1, config = 0x0, config1 = 0x0, 
config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 6 }
# ========
#
...

Apply your patches and rebuild the host (x86_64 version). Life is not so 
good:

/tmp/jiri/perf script --symfs /tmp/f12-ppc \
     -I -i /tmp/f12-ppc/tmp/perf.data \
      --kallsyms /tmp/f12-ppc/proc/kallsyms

# ========
# captured on: Mon May  7 21:32:15 2012
# ========
#


i.e, all the feature data has gone missing.

David

