Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0DULhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 07:37:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37174 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab0DULhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 07:37:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=fkDBp7IkOlscbFKoIPlgDr8uWlFFociszU4b84g3WH70nlbR9qJmqFfhwJ1+2GM+8
	x3JgfxOEXkEih1YTSbtXQ==
MIME-Version: 1.0
In-Reply-To: <20100421105439.GA6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
	 <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
	 <20100420160557.GT11907@erda.amd.com>
	 <20100421084700.GU11907@erda.amd.com>
	 <o2ibd4cb8901004210202i1ba91c3dlc775a9f7759ece68@mail.gmail.com>
	 <20100421092145.GV11907@erda.amd.com>
	 <20100421105439.GA6450@erda.amd.com>
Date: Wed, 21 Apr 2010 13:37:27 +0200
Message-ID: <r2sbd4cb8901004210437i343850b4z94ca99b9ec0316b6@mail.gmail.com>
Subject: Re: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

Some more comments about model_spec.

> Except for the sample period IBS can only be set up with raw (model
> specific) config values and raw data samples. The event attributes for
> the syscall should be programmed like this (IBS_FETCH):
>
>        memset(&attr, 0, sizeof(attr));
>        attr.type        = PERF_TYPE_RAW;
>        attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
>        attr.config      = IBS_FETCH_CONFIG_DEFAULT
>        attr.config     |=
>                ((unsigned long long)MODEL_SPEC_TYPE_IBS_FETCH << 32)
>                & MODEL_SPEC_TYPE_MASK;
>        attr.model_spec  = 1;
>
Why do you need model_spec, in addition to your special encoding?

>  /*
> + * Model specific hardware events
> + *
> + * With the attr.model_spec bit set we can setup hardware events
> + * others than generic performance counters. A special PMU 64 bit
> + * config value can be passed through the perf_event interface. The
> + * concept of PMU model-specific arguments was practiced already in
> + * Perfmon2. The type of event (8 bits) is determinded from the config
> + * value too, bit 32-39 are reserved for this.
> + */
Isn't the config field big enough to encode all the information you need?
In the kernel, you could check bit 32-39 and based on host CPU determine
whether it refers to IBS or is a bogus value. I am trying to figure out what
model_spec buys you. I believe RAW does not mean the final value as
accepted by HW but a value that must be interpreted by the model-specific
code to eventually come up with a raw HW value. In the current code, the
RAW value is never passed as is, it is assembled from various bits and
pieces incl. attr.config of course.
