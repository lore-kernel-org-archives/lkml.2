Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2AHJlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 04:41:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46487 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2AHJlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 04:41:10 -0500
Subject: Re: [ERROR] perf build failure on current tip:perf/core
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20120108090018.GB7168@elte.hu>
References: <1325950949.1486.20.camel@leonhard>
	 <20120108090018.GB7168@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Jan 2012 18:41:04 +0900
Message-ID: <1326015664.1486.10.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-08 (일), 10:00 +0100, Ingo Molnar:
> * Namhyung Kim <namhyung@gmail.com> wrote:
> 
> > Hi,
> > 
> > When I tried to build perf, I was faced with following error:
> > 
> >     CC util/trace-event-info.o
> > cc1: warnings being treated as errors
> > util/trace-event-info.c: In function ‘record_file’:
> > util/trace-event-info.c:192: error: implicit declaration of function
> > ‘pwrite’
> > util/trace-event-info.c:192: error: nested extern declaration of
> > ‘pwrite’
> > make: *** [util/trace-event-info.o] Error 1
> > 
> > The code I tried was latest tip:perf/core - 9e183426bfb5 ("perf kvm: Fix
> > copy & paste error in description") and code in mainline (v3.2) doesn't
> > have this problem. Looking at the code, I couldn't find any clue to
> > this. Any idea?
> > 
> > FYI, my system is Ubuntu 10.04 on x86_64. gcc version is 4.4.3:
> 
> Which header does pwrite() belong to on that system - what does 
> 'map pwrite' say? It ought to be unistd.h, which is directly 
> included in util/trace-event-info.c.
> 
> My guess is that it might be related to:
> 
> tools/perf/Makefile:ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
> 
> Which introduces pwrite64() and defines pwrite() to them.
> 
> Does the patch below help? It's only a workaround really as 
> pwrite() ought to exist ... Also, i have only tested this on 
> 64-bit.
> 
> Thanks,
> 
> 	Ingo
> 
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index ac6830d..ba8b024 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -189,7 +189,7 @@ static void record_file(const char *file, size_t hdr_sz)
>  	if (bigendian())
>  		sizep += sizeof(u64) - hdr_sz;
>  
> -	if (hdr_sz && pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
> +	if (hdr_sz && pwrite64(output_fd, sizep, hdr_sz, hdr_pos) < 0)
>  		die("writing to %s", output_file);
>  }
>  

Hello,

Unfortunately, above patch doesn't work for my system:

      CC util/trace-event-info.o
  cc1: warnings being treated as errors
  util/trace-event-info.c: In function ‘record_file’:
  util/trace-event-info.c:192: error: implicit declaration of function
‘pwrite64’
  util/trace-event-info.c:192: error: nested extern declaration of
‘pwrite64’

And 'map pwrite' on terminal says:

  $ map pwrite
  The program 'map' is currently not installed.  You can install it by
typing:
  sudo apt-get install sgt-puzzles

I don't think this is the package what you said. Anyway quick grep'ing
pwrite tells me it's in the unistd.h:

  $ grep pwrite /usr/include/unistd.h
  extern ssize_t pwrite (int __fd, __const void *__buf, size_t __n,
  extern ssize_t __REDIRECT (pwrite, (int __fd, __const void *__buf,
			     pwrite64) __wur;
  #   define pwrite pwrite64

Thanks.


-- 
Regards,
Namhyung Kim


