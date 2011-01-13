Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab1AMKZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:25:46 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33262 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1AMKZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:25:43 -0500
X-AuditID: b753bd60-a1557ba00000044b-7c-4d2ed324052e
Message-ID: <4D2ED322.4040508@hitachi.com>
Date: Thu, 13 Jan 2011 19:25:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        lkml <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: rewrite find_lazy_match_lines() by using
 getline(3)
References: <m3d3o185u1.fsf@gmail.com>
In-Reply-To: <m3d3o185u1.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/13 19:18), Franck Bui-Huu wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>

Looks very nice! :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> ---
>  tools/perf/util/probe-finder.c |   70 +++++++++++++++------------------------
>  1 files changed, 27 insertions(+), 43 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index ddf4d45..4221738 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -1092,51 +1092,38 @@ static int find_probe_point_by_line(struct probe_finder *pf)
>  static int find_lazy_match_lines(struct list_head *head,
>  				 const char *fname, const char *pat)
>  {
> -	char *fbuf, *p1, *p2;
> -	int fd, line, nlines = -1;
> -	struct stat st;
> -
> -	fd = open(fname, O_RDONLY);
> -	if (fd < 0) {
> -		pr_warning("Failed to open %s: %s\n", fname, strerror(-fd));
> +	FILE *fp;
> +	char *line = NULL;
> +	size_t line_len;
> +	ssize_t len;
> +	int count = 0, linenum = 1;
> +
> +	fp = fopen(fname, "r");
> +	if (!fp) {
> +		pr_warning("Failed to open %s: %s\n", fname, strerror(errno));
>  		return -errno;
>  	}
>  
> -	if (fstat(fd, &st) < 0) {
> -		pr_warning("Failed to get the size of %s: %s\n",
> -			   fname, strerror(errno));
> -		nlines = -errno;
> -		goto out_close;
> -	}
> -
> -	nlines = -ENOMEM;
> -	fbuf = malloc(st.st_size + 2);
> -	if (fbuf == NULL)
> -		goto out_close;
> -	if (read(fd, fbuf, st.st_size) < 0) {
> -		pr_warning("Failed to read %s: %s\n", fname, strerror(errno));
> -		nlines = -errno;
> -		goto out_free_fbuf;
> -	}
> -	fbuf[st.st_size] = '\n';	/* Dummy line */
> -	fbuf[st.st_size + 1] = '\0';
> -	p1 = fbuf;
> -	line = 1;
> -	nlines = 0;
> -	while ((p2 = strchr(p1, '\n')) != NULL) {
> -		*p2 = '\0';
> -		if (strlazymatch(p1, pat)) {
> -			line_list__add_line(head, line);
> -			nlines++;
> +	while ((len = getline(&line, &line_len, fp)) > 0) {
> +
> +		if (line[len - 1] == '\n')
> +			line[len - 1] = '\0';
> +
> +		if (strlazymatch(line, pat)) {
> +			line_list__add_line(head, linenum);
> +			count++;
>  		}
> -		line++;
> -		p1 = p2 + 1;
> -	}
> -out_free_fbuf:
> -	free(fbuf);
> -out_close:
> -	close(fd);
> -	return nlines;
> +		linenum++;
> +	}
> +
> +	if (ferror(fp))
> +		count = -errno;
> +	free(line);
> +	fclose(fp);
> +
> +	if (count == 0)
> +		pr_debug("No matched lines found in %s.\n", fname);
> +	return count;
>  }
>  
>  /* Find probe points from lazy pattern  */
> @@ -1154,10 +1141,7 @@ static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
>  		/* Matching lazy line pattern */
>  		ret = find_lazy_match_lines(&pf->lcache, pf->fname,
>  					    pf->pev->point.lazy_line);
> -		if (ret == 0) {
> -			pr_debug("No matched lines found in %s.\n", pf->fname);
> -			return 0;
> -		} else if (ret < 0)
> +		if (ret <= 0)
>  			return ret;
>  	}
>  


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
