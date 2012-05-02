Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab2ECO0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:26:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40353 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab2ECOZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:25:57 -0400
Date: Wed, 2 May 2012 15:59:13 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 09/13] perf target: Introduce perf_target_errno
Message-ID: <20120502185913.GE5745@infradead.org>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
 <1335417327-11796-10-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335417327-11796-10-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Apr 26, 2012 at 02:15:23PM +0900, Namhyung Kim escreveu:
> The perf_target_errno enumerations are used to indicate
> specific error cases on perf target operations. It'd
> help libperf being a more generic library.
> 
> Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> +	/* UID and SYSTEM are mutually exclusive */
> +	if (target->uid_str && target->system_wide) {
> +		target->system_wide = false;
> +		if (ret == PERF_TARGET__SUCCESS)
> +			ret = PERF_TARGET__UID_OVERRIDE_SYSTEM;
> +	}
> +
> +	return ret;
>  }
> diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
> index 1348065ada5e..c3914c8a9890 100644
> --- a/tools/perf/util/target.h
> +++ b/tools/perf/util/target.h
> @@ -12,6 +12,24 @@ struct perf_target {
>  	bool	     system_wide;
>  };
>  
> -void perf_target__validate(struct perf_target *target);
> +enum perf_target_errno {
> +	/*
> +	 * XXX: Just choose an arbitrary big number standard errno can't have

Here I think its better for us to use _negative_ big numbers, because
according to:

http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/errno.h.html

<quote>
Issue 6

The following new requirements on POSIX implementations derive from
alignment with the Single UNIX Specification:

The majority of the error conditions previously marked as extensions are
now mandatory, except for the STREAMS-related error conditions.

Values for errno are now required to be distinct positive values rather
than non-zero values. This change is for alignment with the ISO/IEC
9899:1999 standard.
</quote>

So system errno range is all positive, since our error enumeration is a
superset of the system one, using negative values won't ever clash.

Also it would be better to have it as PERF_ERRNO__PID_OVERRIDE_CPU, etc.

Agreed?

Anybody else with reasons not to use this ernno range scheme?

Ingo?

- Arnaldo

> +	 */
> +	__PERF_TARGET__ERRNO_START		= 0x10000,
> +
> +	PERF_TARGET__SUCCESS			= __PERF_TARGET__ERRNO_START,
> +
> +	/* for perf_target__validate() */
> +	PERF_TARGET__PID_OVERRIDE_CPU,
> +	PERF_TARGET__PID_OVERRIDE_UID,
> +	PERF_TARGET__UID_OVERRIDE_CPU,
> +	PERF_TARGET__PID_OVERRIDE_SYSTEM,
> +	PERF_TARGET__UID_OVERRIDE_SYSTEM,
> +
> +	__PERF_TARGET__ERRNO_END
> +};
> +
> +enum perf_target_errno perf_target__validate(struct perf_target *target);
>  
>  #endif /* _PERF_TARGET_H */
> -- 
> 1.7.10
