Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1D2PQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:16:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54136 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1D2PQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:16:35 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=GPsPEGSQmmoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=0-WoEn4_7WLqidlhl74A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC 3/3] tracing: set_ftrace_filter support
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1304088194-6214-4-git-send-email-jolsa@redhat.com>
References: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
	 <1304088194-6214-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Apr 2011 11:16:33 -0400
Message-ID: <1304090193.18763.276.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 16:43 +0200, Jiri Olsa wrote:
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index b12f5df..9ce3484 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -164,6 +164,9 @@ struct dyn_ftrace {
>                 unsigned long           flags;
>                 struct dyn_ftrace       *newlist;
>         };
> +       unsigned long                   filter;
> +       unsigned long                   no_trace;
> +       unsigned long                   addr;
>         struct dyn_arch_ftrace          arch;
>  };
>   

Big Fricken NACK!

Absolutely not! The dyn_ftrace structure is allocated for almost every
single function in the kernel. Any function that can be traced has this
structure allocated.

On my box I have:

# cat /debug/tracing/dyn_ftrace_total_info 
32605 0 0

That's 32,605 functions that can be traced, which turns to be 32,605
dyn_ftrace structs allocated. Now this number is after all modules have
been loaded. You added 3 longs, on 64 bit boxes that's 24 bytes, you
just increased the function tracer footprint by 782,520 bytes!

I'm working around not touching that structure, and I will continue to
NAK any changes that increases its size. Actually, I did touch that
structure, but I did not increase the size of it.

-- Steve



