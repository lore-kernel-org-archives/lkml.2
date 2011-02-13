Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1BMVYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 16:24:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50949 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab1BMVYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 16:24:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=HStDDR34UQl0sFqCcY+LPWvDlrzNKha0HcEnegsyw0zPg/fxnu7TVhUv0SSp2MkuQr
         FqM/de7SwQoBjS46CBZczOVVGSBQumMJ1jz+MlbbbufIN0WFW/rq9atnEuQOH7uJjcOv
         yhDs7OG2LqLCG0B+U2KcBONjyPYa5+b1cQc4A=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
Date: Sun, 13 Feb 2011 22:24:25 +0100
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <20110204130455.GA3671@redhat.com> <20110204144858.GI12133@htj.dyndns.org>
In-Reply-To: <20110204144858.GI12133@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201102132224.25197.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 February 2011 15:48, Tejun Heo wrote:
> > But even this doesn't matter. We can not change ptrace API so that,
> > say, it does not reparent the tracee. Once we do this, we already
> > have the new API.
> 
> I would argue that we can get by well enough by trimming and updating
> the curren ptrace API.

In the past Roland wasn't very enthusiastic about changes which
were fixing ptrace's bugs-turned-features.

If you want to do that, you need to convince him to change
his position a bit.

For example, PTRACE_DETACH requires tracee to be stopped to succeed.
If debugger tries to detach while the tracee is running, it will get
an error. This forces debugger to do stupid things like sending SIGSTOP,
then waiting for tracee to stop, then doing PTRACE_DETACH, then
sending SIGCONT. Of course, while this dance is performed,
any SIGSTOPs/SIGCONTs which may be  sent to the tracee by other processes
are totally disrupted by this.

The natural (for me) fix is to make PTRACE_DETACH work even on running
tracee. It simply makes a lot of sense. Why on earth do we need tracee
to be stopped? There is no reason.

But this is a change in ptrace behavior, and therefore is not acceptable
for Roland.

Basically, we have slightly idea what are ptrace's development goals are.

>From my POV, we want to have strace tool which is *completely*, 100%
transparent for traced process and its parent (sans decrease in speed).
No "vfork turns into fork under strace" (we had this sometime ago),
no missed or misinterpreted SIGSTOPs or SIGTRAPs. Real parent
should still see its child stopping on ^Z even if strace -p PID
attached itself to the child. Etc etc etc.

If this can only be achieved by slightly changing (basically, fixing)
ptrace API, I'd go for it.

In many cases, Roland won't.

He is the maintainer. If you want changes which break some aspects of
current behavior, even quirky ones, you need to convince him.


> I could be wrong (with pretty high probability) but I don't really see
> the pressing need for a completely new API.  ptrace sure is ugly and
> quirky but it's something people are already used to.

-- 
vda
