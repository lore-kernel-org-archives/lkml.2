Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2J2OIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:08:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab2J2OIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:08:21 -0400
Date: Mon, 29 Oct 2012 12:06:20 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 7/8] perf hists browser: Add option for runtime
 switching perf data file
Message-ID: <20121029140620.GD6754@infradead.org>
References: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
 <1351569369-26732-8-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351569369-26732-8-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 30, 2012 at 11:56:08AM +0800, Feng Tang escreveu:
> +	pwd_dir = opendir(pwd);
> +	if (!pwd_dir)
> +		return ret;
> +
> +	memset(options, 0, sizeof(options));
> +	memset(options, 0, sizeof(abs_path));
> +
> +	while ((dent = readdir(pwd_dir))) {
> +		char path[PATH_MAX];
> +		u64 magic;
> +		char *name = dent->d_name;
> +		FILE *file;
> +
> +		if (!(dent->d_type == DT_REG))
> +			continue;
> +
> +		snprintf(path, PATH_MAX, "%s/%s", pwd, name);
> +
> +		file = fopen(path, "r");
> +		if (!file)
> +			continue;
> +
> +		if (fread(&magic, 1, 8, file) < 8)
> +			goto close_file_and_continue;
> +
> +		if (is_perf_magic(magic)) {
> +			options[nr_options] = strdup(name);
> +			if (!options[nr_options])
> +				goto close_file_and_continue;

Silently not offering a valid file? At this point I think you should
warn the user and bail out.

> +
> +			abs_path[nr_options] = strdup(path);
> +			if (!abs_path[nr_options]) {
> +				free(options[nr_options]);
> +				goto close_file_and_continue;
> +			}
> +
> +			nr_options++;
> +		}
> +
> +close_file_and_continue:
> +		fclose(file);
> +		if (nr_options >= 256)
> +			break;

Why is this? At the very least a warning has to be given to the user
that way too many perf.data files are present, so only the first N are
in the menu.

> +	}
> +	closedir(pwd_dir);
> +
> +	if (nr_options) {
> +		choice = ui__popup_menu(nr_options, options);
> +		if (choice < nr_options && choice >= 0) {
> +			tmp = strdup(abs_path[choice]);
> +			if (tmp) {
> +				if (is_input_name_malloced)
> +					free((void *)input_name);
> +				input_name = tmp;
> +				is_input_name_malloced = true;
> +				ret = 0;
> +			}

Here you return an error, but will the user get any warning on the
caller of this function if it returns -1?


> +		/* Switch to another data file */
> +		else if (choice == switch_data) {
> +do_data_switch:
> +			if (!switch_data_file()) {
> +				key = K_SWITCH_INPUT_DATA;
> +				break;
> +			}
> +		}

... no, so it will silently continue and the user will get confused.

>  	}
>  out_free_stack:
>  	pstack__delete(fstack);
> @@ -1563,6 +1666,7 @@ browse_hists:
>  						"Do you really want to exit?"))
>  					continue;
>  				/* Fall thru */
> +			case K_SWITCH_INPUT_DATA:
>  			case 'q':
>  			case CTRL('c'):
>  				goto out;
> diff --git a/tools/perf/ui/keysyms.h b/tools/perf/ui/keysyms.h
> index 809eca5..65092d5 100644
> --- a/tools/perf/ui/keysyms.h
> +++ b/tools/perf/ui/keysyms.h
> @@ -23,5 +23,6 @@
>  #define K_TIMER	 -1
>  #define K_ERROR	 -2
>  #define K_RESIZE -3
> +#define K_SWITCH_INPUT_DATA -4
>  
>  #endif /* _PERF_KEYSYMS_H_ */
> -- 
> 1.7.9.5
