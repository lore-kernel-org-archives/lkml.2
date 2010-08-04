Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0HDEeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:34:10 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:36398 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab0HDEeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:34:08 -0400
Date: Wed, 4 Aug 2010 00:33:28 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Paul Menage <menage@google.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com
Subject: Re: [PATCH v4 1/2] cgroups: read-write lock CLONE_THREAD forking
 per threadgroup
Message-ID: <20100804043328.GB11950@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
 <20100730235754.GB22644@ghc17.ghc.andrew.cmu.edu>
 <AANLkTikpNG2Y3S3AyxAbCkMynKu1u5yKPrw=bh+uy=9R@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikpNG2Y3S3AyxAbCkMynKu1u5yKPrw=bh+uy=9R@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1600_1699 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 08:44:01PM -0700, Paul Menage wrote:
>  On Fri, Jul 30, 2010 at 4:57 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> > +	 * The threadgroup_fork_lock prevents threads from forking with
> > +	 * CLONE_THREAD while held for writing. Use this for fork-sensitive
> > +	 * threadgroup-wide operations. It's taken for reading in fork.c in
> > +	 * copy_process().
> > +	 * Currently only needed write-side by cgroups.
> > +	 */
> > +	struct rw_semaphore threadgroup_fork_lock;
> > +#endif
> 
> I'm not sure how best to word this comment, but I'd prefer something like:
> 
> "The threadgroup_fork_lock is taken in read mode during a CLONE_THREAD
> fork operation; taking it in write mode prevents the owning
> threadgroup from adding any new threads and thus allows you to
> synchronize against the addition of unseen threads when performing
> threadgroup-wide operations. New-process forks (without CLONE_THREAD)
> are not affected."

That sounds good.

> As far as the #ifdef mess goes, it's true that some people don't have
> CONFIG_CGROUPS defined. I'd imagine that these are likely to be
> embedded systems with a fairly small number of processes and threads
> per process. Are there really any such platforms where the cost of a
> single extra rwsem per process is going to make a difference either in
> terms of memory or lock contention? I think you should consider making
> these additions unconditional.

That's certainly an option, but I think it would be clean enough to put
static inline functions just under the signal_struct definition.
Thoughts?

> 
> Paul
> 

-- Ben
