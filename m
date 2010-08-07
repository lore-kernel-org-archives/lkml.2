Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762366Ab0HGJve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 05:51:34 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51480 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0HGJvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 05:51:31 -0400
X-AuditID: b753bd60-a70d9ba000000a18-7e-4c5d2c9ea8dd
Message-ID: <4C5D2C9B.5080601@hitachi.com>
Date: Sat, 07 Aug 2010 18:51:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>	 <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal>	 <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal>	 <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal>	 <1280855904.1923.675.camel@laptop> <20100803182556.GA13798@Krystal>	 <1280904410.1923.700.camel@laptop>  <20100804144539.GA4617@Krystal>	 <1280933788.1923.1281.camel@laptop>  <4C5BA937.5010504@hitachi.com> <1281088240.1947.357.camel@laptop>
In-Reply-To: <1281088240.1947.357.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2010-08-06 at 15:18 +0900, Masami Hiramatsu wrote:
>> Peter Zijlstra wrote:
>>> On Wed, 2010-08-04 at 10:45 -0400, Mathieu Desnoyers wrote:
>>>
>>>> How do you plan to read the data concurrently with the writer overwriting the
>>>> data while you are reading it without corruption ?
>>> I don't consider reading while writing (in overwrite mode) a valid case.
>>>
>>> If you want to use overwrite, stop the writer before reading it.
>> For example, would you like to read system audit log always after
>> stop the audit?
>>
>> NO, that's a most important requirement for tracers, especially for
>> system admins (they're the most important users of Linux) to check
>> the system health and catch system troubles.
>>
>> For performance measurement and checking hotspot, one-shot tracing
>> is enough. But it's just for developers. But for the real world
>> computing, Linux is just an OS, users want to run their system,
>> middleware and applications, without troubles. But when they hit
>> a trouble, they wanna shoot it ASAP.
>> The flight recorder mode is mainly for those users.
> 
> You cannot over-write and consistently read the buffer, that's plain
> impossible. With sub-buffers you can swivel a sub-buffer and
> consistently read that, but there is no guarantee the next sub-buffer
> you steal was indeed adjacent to the previous buffer you stole as that
> might have gotten over-written by the active writer while you were
> stealing the previous one.

Right, we cannot ensure that. In over-written mode, reader could lose
some data, because of overwriting by writers. (or writer may fails
to write new data on buffer in non-overwritten mode)
However, I think that doesn't mean this mode is completely useless.
If we can know when(where) the data was lost, the rest of data
is enough useful in some cases.

> If you want to snapshot buffers, do that, simply swivel the whole trace
> buffer, and continue tracing in a new one, then consume the old trace in
> a consistent manner.

Hmm, would that consume much more memory compared with sub-buffer
ring buffer if we have spare buffers?
Or, if allocating it after reader opens buffer, will it also slow
down the reader process?

> I really see no value in being able to read unrelated bits and pieces of
> a buffer.

I think there is a trade-off of perfect snapshot and consuming memory,
and it depends on use-case in many cases.

> 
> So no, I will _not_ support reading an over-write buffer while there is
> an active reader.
> 

I hope you to reconsider how over-write buffer is useful even if
it is far from perfect.

Thank you,

-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
