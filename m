Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1GRKeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 06:34:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab1GRKeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 06:34:17 -0400
Date: Mon, 18 Jul 2011 12:34:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: buildid-cache zero out buffer of filenames when
 adding/remoing buildid
Message-ID: <20110718103415.GA1978@jolsa.brq.redhat.com>
References: <20110718031314.GA5802@hpt.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718031314.GA5802@hpt.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 11:13:14AM +0800, Han Pingtian wrote:
> readlink() doesn't append a null byte to buf. So we should zero out buf
> with zalloc(). Or we'll see sometimes error like this:
> 
> [root@intel-s3e36-01]~# /usr/bin/perf buildid-cache -a /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko -v
> Adding f64ba8efd5f53c7ad332fc17db1d21de309038e1 /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko: Ok
> [root@intel-s3e36-01]~# /usr/bin/perf buildid-cache -r /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko -v
> Removing f64ba8efd5f53c7ad332fc17db1d21de309038e1 /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko: FAIL
> /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko wasn't in the cache
> 
> The change in build_id_cache__add_s() is a defense.
> 
> Signed-off-by: Han Pingtian <phan@redhat.com>

works for me

Tested-by: Jiri Olsa <jolsa@redhat.com>

> ---
>  tools/perf/util/header.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index afb0849..36d723d 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -189,8 +189,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
>  			  const char *name, bool is_kallsyms)
>  {
>  	const size_t size = PATH_MAX;
> -	char *realname, *filename = malloc(size),
> -	     *linkname = malloc(size), *targetname;
> +	char *realname, *filename = zalloc(size),
> +	     *linkname = zalloc(size), *targetname;
>  	int len, err = -1;
>  
>  	if (is_kallsyms) {
> @@ -254,8 +254,8 @@ static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
>  int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
>  {
>  	const size_t size = PATH_MAX;
> -	char *filename = malloc(size),
> -	     *linkname = malloc(size);
> +	char *filename = zalloc(size),
> +	     *linkname = zalloc(size);
>  	int err = -1;
>  
>  	if (filename == NULL || linkname == NULL)
> -- 
> 1.7.1
