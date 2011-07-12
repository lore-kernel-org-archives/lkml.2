Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1GLW47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:56:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55306 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab1GLW46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:56:58 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=NyiLX209gCUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=cm27Pg_UAAAA:8 a=wpG1aJ3ptb5VdpW5lg4A:9 a=PUjeQqilurYA:10 a=zv9_9hqRWm8A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] [RFC] perf: robustify proc and debugfs file recording
From: Steven Rostedt <rostedt@goodmis.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: acme@redhat.com, anton@samba.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org>
References: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 12 Jul 2011 18:56:55 -0400
Message-ID: <1310511415.3931.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 14:15 -0700, Sonny Rao wrote:
> While attempting to create a timechart of boot up I found
> perf didn't tolerate modules being loaded/unloaded.  This patch
> fixes this by reading the file once and then writing the size
> read at the correct point in the file.  It also simplifies the
> code somewhat.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>

>  static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
> @@ -338,14 +292,8 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
>  		sprintf(format, "%s/%s/format", sys, dent->d_name);
>  		ret = stat(format, &st);
>  
> -		if (ret >= 0) {
> -			/* unfortunately, you can not stat debugfs files for size */
> -			size = get_size(format);
> -			write_or_die(&size, 8);
> -			check_size = copy_file(format);
> -			if (size != check_size)
> -				die("error in size of file '%s'", format);

You mean to tell me that you are hitting a race between the get_size()
and check_size()?  This is a very quick action, and this only happens at
start up. Are you starting up perf and loading modules at the same time?

-- Steve

> -		}
> +		if (ret >= 0)
> +			record_file(format, 8);
>  
>  		free(format);


