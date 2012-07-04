Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254Ab2GDKW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:22:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:39241 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030241Ab2GDKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:22:22 -0400
Subject: Re: [PATCH 04/10] perf, x86: Making hardware events translations
 available in sysfs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341352848-11833-5-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	 <1341352848-11833-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 12:22:10 +0200
Message-ID: <1341397330.2507.85.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
> +#define PMU_EVENTS_ATTR_CONFIG(_name, _id)                             \
> +static ssize_t                                                         \
> +_name##_show(struct device *dev,                                       \
> +                          struct device_attribute *attr,               \
> +                          char *page)                                  \
> +{                                                                      \
> +       u64 val = x86_pmu.event_map(_id);                               \
> +       BUILD_BUG_ON(_id >= PERF_COUNT_HW_MAX);                         \
> +       return sprintf(page, "config=0x%llx\n", val);                   \
> +}                                                                      \ 

How about something like:

 u64 config = x86_pmu.event_map(_id);
 u64 event = (config & ARCH_PERFMON_EVENTSEL_EVENT) |
	     (config & AMD64_EVENTSEL_EVENT) >> 24;
 u64 umask = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;

 WARN_ON_ONCE(config & (ARCH_PERFMON_EVENTSEL_INV |
                        ARCH_PERFMON_EVENTSEL_CMASK));

 sprintf("event=0x%02llx,umask=0x%02llx\n", event, umask);




