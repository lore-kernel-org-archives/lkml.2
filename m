Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0IPIJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 04:09:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43889 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab0IPII7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:08:59 -0400
Date: Thu, 16 Sep 2010 10:08:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Alexander Viro <viro@ftp.linux.org.uk>,
        Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Donlan <bdonlan@gmail.com>, Avi Kivity <avi@redhat.com>,
        Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] Cross Memory Attach
Message-ID: <20100916080826.GB21228@elte.hu>
References: <4C90A6C7.9050607@redhat.com>
 <AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com>
 <20100916105311.CA00.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100916105311.CA00.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Wed, Sep 15, 2010 at 19:58, Avi Kivity <avi@redhat.com> wrote:
> > 
> > > Instead of those two syscalls, how about a vmfd(pid_t pid, ulong start,
> > > ulong len) system call which returns an file descriptor that represents a
> > > portion of the process address space.  You can then use preadv() and
> > > pwritev() to copy memory, and io_submit(IO_CMD_PREADV) and
> > > io_submit(IO_CMD_PWRITEV) for asynchronous variants (especially useful with
> > > a dma engine, since that adds latency).
> > >
> > > With some care (and use of mmu_notifiers) you can even mmap() your vmfd and
> > > access remote process memory directly.
> > 
> > Rather than introducing a new vmfd() API for this, why not just add
> > implementations for these more efficient operations to the existing
> > /proc/$pid/mem interface?
> 
> As far as I heared from my friend, old HP MPI implementation used 
> /proc/$pid/mem for this purpose. (I don't know current status). 
> However almost implementation doesn't do that because /proc/$pid/mem 
> required the process is ptraced. As far as I understand , very old 
> /proc/$pid/mem doesn't require it. but It changed for security 
> concern. Then, Anybody haven't want to change this interface because 
> they worry break security.
> 
> But, I don't know what exactly protected "the process is ptraced" 
> check. If anyone explain the reason and we can remove it. I'm not 
> againt at all.

I did some Git digging - that ptrace check for /proc/$pid/mem read/write 
goes all the way back to the beginning of written human history, aka 
Linux v2.6.12-rc2.

I researched the fragmented history of the stone ages as well, i checked 
out numerous cave paintings, and while much was lost, i was able to 
recover this old fragment of a clue in the cave called 'patch-2.3.27', 
carbon-dated back as far as the previous millenium (!):

  mem_read() in fs/proc/base.c:

+ *  1999, Al Viro. Rewritten. Now it covers the whole per-process part.
+ *  Instead of using magical inumbers to determine the kind of object
+ *  we allocate and fill in-core inodes upon lookup. They don't even
+ *  go into icache. We cache the reference to task_struct upon lookup too.
+ *  Eventually it should become a filesystem in its own. We don't use the
+ *  rest of procfs anymore.

In such a long timespan language has changed much, so not all of this 
scribbling can be interpreted - but one thing appears to be sure: this 
is where the MAY_PTRACE() restriction was introduced to /proc/$pid/mem - 
as part of a massive rewrite.

Alas, the reason for the restriction was not documented, and is feared 
to be lost forever.

Thanks,

	Ingo
