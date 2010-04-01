Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab0DARdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:33:22 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41909 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab0DARdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:33:17 -0400
Date: Thu, 1 Apr 2010 12:33:05 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [2.6.31 and later] "struct pid" leak.
Message-ID: <20100401173305.GA3745@us.ibm.com>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp>
 <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com>
 <20100331151719.8a92b302.akpm@linux-foundation.org>
 <20100401165247.GB19551@redhat.com>
 <20100401172120.GA3111@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401172120.GA3111@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Oleg Nesterov (oleg@redhat.com):
> > On 03/31, Andrew Morton wrote:
> > >
> > > On Tue, 30 Mar 2010 16:31:13 +0100
> > > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > >
> > > > Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> > > > > I got below report with 2.6.33.1 .
> > > > >
> > > > > unreferenced object 0xde144600 (size 64):
> > > > >   comm "init", pid 1, jiffies 4294678101 (age 291.508s)
> > > > >   hex dump (first 32 bytes):
> > > > >     02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > > >     00 00 00 00 04 76 ae de d1 76 43 c0 d6 08 00 00  .....v...vC.....
> > > > >   backtrace:
> > > > >     [<c0481704>] create_object+0x121/0x1ef
> > > > >     [<c05f546b>] kmemleak_alloc+0x25/0x42
> > > > >     [<c047e326>] kmemleak_alloc_recursive+0x1c/0x22
> > > > >     [<c047e36e>] kmem_cache_alloc+0x42/0x68
> > > > >     [<c0437701>] alloc_pid+0x19/0x288
> > > > >     [<c0428acc>] copy_process+0x95a/0xdac
> > > > >     [<c04290d8>] do_fork+0x129/0x261
> > > > >     [<c0407de5>] sys_clone+0x1f/0x24
> > > > >     [<c040292d>] ptregs_clone+0x15/0x28
> > > > >     [<ffffffff>] 0xffffffff
> > > > > unreferenced object 0xdfa96a40 (size 64):
> > > > >   comm "login", pid 2259, jiffies 4294719437 (age 250.179s)
> > > > >   hex dump (first 32 bytes):
> > > > >     02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > > >     00 00 00 00 60 39 ae de d1 76 43 c0 bb 09 00 00  ....`9...vC.....
> > > > >   backtrace:
> > > > >     [<c0481704>] create_object+0x121/0x1ef
> > > > >     [<c05f546b>] kmemleak_alloc+0x25/0x42
> > > > >     [<c047e326>] kmemleak_alloc_recursive+0x1c/0x22
> > > > >     [<c047e36e>] kmem_cache_alloc+0x42/0x68
> > > > >     [<c0437701>] alloc_pid+0x19/0x288
> > > > >     [<c0428acc>] copy_process+0x95a/0xdac
> > > > >     [<c04290d8>] do_fork+0x129/0x261
> > > > >     [<c0407de5>] sys_clone+0x1f/0x24
> > > > >     [<c040292d>] ptregs_clone+0x15/0x28
> > > > >     [<ffffffff>] 0xffffffff
> > > >
> > > > I reported similar leaks last year -
> > > > http://lkml.org/lkml/2009/7/8/422. There is some analysis in the thread
> > > > above of the reference counting but I couldn't figure out where it goes
> > > > wrong. It looks to me like there isn't any reference to a struct pid
> > > > block but its reference count is 2.
> > > >
> > > > There is a bugzilla entry as well -
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=13868
> > > >
> > >
> > > Let's bug some people by cc'ing them ;)
> > 
> > Oh. It is hardly possibly to find the unbalanced get_pid() via grep.
> > 
> > IIRC, I sent the debugging patch which tracks get/put pid, but I can't
> > recall if anybody tried this patch. Hmm, and I can't find that patch
> > or the previous discussion in my maildir...
> > 
> > Catalin, Tetsuo, any chance you can remind me if this patch was used?
> > 
> > Oleg.
> 
> [ probably sounding like a moron, but... ]
> 
> Looking through vt_ioctl.c, I get the feeling that the ttys will
> hang onto vc->vt_pid until either getting a SAK or until someone
> new logs in.  I don't see where logging out will cause a reset_vc().
> So when the logged in task logs out, does vt_pid keep a ref to the
> pid which now no longer exists?
> 
> Came to mind bc I notice that every trace you've sent has included
> /bin/login or X...
> 
> -serge

In particular, if vt_ioctl is called with VT_RELDISP, then
complete_change_console() will get called, which will kill vc->vt_pid,
but it will only call reset_vc(vc) if that kill_pid failed.  reset_vc()
is needed to do our last put_pid().

I could be way off base here, but...

-serge
