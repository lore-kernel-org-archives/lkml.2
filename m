Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab2IQD6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:58:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42384 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab2IQD6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:58:05 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-53-50569fca801f
From: Namhyung Kim <namhyung@kernel.org>
To: liang xie <xieliang007@gmail.com>
Cc: linux-perf-users@vger.kernel.org, acme@ghostprotocols.net, balbi@ti.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] memory leak fix while calling system_path
References: <CADu=CFrGDZ7waQbigcm43_Jm0NE2BAnmr0263iNAm-=A8erwBA@mail.gmail.com>
Date: Mon, 17 Sep 2012 12:51:34 +0900
In-Reply-To: <CADu=CFrGDZ7waQbigcm43_Jm0NE2BAnmr0263iNAm-=A8erwBA@mail.gmail.com>
	(liang xie's message of "Fri, 14 Sep 2012 11:14:13 +0800")
Message-ID: <87haqx8fy1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Sep 2012 11:14:13 +0800, liang xie wrote:
> memory leak fix while calling system_path
>
> Since v1: Remove an unnecessary null pointer check per Felipe's comments
> Since v2: Make system_path&perf_exec_path always return dynamically
> allocated string
>
> Signed-off-by: xieliang <xieliang@xiaomi.com>
> ---
>  tools/perf/builtin-help.c   |   12 +++++++++---
>  tools/perf/builtin-script.c |   13 ++++++++++---
>  tools/perf/perf.c           |    8 ++++++--
>  tools/perf/util/config.c    |   16 +++++-----------
>  tools/perf/util/exec_cmd.c  |   26 +++++++++++++++-----------
>  tools/perf/util/exec_cmd.h  |    4 ++--
>  tools/perf/util/help.c      |    6 ++++--
>  7 files changed, 51 insertions(+), 34 deletions(-)
>
> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
> index 6d5a8a7..180a5bd 100644
> --- a/tools/perf/builtin-help.c
> +++ b/tools/perf/builtin-help.c
> @@ -321,12 +321,13 @@ static void setup_man_path(void)
>  {
>  	struct strbuf new_path = STRBUF_INIT;
>  	const char *old_path = getenv("MANPATH");
> +	char *man_path = system_path(PERF_MAN_PATH);

I think the return value of system_path and perf_exec_path should be
checked since they can return NULL as strdup() does.


[snip]
> diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
> index 7adf4ad..1ace941 100644
> --- a/tools/perf/util/exec_cmd.c
> +++ b/tools/perf/util/exec_cmd.c
> @@ -9,17 +9,19 @@
>  static const char *argv_exec_path;
>  static const char *argv0_path;
>
> -const char *system_path(const char *path)
> +char *system_path(const char *path)
>  {
> -	static const char *prefix = PREFIX;
> -	struct strbuf d = STRBUF_INIT;
> +	char *new_path = NULL;
>
>  	if (is_absolute_path(path))
> -		return path;
> +		return strdup(path);
>
> -	strbuf_addf(&d, "%s/%s", prefix, path);
> -	path = strbuf_detach(&d, NULL);
> -	return path;
> +	new_path = malloc((strlen(PREFIX) + strlen(path) + 2));
> +	if (!new_path)
> +		die("malloc");
> +
> +	sprintf(new_path, "%s/%s", PREFIX, path);
> +	return new_path;

AFAIK strbuf allocates memory internally, so why this code is needed?

Thanks,
Namhyung
