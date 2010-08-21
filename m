Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab0HURP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:15:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0HURP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:15:57 -0400
Date: Sat, 21 Aug 2010 14:15:37 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: add test for strlcpy()
Message-ID: <20100821171537.GE2973@ghostprotocols.net>
References: <1282351101-8879-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282351101-8879-1-git-send-email-kirill@shutemov.name>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Aug 21, 2010 at 03:38:20AM +0300, Kirill A. Shutemov escreveu:
> Some Linux distributions like ALT Linux provides patched glibc with
> contains strlcpy(). It's confilcts with strlcpy() from perf.
> 
> Let's add check for strlcpy().

It doesn't work on !ALT Linux ;-\

    LINK /home/acme/git/build/perf//perf
/home/acme/git/build/perf//libperf.a(path.o): In function `perf_vsnpath':
/home/acme/git/linux/tools/perf/util/path.c:74: undefined reference to `strlcpy'
/home/acme/git/build/perf//libperf.a(abspath.o): In function `get_pwd_cwd':
/home/acme/git/linux/tools/perf/util/abspath.c:16: undefined reference to `strlcpy'
/home/acme/git/build/perf//libperf.a(abspath.o): In function `make_nonrelative_path':
/home/acme/git/linux/tools/perf/util/abspath.c:27: undefined reference to `strlcpy'
collect2: ld returned 1 exit status
make: *** [/home/acme/git/build/perf//perf] Error 1
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@emilia linux]$ 

See below why:
 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  tools/perf/Makefile          |    8 ++++++++
>  tools/perf/feature-tests.mak |   11 +++++++++++
>  tools/perf/util/cache.h      |    2 ++
>  tools/perf/util/path.c       |    3 ++-
>  4 files changed, 23 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 4f1fa77..496a0d6 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -653,6 +653,14 @@ else
> diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
> index 58a470d..029661c 100644
> --- a/tools/perf/util/path.c
> +++ b/tools/perf/util/path.c
> @@ -22,6 +22,7 @@ static const char *get_perf_dir(void)
>  	return ".";
>  }
>  
> +#ifdef STRLCPY

Should be:

+#ifdef NO_STRLCPY

I'm fixing it up.

>  size_t strlcpy(char *dest, const char *src, size_t size)
>  {
>  	size_t ret = strlen(src);
> @@ -33,7 +34,7 @@ size_t strlcpy(char *dest, const char *src, size_t size)
>  	}
>  	return ret;
>  }
