Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2HDXPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 19:15:47 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:35029 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2HDXPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 19:15:45 -0400
From: Serge Hallyn <serge@hallyn.com>
Reply-To: Serge Hallyn <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Forbid invocation of kexec_load() outside initial PID
	namespace
X-Mailer: Modest 3.2
References: <1343991184-3619-1-git-send-email-berrange@redhat.com>
	 <cfa2e2c9-db52-40cd-979b-7a6084427190@email.android.com>
	 <20120803125210.GD12870@redhat.com>
	  <bef31b2b-429b-4b2b-981b-b230f9c6bfad@email.android.com>
In-Reply-To: <bef31b2b-429b-4b2b-981b-b230f9c6bfad@email.android.com>
Content-Type: text/plain; charset=utf-8
Content-ID: <1344122134.1422.1.camel@Nokia-N900-51-1>
Date: Sat, 04 Aug 2012 18:15:35 -0500
Message-Id: <1344122135.1422.2.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

during the container reboot discussion, the agreement was reached that rebooting for real fron non-init pid ns is not safe.  Restarting userspace (in pidns caller owns) is.  I argue the same reasoning supports this.

I haven't had a chance to review the patch, but the idea gets my ack.  I'll look at the patch asap.

I'm also fine with splitting cap_sys_boot into a user and system caps.  The former would only be needed targeted to the userns of the init pid, while the latter would be required to init_user_ns.  Then containers could safely be given cap_sys_restart or whatever, but not cap_sys_boot which authorizes kexec and machine reset/poweroff.

----- Original message -----
> "Daniel P. Berrange" <berrange@redhat.com> wrote:
> 
> > On Fri, Aug 03, 2012 at 05:45:40AM -0700, Eric W. Biederman wrote:
> > > The solution is to use user namespaces and to only test ns_capable on
> > the magic reboot path.
> > > 
> > > For the 3.7 timeframe that should be a realistic solution.
> > 
> > Hmm, that would imply that if LXC wants to allow reboot()/CAP_SYS_BOOT
> > they will be forced to use CLONE_NEWUSER. I was rather looking for a
> > way
> > to allow the container to keep CAP_SYS_BOOT, without also mandating use
> > of user namespaces.
> 
> If we remove the use of CAP_SYS_BOOT on the container reboot path
> perhaps.
> 
> But you have hit one small issue in the huge pile of issues why giving
> contaners capabilities is generally a bad idea.
> 
> This is the reason I have been insisting on a reasonable version of user
> namespaces for a long time.
> 
> When the security issues become important it is time for user
> namespaces.     That is their purpose.
> 
> Eric
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at   http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at   http://www.tux.org/lkml/

