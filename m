Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab2BGVzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:55:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56604 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2BGVzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:55:47 -0500
Message-ID: <4F319DDF.4020303@gmail.com>
Date: Tue, 07 Feb 2012 14:55:43 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: allow command to attach local data to thread/evsel structs
References: <4F316964.2050900@gmail.com> <20120207201052.GE2172@infradead.org> <4F319514.7030604@gmail.com> <20120207213322.GF2172@infradead.org>
In-Reply-To: <20120207213322.GF2172@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 02:33 PM, Arnaldo Carvalho de Melo wrote:
>>> I think we either use {thread_conf,evsel_conf} for global configuration
>>> options for these two core data structures or we just provide some
>>> optional, per perf_tool allocator.
>>
>> Meaning conf's that parallel symbol_conf -- allocated and 'owned' by the
>> perf library but exported for the user to set values. In this case
>> handlers are needed for allocation and free as instances come and go?
>> e.g., thread__new invokes thread_conf.allocator if defined and
>> thread__priv returns a pointer to private data.
> 
> Well, the symbol way of doing things is to just allocate as many bytes
> as the tool being used asks for and then at free time nothing special
> has to be done.

Consider the case of events and you want to track time last seen by cpu.
You need an array:

u64 last_seen[]

with CPU as an index, but do not want to assume some value of max_cpus.
So one option is:

struct priv {
    u64 *last_seen; /* time this event was last seen */
    u32 max_cpu;    /* highest cpu slot allocated */
};

last_seen is malloc'ed first time the event is processed and realloc'ed
as max_cpu increases. Attaching that struct to an event means an
embedded allocation that does not follow the static model of symbol_conf.

David
