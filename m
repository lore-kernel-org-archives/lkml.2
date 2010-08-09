Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab0HIQxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 12:53:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53022 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab0HIQxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 12:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nRSlu7bwdUo1fLHTHF3wcu1+6pmkW0pqTx5yYiqf1mrXzeBkyLZI1AipG5OdRG1zWW
         EEBXVpun4AgXpPMuVRArxpv3/c85+jbVxto1WzGm3bFbe2O7f9/0gY5/UWLvOzg1eziG
         jugCe/Tu6HGEznUTcgxox69XmYy2aWkIBnVaE=
Date: Mon, 9 Aug 2010 18:53:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Message-ID: <20100809165307.GA5329@nowhere>
References: <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <20100803182556.GA13798@Krystal> <1280904410.1923.700.camel@laptop> <20100804144539.GA4617@Krystal> <1280933788.1923.1281.camel@laptop> <4C5BA937.5010504@hitachi.com> <1281088240.1947.357.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281088240.1947.357.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 11:50:40AM +0200, Peter Zijlstra wrote:
> On Fri, 2010-08-06 at 15:18 +0900, Masami Hiramatsu wrote:
> > Peter Zijlstra wrote:
> > > On Wed, 2010-08-04 at 10:45 -0400, Mathieu Desnoyers wrote:
> > > 
> > >> How do you plan to read the data concurrently with the writer overwriting the
> > >> data while you are reading it without corruption ?
> > > 
> > > I don't consider reading while writing (in overwrite mode) a valid case.
> > > 
> > > If you want to use overwrite, stop the writer before reading it.
> > 
> > For example, would you like to read system audit log always after
> > stop the audit?
> > 
> > NO, that's a most important requirement for tracers, especially for
> > system admins (they're the most important users of Linux) to check
> > the system health and catch system troubles.
> > 
> > For performance measurement and checking hotspot, one-shot tracing
> > is enough. But it's just for developers. But for the real world
> > computing, Linux is just an OS, users want to run their system,
> > middleware and applications, without troubles. But when they hit
> > a trouble, they wanna shoot it ASAP.
> > The flight recorder mode is mainly for those users.
> 
> You cannot over-write and consistently read the buffer, that's plain
> impossible. With sub-buffers you can swivel a sub-buffer and
> consistently read that, but there is no guarantee the next sub-buffer
> you steal was indeed adjacent to the previous buffer you stole as that
> might have gotten over-written by the active writer while you were
> stealing the previous one.
> 
> If you want to snapshot buffers, do that, simply swivel the whole trace
> buffer, and continue tracing in a new one, then consume the old trace in
> a consistent manner.
> 
> I really see no value in being able to read unrelated bits and pieces of
> a buffer.



It all depends on the frequency on your events and on the amount of memory
used for the buffer.

If you are tracing syscalls in a semi-idle box with a ring buffer of 500 MB
per cpu, you really don't care about the writer catching up the reader: it
will simply not happen.

OTOH if you are tracing function graphs, no buffer size will ever be enough:
the writer will always be faster and catch up the reader.

Using the sub-buffer scheme though, and allowing concurrent writer and reader
in overwriting mode, we can easily tell the user about the writer beeing
faster and content that have been lost. On top of these informations, the
user can chose what to do: trying with a larger buffer or so.

See? It's not our role to say: the result might be unreliable if the user
does silly settings (not enough memory, reader too slow for random reasons,
too high frequency events or so...). Let the user deal with that and just
inform him about unreliable results. This is what ftrace does currently.

Also the snapshot thing doesn't look like a replacement. If you are
tracing on a low memory embedded system, you consume a lot of memory
to keep the snapshot alive, it means the live buffer can be critically
lowered and you might in turn lose traces there.
That said it's an interesting feature that may fit on other kind of
environments or for other needs.


Off-topic: It's sad that about tracing, we often have to figure out the needs
from embedded world, or learn from indirect sources. In the end we rarely
know from them directly. Except may be in confs....

