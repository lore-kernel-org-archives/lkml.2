Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab2CTNyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:54:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52453 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759808Ab2CTNyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:54:12 -0400
MIME-Version: 1.0
In-Reply-To: <1332245766.3329.14.camel@jlt3.sipsolutions.net>
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
 <1332214021-9716-5-git-send-email-mcgrof@frijolero.org> <1332245766.3329.14.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 20 Mar 2012 06:53:52 -0700
X-Google-Sender-Auth: JxLr9AKcQVXWfBabS0HD0SokDbE
Message-ID: <CAB=NE6XyDDfzu71K-1ecMQ+F-0Z1iTN4OKCUjJ+E3yxvydks0Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] compat: add some tracing backport work
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 5:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> In other words:
>
>>  #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
>
> I'd change this to 2.6.33 so

I think I tried this approach as well.

>>  #include_next <linux/tracepoint.h>
>
> I don't have to think about this:
>
>> +/* Backports f42c85e7 */
>> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
>> +#undef TP_STRUCT__entry
>> +#define TP_STRUCT__entry(args...) args
>> +#endif
>> +
>> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
>> +/* Backports 091ad365, a rename */
>> +#define DECLARE_EVENT_CLASS TRACE_EVENT_TEMPLATE
>> +
>> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
>> +#define TP_PROTO TPPROTO
>> +#define TP_ARGS TPARGS
>> +#define TP_FMT TPFMT
>> +#define TP_RAW_FMT TPRAWFMT
>> +#endif
>> +
>> +#endif
>
>
> This seems worthwhile and looks good:
>
>> +#else /* just disable tracing */
>> +
>> +/* Disable all tracing */
>> +#undef TRACE_EVENT
>> +#define TRACE_EVENT(name, proto, ...) \
>> +static inline void trace_ ## name(proto) {}
>> +#undef DECLARE_EVENT_CLASS
>> +#define DECLARE_EVENT_CLASS(...)
>> +#undef DEFINE_EVENT
>> +#define DEFINE_EVENT(evt_class, name, proto, ...) \
>> +static inline void trace_ ## name(proto) {}
>> +
>> +#define TP_PROTO(args...)  args
>> +#define TP_ARGS(args...)   args
>> +#define TP_CONDITION(args...)      args
>
> That doesn't seem to be needed since these are used inside the other
> macros only?
>
>> +struct tracepoint_iter {
>> +};
>
> Not sure why that would be needed?

Sure, yeah I think I tried disabling as you suggested and ran into
compilation issues with mac80211 on 2.6.31.

  Luis
