Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0ESTgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:36:52 -0400
Received: from smtp-out.google.com ([74.125.121.35]:3109 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0ESTgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:36:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=rhkenIIaHAPokK9YoJ23+Jjp+s7/wd4dzuIrrRK1v6Xo6x8N9jxy2+kVkaSnw/ePz
	qfIsrPwnKT0gjkGoaga5g==
MIME-Version: 1.0
In-Reply-To: <1274288493-15523-1-git-send-email-acme@infradead.org>
References: <1274288493-15523-1-git-send-email-acme@infradead.org>
Date: Wed, 19 May 2010 21:36:45 +0200
Message-ID: <AANLkTindijJnIeElAkoj0CGC7nJwVEzIC_OlDbJ_adE8@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] perf session fix host_machine handling wrt build 
	ids
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 19, 2010 at 7:01 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Hi Ingo,
>
>        Please pull from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
>
> Stephane and Tom,
>
>        Now the build id code should be back working:
>
> [root@doppio linux-2.6-tip]# rm -rf /root/.debug/
> [root@doppio linux-2.6-tip]# perf record find / > /dev/null
> ^C[ perf record: Woken up 3 times to write data ]
> [ perf record: Captured and wrote 0.667 MB perf.data (~29163 samples) ]
> [root@doppio linux-2.6-tip]# perf buildid-list
> 349199a1e1b7cc25ac4f7004deed260f0146665e [kernel.kallsyms]


It is working again for me too. Thanks for the quick fix.

Related to .debug, I think it would be useful to have a choice as to
where all that stuff gets saved. It is hardcoded to $HOME today.

We could provide:
- an environment variable, e.g., PERFHOME or PERFDEBUGDIR
- an option to perf record, perf report, perf annotate, i.e., all commands
  that use .debug

I looked at that today and I have a draft patch to add both the variable
+ the option.

The problem with the environment variable is that you tend to forget to
set it. As you suggest below, you may run perf report on another machine
too and you don't necessarily want to overwrite the .debug you may already
have in your $HOME dir. I think the option has the advantage of making this
explicit. It would still default to $HOME if not set.


> 1f095dcd586045d7aa158b4774b8b053e7f580a4 /lib/modules/2.6.34-rc6/kernel/net/ipv4/netfilter/nf_nat.ko
> 78913cef49182f29a0237d9867ff12811df00663 /lib/modules/2.6.34-rc6/kernel/drivers/md/dm-crypt.ko
> 5b2b076ef0b0be593d76c96fbd4393455380e589 /lib/modules/2.6.34-rc6/kernel/drivers/ata/sata_sil.ko
> b6c457f3d69870e6f68f2c61978f8e3beb25221c /lib/modules/2.6.34-rc6/kernel/drivers/net/e1000e/e1000e.ko
> 2249bf363819205e320e242af2e757906be5010e /lib/modules/2.6.34-rc6/kernel/drivers/gpu/drm/i915/i915.ko
> a8e4f743b40fb1fd8b85e2f9b88d93b661472b8f /bin/find
> eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1 /lib64/libc-2.10.2.so
> 5c68f7afeb33309c78037e374b0deee84dd441f6 /lib64/libpthread-2.10.2.so
> [root@doppio linux-2.6-tip]# ls -la /root/.debug/
> total 28
> drwxr-xr-x   7 root root 4096 Mai 19 13:56 .
> drwxr-x---. 31 root root 4096 Mai 19 13:56 ..
> drwxr-xr-x   3 root root 4096 Mai 19 13:56 bin
> drwxr-xr-x  76 root root 4096 Mai 19 13:56 .build-id
> drwxr-xr-x   2 root root 4096 Mai 19 13:56 [kernel.kallsyms]
> drwxr-xr-x   3 root root 4096 Mai 19 13:56 lib
> drwxr-xr-x   4 root root 4096 Mai 19 13:56 lib64
> [root@doppio linux-2.6-tip]# ls -la /root/.debug/.build-id/
> 03/ 0c/ 13/ 1e/ 20/ 28/ 2b/ 2d/ 34/ 3b/ 3f/ 47/ 56/ 5b/ 5e/ 6e/ 72/ 7e/
> 85/ 87/ 94/ 98/ a0/ a5/ a8/ ac/ bc/ c8/ cc/ d9/ dd/ e2/ e8/ eb/ ef/ f2/
> fd/ 0b/ 0e/ 19/ 1f/ 22/ 29/ 2c/ 2e/ 39/ 3e/ 42/ 55/ 57/ 5c/ 62/ 6f/ 78/
> 80/ 86/ 91/ 97/ 99/ a1/ a7/ a9/ b6/ c6/ ca/ d8/ dc/ df/ e3/ e9/ ed/ f1/
> fa/ fe/
> [root@doppio linux-2.6-tip]# ls -la /root/.debug/lib64/libc-2.10.2.so/eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1
> -rwxr-xr-x 2 root root 1825560 Nov 20 09:29 /root/.debug/lib64/libc-2.10.2.so/eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1
> [root@doppio linux-2.6-tip]# ls -la /root/.debug/.build-id/eb/4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1
> lrwxrwxrwx 1 root root 67 Mai 19 13:56 /root/.debug/.build-id/eb/4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1 -> ../../lib64/libc-2.10.2.so/eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1
> [root@doppio linux-2.6-tip]#
> [root@doppio linux-2.6-tip]# perf archive
> Now please run:
>
> $ tar xvf perf.data.tar.bz2 -C ~/.debug
>
> wherever you need to run 'perf report' on.
> [root@doppio linux-2.6-tip]#
>
> ot@doppio linux-2.6-tip]# tar tvf perf.data.tar.bz2
> lrwxrwxrwx root/root         0 2010-05-19 13:56 .build-id/34/9199a1e1b7cc25ac4f7004deed260f0146665e -> ../../[kernel.kallsyms]/349199a1e1b7cc25ac4f7004deed260f0146665e
> -rw-r--r-- root/root   2842888 2010-05-19 13:56 [kernel.kallsyms]/349199a1e1b7cc25ac4f7004deed260f0146665e
> lrwxrwxrwx root/root         0 2010-05-19 13:56 .build-id/1f/095dcd586045d7aa158b4774b8b053e7f580a4 -> ../../lib/modules/2.6.34-rc6/kernel/net/ipv4/netfilter/nf_nat.ko/1f095dcd586045d7aa158b4774b8b053e7f580a4
> -rw-r--r-- root/root   1670552 2010-04-30 11:43 lib/modules/2.6.34-rc6/kernel/net/ipv4/netfilter/nf_nat.ko/1f095dcd586045d7aa158b4774b8b053e7f580a4
> lrwxrwxrwx root/root         0 2010-05-19 13:56 .build-id/78/913cef49182f29a0237d9867ff12811df00663 -> ../../lib/modules/2.6.34-rc6/kernel/drivers/md/dm-crypt.ko/78913cef49182f29a0237d9867ff12811df00663
> -rw-r--r-- root/root    326827 2010-04-30 11:43 lib/modules/2.6.34-rc6/kernel/drivers/md/dm-crypt.ko/78913cef49182f29a0237d9867ff12811df00663
> lrwxrwxrwx root/root         0 2010-05-19 13:56 .build-id/5b/2b076ef0b0be593d76c96fbd4393455380e589 -> ../../lib/modules/2.6.34-rc6/kernel/drivers/ata/sata_sil.ko/5b2b076ef0b0be593d76c96fbd4393455380e589
> -rw-r--r-- root/root    325915 2010-04-30 11:43 lib/modules/2.6.34-rc6/kernel/drivers/ata/sata_sil.ko/5b2b076ef0b0be593d76c96fbd4393455380e589
> lrwxrwxrwx root/root         0 2010-05-19 13:56 .build-id/b6/c457f3d69870e6f68f2c61978f8e3beb25221c -> ../../lib/modules/2.6.34-rc6/kernel/drivers/net/e1000e/e1000e.ko/b6c457f3d69870e6f68f2c61978f8e3beb25221c
> -rw-r--r-- root/root   2587163 2010-04-30 11:43 lib/modules/2.6.34-rc6/kernel/drivers/net/e1000e/e1000e.ko/b6c457f3d69870e6f68f2c61978f8e3beb25221c
> lrwxrwxrwx root/root         0 2010-05-19 13:56 .build-id/22/49bf363819205e320e242af2e757906be5010e -> ../../lib/modules/2.6.34-rc6/kernel/drivers/gpu/drm/i915/i915.ko/2249bf363819205e320e242af2e757906be5010e
> -rw-r--r-- root/root   8296246 2010-04-30 11:43 lib/modules/2.6.34-rc6/kernel/drivers/gpu/drm/i915/i915.ko/2249bf363819205e320e242af2e757906be5010e
> lrwxrwxrwx root/root         0 2010-05-19 13:56 .build-id/a8/e4f743b40fb1fd8b85e2f9b88d93b661472b8f -> ../../bin/find/a8e4f743b40fb1fd8b85e2f9b88d93b661472b8f
> -rwxr-xr-x root/root    233032 2009-02-24 14:13 bin/find/a8e4f743b40fb1fd8b85e2f9b88d93b661472b8f
> lrwxrwxrwx root/root         0 2010-05-19 13:56 .build-id/eb/4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1 -> ../../lib64/libc-2.10.2.so/eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1
> -rwxr-xr-x root/root   1825560 2009-11-20 09:29 lib64/libc-2.10.2.so/eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1
> lrwxrwxrwx root/root         0 2010-05-19 13:56 .build-id/5c/68f7afeb33309c78037e374b0deee84dd441f6 -> ../../lib64/libpthread-2.10.2.so/5c68f7afeb33309c78037e374b0deee84dd441f6
> -rwxr-xr-x root/root    148528 2009-11-20 09:29 lib64/libpthread-2.10.2.so/5c68f7afeb33309c78037e374b0deee84dd441f6
> [root@doppio linux-2.6-tip]#
>
> Regards,
>
> - Arnaldo
>
> Arnaldo Carvalho de Melo (2):
>  perf symbols: Don't try to read the build-id twice
>  perf session: Make read_build_id routines look at the host_machine too
>
>  tools/perf/util/header.c  |   84 ++++++++++++++++++++++++++++-----------------
>  tools/perf/util/session.c |    7 ++++
>  tools/perf/util/session.h |    8 +---
>  tools/perf/util/symbol.c  |   13 ++++++-
>  tools/perf/util/symbol.h  |    1 +
>  5 files changed, 73 insertions(+), 40 deletions(-)
>
>
