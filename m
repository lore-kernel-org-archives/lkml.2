Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1EMCuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 22:50:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1EMCuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 22:50:16 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=wom5GMh1gUkA:10 a=2uYajzE4MAAA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=Z4Rwk6OoAAAA:8 a=Xhs_OCri0ZqoKb3a65YA:9 a=wJzhNVX2FVUPdgHEftsA:7 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Thu, 12 May 2011 21:50:13 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: acl_permission_check: disgusting performance
Message-ID: <20110513025013.GA13209@mail.hallyn.com>
References: <BANLkTi=nc3WGaASQm1Pc9byshLOmLf2bXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=nc3WGaASQm1Pc9byshLOmLf2bXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (torvalds@linux-foundation.org):
> Those four instructions are about two thirds of the cost of the
> function. The last two are about 50% of the cost.
> 
> They are the accesses to "current", "->cred", "->user" and "->user_ns"
> respectively (the cmp with the big constant is that compare against
> "init_ns").
> 
> Now, if we got rid of them, we wouldn't improve performance by 2/3rds
> on that function, because we do need the two first accesses for
> "fsuid" (which is the next check), and the third one (which is
> currently "cred->user" ends up doing the cache miss that we'd take for
> "cred->fsuid" anyway. So the first three costs are fairly inescapable.
> 
> They are also cheaper, probably because those fields tend to be more
> often in the cache. So it really is that fourth one that hurts the
> most, as shown by it taking almost a third of the cycles of that
> function.
> 
> And it all comes from that annoying commit e795b71799ff0 ("userns:
> userns: check user namespace for task->file uid equivalence checks"),
> and I bet nobody involved thought about how expensive that was.
> 
> That "user_ns" is _really_ expensive to load. And the fact that it's
> after a chain of three other loads makes it all totally serialized,
> and makes things much more expensive.
> 
> Could we perhaps have "user_ns" directly in the "struct cred"? Or

The only reason not to put it into struct cred would be to avoid growing
the struct cred.  For that matter, esp since you can't unshare the user_ns,
it could also go right into the task_struct.

(Eric's sys_setns patchset will eventually complicate that, but I don't
think it'll be a problem)

> could we avoid or short-circuit this check entirely somehow, since it
> always checks against "init_ns"?

Of course I'm hoping that before fall the check won't be against
init_ns any more :)  I was actually hoping to get back to that next
week, so I can start by testing the caching you suggest.

thanks,
-serge
