Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0LURAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:00:18 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:38764 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0LURAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cAUGF1FSvC0kzwm+CA11cQnvi1rHuSMLsBwXslnvO1To8ITslVwhDQ+nh+jAepPzmU
         T7D+vIbbkUP1xk/SD/oe4Biv8McWAqTvHrT/lCnoojhXaecrXIM28Iq7xS23d6f51BvE
         mADQNLM3+TzJXsR/7RDpmN7Pv0ulwB2ByYrOA=
Date: Tue, 21 Dec 2010 18:00:12 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 04/16] ptrace: kill tracehook_notify_jctl()
Message-ID: <20101221170011.GC13285@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-5-git-send-email-tj@kernel.org>
 <20101220145956.GC11583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220145956.GC11583@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 03:59:56PM +0100, Oleg Nesterov wrote:
> On 12/06, Tejun Heo wrote:
> >
> > tracehook_notify_jctl() aids in determining whether and what to report
> > to the parent when a task is stopped or continued.  The function also
> > adds an extra requirement that siglock may be released across it,
> > which is currently unused and quite difficult to satisfy in
> > well-defined manner.
> 
> OK. I agree, tracehook_notify_jctl() looks very unobvious, especially
> because it is not really used currently.
> 
> The patch looks correct, except
> 
> > @@ -1853,21 +1850,19 @@ relock:
> >  	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
> >  		int why;
> >
> > -		if (signal->flags & SIGNAL_CLD_CONTINUED)
> > +		if (task_ptrace(current) ||
> > +		    (signal->flags & SIGNAL_CLD_CONTINUED))
> >  			why = CLD_CONTINUED;
> >  		else
> >  			why = CLD_STOPPED;
> 
> Hmm, I can't understand this.
> 
> task_ptrace() should not turn CLD_STOPPED in CLD_CONTINUED?
> 
> Looking ahead, it _seems_ that the next patches keep this logic,
> could you explain?

That's the logic from tracehook_notify_jctl() or I think it is
incorrectly.  Yes, the latter.  I got confused the two parameters.  I
thought tracehook_notify_jctl() always returned CLD_CONTINUED when
traced.  The @why is @notified and CLD_CONTINUED is @why.  :-)

I'll drop the above chunk.  Thanks.

-- 
tejun
