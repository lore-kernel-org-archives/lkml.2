Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2IDBRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 21:17:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62221 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab2IDBRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 21:17:30 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-7a-504556a7a4b5
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] perf scripts: Export a find_scripts() function
References: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
	<1346660073-20279-5-git-send-email-feng.tang@intel.com>
Date: Tue, 04 Sep 2012 10:09:56 +0900
In-Reply-To: <1346660073-20279-5-git-send-email-feng.tang@intel.com> (Feng
	Tang's message of "Mon, 3 Sep 2012 16:14:30 +0800")
Message-ID: <87ipbuegpn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Sep 2012 16:14:30 +0800, Feng Tang wrote:
> So that other perf commands/browser has a way to dig out the available
> scripts info in system, this is a preparation for the script browser.
>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  tools/perf/builtin-script.c |   46 +++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/builtin.h        |    1 +
>  2 files changed, 47 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 7ab86bb..d46056c 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -1031,6 +1031,52 @@ static int list_available_scripts(const struct option *opt __used,
>  	exit(0);
>  }
>  
> +/*
> + * Return 0 if none is found, otherwise the actual scripts number.
> + *
> + * Currently we just return all the raw scripts name, and their full path.
> + *
> + */
> +int find_scripts(char **scripts_array, char **scripts_path_array)
> +{
> +	struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
> +	char scripts_path[MAXPATHLEN];
> +	DIR *scripts_dir, *lang_dir;
> +	char lang_path[MAXPATHLEN];
> +	struct script_desc *desc;
> +	char first_half[BUFSIZ];
> +	char *temp;
> +	int i = 0;
> +
> +	first_half[0] = 0;
> +	desc = NULL;
> +
> +	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
> +
> +	scripts_dir = opendir(scripts_path);
> +	if (!scripts_dir)
> +		return -1;
> +
> +	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {

It'd be better if checking language supported - ie. by NO_LIBPERL and/or
NO_LIBPYTHON macro rather than showing all regardless.  Also you might
consider when perf was built with no script language support.

Thanks,
Namhyung


> +		snprintf(lang_path, MAXPATHLEN, "%s/%s", scripts_path,
> +			 lang_dirent.d_name);
> +		lang_dir = opendir(lang_path);
> +		if (!lang_dir)
> +			continue;
> +
> +		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
> +			sprintf(scripts_path_array[i], "%s/%s", lang_path,
> +				script_dirent.d_name);
> +			temp = strchr(script_dirent.d_name, '.');
> +			snprintf(scripts_array[i], (temp - script_dirent.d_name) + 1,
> +				"%s", script_dirent.d_name);
> +			i++;
> +		}
> +	}
> +
> +	return i;
> +}
> +
>  static char *get_script_path(const char *script_root, const char *suffix)
>  {
>  	struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
> diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
> index b382bd5..3ea74ed 100644
> --- a/tools/perf/builtin.h
> +++ b/tools/perf/builtin.h
> @@ -36,4 +36,5 @@ extern int cmd_kvm(int argc, const char **argv, const char *prefix);
>  extern int cmd_test(int argc, const char **argv, const char *prefix);
>  extern int cmd_inject(int argc, const char **argv, const char *prefix);
>  
> +extern int find_scripts(char **scripts_array, char **scripts_path_array);
>  #endif
