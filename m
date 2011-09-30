Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab1I3Tyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:54:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63569 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab1I3Ty3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:54:29 -0400
Date: Fri, 30 Sep 2011 23:53:29 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm00@gmail.com>
Cc: kernel-hardening@lists.openwall.com,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, Kees Cook <kees@ubuntu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
Message-ID: <20110930195329.GA2020@albatros>
References: <20110927175453.GA3393@albatros>
 <20110927175642.GA3432@albatros>
 <20110927193810.GA5416@albatros>
 <20110928144614.38591e97.akpm00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928144614.38591e97.akpm00@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 14:46 -0700, Andrew Morton wrote:
> On Tue, 27 Sep 2011 23:38:10 +0400
> Vasiliy Kulikov <segoon@openwall.com> wrote:
> 
> > On Tue, Sep 27, 2011 at 21:56 +0400, Vasiliy Kulikov wrote:
> > > /proc/meminfo stores information related to memory pages usage, which
> > > may be used to monitor the number of objects in specific caches (and/or
> > > the changes of these numbers).  This might reveal private information
> > > similar to /proc/slabinfo infoleaks.  To remove the infoleak, just
> > > restrict meminfo to root.  If it is used by unprivileged daemons,
> > > meminfo permissions can be altered the same way as slabinfo:
> > > 
> > >     groupadd meminfo
> > >     usermod -a -G meminfo $MONITOR_USER
> > >     chmod g+r /proc/meminfo
> > >     chgrp meminfo /proc/meminfo
> > 
> > Just to make it clear: since this patch breaks "free", I don't propose
> > it anymore.
> 
> It will break top(1) too.  It isn't my favoritest-ever patch :)

FWIW, I consider it as a top's bug.  It tries to handle failed open(),
but forgets to reset tty mode.


Anyway, how do we expect userspace apps handle meminfo data?  Is it used
as a debugging information only?  E.g. admin wants to see how much
memory is used, monitoring daemon looks for memleaks and running out of
memory (1)?  Or the numbers are used in some calculations e.g.
calculation of approximate number of parallel processes to spawn (2)?

If we care about (1) only, we may do the same as we do with kernel
pointers, i.e. show zeroes to non-CAP_SYS_ADMIN users (plus emit a
sinlge warning in syslog).  It will not break top, and top will simply
show zero counters.  Admins who still want to read this information as
non-root should chmod/chgrp it in boot scripts.  (And distros should
provide a default "debugging" group for these needs.)

If we care about (2), we should pass non-zero counters, but imagine some
default values, which will result in sane processes numbers.  But it
might depend on specific applications, I'm not aware whether (2) is
real.


Other ideas?

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
