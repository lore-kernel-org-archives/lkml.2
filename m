Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1BXAsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:48:07 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:37614
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751834Ab1BXAsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:48:05 -0500
Date: Thu, 24 Feb 2011 00:48:18 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 4/9] allow killing tasks in your own or child userns
Message-ID: <20110224004818.GA11822@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
 <20110217150325.GD26395@mail.hallyn.com>
 <20110218155921.440f1137.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218155921.440f1137.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Thu, 17 Feb 2011 15:03:25 +0000
> "Serge E. Hallyn" <serge@hallyn.com> wrote:
> 
> >  /*
> > + * called with RCU read lock from check_kill_permission()
> > + */
> > +static inline int kill_ok_by_cred(struct task_struct *t)
> > +{
> > +	const struct cred *cred = current_cred();
> > +	const struct cred *tcred = __task_cred(t);
> > +
> > +	if (cred->user->user_ns == tcred->user->user_ns &&
> > +	    (cred->euid == tcred->suid ||
> > +	     cred->euid == tcred->uid ||
> > +	     cred->uid  == tcred->suid ||
> > +	     cred->uid  == tcred->uid))
> > +		return 1;
> > +
> > +	if (ns_capable(tcred->user->user_ns, CAP_KILL))
> > +		return 1;
> > +
> > +	return 0;
> > +}
> 
> The compiler will inline this for us.

Is that simply true with everything (worth inlining) nowadays, or is
there a particular implicit hint to the compiler that'll make that
happen?

Not that I guess it's even particularly important in this case.

From: Serge E. Hallyn <serge.hallyn@canonical.com>
Date: Thu, 24 Feb 2011 00:26:02 +0000
Subject: [PATCH 1/2] userns: let compiler inline kill_ok_by_cred (per akpm)

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ffe4bdf..12702b4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -638,7 +638,7 @@ static inline bool si_fromuser(const struct siginfo *info)
 /*
  * called with RCU read lock from check_kill_permission()
  */
-static inline int kill_ok_by_cred(struct task_struct *t)
+static int kill_ok_by_cred(struct task_struct *t)
 {
 	const struct cred *cred = current_cred();
 	const struct cred *tcred = __task_cred(t);
-- 
1.7.0.4

