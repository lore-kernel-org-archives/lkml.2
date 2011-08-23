Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1HWTUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:20:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9029 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab1HWTUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:20:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=XNoj+2TDwZ3wW0bEI2skau7gsyKVAyA80M2O33H3cyNt2jYPBxzDWh8bP9x8KhKzb
	kUICkHCYbUyYOMmxd54Cg==
MIME-Version: 1.0
In-Reply-To: <CAJL_ektp-BP52Qqfu_bBDjUnXyX20PWzgNuQF_atB0J9q7n=Zw@mail.gmail.com>
References: <1313531179-9323-5-git-send-email-vnagarnaik@google.com>
 <1314125758-5069-1-git-send-email-vnagarnaik@google.com> <CAJL_ektp-BP52Qqfu_bBDjUnXyX20PWzgNuQF_atB0J9q7n=Zw@mail.gmail.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 23 Aug 2011 12:20:14 -0700
Message-ID: <CAL26m8J29HA89m-r0EXRxn_hRoBkDksXXfgO4A12256i+0aamg@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] trace: Make removal of ring buffer pages atomic
To: David Sharp <dhsharp@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 12:16 PM, David Sharp <dhsharp@google.com> wrote:
> On Tue, Aug 23, 2011 at 11:55 AM, Vaibhav Nagarnaik
> <vnagarnaik@google.com> wrote:
>> This patch adds the capability to remove pages from a ring buffer
>> without destroying any existing data in it.
>>
>> This is done by removing the pages after the tail page. This makes sure
>> that first all the empty pages in the ring buffer are removed. If the
>> head page is one in the list of pages to be removed, then the page after
>> the removed ones is made the head page. This removes the oldest data
>> from the ring buffer and keeps the latest data around to be read.
>>
>> To do this in a non-racey manner, tracing is stopped for a very short
>> time while the pages to be removed are identified and unlinked from the
>> ring buffer. The pages are freed after the tracing is restarted to
>> minimize the time needed to stop tracing.
>>
>> The context in which the pages from the per-cpu ring buffer are removed
>> runs on the respective CPU. This minimizes the events not traced to only
>> NMI trace contexts.
>
> "interrupt contexts". We're not disabling interrupts.
>

Since the reader_lock is held using spin_lock_irq(), there won't be IRQs
coming in, only the NMIs.


Vaibhav Nagarnaik
