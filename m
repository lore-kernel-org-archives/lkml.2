Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2IGGdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:33:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47680 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2IGGdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:33:17 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-45-5049952b30c1
From: Namhyung Kim <namhyung@kernel.org>
To: liang xie <xieliang007@gmail.com>
Cc: acme@ghostprotocols.net, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, balbi@ti.com, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] A trivial memory leak fix while calling system_path
References: <CADu=CFpMKkAW5+=Us9J2GOxZTBDN91FTeteCgbyh8c7fsP837g@mail.gmail.com>
Date: Fri, 07 Sep 2012 15:26:00 +0900
In-Reply-To: <CADu=CFpMKkAW5+=Us9J2GOxZTBDN91FTeteCgbyh8c7fsP837g@mail.gmail.com>
	(liang xie's message of "Fri, 7 Sep 2012 11:34:49 +0800")
Message-ID: <87oblibb7r.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, liang

On Fri, 7 Sep 2012 11:34:49 +0800, liang xie wrote:
> A trivial memory leak fix while calling system_path
>
> Since v1: Remove an unnecessary null pointer check per Felipe's comments
>
> Signed-off-by: Liang Xie <xieliang@xiaomi.com>
> ---
>  tools/perf/util/exec_cmd.c |    4 +++-
>  tools/perf/util/help.c     |    1 +
>  2 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
> index 7adf4ad..d041407 100644
> --- a/tools/perf/util/exec_cmd.c
> +++ b/tools/perf/util/exec_cmd.c
> @@ -83,8 +83,9 @@ void setup_path(void)
>  {
>  	const char *old_path = getenv("PATH");
>  	struct strbuf new_path = STRBUF_INIT;
> +	const char *exec_path = perf_exec_path();
>
> -	add_path(&new_path, perf_exec_path());
> +	add_path(&new_path, exec_path);
>  	add_path(&new_path, argv0_path);
>
>  	if (old_path)
> @@ -95,6 +96,7 @@ void setup_path(void)
>  	setenv("PATH", new_path.buf, 1);
>
>  	strbuf_release(&new_path);
> +	free((void *)exec_path);
>  }

The problem is that perf_exec_path() can return a non-dynamically
allocated string (e.g. command line argument or environment string) and
currently we cannot know where the returned string is came from.

It might cause much more troubles when you free that kind of string than
just leaking a couple of bytes IMHO.

Thanks,
Namhyung

>
>  static const char **prepare_perf_cmd(const char **argv)
> diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
> index 6f2975a..798f66d 100644
> --- a/tools/perf/util/help.c
> +++ b/tools/perf/util/help.c
> @@ -187,6 +187,7 @@ void load_command_list(const char *prefix,
>  		uniq(other_cmds);
>  	}
>  	exclude_cmds(other_cmds, main_cmds);
> +	free((void *)exec_path);
>  }
>
>  void list_commands(const char *title, struct cmdnames *main_cmds,
