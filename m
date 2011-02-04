Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1BDRO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:14:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab1BDRO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:14:27 -0500
Date: Fri, 4 Feb 2011 18:06:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110204170602.GB15301@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <1296227324-25295-11-git-send-email-tj@kernel.org> <20110203204122.GA26371@redhat.com> <20110203204154.GB26371@redhat.com> <20110203213640.1F516180995@magilla.sf.frob.com> <20110203214450.GA29496@redhat.com> <20110204105343.GA12133@htj.dyndns.org> <20110204130455.GA3671@redhat.com> <20110204144858.GI12133@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204144858.GI12133@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Tejun Heo wrote:
>
> Hey, guys.
>
> On Fri, Feb 04, 2011 at 02:04:55PM +0100, Oleg Nesterov wrote:
> > > Hmm... I can't reproduce the problem here,
> >
> > Very strange. Do you mean the test-case doesn't die? (on vanilla kernel).
>
> Heh, it turns out the second child was attaching before the first
> succeeded stopping itself, so when it gets detached for the first
> time, the first child then stops generating new exit_code.

OOPS! Yes, the test-case is racy.

> Adding a
> small delay to the parent after the first child started made it
> reliably fail on the vanially kernel.

Yes, or waitpid(WSTOPPED).

> > There is no STOPPED/TRACED transformation at all.
>
> But it is.  It happens because there is no clear distinction between
> group stop and ptrace_stop.

Ah, in this sense I agree.

> With my first series applied, it doesn't
> happen anymore because ptracer _never_ depends on or consumes group
> stop exit_code.

Yes, I know ;) Please note "[PATCH 0/1]", I specially mentioned that
your patch should fix the problem too. And yes, my patch is the hack
which doesn't even try to address the underlying problem.

> Yes, I agree it's ugly but that's what we already have.  I think we
> can still achieve well-defined behavior even with ptracer allowed to
> diddle with the task while group stop is in effect.  It may not be
> immediately intuitive but I personally think it actually would be more
> useful to do things that way, as long as we clearly lay out what are
> supported what are undefined.
>
> I think a good compromise would be guaranteeing that when the ptracer
> goes away, the tracee would put into the state the real parent can
> agree to and the real parent to be notified that it has happened.

I am not sure. The tracing should be transparent as much as possible.

> We
> are already skipping all notifications to the real parent for ptraced
> children, there's no pressing need to change that.  If there becomes a
> real pressing requirement to change that.

And this looks just wrong to me. Say, why the ptraced application
doesn't react to ^Z ? It does, just it parent have no chance to see
this. (yes, yes, we should also change do_wait).

> I could be wrong (with pretty high probability) but I don't really see
> the pressing need for a completely new API.  ptrace sure is ugly and
> quirky but it's something people are already used to.

I won't argue. And yes, in any case ptrace can't go away, we should
try to improve it anyway. The obvious problem is that almost any
"visible" improvement breaks something.

Oleg.

