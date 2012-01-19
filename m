Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab2ASCHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:07:40 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:53563 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab2ASCHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:07:39 -0500
X-Nat-Received: from [202.181.97.72]:49733 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1326938842.18594
Message-Id: <201201190207.q0J27Mr5099912@www262.sakura.ne.jp>
Subject: Re: [PATCH v3] kmod: Avoid deadlock by recursive kmod call.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org
Cc: arjan@linux.intel.com, richard@nod.at, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 19 Jan 2012 11:07:22 +0900
References: <201112270701.pBR713wO005588@www262.sakura.ne.jp> <201201040743.q047h9OD055670@www262.sakura.ne.jp> <201201042208.JHG52695.OLStHFQOFFMVJO@I-love.SAKURA.ne.jp> <201201062139.JFC73472.SMQFOFOFHLVOtJ@I-love.SAKURA.ne.jp> <20120118164558.a10d7821.akpm@linux-foundation.org>
In-Reply-To: <20120118164558.a10d7821.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 19012012 #6579389, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

("[PATCH v3] kmod: Avoid deadlock by recursive kmod call." didn't arrive at ML
 due to mail delivery failure. The V3 patch can be found at
 https://bugzilla.kernel.org/show_bug.cgi?id=42579 )

Andrew Morton wrote:
> I suppose we should fix this, although it's obscure.
> 
> The changelog doesn't tell people how the bug might occur, which is
> bad.  I suggest adding this text to it:
> 
> : This bug was observed when using a corrupted /sbin/hotplug binary.  The
> : corrupted binary caused a call to request_module("binfmt-0000"). 
> : search_binary_handler() uses UMH_WAIT_EXEC.

A corrupted /sbin/hotplug binary is just a simplest example. There are various
hooks called during do_execve() operation (e.g. security_bprm_check(),
audit_bprm(), "struct linux_binfmt"->load_binary()). If one of such hooks
triggers (in the future, but maybe already) UMH_WAIT_EXEC, this deadlock
will happen even if /sbin/hotplug is not corrupted.

> I prefer patch A - all that poking around at stack slots is hacky.
OK.

> > --- linux-3.2.orig/fs/exec.c
> > +++ linux-3.2/fs/exec.c
> > @@ -1406,6 +1406,7 @@ int search_binary_handler(struct linux_b
> >  					fput(bprm->file);
> >  				bprm->file = NULL;
> >  				current->did_exec = 1;
> > +				current->kmod_thread = 0;
> >  				proc_exec_connector(current);
> >  				return retval;
> >  			}
> 
> Special-casing this assignment down in this particular client of kmod
> looks bad.  We need to find somewhere else to do this.  Perferably
> within the kmod code itself, or possibly over in exec.c or fork.c.
> 
Well, kmod code is no longer called if do_execve() succeeded.

In "[PATCH v2] kmod: Avoid deadlock by recursive kmod call"
( https://lkml.org/lkml/2012/1/4/111 ), I forgot to do

	current->kmod_thread = 0;

when do_execve() succeeded. Not clearing this flag might overkill functionality
of /sbin/hotplug and its descendants. If we want to clear this flag, I think we
cannot help doing it in fork.c or exec.c (or do like patch B which does not
need this flag).
