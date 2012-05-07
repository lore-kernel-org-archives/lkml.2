Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2EGLBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:01:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36522 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab2EGLBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:01:08 -0400
Subject: Re: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1335983192-23731-5-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
	 <1335983192-23731-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 13:00:54 +0200
Message-ID: <1336388454.27020.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 20:26 +0200, Robert Richter wrote:
> +enum ibs_filter_type {
> +       IBS_NO_FILTER           = 0,
> +       IBS_MATCH_FILTER        = 1,
> +       IBS_ANY_SET_FILTER      = 2,
> +       IBS_PSEUDO_EVENT        = 0x0F,
> +};
> +
> +struct ibs_filter {
> +       struct {
> +               u16             idx             : 8;
> +               u16             reserved        : 4;
> +               u16             type            : 4;
> +       };
> +       union {
> +               struct {
> +                       u8      mask;
> +                       u8      match;
> +               };
> +               u16             any;
> +       };
> +};
> +
> +static bool
> +__perf_ibs_sample_matches(struct ibs_filter *filter, void *data, int size)
> +{
> +       int left = size;
> +
> +       switch (filter->type) {
> +       case IBS_MATCH_FILTER:
> +               left -= sizeof(u8);
> +               break;
> +       case IBS_ANY_SET_FILTER:
> +               left -= sizeof(u16);
> +               break;
> +       default:
> +               return false;
> +       }
> +
> +       left -= filter->idx;
> +       if (left < 0)
> +               return false;
> +
> +       switch (filter->type) {
> +       case IBS_MATCH_FILTER:
> +               return ((*(u8*)(data + filter->idx)) & filter->mask) == filter->match;
> +       case IBS_ANY_SET_FILTER:
> +               return (*(u16*)(data + filter->idx)) & filter->any;
> +       };
> +
> +       return false;
> +}
> +
> +static bool perf_ibs_sample_matches(struct perf_event *event,
> +                                   struct perf_ibs_data *data)
> +{
> +       int i;
> +       union {
> +               struct ibs_filter filter[4];
> +               u64     config[2];
> +       } f;
> +       struct ibs_filter *filter = f.filter;
> +
> +       f.config[0] = event->attr.config1;
> +       f.config[1] = event->attr.config2;
> +
> +       for (i = 0; i < 4; i++, filter++) {
> +               if (filter->type == IBS_NO_FILTER)
> +                       break;
> +               if (!__perf_ibs_sample_matches(filter, data->regs, data->size))
> +                       return false;
> +       }
> +
> +       return true;
> +} 

Who again wasn't decoding anything in perf_event_attr:config* ?

