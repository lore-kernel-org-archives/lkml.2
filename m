Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397Ab0HFNqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:46:39 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43825 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761389Ab0HFNqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:46:36 -0400
Date: Fri, 6 Aug 2010 09:46:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100806134634.GA30349@Krystal>
References: <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <20100803182556.GA13798@Krystal> <1280904410.1923.700.camel@laptop> <20100804144539.GA4617@Krystal> <1280933788.1923.1281.camel@laptop> <20100806014925.GB496@Krystal> <1281088300.1947.359.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281088300.1947.359.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:40:59 up 195 days, 16:17,  5 users,  load average: 0.21, 0.13,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2010-08-05 at 21:49 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Wed, 2010-08-04 at 10:45 -0400, Mathieu Desnoyers wrote:
> > > 
> > > > How do you plan to read the data concurrently with the writer overwriting the
> > > > data while you are reading it without corruption ?
> > > 
> > > I don't consider reading while writing (in overwrite mode) a valid case.
> > > 
> > > If you want to use overwrite, stop the writer before reading it.
> > 
> > How inconvenient. It happens that the relatively large group of users I am
> > working for do care for this use-case. They cannot afford to stop tracing as
> > soon as they hit "one bug". This "bug" could be a simple odd scenario that they
> > want to snapshot, but in all cases they want tracing to continue.
> 
> Snapshot is fine, just swivel the whole buffer.

There is a very important trade-off between the amount of information that can
be kept around in memory to take as snapshot and the amount of system memory
reserved for buffers. The sub-buffer scheme is pretty good at that: the whole
memory reserved (except the extra reader-owned sub-buffer) is available to save
the flight recorder trace.

With the multiple-buffer scheme you propose, only one of the buffers can be used
to save data. This is very limiting, especially for embedded systems in telecom
switches that does not have that much memory: all the memory reserved for the
buffer that is currently inactive is simply wasted. It does not even allow the
user to gather a longer snapshot.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
