Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1CWRUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:20:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47017 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab1CWRUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X37+rPVhbnXot/i36VWi/rZG7ZHm+WJT6h3NWNrZCgcXGxRbSxHFEGF8Vk1BLgCWRR
         9054bEoxJrtSLjSKT+sI6xDbQS5M1IcK+Hay0Mww+6MKMyA/8DjDciKRT4SRvhCVaVUq
         oVfS5lU4EOEm1RO6f2/I4qIgvp5pKEZPSONME=
Date: Wed, 23 Mar 2011 18:20:25 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 7/8] job control: Notify the real parent of job control
 events regardless of ptrace
Message-ID: <20110323172025.GG12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-8-git-send-email-tj@kernel.org>
 <20110321174306.GA29895@redhat.com>
 <20110322080444.GM12003@htj.dyndns.org>
 <20110322194416.GC28038@redhat.com>
 <20110323091736.GY12003@htj.dyndns.org>
 <20110323092455.GZ12003@htj.dyndns.org>
 <20110323164657.GB22527@redhat.com>
 <20110323165907.GE12003@htj.dyndns.org>
 <20110323170708.GA24304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323170708.GA24304@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 23, 2011 at 06:07:08PM +0100, Oleg Nesterov wrote:
> On 03/23, Tejun Heo wrote:
> > On Wed, Mar 23, 2011 at 05:46:57PM +0100, Oleg Nesterov wrote:
> > > > Ooh, on a related note, we probably want to change
> > > > do_notify_parent_cldstop() too.  tsk->group_leader->real_parent is
> > > > used as the delivery target when !@for_ptracer.  This is the same with
> > > > tsk->real_parent and the code has been like this for a long time but
> > > > is a bit confusing.
> > >
> > > Yes, although in this case we do
> > >
> > > 		tsk = tsk->group_leader;
> > > 		parent = tsk->real_parent;
> > >
> > > We need to change tsk to report the correct si_pid. But we could do
> > >
> > > 		parent = tsk->real_parent;
> > > 		tsk = tsk->group_leader;
> > >
> > > not sure this looks less confusing.
> >
> > They themselves are about the same but the inconsistency with the
> > is_real_parent() test is a bit confusing, I think.  If we're testing
> > for duplicates by testing ->real_parent against ->parent then the
> > actual delivery should be also be using ->real_parent and ->parent,
> > so...
> 
> Hmm. So I misunderstood you. And still can't understand...
> 
> Could you explain how should we change do_notify_parent_cldstop()?
> I am just curious.

As you suggested above. :-) The inconsistency I'm concernced about is
the following.

 /*
  * Test whether the target task of the usual cldstop notification - the
  * real_parent of @child - is in the same group as the ptracer.
  */
 static bool real_parent_is_ptracer(struct task_struct *child)
 {
	 return same_thread_group(child->parent, child->real_parent);
 }

So, here, we're saying that if child->parent and child->real_parent
are in the same thread group, they're gonna be duplicates, but in
do_notify_parent_cldstop(), we target tsk->group_leader->real_parent,
which should be the same as tsk->real_parent but confusing
nonetheless.  That's actually the reason why I used
child->group_leader->real_parent in the first place.

Thanks.

-- 
tejun
