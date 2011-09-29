Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1I2WKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:10:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab1I2WKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:10:04 -0400
Date: Thu, 29 Sep 2011 19:09:47 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tool: Treat all memory maps without dso file as
	loaded
Message-ID: <20110929220947.GB17597@ghostprotocols.net>
References: <1312980251-4945-1-git-send-email-jolsa@redhat.com> <20110822075322.GI2073@jolsa.brq.redhat.com> <20110822141130.GA21345@ghostprotocols.net> <20110822145849.GB8694@jolsa.brq.redhat.com> <20110824131834.GA2007@jolsa.brq.redhat.com> <20110929161103.GB8950@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929161103.GB8950@jolsa.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 29, 2011 at 06:11:03PM +0200, Jiri Olsa escreveu:
> > and here it is ;)
> 
> hi,
> any feedback?

I'm applying it now because the warning is annoying, but recently I
noticed that at least for vdso:


[admin@felicio x86_64]$ rpm -ql kernel-2.6.35.14-96.fc14 | grep vdso
/lib/modules/2.6.35.14-96.fc14.x86_64/vdso
/lib/modules/2.6.35.14-96.fc14.x86_64/vdso/vdso.so
/lib/modules/2.6.35.14-96.fc14.x86_64/vdso/vdso32-int80.so
/lib/modules/2.6.35.14-96.fc14.x86_64/vdso/vdso32-syscall.so
/lib/modules/2.6.35.14-96.fc14.x86_64/vdso/vdso32-sysenter.so
[admin@felicio x86_64]$ readelf -s /lib/modules/2.6.35.14-96.fc14.x86_64/vdso/vdso.so | head

Symbol table '.dynsym' contains 9 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: ffffffffff70030c     0 SECTION LOCAL  DEFAULT    7 
     2: ffffffffff700830   133 FUNC    WEAK   DEFAULT   12 clock_gettime@@LINUX_2.6
     3: 0000000000000000     0 OBJECT  GLOBAL DEFAULT  ABS LINUX_2.6
     4: ffffffffff7008c0   139 FUNC    GLOBAL DEFAULT   12 __vdso_gettimeofday@@LINUX_2.6
     5: ffffffffff700950    61 FUNC    GLOBAL DEFAULT   12 __vdso_getcpu@@LINUX_2.6
     6: ffffffffff7008c0   139 FUNC    WEAK   DEFAULT   12 gettimeofday@@LINUX_2.6
[admin@felicio x86_64]$ rpm -ql kernel-debuginfo | grep vdso
/usr/lib/debug/lib/modules/2.6.35.14-96.fc14.x86_64/vdso
/usr/lib/debug/lib/modules/2.6.35.14-96.fc14.x86_64/vdso/vdso.so.debug
/usr/lib/debug/lib/modules/2.6.35.14-96.fc14.x86_64/vdso/vdso32-int80.so.debug
/usr/lib/debug/lib/modules/2.6.35.14-96.fc14.x86_64/vdso/vdso32-syscall.so.debug
/usr/lib/debug/lib/modules/2.6.35.14-96.fc14.x86_64/vdso/vdso32-sysenter.so.debug
[admin@felicio x86_64]$ 

So eventually we need to remove "[vdso]" from that function and make it use the
symtabs above.

- Arnaldo
