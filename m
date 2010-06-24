Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0FXG3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:29:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:26170 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab0FXG3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:29:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,472,1272870000"; 
   d="scan'208";a="292457557"
Subject: Re: [PATCH] perf: close the opened directories.
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: acme@ghostprotocols.net, mingo@elte.hu,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <4C1C3F7C.4030607@cn.fujitsu.com>
References: <4C1C3F7C.4030607@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 24 Jun 2010 14:29:25 +0800
Message-Id: <1277360965.2096.881.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-19 at 11:54 +0800, Gui Jianfeng wrote:
> When I ran "perf kvm ... top", I encountered the following error output.
> 
>   Error: perfcounter syscall returned with -1 (Too many open files)
> 
>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> Looking into perf, I found perf opens too many direcotries at initialization
> time, but forgets to close them. Here is the fix.
Good catch!

> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  tools/perf/util/symbol.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 7fd6b15..a00dcad 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1443,6 +1443,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
>  {
>  	struct dirent *dent;
>  	DIR *dir = opendir(dir_name);
> +	int ret = 0;
>  
>  	if (!dir) {
>  		pr_debug("%s: cannot open %s dir\n", __func__, dir_name);
> @@ -1465,8 +1466,10 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
>  
>  			snprintf(path, sizeof(path), "%s/%s",
>  				 dir_name, dent->d_name);
> -			if (map_groups__set_modules_path_dir(self, path) < 0)
> -				goto failure;
> +			if (map_groups__set_modules_path_dir(self, path) < 0) {
> +				ret = -1;
> +				goto out;
> +			}
How about changing above to:
			ret = map_groups__set_modules_path_dir(self, path);
			if (ret < 0)
				goto out;



>  		} else {
>  			char *dot = strrchr(dent->d_name, '.'),
>  			     dso_name[PATH_MAX];
> @@ -1487,17 +1490,18 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
>  				 dir_name, dent->d_name);
>  
>  			long_name = strdup(path);
> -			if (long_name == NULL)
> -				goto failure;
> +			if (long_name == NULL) {
> +				ret = -1;
> +				goto out;
> +			}
>  			dso__set_long_name(map->dso, long_name);
>  			dso__kernel_module_get_build_id(map->dso, "");
>  		}
>  	}
>  
> -	return 0;
> -failure:
> +out:
>  	closedir(dir);
> -	return -1;
> +	return ret;
>  }
>  
>  static char *get_kernel_version(const char *root_dir)


