Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab1GYNc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:32:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1GYNcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:32:54 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=P3cOjMdFbJwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=L3R30uPXNkQWImsK0doA:9 a=cSfQL42o8_VUKgrQ5N4A:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=Y9wJXkp8rhD2CSEq:21 a=HAgq1QJore988n05:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/4] trace-cmd: Add parse error checking target
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 09:32:53 -0400
Message-ID: <1311600773.3526.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 20:00 -0700, Vaibhav Nagarnaik wrote:
> Add another target 'check-events' which parses all the event formats and
> returns whether there are any issues with the print format strings.
> 
> With an error in the format, the return value is 22 (EINVAL) and for
> success, it is 0.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  trace-capture.c |    2 +-
>  trace-cmd.c     |   22 ++++++++++++++++++++++
>  trace-cmd.h     |    2 +-
>  trace-usage.c   |    5 +++++
>  trace-util.c    |   48 ++++++++++++++++++++++++++++++++----------------
>  5 files changed, 61 insertions(+), 18 deletions(-)
> 
> diff --git a/trace-capture.c b/trace-capture.c
> index 61ff165..5708945 100644
> --- a/trace-capture.c
> +++ b/trace-capture.c
> @@ -1295,7 +1295,7 @@ static void tracing_dialog(struct shark_info *info, const char *tracing)
>  	/* Send parse warnings to status display */
>  	trace_dialog_register_alt_warning(vpr_stat);
>  
> -	pevent = tracecmd_local_events(tracing);
> +	tracecmd_local_events(tracing, &pevent);

Ug, please no. I don't see any good reason to move the creation of a
pevent into a pointer than just return it. If you require a different
return code, or (a even better reason) that this may be called without
needing to create a pevent at all, then I can understand this. But
creating an object (sturcture) by passing its address is an anomaly of C
and I like to avoid when possible. Passing an address of a atom value
(int, long) or even maybe a string that is allocated is one thing. But
doing it with a constructor function is just plain ugly.


>  	trace_dialog_register_alt_warning(NULL);
>  
>  	cap.pevent = pevent;
> diff --git a/trace-cmd.c b/trace-cmd.c
> index bff5bbf..a2b6b91 100644
> --- a/trace-cmd.c
> +++ b/trace-cmd.c
> @@ -158,6 +158,28 @@ int main (int argc, char **argv)
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
> +		ret = tracecmd_local_events(tracing, &pevent);
> +		if (pevent)
> +			pevent_free(pevent);
> +
> +		ret ? exit(0) : exit(EINVAL);
> +

And here the code is even uglier. You just free pevent and the ret is
just a boolean!  Also, that ?: trick is even uglier.


		pevent = tracecmd_local_events(tracing);
		if (!pevent)
			exit(EINVAL);
		pevent_free(pevent);
		exit(0);

Is much more readable.

-- Steve




