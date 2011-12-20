Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab1LTLbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:31:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:56274 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LTLbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:31:02 -0500
Message-ID: <1324380648.24621.49.camel@twins>
Subject: Re: [PATCH 1/3] perf, tool: Add parser generator for events parsing
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Tue, 20 Dec 2011 12:30:48 +0100
In-Reply-To: <1324378070.24621.32.camel@twins>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
	 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
	 <1324044159.18942.104.camel@twins> <1324044196.18942.105.camel@twins>
	 <20111220103154.GA1861@m.brq.redhat.com> <1324378070.24621.32.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 11:47 +0100, Peter Zijlstra wrote:

> > any idea/details/specifics how they might look like? ;)
> 
> The current idea is that they'd live in a place like:
> 
>   /sys/bus/event_source/devices/$pmu/events/$event
> 
> and when you read them they contain a full event_raw style string so you
> could do things like:
> 
>   perf record -e `cat $sysfsfile` or so
> 
> (or maybe without the 'r' prefix).
> 
> The idea was to have some $pmu:$event like syntax, but seeing that ':'
> is already used quite a lot, there's maybe a more suitable separator.
> Maybe '/' would do, yielding things like cpu/instructions.
> 
> Then again, it might make sense to restructure the syntax without
> considerations for the status quo and see if we can come up with
> something a little more consistent, the above event_* things are quite a
> hodge podge, syntax wise.
> 
> While I appreciate that they are the result of organic growth, it
> doesn't mean we shouldn't try and restructure stuff once in a while when
> it makes sense.

There's also the raw event format idea, where

 /sys/bus/event_source/devices/$pmu/format

contains a syntax description on how to construct raw events, for intel
(!p4) it would be something as simple as a bitfield definition:

event	config-0:7
umask	config-8:15
usr	config-16
os	config-17
edge	config-18
any	config-21
inv	config-23
cmask	config-24:31

nhm-dmnd_data_rd	config1-0
nhm-dmnd_rfo		config1-1
nhm-dmnd_ifetch		config1-2
...

(the real syntax will likely be a little more complex in order to be
able to express the various other architectures their raw input format).

This would allow us to write things like:

 perf record -e cpu/event=0x34,umask=0x01,inv,cmask=2

or to give an offcore example:

 perf record -e
cpu/offcore,nhm-dmnd_data_rd,nhm-non_dram,nhm-remote_dram,nhm-local_dram

Where cpu/events/offcore would contain: 0x01b7 to fill out config.

We should also extend this to allow per event setting of the period by
adding a ,period=10000 or so.

 perf record -e cpu/cycles,period=100000

should then give us a cycle counter with a fixed period of .1M cycles.

I think there's currently means to provide this period, but I don't
actually know the syntax for it.

But note, the above again uses ',' as separator, which will be much
confused with the group idea you already proposed. So we need some
consideration on how we all want to express this.



