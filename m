Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2HVIUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:20:21 -0400
Received: from shutemov.name ([176.9.204.213]:58939 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2HVIUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:20:17 -0400
Date: Wed, 22 Aug 2012 11:20:15 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 4/4] tools lib traceevent: Fix strerror_r() use in
 pevent_strerror
Message-ID: <20120822082015.GA6250@shutemov.name>
References: <1345618831-9148-1-git-send-email-namhyung@kernel.org>
 <1345618831-9148-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345618831-9148-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 04:00:31PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> glibc-2.16 starts to mark the function with attribute
> warn_unused_result so that it can cause a build warning.
> 
> Since GNU version of strerror_r() can return a pointer to a string
> without setting @buf, check the return value and copy/truncate it to
> our buffer if needed.
> 
> Cc: Fredereic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

> ---
>  tools/lib/traceevent/event-parse.c | 7 ++++++-
>  tools/lib/traceevent/event-utils.h | 6 ++++++
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 1373e4cf109e..f978c59f67bf 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -4809,7 +4809,12 @@ int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
>  	const char *msg;
>  
>  	if (errnum >= 0) {
> -		strerror_r(errnum, buf, buflen);
> +		msg = strerror_r(errnum, buf, buflen);
> +		if (msg != buf) {
> +			size_t len = strlen(msg);
> +			char *c = mempcpy(buf, msg, min(buflen-1, len));
> +			*c = '\0';
> +		}
>  		return 0;
>  	}
>  
> diff --git a/tools/lib/traceevent/event-utils.h b/tools/lib/traceevent/event-utils.h
> index 08296383d1e6..bc075006966e 100644
> --- a/tools/lib/traceevent/event-utils.h
> +++ b/tools/lib/traceevent/event-utils.h
> @@ -39,6 +39,12 @@ void __vdie(const char *fmt, ...);
>  void __vwarning(const char *fmt, ...);
>  void __vpr_stat(const char *fmt, ...);
>  
> +#define min(x, y) ({				\
> +	typeof(x) _min1 = (x);			\
> +	typeof(y) _min2 = (y);			\
> +	(void) (&_min1 == &_min2);		\
> +	_min1 < _min2 ? _min1 : _min2; })
> +
>  static inline char *strim(char *string)
>  {
>  	char *ret;
> -- 
> 1.7.11.4
> 

-- 
 Kirill A. Shutemov
