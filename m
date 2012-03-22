Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab2CVE3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 00:29:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33467 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2CVE3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 00:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XyDDfzu71K-1ecMQ+F-0Z1iTN4OKCUjJ+E3yxvydks0Q@mail.gmail.com>
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
 <1332214021-9716-5-git-send-email-mcgrof@frijolero.org> <1332245766.3329.14.camel@jlt3.sipsolutions.net>
 <CAB=NE6XyDDfzu71K-1ecMQ+F-0Z1iTN4OKCUjJ+E3yxvydks0Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 21 Mar 2012 21:29:09 -0700
X-Google-Sender-Auth: 60pvnlwjGmWdIxacATJVAeHPX-8
Message-ID: <CAB=NE6XXd-T5B37Cc_eCwnWHRk-_UVn0JY0mQjzMQcK+ZcLuWQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] compat: add some tracing backport work
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 6:53 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Tue, Mar 20, 2012 at 5:16 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> Sure, yeah I think I tried disabling as you suggested and ran into
> compilation issues with mac80211 on 2.6.31.

I tested again by only having this:


mcgrof@tux ~/compat (git::master)$ cat include/linux/tracepoint.h
#ifndef _COMPAT_LINUX_TRACEPOINT_H
#define _COMPAT_LINUX_TRACEPOINT_H 1

#include <linux/version.h>

#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,33))

#include_next <linux/tracepoint.h>

#else /* just disable tracing */

/* Disable all tracing */
#undef TRACE_EVENT
#define TRACE_EVENT(name, proto, ...) \
static inline void trace_ ## name(proto) {}
#undef DECLARE_EVENT_CLASS
#define DECLARE_EVENT_CLASS(...)
#undef DEFINE_EVENT
#define DEFINE_EVENT(evt_class, name, proto, ...) \
static inline void trace_ ## name(proto) {}

#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,33)) */

#endif	/* _COMPAT_LINUX_TRACEPOINT_H */

And then by using compat-wireless tag
compat-wireless-2012-03-14-3-g98cc995 against linux-next tag
next-20120314 I can only compile up to 2.6.34. Anything older I get
compilation errors which seem to point to somehow DEFINE_EVENT()
failing.

./scripts/gen-compat-autoconf.sh
/home/mcgrof/devel/compat-wireless/.config
/home/mcgrof/devel/compat-wireless/config.mk >
include/linux/compat_autoconf.h
make -C /lib/modules/2.6.33-02063305-generic/build
M=/home/mcgrof/devel/compat-wireless modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.33-02063305-generic'
  CC [M]  /home/mcgrof/devel/compat-wireless/compat/main.o
In file included from include/linux/kmemtrace.h:12:0,
                 from include/linux/slub_def.h:13,
                 from include/linux/slab.h:162,
                 from include/linux/percpu.h:5,
                 from
/usr/src/linux-headers-2.6.33-02063305-generic/arch/x86/include/asm/local.h:4,
                 from include/linux/module.h:20,
                 from include/linux/textsearch.h:7,
                 from include/linux/skbuff.h:27,
                 from include/linux/if_ether.h:124,
                 from include/linux/netdevice.h:29,
                 from
/home/mcgrof/devel/compat-wireless/include/linux/compat-2.6.29.h:5,
                 from
/home/mcgrof/devel/compat-wireless/include/linux/compat-2.6.h:49,
                 from <command-line>:1:
include/trace/events/kmem.h:81:11: error: expected ‘)’ before ‘(’ token

Now this kmem.h line 81 has:

DEFINE_EVENT(kmem_alloc, kmalloc,

        TP_PROTO(unsigned long call_site, const void *ptr,
                 size_t bytes_req, size_t bytes_alloc, gfp_t gfp_flags),

        TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags)
);

This is then fixed by adding TP_PROTO and TP_ARGS to our backport:

#define TP_PROTO(args...)  args
#define TP_ARGS(args...)   args
#define TP_CONDITION(args...)      args

But then we get:

./scripts/gen-compat-autoconf.sh
/home/mcgrof/devel/compat-wireless/.config
/home/mcgrof/devel/compat-wireless/config.mk >
include/linux/compat_autoconf.h
make -C /lib/modules/2.6.33-02063305-generic/build
M=/home/mcgrof/devel/compat-wireless modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.33-02063305-generic'
  CC [M]  /home/mcgrof/devel/compat-wireless/compat/main.o
In file included from include/linux/kmemtrace.h:12:0,
                 from include/linux/slub_def.h:13,
                 from include/linux/slab.h:162,
                 from include/linux/percpu.h:5,
                 from
/usr/src/linux-headers-2.6.33-02063305-generic/arch/x86/include/asm/local.h:4,
                 from include/linux/module.h:20,
                 from include/linux/textsearch.h:7,
                 from include/linux/skbuff.h:27,
                 from include/linux/if_ether.h:124,
                 from include/linux/netdevice.h:29,
                 from
/home/mcgrof/devel/compat-wireless/include/linux/compat-2.6.29.h:5,
                 from
/home/mcgrof/devel/compat-wireless/include/linux/compat-2.6.h:49,
                 from <command-line>:1:
include/trace/events/kmem.h:292:41: error: expected ‘)’ before ‘(’ token

And also:

include/linux/module.h:543:47: warning: ‘struct tracepoint_iter’
declared inside parameter list
include/linux/module.h:543:47: warning: its scope is only this
definition or declaration, which is probably not what you want
make[3]: *** [/home/mcgrof/devel/compat-wireless/compat/main.o] Error 1
make[2]: *** [/home/mcgrof/devel/compat-wireless/compat] Error 2
make[1]: *** [_module_/home/mcgrof/devel/compat-wireless] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.33-02063305-generic'
make: *** [modules] Error 2

I'm trying to work my way through disabling this properly but haven't
figured out yet how. I tried adding:

#undef DECLARE_TRACE
#define DECLARE_TRACE(name, proto, ...) \
static inline void trace_ ## name(proto) {}

#undef DEFINE_EVENT_PRINT
#define DEFINE_EVENT_PRINT(template, name, proto, args, print)  \
        DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))

But no dice. I then figured it may be my kernel with
CONFIG_TRACEPOINTS=y and indeed that is the case -- so we have to
consider the case where the target kernel may have tracing enabled and
we have to disable it somehow. Undef'ing CONFIG_TRACEPOINTS and
DECLARE_TRACE doesn't really do it.

We may need to redefine each macro to some COMPAT_TRACE_ macro, not sure yet.

  Luis
