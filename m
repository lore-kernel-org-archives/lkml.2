Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0DVRcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 13:32:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29102 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab0DVRc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 13:32:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=OPa0Ajen+kDRgDPKJwMOeAk+F282pP+YhkxlBbbtGcp4b30Ovnlv3hSrkNHQLm2I2
	bn2uDl1seH6GDbcwWywcQ==
MIME-Version: 1.0
In-Reply-To: <20100421165843.GD6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
	 <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
	 <20100420160557.GT11907@erda.amd.com>
	 <20100421084700.GU11907@erda.amd.com>
	 <o2ibd4cb8901004210202i1ba91c3dlc775a9f7759ece68@mail.gmail.com>
	 <20100421092145.GV11907@erda.amd.com>
	 <20100421105439.GA6450@erda.amd.com>
	 <r2sbd4cb8901004210437i343850b4z94ca99b9ec0316b6@mail.gmail.com>
	 <20100421165843.GD6450@erda.amd.com>
Date: Thu, 22 Apr 2010 19:32:23 +0200
Message-ID: <t2ybd4cb8901004221032pe503eb44lb2e669939977f93b@mail.gmail.com>
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

On Wed, Apr 21, 2010 at 6:58 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 21.04.10 13:37:27, Stephane Eranian wrote:
>> Why do you need model_spec, in addition to your special encoding?
>>
>> >  /*
>> > + * Model specific hardware events
>> > + *
>> > + * With the attr.model_spec bit set we can setup hardware events
>> > + * others than generic performance counters. A special PMU 64 bit
>> > + * config value can be passed through the perf_event interface. The
>> > + * concept of PMU model-specific arguments was practiced already in
>> > + * Perfmon2. The type of event (8 bits) is determinded from the config
>> > + * value too, bit 32-39 are reserved for this.
>> > + */
>> Isn't the config field big enough to encode all the information you need?
>> In the kernel, you could check bit 32-39 and based on host CPU determine
>> whether it refers to IBS or is a bogus value. I am trying to figure out what
>> model_spec buys you. I believe RAW does not mean the final value as
>> accepted by HW but a value that must be interpreted by the model-specific
>> code to eventually come up with a raw HW value. In the current code, the
>> RAW value is never passed as is, it is assembled from various bits and
>> pieces incl. attr.config of course.
>
> The raw config value without the model_spec bit set would asume a
> config value for a generic x86 counter. We could reuse also an unused
> bit in this config value, but what if this bit will be somewhen used?

I have not yet seen a definition for what PERF_TYPE_RAW actually
means, unfortunately. But I would not necessarily the same conclusion
you did for raw without model_spec. I think the interpretation of raw
config is up to the machine/model specific layer, it could be a counting
event and something else.

To use IBS regardless, it seems the app needs to be aware it is
available on the host and that with or without model_spec.

You know that on a Barcelona-class system, you will never need
more than 42 bits. So you could reuse bits 63-42 to encode anything
you want.

When you go to another class of system which may use more than 42 bits,
then the app will have to know the type of host to use any
model-specific feature,
thus it is also safe to assume it will now how to encode those feature
for that host.
I don't see how model_spec would solve that particular problem.

To avoid the problem with full 64-bit raw config, you'd have to have another
u64 model_spec field and not just a bit to encode the feature type,
i.e., what you
are load in bits 32-63 today.



> Or, it is available on one hw bot not another? So I found it much
> cleaner to introduce this attribute flag that can be reused on other
> architectures. Also, you will then have the freedom to implement model
> specific generic events without using raw_config. As most pmu features
> are setup with a 64 bit config value, I would prefer to have also the
> encoding of the model specific event type outside of the config
> value. A want to be close to the hw register layout without shifting
> bits back and forth. This may also introduce trouble in the future if
> we need all 64 bits.
>
> -Robert
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
> email: robert.richter@amd.com
>
>
