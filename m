Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0IPUSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:18:38 -0400
Received: from smtp-out.google.com ([74.125.121.35]:29230 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0IPUSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I2y+SvSOUTqA0NNBjVf0JPOgX020ph9wFDaI2i44PVzxEjLqgLtzcnF0f5mjPdV876
         g+suU3L9ezeVloyJFlnw==
MIME-Version: 1.0
In-Reply-To: <1284658950.2275.591.camel@laptop>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	<1284118900.402.35.camel@laptop>
	<20100910132741.GB4879@redhat.com>
	<20100910144634.GA1060@elte.hu>
	<20100910155659.GD13563@erda.amd.com>
	<1284658950.2275.591.camel@laptop>
Date: Thu, 16 Sep 2010 22:18:33 +0200
Message-ID: <AANLkTimuG3N-qPvB-af=afgJbo5aVBCd6ozxkLFNz78K@mail.gmail.com>
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 7:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-09-10 at 17:56 +0200, Robert Richter wrote:
>> The commit:
>>
>>  e40b172 x86: Move notify_die from nmi.c to traps.c
>>
>> moved the nmi handler call to default_do_nmi(). DIE_NMI_IPI and
>> DIE_NMI are called subsequently now. If the return code is
>> !NOTIFY_STOP, then the handlers are called twice. This patch fixes
>> this.
>
> What is this NMI_IPI thing, and why do we bother?
>
I think you only need to be on one of the callchains and most likely
the higher priority one. That's beauce you're using NMI for performance
monitoring and not debugging. Thus you expect a high rate of calls and
you don't want to be calling a bunch of other handlers for nothing.

The way the code is laid out in default_do_nmi() means that NMI_IPI
has higher priority over NMI. NMI also depends on X86_LOCAL_APIC,
but without it no PMU interrupts anyway.

The other thing to notice is that default_do_nmi() is the only place for
invoking NMI_IPI. I don't see the point of it vs. NMI (except APIC vs. no APIC).

Why not just have one level, NMI, and use the priority field to position
handlers correctly?

> If the hardware reason thin can discriminate between IPI and other NMIs
> we should never call both chains, if it cannot, why do we have 2 chains?
>
> In any case, I don't think perf/oprofile/etc,. should use NMI_IPI, that
> doesn't really make sense.
>
> Or am I totally confused about things here?
>
