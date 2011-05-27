Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab1E0SV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:21:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35171 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1E0SV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DMByl8d+WuMrRhh+12HPTI3ysU+GC9G5f+8S3PvsoKpeWp1y8gS+HX3xQ/Oct4ffFW
         VvNbI0s8y+EraVPDKWfuwvb7qQ0UJOo+LXKeGCsar01LdQx61CSyebeqtSV90oWM4Vxo
         ifXBX/JiN4vJ2wSe5sFoLni88ywpeoEPff64U=
Date: Fri, 27 May 2011 20:21:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110527182121.GA3212@mtj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-4-git-send-email-tj@kernel.org>
 <201105180240.56754.vda.linux@googlemail.com>
 <20110518095539.GU20624@htj.dyndns.org>
 <20110523124314.GA7232@redhat.com>
 <20110524102834.GC10334@htj.dyndns.org>
 <20110525182919.GB16575@redhat.com>
 <20110526091401.GD9715@htj.dyndns.org>
 <20110526150150.GD12525@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526150150.GD12525@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 26, 2011 at 05:01:50PM +0200, Oleg Nesterov wrote:
> On 05/26, Tejun Heo wrote:
> > > Or we can change do_wait() to detach a zombie leader. In this case it
> > > is not clear what should we do if the debugger is the real parent.
> > > Perhaps do_wait() should do the same: detach a leader (but not reap).
> > > When the last thread does, the real parent will be notified again.
> > > IOW, wait(tgid) can succeed twice.
> >
> > Just letting PTRACE_DETACH work for zombies sounds much simpler to me.
> 
> Probably, but please note we have to modify do_wait() anyway. Otherwise
> in general the tracer simply can not know the tracee has exited. IOW,
> waitpid(zombie_leader_pid, WEXITED) should succeed without reaping if
> delay_group_leader(), then the tracer can do PTRACE_DETACH. But this is
> not symmetrical with sub-thread zombies.

Yes, complicated.  The task/process duality conflicts.  wait(2)
already is different for group leader and succeeds twice for the
ptracer and the real parent (when they're different).

If we relocate ptrace group leader zombie wait, as suggested, such
that it waits for the task itself rather than the whole group, we
would be taking away a feature - ptracer waiting for the whole process
to exit and having access to group exit code, which might not mean
much, I have no idea.

I think group leader wait becoming asymmetrical with sub-thread
zombies is perfectly fine - it already is.  But would it be okay to
change ptrace wait(2) on group leader to wait for the task itself
rather than the whole group?

Thanks.

-- 
tejun
