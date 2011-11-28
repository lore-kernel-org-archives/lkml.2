Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab1K1QYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:24:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1K1QYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:24:07 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=xB0wigvs-loA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=6jxBsJtdXEPMm902llQA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 2/9] ftrace: Fix possible NULL dereferencing in
 __ftrace_hash_rec_update
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
In-Reply-To: <1322417074-5834-3-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 11:24:05 -0500
Message-ID: <1322497445.17003.3.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-27 at 19:04 +0100, Jiri Olsa wrote:
> We need to check the existence of the other_hash before
> we touch its count variable.
> 
> This issue is hit only when non global ftrace_ops is used.
> The global ftrace_ops is initialized with empty hashes.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/ftrace.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index b1e8943..c6d0293 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1372,7 +1372,8 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
>  			if (filter_hash && in_hash && !in_other_hash)
>  				match = 1;
>  			else if (!filter_hash && in_hash &&
> -				 (in_other_hash || !other_hash->count))
> +				 (in_other_hash ||
> +				  !other_hash || !other_hash->count))

Thanks! I hit this bug in too many places. I need to make a helper
routine, which I think I will, that is:

	hash_has_contents(hash)

that does the check for us.

-- Steve

>  				match = 1;
>  		}
>  		if (!match)


