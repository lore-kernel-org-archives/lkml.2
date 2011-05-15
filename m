Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113Ab1EOQKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:10:21 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:36008 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756656Ab1EOQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:10:20 -0400
Date: Sun, 15 May 2011 18:10:00 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: PTRACE_DETACH without stop  [Re: [PATCH 04/11] ptrace: implement
 PTRACE_INTERRUPT]
Message-ID: <20110515161000.GE31855@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com>
 <20110511091955.GD1661@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511091955.GD1661@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 11:19:55 +0200, Tejun Heo wrote:
> On Tue, May 10, 2011 at 11:59:58PM +0200, Denys Vlasenko wrote:
> > Another note: even though PTRACE_INTERRUPT solves the problem that
> > PTRACE_DETACH of a running tracee was butt-ugly thing to do correctly,
> > the "new" way is still a bit ugly: tracer needs PTRACE_INTERRUPT,
> > waitpid, and only then PTRACE_DETACH. Why not go all the way
> > and make PTRACE_DETACH work on running tracee too?
> 
> I don't think I'll change that.  It's only three syscall sequence -
> INTERRUPT, wait(STOPPED) and DETACH which will always work reliably
> (unless tracee gets killed or something).

I do not think this change is much related to this patchset.

But having to PTRACE_INTERRUPT the tracee before PTRACE_DETACH has no
advantage, it is just a performance (see transparent tracking of 10000+ thread
	https://lkml.org/lkml/2011/5/15/115
) problem and also getting it correct.  As when one wait()s and gets
WIFSTOPPED one needs to respawn to signal otherwise the signal gets lost on
PTRACE_ATTACH.  How to respawn it?  By PTRACE_INTERRUPT with DATA==signal?
Or PTRACE_CONT with DATA==signal?  With rapid signalling of the tracee the
debugger may never have a chance to correctly quit.  Handling other cases
transparently for the original parent also may not be fully clear.

It would be nice to write documentation already while discussing this patch,
I do not know if PTRACE_INTERRUPT respects DATA etc., it may show ptrace is
still tricky.



Thanks,
Jan
