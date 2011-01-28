Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1A1LAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 06:00:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64997 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1A1LAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 06:00:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xYSTBJfsVC5g8IUikdATVPr8rw32u4pK2oZhxM5YuXK/OFQ3MSFY6Ms7nJMhrJOYTp
         fTAz/0ocdX5pCPi8QJyQkbQdciki+bZ+JG53E8MAJWMu8aET2Waf1TKcMeLpXGlfPWoQ
         lda2ytHFu4NVVZIvrgfISVcOafxZ9EJko0Nnw=
Date: Fri, 28 Jan 2011 11:59:57 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 2/4] ptrace: remove the extra wake_up_process() from
 ptrace_detach()
Message-ID: <20110128105957.GJ24925@htj.dyndns.org>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
 <1293016398-18001-3-git-send-email-tj@kernel.org>
 <20110117221340.E6A4F180996@magilla.sf.frob.com>
 <20110127133412.GC24925@htj.dyndns.org>
 <20110128070252.709F8183C1A@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128070252.709F8183C1A@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Roland.

On Thu, Jan 27, 2011 at 11:02:52PM -0800, Roland McGrath wrote:
> > On Mon, Jan 17, 2011 at 02:13:40PM -0800, Roland McGrath wrote:
> > > Of course I agree that the current code is wrong here.  But I'm still not
> > > at all clear on what practical compatibility problems it introduces.  This
> > > change is OK if and only if we are really making the only area clean and
> > > well-defined in the same release cycle.
> > 
> > I don't follow what you meant by the above sentence.  Can you please
> > clarify a bit?
> 
> I think I meant to write "the whole area" rather than "the only area".
> The point I meant to make is that removing this (wrong) wake-up entirely
> should only be done when we are also thoroughly cleaning up and verifying
> everything about the behavior of stopping/resuming in ptrace.  When we get
> to a clear statement of what all the rules are and we really believe that
> the new code matches those rules, then fine.  When we are still in the
> quagmire, no change is better than an incremental change whose subtle
> ramifications we can't clearly articulate.

Hmm... I'm not sure I quite agree.  We sure should proceed with the
big picture in mind but procedding gradually is usually the better and
sometimes the only way to get there.  Unconditional wake up doesn't
belong anywhere no matter which direction we end up taking.  It's a
natural step to take.

> > It's slightly more serious than that.  Calling wake_up_process()
> > unconditionally can cause a quite serious failure.  It wakes up a
> > process in any state and there are code paths which aren't prepared to
> > be woken up unless certain conditions are met.  
> 
> I understand that.  But I don't recall having seen anyone cite an actual
> scenario in the real world where it does something problematic.

I don't think it will be easily seen during regular use.  Debugging is
often pretty slow paced and tasks are usually stopped in well known
places.  But it does make a pretty decent attack vector for malicious
users.  I don't think it will take too much effort to come up with a
proof-of-concept DOS attack exploiting this.  It's plain dangerous to
do this no matter how unlikely regular users might hit it.

> > A safer choice can be changing it to wake up only tasks in interruptible
> > sleep.
> 
> For ptrace-related purposes, wake_up_state(child, TASK_TRACED|TASK_STOPPED)
> ought to cover anything that it is doing now that anything could reasonably
> be relying on.

That probably is something we need to do for -stable, I agree.

> > I have very difficult time imagining what real user visible
> > implication it would have in negative and noticeable manner, so while
> > I do agree that we should proceed carefully, I think it would be
> > better to take the chance and remove the erratic behavior.  We have
> > release cycles and testing at multiple layers after all.  If we find
> > out that it breaks something in serious manner, we can always revert.
> 
> "Difficult time imagining" and ptrace subtleties unfortunately often go
> together.

But that's the only way forward.  Ptrace sure is complicated, some
part due to its inherent nature but more because things were
continuously piled on top of it without proper clean up, but other
parts of kernel are complicated too and we make changes all the time.
We have the whole release cycle structure and testing hierarchies
throughout the ecosystem to enable changes like this.

> I want to be sure we are doing something right, rather than just
> being thoroughly unsure that we aren't doing something wrong.

But this is something which is apparently wrong and highly unlikely to
cause any problem especially because with the patchset an attached
task is always in traced state on detach and thus always gets
signal_wake_up().  The only difference is removal of an extra spurious
unconditional wakeup which may or may not disturb the group stop
depending on timing.  If we can't change this, I don't know what we
can.

Thank you.

-- 
tejun
