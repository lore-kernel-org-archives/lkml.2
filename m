Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1KSXZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 18:25:36 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:40095 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1KSXZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 18:25:35 -0500
Date: Sat, 19 Nov 2011 23:25:37 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>, richard@nod.at,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, dhowells@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 6/6] protect cap_netlink_recv from user namespaces
Message-ID: <20111119232537.GB13312@hallyn.com>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
 <1320445482-8459-7-git-send-email-serge@hallyn.com>
 <1320694510.10093.23.camel@localhost>
 <20111108032902.GA29433@hallyn.com>
 <1320848342.10093.57.camel@localhost>
 <m11ut41nqy.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11ut41nqy.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Eric Paris <eparis@redhat.com> writes:
> 
> > On Tue, 2011-11-08 at 03:29 +0000, Serge E. Hallyn wrote:
> >> Quoting Eric Paris (eparis@redhat.com):
> >
> >> But, regardless, your point is valid in that I'm not tightening down as
> >> much as I could.  So how about I don't change the security_netlink_recv()
> >> and callers yet, and instead I change cap_netlink_recv() to do:
> >> 
> >> 	if (!IN_ROOT_USER_NS && !cap_raised(current_cap(), cap))
> >
> > Actually better thought.  Remove the LSM hook altogether and just use
> > capable() in the callers.  This hook, being used this way, was
> > introduced in c7bdb545 back when we took the effective perms from the
> > skb.  We don't use the skb any more since netlink is synchronous.  This
> > is functionally equivalent except the capabilities code checks against
> > the init_user_ns (something we want) and it will now set PF_PRIV (which
> > also seems like a good thing) Something like:
> >
> > security: remove the security_netlink_recv hook as it is equivalent to capable()
> >     
> > Once upon a time netlink was not sync and we had to get the effective
> > capabilities from the skb that was being received.  Today we instead get
> > the capabilities from the current task.  This has rendered the entire
> > purpose of the hook moot as it is now functionally equivalent to the
> > capable() call.
> >
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Darn.  I missed this one went it went past the first time.  Let's do
> this.
> 
> As Serge pointed out checking against the user namespace of the network
> namespace happens to be safe because the subsystems that are brittle
> really have problems don't support multiple network namespaces.
> 
> Still I like the idea of erring on the conservative side here and
> making everything safe.  We can open relax the restrictions later
> by using ns_capable.  I want to get to a point where it is safe
> for an unprivileged user to create their own user namespace,
> and most of that is just getting the capable calls correct.
> 
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in

Ok.  Oh!  This was a part of my new 6-patch set I was going to send, but
when you pursuaded me that some were not worth it if you're rethinking the
nature of uids, I only sent patch 1.

I did queue up the patch at http://kernel.ubuntu.com/git?p=serge/linux-2.6.git;a=commit;h=b97c54cb518160466095db8f8d2ecf5bd4f81ce2
and tested it a bit in ltp (with userns both on and off).

Eric Paris, would you like to resend it separately (with Eric's and my
ack's, as above and at http://lkml.org/lkml/2011/11/9/195), or would you
like me to do so?

thanks,
-serge
