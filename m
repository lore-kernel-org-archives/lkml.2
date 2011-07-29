Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982Ab1G2OTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:19:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1G2OTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:19:35 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=S531j9xFrh8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=ix2d7svzPLLCW1oQRRgA:9 a=hRkEWG1QU82cgbT_5AYA:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2 1/4] trace-cmd: Add parse error checking target
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1311619188-4905-1-git-send-email-vnagarnaik@google.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
	 <1311619188-4905-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 10:19:33 -0400
Message-ID: <1311949173.21143.43.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 11:39 -0700, Vaibhav Nagarnaik wrote:
> Add another target 'check-events' which parses all the event formats and
> returns whether there are any issues with the print format strings.
> 
> With an error in the format, the return value is 22 (EINVAL) and for
> success, it is 0.

Could you write up a man page for this too?


> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
> Changelog v2-v1:
> * Pass any parsing failures in pevent structure
> 
>  parse-events.h |    2 ++
>  trace-cmd.c    |   25 +++++++++++++++++++++++++
>  trace-usage.c  |    5 +++++
>  trace-util.c   |   36 ++++++++++++++++++++++++++----------
>  4 files changed, 58 insertions(+), 10 deletions(-)
> 
> diff --git a/parse-events.h b/parse-events.h
> index c32d715..f5cab15 100644
> --- a/parse-events.h
> +++ b/parse-events.h
> @@ -402,6 +402,8 @@ struct pevent {
>  	struct event_handler *handlers;
>  	struct pevent_function_handler *func_handlers;
>  
> +	int parsing_failures;
> +
>  	/* cache */
>  	struct event_format *last_event;
>  };
> diff --git a/trace-cmd.c b/trace-cmd.c
> index bff5bbf..5cfd97f 100644
> --- a/trace-cmd.c
> +++ b/trace-cmd.c
> @@ -158,6 +158,31 @@ int main (int argc, char **argv)
>  	} else if (strcmp(argv[1], "stack") == 0) {
>  		trace_stack(argc, argv);
>  		exit(0);
> +	} else if (strcmp(argv[1], "check-events") == 0) {
> +		char *tracing;
> +		int ret;
> +		struct pevent *pevent = NULL;
> +
> +		tracing = tracecmd_find_tracing_dir();
> +
> +		if (!tracing) {
> +			printf("Can not find or mount tracing directory!\n"
> +				"Either tracing is not configured for this "
> +				"kernel\n"
> +				"or you do not have the proper permissions to "
> +				"mount the directory");
> +			exit(EINVAL);
> +		}
> +
> +		ret = 0;
> +		pevent = tracecmd_local_events(tracing);
> +		if (!pevent)
> +			exit(EINVAL);
> +		if (pevent->parsing_failures)
> +			ret = EINVAL;

Hmm, what about doing:

	if (!pevent || pevent->parsing_failures)
		ret = EINVAL;



> +		pevent_free(pevent);

And allow pevent_free() to take a NULL pointer?

Hmm, I'll just apply this patch and then make the update. But could you
still send a man page patch?

Thanks!

-- Steve

> +		exit(ret);
> +
>  	} else if (strcmp(argv[1], "record") == 0 ||
>  		   strcmp(argv[1], "start") == 0 ||
>  		   strcmp(argv[1], "extract") == 0 ||
> diff --git a/trace-usage.c b/trace-usage.c
> index 39c8fc1..58ef167 100644
> --- a/trace-usage.c
> +++ b/trace-usage.c
> @@ -150,6 +150,11 @@ static struct usage_help usage_help[] = {
>  		"          --reset  reset the maximum stack found\n"
>  	},
>  	{
> +		"check-events",
> +		"parse trace event formats",
> +		" %s check-format\n"
> +	},
> +	{
>  		NULL, NULL, NULL
>  	}
>  };
> diff --git a/trace-util.c b/trace-util.c
> index 674f37e..01894f8 100644
> --- a/trace-util.c
> +++ b/trace-util.c
> @@ -621,22 +621,22 @@ static int read_file(const char *file, char **buffer)
>  	return len;
>  }
>  
> -static void load_events(struct pevent *pevent, const char *system,
> +static int load_events(struct pevent *pevent, const char *system,
>  			const char *sys_dir)
>  {
>  	struct dirent *dent;
>  	struct stat st;
>  	DIR *dir;
>  	int len = 0;
> -	int ret;
> +	int ret = 0, failure = 0;
>  
>  	ret = stat(sys_dir, &st);
>  	if (ret < 0 || !S_ISDIR(st.st_mode))
> -		return;
> +		return EINVAL;
>  
>  	dir = opendir(sys_dir);
>  	if (!dir)
> -		return;
> +		return errno;
>  
>  	while ((dent = readdir(dir))) {
>  		const char *name = dent->d_name;
> @@ -662,15 +662,18 @@ static void load_events(struct pevent *pevent, const char *system,
>  		if (len < 0)
>  			goto free_format;
>  
> -		pevent_parse_event(pevent, buf, len, system);
> +		ret = pevent_parse_event(pevent, buf, len, system);
>  		free(buf);
>   free_format:
>  		free(format);
>   free_event:
>  		free(event);
> +		if (ret)
> +			failure = ret;
>  	}
>  
>  	closedir(dir);
> +	return failure;
>  }
>  
>  static int read_header(struct pevent *pevent, const char *events_dir)
> @@ -715,7 +718,7 @@ struct pevent *tracecmd_local_events(const char *tracing_dir)
>  	char *events_dir;
>  	struct stat st;
>  	DIR *dir;
> -	int ret;
> +	int ret, failure = 0;
>  
>  	if (!tracing_dir)
>  		return NULL;
> @@ -725,21 +728,28 @@ struct pevent *tracecmd_local_events(const char *tracing_dir)
>  		return NULL;
>  
>  	ret = stat(events_dir, &st);
> -	if (ret < 0 || !S_ISDIR(st.st_mode))
> +	if (ret < 0 || !S_ISDIR(st.st_mode)) {
> +		failure = 1;
>  		goto out_free;
> +	}
>  
>  	dir = opendir(events_dir);
> -	if (!dir)
> +	if (!dir) {
> +		failure = 1;
>  		goto out_free;
> +	}
>  
>  	pevent = pevent_alloc();
> -	if (!pevent)
> +	if (!pevent) {
> +		failure = 1;
>  		goto out_free;
> +	}
>  
>  	ret = read_header(pevent, events_dir);
>  	if (ret < 0) {
>  		pevent_free(pevent);
>  		pevent = NULL;
> +		failure = 1;
>  		goto out_free;
>  	}
>  
> @@ -758,9 +768,12 @@ struct pevent *tracecmd_local_events(const char *tracing_dir)
>  			continue;
>  		}
>  
> -		load_events(pevent, name, sys);
> +		ret = load_events(pevent, name, sys);
>  
>  		free(sys);
> +
> +		if (ret)
> +			failure = 1;
>  	}
>  
>  	closedir(dir);
> @@ -768,6 +781,9 @@ struct pevent *tracecmd_local_events(const char *tracing_dir)
>   out_free:
>  	free(events_dir);
>  
> +	if (pevent)
> +		pevent->parsing_failures = failure;
> +
>  	return pevent;
>  }
>  


