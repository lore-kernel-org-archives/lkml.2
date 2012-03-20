Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab2CTMQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:16:09 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:50571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759863Ab2CTMQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:16:07 -0400
Subject: Re: [PATCH 4/4] compat: add some tracing backport work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org
In-Reply-To: <1332214021-9716-5-git-send-email-mcgrof@frijolero.org> (sfid-20120320_042820_342785_1C57CC56)
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
	 <1332214021-9716-5-git-send-email-mcgrof@frijolero.org>
	 (sfid-20120320_042820_342785_1C57CC56)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 13:16:06 +0100
Message-ID: <1332245766.3329.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In other words:

>  #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))

I'd change this to 2.6.33 so

>  #include_next <linux/tracepoint.h>

I don't have to think about this:

> +/* Backports f42c85e7 */
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> +#undef TP_STRUCT__entry
> +#define TP_STRUCT__entry(args...) args
> +#endif
> +
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
> +/* Backports 091ad365, a rename */
> +#define DECLARE_EVENT_CLASS TRACE_EVENT_TEMPLATE
> +
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> +#define TP_PROTO TPPROTO
> +#define TP_ARGS TPARGS
> +#define TP_FMT TPFMT
> +#define TP_RAW_FMT TPRAWFMT
> +#endif
> +
> +#endif


This seems worthwhile and looks good:

> +#else /* just disable tracing */
> +
> +/* Disable all tracing */
> +#undef TRACE_EVENT
> +#define TRACE_EVENT(name, proto, ...) \
> +static inline void trace_ ## name(proto) {}
> +#undef DECLARE_EVENT_CLASS
> +#define DECLARE_EVENT_CLASS(...)
> +#undef DEFINE_EVENT
> +#define DEFINE_EVENT(evt_class, name, proto, ...) \
> +static inline void trace_ ## name(proto) {}
> +
> +#define TP_PROTO(args...)  args
> +#define TP_ARGS(args...)   args
> +#define TP_CONDITION(args...)      args

That doesn't seem to be needed since these are used inside the other
macros only?

> +struct tracepoint_iter {
> +};

Not sure why that would be needed?

johannes

