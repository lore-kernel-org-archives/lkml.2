Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0KUAsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:48:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56268 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0KUAsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:48:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=fFS/oMIb3HgYIHLn3vkD2vI3qe1qmVLSSh4NAkgDLXkzZMluPk5rsAAp3cbYwIU+/3
         Zv7qjr6AIMzQQ6ho6cPcVY4eRFtAHRlVT0a90dtS48grHx2z4y7Ct/DPrZVdFajUjkyK
         je2WYJOl9GpzsFYsNH9Jj6mwMkCW32L9LzOWY=
Date: Sat, 20 Nov 2010 22:48:36 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Handle DT_UNKNOWN on filesystems that don't
	support d_type
Message-ID: <20101121004836.GA16668@ghostprotocols.net>
References: <1290300139-2695-1-git-send-email-sbohrer@rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290300139-2695-1-git-send-email-sbohrer@rgmadvisors.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Nov 20, 2010 at 06:42:19PM -0600, Shawn Bohrer escreveu:
> Some filesystems like xfs and reiserfs will return DT_UNKNOWN for the
> d_type.  Handle this case by calling stat() to determine the type.

Thanks for the fix, just waiting for some more reviewers to chime in,
seems odd, like readdir_r has a bug.

Even if that is the case we'll have to cope, and doing the extra stat
only when in "doubt" (i.e. when getting DT_UNKNOWN) seems the right
thing to me.

- Arnaldo
 
> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> ---
>  tools/perf/builtin-trace.c |   35 +++++++++++++++++++++++++++--------
>  1 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index 86cfe38..9cb24fa 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -301,17 +301,36 @@ static int parse_scriptname(const struct option *opt __used,
>  	return 0;
>  }
>  
> -#define for_each_lang(scripts_dir, lang_dirent, lang_next)		\
> +/* Helper function for filesystems that return a dent->d_type DT_UNKNOWN */
> +static int is_directory(const char *base_path, const struct dirent *dent)
> +{
> +	char path[PATH_MAX];
> +	struct stat st;
> +
> +	sprintf(path, "%s/%s", base_path, dent->d_name);
> +	if (stat(path, &st))
> +		return 0;
> +
> +	return S_ISDIR(st.st_mode);
> +}
> +
> +#define for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next)\
>  	while (!readdir_r(scripts_dir, &lang_dirent, &lang_next) &&	\
>  	       lang_next)						\
> -		if (lang_dirent.d_type == DT_DIR &&			\
> +		if (((lang_dirent.d_type == DT_DIR &&			\
> +		      lang_dirent.d_type != DT_UNKNOWN) ||		\
> +		     (lang_dirent.d_type == DT_UNKNOWN &&		\
> +		      is_directory(scripts_path, &lang_dirent))) &&	\
>  		    (strcmp(lang_dirent.d_name, ".")) &&		\
>  		    (strcmp(lang_dirent.d_name, "..")))
>  
> -#define for_each_script(lang_dir, script_dirent, script_next)		\
> +#define for_each_script(lang_path, lang_dir, script_dirent, script_next)\
>  	while (!readdir_r(lang_dir, &script_dirent, &script_next) &&	\
>  	       script_next)						\
> -		if (script_dirent.d_type != DT_DIR)
> +		if ((script_dirent.d_type != DT_DIR &&			\
> +		     script_dirent.d_type != DT_UNKNOWN) ||		\
> +		    (script_dirent.d_type == DT_UNKNOWN &&		\
> +		     !is_directory(lang_path, &script_dirent)))
>  
>  
>  #define RECORD_SUFFIX			"-record"
> @@ -466,14 +485,14 @@ static int list_available_scripts(const struct option *opt __used,
>  	if (!scripts_dir)
>  		return -1;
>  
> -	for_each_lang(scripts_dir, lang_dirent, lang_next) {
> +	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {
>  		snprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
>  			 lang_dirent.d_name);
>  		lang_dir = opendir(lang_path);
>  		if (!lang_dir)
>  			continue;
>  
> -		for_each_script(lang_dir, script_dirent, script_next) {
> +		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
>  			script_root = strdup(script_dirent.d_name);
>  			str = ends_with(script_root, REPORT_SUFFIX);
>  			if (str) {
> @@ -514,14 +533,14 @@ static char *get_script_path(const char *script_root, const char *suffix)
>  	if (!scripts_dir)
>  		return NULL;
>  
> -	for_each_lang(scripts_dir, lang_dirent, lang_next) {
> +	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {
>  		snprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
>  			 lang_dirent.d_name);
>  		lang_dir = opendir(lang_path);
>  		if (!lang_dir)
>  			continue;
>  
> -		for_each_script(lang_dir, script_dirent, script_next) {
> +		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
>  			__script_root = strdup(script_dirent.d_name);
>  			str = ends_with(__script_root, suffix);
>  			if (str) {
> -- 
> 1.7.2.3
