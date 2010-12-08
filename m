Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0LHWWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:22:40 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:27457 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab0LHWWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:22:38 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANeT/0yrR7Ht/2dsb2JhbACjYXikOptAhUkEhGI6hVWDFA
X-IronPort-AV: E=Sophos;i="4.59,317,1288569600"; 
   d="scan'208";a="632960990"
Message-ID: <4D00052D.1020206@cisco.com>
Date: Wed, 08 Dec 2010 15:22:37 -0700
From: "David S. Ahern" <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Add symfs option for off-box analysis using
 specified tree
References: <1291776174-16535-1-git-send-email-daahern@cisco.com> <20101208205614.GD10353@ghostprotocols.net>
In-Reply-To: <20101208205614.GD10353@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/08/10 13:56, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 07, 2010 at 07:42:54PM -0700, David Ahern escreveu:
>> The symfs argument allows analysis of perf.data file using a locally
>> accessible filesystem tree with debug symbols - e.g., tree created
>> during image builds, sshfs mount, loop mounted KVM disk images,
>> USB keys, initrds, etc. Anything with an OS tree can be analyzed from
>> anywhere without the need to populate a local data store with
>> build-ids.
>>
>> Signed-off-by: David Ahern <daahern@cisco.com>
>> ---
>>  tools/perf/builtin-annotate.c  |   16 +++++--
>>  tools/perf/builtin-diff.c      |    2 +
>>  tools/perf/builtin-report.c    |    2 +
>>  tools/perf/builtin-timechart.c |    2 +
>>  tools/perf/util/hist.c         |   14 +++++-
>>  tools/perf/util/symbol.c       |   82 +++++++++++++++++++++++++---------------
>>  tools/perf/util/symbol.h       |    1 +
>>  7 files changed, 80 insertions(+), 39 deletions(-)
>>
>> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
>> index 569a276..0c47bee 100644
>> --- a/tools/perf/builtin-annotate.c
>> +++ b/tools/perf/builtin-annotate.c
>> @@ -280,7 +280,8 @@ static int hist_entry__tty_annotate(struct hist_entry *he)
>>  	struct map *map = he->ms.map;
>>  	struct dso *dso = map->dso;
>>  	struct symbol *sym = he->ms.sym;
>> -	const char *filename = dso->long_name, *d_filename;
>> +	const char *filename = dso->long_name;
>> +	char d_filename[PATH_MAX];
>>  	u64 len;
>>  	LIST_HEAD(head);
>>  	struct objdump_line *pos, *n;
>> @@ -288,10 +289,13 @@ static int hist_entry__tty_annotate(struct hist_entry *he)
>>  	if (hist_entry__annotate(he, &head, 0) < 0)
>>  		return -1;
>>  
>> -	if (full_paths)
>> -		d_filename = filename;
>> -	else
>> -		d_filename = basename(filename);
>> +	if (full_paths) {
>> +		snprintf(d_filename, sizeof(d_filename), "%s%s",
>> +			 symbol_conf.symfs, filename);
>> +	} else {
>> +		snprintf(d_filename, sizeof(d_filename), "%s/%s",
>> +			 symbol_conf.symfs, basename(filename));
>> +	}
> 
> Are you sure about the one above? I guess you don't need to concat here,
> its just informative message, if you're using --symfs, you know
> everything is from there, and in the !full_paths case the resulting
> filename will be bogus, right?

Ok. I removed.

>   
>>  	len = sym->end - sym->start;
>>  
>> @@ -437,6 +441,8 @@ static const struct option options[] = {
>>  		    "print matching source lines (may be slow)"),
>>  	OPT_BOOLEAN('P', "full-paths", &full_paths,
>>  		    "Don't shorten the displayed pathnames"),
>> +	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>> +		    "Look for files with symbols relative to this directory"),
>>  	OPT_END()
>>  };

In which case the above is not needed.

>> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
>> index 2022e87..b24ae53 100644
>> --- a/tools/perf/util/hist.c
>> +++ b/tools/perf/util/hist.c
>> @@ -1092,6 +1092,12 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
>>  	FILE *file;
>>  	int err = 0;
>>  	u64 len;
>> +	char symfs_filename[PATH_MAX];
>> +
>> +	if (filename) {
>> +		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
>> +		 symbol_conf.symfs, filename);
> 
> Above you have tab/space damage

fixed

> 
>> +	}
>>  
>>  	if (filename == NULL) {
>>  		if (dso->has_build_id) {
>> @@ -1100,9 +1106,9 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
>>  			return -ENOMEM;
>>  		}
>>  		goto fallback;
>> -	} else if (readlink(filename, command, sizeof(command)) < 0 ||
>> +	} else if (readlink(symfs_filename, command, sizeof(command)) < 0 ||
>>  		   strstr(command, "[kernel.kallsyms]") ||
>> -		   access(filename, R_OK)) {
>> +		   access(symfs_filename, R_OK)) {
>>  		free(filename);
>>  fallback:
>>  		/*
>> @@ -1111,6 +1117,8 @@ fallback:
>>  		 * DSO is the same as when 'perf record' ran.
>>  		 */
>>  		filename = dso->long_name;
>> +		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
>> +		 symbol_conf.symfs, filename);
> 
> Ditto above

fixed

> 
>>  		free_filename = false;
>>  	}
>>  
>> @@ -1137,7 +1145,7 @@ fallback:
>>  		 "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS -C %s|grep -v %s|expand",
>>  		 map__rip_2objdump(map, sym->start),
>>  		 map__rip_2objdump(map, sym->end),
>> -		 filename, filename);
>> +		 symfs_filename, filename);
>>  
>>  	pr_debug("Executing: %s\n", command);
>>  
>> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
>> index a348906..7a0d284 100644
>> --- a/tools/perf/util/symbol.c
>> +++ b/tools/perf/util/symbol.c
>> @@ -41,6 +41,7 @@ struct symbol_conf symbol_conf = {
>>  	.exclude_other	  = true,
>>  	.use_modules	  = true,
>>  	.try_vmlinux_path = true,
>> +	.symfs           = "",
>>  };
>>  
>>  int dso__name_len(const struct dso *self)
>> @@ -833,8 +834,11 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
>>  	char sympltname[1024];
>>  	Elf *elf;
>>  	int nr = 0, symidx, fd, err = 0;
>> +	char name[PATH_MAX];
>>  
>> -	fd = open(self->long_name, O_RDONLY);
>> +	snprintf(name, sizeof(name), "%s%s",
>> +		 symbol_conf.symfs, self->long_name);
>> +	fd = open(name, O_RDONLY);
>>  	if (fd < 0)
>>  		goto out;
>>  
>> @@ -1446,16 +1450,19 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
>>  	     self->origin++) {
>>  		switch (self->origin) {
>>  		case DSO__ORIG_BUILD_ID_CACHE:
>> -			if (dso__build_id_filename(self, name, size) == NULL)
>> +			/* skip the locally configured cache if a symfs is given */
>> +			if ((strlen(symbol_conf.symfs) != 0) ||
> 
> I suggest you use:
> 
> 			if (symbol_conf.symfs[1] ||
> 
> cheaper :)

Changed. I presume you meant: symbol_conf.symfs[0]  -- ie., element 0
has something other than '\0' which means strlen > 0

...

>> @@ -1778,17 +1786,20 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
>>  			     const char *vmlinux, symbol_filter_t filter)
>>  {
>>  	int err = -1, fd;
>> +	char symfs_vmlinux[PATH_MAX];
>> -	fd = open(vmlinux, O_RDONLY);
>> +	snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s/%s",
>> +		 symbol_conf.symfs, vmlinux);
> 
> Its userspace, so stack is plenty, but I guess if using asprintf
> wouldn't be better...
> 
> I.e. if we were programming some kernel module, creating a 4K stack
> variable would be considered bad practice, so I think it is here as
> well.

Declaring symfs_vmlinux on the stack is consistent with other PATH_MAX
declarations within perf, and especially within util/symbol.c.

>   
>> +	fd = open(symfs_vmlinux, O_RDONLY);
>>  	if (fd < 0)
>>  		return -1;
>>  
>>  	dso__set_loaded(self, map->type);
>> -	err = dso__load_sym(self, map, vmlinux, fd, filter, 0, 0);
>> +	err = dso__load_sym(self, map, symfs_vmlinux, fd, filter, 0, 0);
>>  	close(fd);
>>  
>>  	if (err > 0)
>> -		pr_debug("Using %s for symbols\n", vmlinux);
>> +		pr_debug("Using %s for symbols\n", symfs_vmlinux);
>>  
>>  	return err;
>>  }
>> @@ -1861,6 +1872,10 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
>>  			goto out_fixup;
>>  	}
>>  
>> +	/* do not try local files if a symfs was given */
>> +	if (strlen(symbol_conf.symfs) != 0)
>> +		return -1;
>> +

changed that strlen as well.


>>  	/*
>>  	 * Say the kernel DSO was created when processing the build-id header table,
>>  	 * we have a build-id, so check if it is the same as the running kernel,
>> @@ -2210,9 +2225,6 @@ static int vmlinux_path__init(void)
>>  	struct utsname uts;
>>  	char bf[PATH_MAX];
>>  
>> -	if (uname(&uts) < 0)
>> -		return -1;
>> -
>>  	vmlinux_path = malloc(sizeof(char *) * 5);
>>  	if (vmlinux_path == NULL)
>>  		return -1;
>> @@ -2225,22 +2237,30 @@ static int vmlinux_path__init(void)
>>  	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
>>  		goto out_fail;
>>  	++vmlinux_path__nr_entries;
>> -	snprintf(bf, sizeof(bf), "/boot/vmlinux-%s", uts.release);
>> -	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
>> -	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
>> -		goto out_fail;
>> -	++vmlinux_path__nr_entries;
>> -	snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux", uts.release);
>> -	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
>> -	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
>> -		goto out_fail;
>> -	++vmlinux_path__nr_entries;
>> -	snprintf(bf, sizeof(bf), "/usr/lib/debug/lib/modules/%s/vmlinux",
>> -		 uts.release);
>> -	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
>> -	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
>> -		goto out_fail;
>> -	++vmlinux_path__nr_entries;
>> +
>> +	/* if no symfs has been given try running kernel version too */
>> +	if (strlen(symbol_conf.symfs) == 0) {
> 
> Do it as:
> 
> 	if (!symbol_conf.symfs[1])
> 		return 0;
> 
> And then the patch can be made smaller.

Done.


I also added the symfs option to the Documentation files. Will send an
updated patch.

David
