Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab1CWJRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:17:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43963 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab1CWJRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=axwOccCJ1I/l1QlNyugbYFHu4SeO2OYqz+akrPBg2crg4c0+DV9MIdO0SHyzvTGLgN
         1h9JgfkgAhgeOlS4BXFoifbTbCVMYz+Idg85voFPowXM4N3yuW4Df5vC+Kd+BI/NvXf6
         DbpEwlSfKFQJk1WVCN40GKHXK9HJoQswf9CHw=
Date: Wed, 23 Mar 2011 10:17:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 7/8] job control: Notify the real parent of job control
 events regardless of ptrace
Message-ID: <20110323091736.GY12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-8-git-send-email-tj@kernel.org>
 <20110321174306.GA29895@redhat.com>
 <20110322080444.GM12003@htj.dyndns.org>
 <20110322194416.GC28038@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322194416.GC28038@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Tue, Mar 22, 2011 at 08:44:16PM +0100, Oleg Nesterov wrote:
> On 03/22, Tejun Heo wrote:
> >
> > On Mon, Mar 21, 2011 at 06:43:06PM +0100, Oleg Nesterov wrote:
> > > Hmm... in fact I can't convince myself we really need to look at
> > > child->group_leader, will recheck... Anyway, this is minor too.
> >
> > Care to elaborate?
> 
> child->real_parent must be equal to child->group_leader->real_parent.

Okay.

> What we need is ptrace_reparented(). But as I said, it should be
> fixed first (I think) and this needs a separate patch/discussion.
> 
> So yes, we need a new helper.
> 
> Well, and look at get_signal_to_deliver(),
> 
> 		leader = current->group_leader;
> 		if (task_ptrace(leader) && !real_parent_is_ptracer(leader))
> 			do_notify_parent_cldstop(leader, true, why);
> 
> Indeed. But in fact task_ptrace(leader) is not needed. If
> real_parent_is_ptracer(tsk) returns false, then tsk must be ptraced.
> 
> So we could write
> 
> 		if (!real_parent_is_ptracer(leader))
> 			do_notify_parent_cldstop(leader, true, why);
> 
> but now this looks confusing because of the naming. Compare with
> 
> 		if (ptrace_reparented(leader))
> 			do_notify_parent_cldstop(leader);

I see but I don't think ptrace_reparented() is a good name for
!same_thread_group(child->parent, child->real_parent).  It gets too
confusing with child->parent != child->real_parent test.

Anyways, I'll leave the renaming for later patch and just update the
->group_leader part.

Thanks.

-- 
tejun
