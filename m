Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0CRAdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 20:33:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:35416 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0CRAdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 20:33:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=MH1J4+lM/mMJloeiTw3YQeEnyme1mwEclIcWtwFWKnKNyghONF59M7Y+dAWrFhoFP
	aZCU1LTgQKde8qgVV4gqw==
MIME-Version: 1.0
In-Reply-To: <1268869631.9440.282.camel@laptop>
References: <4ba0a646.25e2660a.1b25.531c@mx.google.com>
	 <1268869631.9440.282.camel@laptop>
Date: Thu, 18 Mar 2010 01:33:15 +0100
Message-ID: <bd4cb8901003171733k95fcf50mf6de78bf503d9a7b@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bug in AMD per-cpu initialization
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 12:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-03-17 at 10:40 +0200, Stephane Eranian wrote:
>>       On AMD processors, we need to allocate a data structure per Northbridge
>>       to handle certain events.
>>
>>       On CPU initialization, we need to query the Northbridge id and check
>>       whether the structure is already allocated or not. We use the
>>       amd_get_nb_id() function to request the Northbridge identification.
>>
>>       The recent cleanup of the CPU online/offline initialization introduced
>>       a bug. AMD cpu initialization is invoked on CPU_UP_PREPARE callback.
>>       This is before the CPU Northbridge id is calculated. Therefore no
>>       processor had a Northbridge structure allocated except the boot
>>       processor. That was causing bogus NB event scheduling.
>>
>>       This patch uses the CPU_ONLINE callback to initialize the AMD
>>       Northbridge structure. This way amd_get_nb_id() returns valid
>>       information.
>>
>>       The x86_cpu_up() callback was added. Could not call it cpu_online
>>       because of existing macro.
>>
>>       Signed-off-by: Stephane Eranian <eranian@google.com>
>
>
> No, ONLINE is not exposed for a good reason, its always wrong.
>
> Use prepare to allocate data, and starting to initialize stuff on the
> cpu proper once its up. Online is after the cpu is up and running and we
> are already scheduling stuff on it so its too late to initialize things.
>
>
I can't because amd_get_nb_id() returns garbage for the CPU
when you call from CPU_STARTING. So looks like initialization
of cpu_llc_id needs to be moved way earlier. I don't want to have
to duplicate that code.
