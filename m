Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1KGTfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:35:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab1KGTfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:35:23 -0500
Message-ID: <1320694510.10093.23.camel@localhost>
Subject: Re: [PATCH 6/6] protect cap_netlink_recv from user namespaces
From: Eric Paris <eparis@redhat.com>
To: Serge Hallyn <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        oleg@redhat.com, richard@nod.at, akpm@linux-foundation.org,
        ebiederm@xmission.com, dhowells@redhat.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Date: Mon, 07 Nov 2011 14:35:10 -0500
In-Reply-To: <1320445482-8459-7-git-send-email-serge@hallyn.com>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
	 <1320445482-8459-7-git-send-email-serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 22:24 +0000, Serge Hallyn wrote:
> From: Serge E. Hallyn <serge.hallyn@canonical.com>
> 
> cap_netlink_recv() was granting privilege if a capability is in
> current_cap(), regardless of the user namespace.  Fix that by
> targeting the capability check against the user namespace which
> owns the skb.
> 
> Caller passes the user ns down because sock_net is static inline defined in
> net/sock.h, which we'd rather not #include at the cap_netlink_recv function.

This is wrong at least in relation to audit.  I don't know the other
code well enough to know if I think it's ok there.  Lets say I have
(CAP_SYS_ADMIN | CAP_SETUID | CAP_SETGID) and I create a new task with
CLONE_NEWNAME.  This task then immediately does the needful to remove
all audit rules (which supposedly requires CAP_AUDIT_CONTROL).  That's
going to succeed because the task is init in it's namespace, aka:

        /* The creator of the user namespace has all caps. */
        if (targ_ns != &init_user_ns && targ_ns->creator == cred->user)
                return 0;

But it just screwed with a global resource.  aka audit.  I don't know
the meaning of these others, but it seems to me probably most or all of
them should be against the init_user_ns, not the namespace the skb came
from....

What am I missing?

-Eric

