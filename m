Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1AUSxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:53:50 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63036 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1AUSxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:53:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=pPexl/HCUAfTaFrVDjOU6hRX2c0AELsbMOUuO8E9FwPbvYdaT1eacV+tW6JO+dnvaE
         e8XjqBxSjYTANMbX03lII6w+eHG1i2S7CQiQYfPZAyg2QGBna9ps9kxUwySXgjN3c+4E
         U1qyGNFH84xU0RhU0s9JYkCovyc8/ip/T4mdg=
Date: Fri, 21 Jan 2011 16:53:37 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Denis Kirjanov <dkirjanov@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH] perftools: Fix build error
Message-ID: <20110121185337.GA15881@ghostprotocols.net>
References: <20110120093246.GA8031@hera.kernel.org>
 <20110120114719.GD23661@elte.hu>
 <4D385866.3060405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D385866.3060405@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 20, 2011 at 06:44:38PM +0300, Denis Kirjanov escreveu:
> On 01/20/2011 02:47 PM, Ingo Molnar wrote:
> > 
> > * Denis Kirjanov <dkirjanov@kernel.org> wrote:
> > 
> >> Fix perftools build error (ppc64 box) with PERF_VERSION = 2.6.38.rc1.47.g12fcdb
> >> CC builtin-top.o
> >> cc1: warnings being treated as errors
> >> builtin-top.c: In function 'print_sym_table':
> >> builtin-top.c:540: error: format '%Ld' expects type 'long long int', but argument 2 has type '__u64'
> >>
> >> Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
> >> ---
> >>  tools/perf/builtin-top.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> >> index 05344c6..8202a2e 100644
> >> --- a/tools/perf/builtin-top.c
> >> +++ b/tools/perf/builtin-top.c
> >> @@ -537,7 +537,7 @@ static void print_sym_table(void)
> >>  	if (nr_counters == 1 || !display_weighted) {
> >>  		struct perf_evsel *first;
> >>  		first = list_entry(evsel_list.next, struct perf_evsel, node);
> >> -		printf("%Ld", first->attr.sample_period);
> >> +		printf("%Ld", (unsigned long long)first->attr.sample_period);
> > 
> > Wouldnt %Lu solve this in a cleaner way?
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> I think that cleaner way is to use PRIu64.
> 
> 
> >From 492bf54effdf8c154e76c4ca734f27ce1db46df6 Mon Sep 17 00:00:00 2001
> From: Denis Kirjanov <dkirjanov@kernel.org>
> Date: Thu, 20 Jan 2011 18:34:56 +0300
> Subject: [PATCH] perftools: Fix build error
> 
>     CC perf.o
>     CC builtin-top.o
> cc1: warnings being treated as errors
> builtin-top.c: In function 'print_sym_table':
> builtin-top.c:540: error: format '%Ld' expects type 'long long int', but argument 2 has type '__u64'
> make: *** [builtin-top.o] Error 1


Now, after applying your patch, I get:

[acme@felicio linux]$ make -j2 O=~acme/git/build/perf -C tools/perf/ install
make: Entering directory `/media/tbs/acme/git/linux/tools/perf'
    GEN perf-archive
    CC /home/acme/git/build/perf/builtin-top.o
cc1: warnings being treated as errors
builtin-top.c: In function ‘print_sym_table’:
builtin-top.c:541:3: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 2 has type ‘__u64’
make: *** [/home/acme/git/build/perf/builtin-top.o] Error 1
make: Leaving directory `/media/tbs/acme/git/linux/tools/perf'




[acme@felicio linux]$ gcc -v
Using built-in specs.
COLLECT_GCC=/usr/bin/gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.5.1/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,lto --enable-plugin --enable-java-awt=gtk --disable-dssi --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre --enable-libgcj-multifile --enable-java-maintainer-mode --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) 
[acme@felicio linux]$ cat /etc/fedora-release 
Fedora release 14 (Laughlin)
[acme@felicio linux]$ 

- Arnaldo
