Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0KYPrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:47:32 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33030 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0KYPrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:47:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=nXNV0JZEEdHknjm7+hbhCa3e2Yn1PhD5i0exCa7GViY4sL73DZX2pGuZcWH+DvOuMW
         3PoB0R3eVdghN8VdpiCyuUZt3RX2whm2tr4BPnKbppKsVGaFtmrnYXSZM/lXhpjsDfeU
         EVgPg7QVU4+8GcaFwh0kA7fAIG4r447ICm7IU=
Date: Thu, 25 Nov 2010 13:47:18 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] perf: Add timestamp to COMM and MMAP events
Message-ID: <20101125154718.GE15875@ghostprotocols.net>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
 <1290490544-14349-4-git-send-email-imunsie@au1.ibm.com>
 <1290510512.2072.387.camel@laptop>
 <20101123124121.GA11101@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123124121.GA11101@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 23, 2010 at 10:41:21AM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Nov 23, 2010 at 12:08:32PM +0100, Peter Zijlstra escreveu:
> > Right, so acme had a patch adding
> > 
> > PERF_SAMPLE_TID
> > PERF_SAMPLE_TIME
> > PERF_SAMPLE_ID
> > PERF_SAMPLE_CPU
> > PERF_SAMPLE_STREAM_ID
> > 
> > (IIRC) to every record.. so solve this same problem. Except he got
> > interrupted by KS and things and didn't get around to posting it.
> > 
> > Arnaldo?
> 
> Will post later today, IIRC I have to break it down because I did some
> refactorings, etc.

Ian,

	Please take a look at:

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=shortlog;h=refs/heads/perf/sample_type_id_all

I'm still testing and Peter is reviewing them, I know of a problem with
unconditionally stting attr->sample_type_all and then trying the new
perf tool on an older kernel, that will fail with:

[root@felicio ~]# perf record -a -g

  Error: sys_perf_event_open() syscall returned with -1 (Invalid
argument).  /bin/dmesg may provide additional information.

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

[root@felicio ~]# 

Because it doesn't expects that extra bit to be set. I'll use that to
make sure the binary works on older kernels without this feature.

But apart from this it seems ok, end result can be seen on the HEAD:

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=commit;h=27ebd1697fe03268d75fbe44ba1648ec34cf572b

$ perf report -D | grep PERF_RECORD_
<SNIP>
 3   5951915425 0x47530 [0x58]: PERF_RECORD_SAMPLE(IP, 1): 16811/16811: 0xffffffff8138c1a2 period: 215979 cpu:3
 3   5952026879 0x47588 [0x90]: PERF_RECORD_SAMPLE(IP, 1): 16811/16811: 0xffffffff810cb480 period: 215979 cpu:3
 3   5952059959 0x47618 [0x38]: PERF_RECORD_FORK(6853:6853):(16811:16811)
 3   5952138878 0x47650 [0x78]: PERF_RECORD_SAMPLE(IP, 1): 16811/16811: 0xffffffff811bac35 period: 431478 cpu:3
 3   5952375068 0x476c8 [0x30]: PERF_RECORD_COMM: find:6853
 3   5952395923 0x476f8 [0x50]: PERF_RECORD_MMAP 6853/6853: [0x400000(0x25000) @ 0]: /usr/bin/find
 3   5952413756 0x47748 [0xa0]: PERF_RECORD_SAMPLE(IP, 1): 6853/6853: 0xffffffff810d080f period: 859332 cpu:3
 3   5952419837 0x477e8 [0x58]: PERF_RECORD_MMAP 6853/6853: [0x3f44600000(0x21d000) @ 0]: /lib64/ld-2.5.so
 3   5952437929 0x47840 [0x48]: PERF_RECORD_MMAP 6853/6853: [0x7fff7e1c9000(0x1000) @ 0x7fff7e1c9000]: [vdso]
 3   5952570127 0x47888 [0x58]: PERF_RECORD_MMAP 6853/6853: [0x3f46200000(0x218000) @ 0]: /lib64/libselinux.so.1
 3   5952623637 0x478e0 [0x58]: PERF_RECORD_MMAP 6853/6853: [0x3f44a00000(0x356000) @ 0]: /lib64/libc-2.5.so
 3   5952675720 0x47938 [0x58]: PERF_RECORD_MMAP 6853/6853: [0x3f44e00000(0x204000) @ 0]: /lib64/libdl-2.5.so
 3   5952710080 0x47990 [0x58]: PERF_RECORD_MMAP 6853/6853: [0x3f45a00000(0x246000) @ 0]: /lib64/libsepol.so.1
 3   5952847802 0x479e8 [0x58]: PERF_RECORD_SAMPLE(IP, 1): 6853/6853: 0xffffffff813897f0 period: 1142536 cpu:3
<SNIP>
cpu   tstamp

- Arnaldo
