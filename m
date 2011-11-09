Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1KIOTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:19:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1KIOTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:19:05 -0500
Date: Wed, 9 Nov 2011 08:18:53 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Serge Hallyn <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, oleg@redhat.com, richard@nod.at,
        ebiederm@xmission.com, dhowells@redhat.com, eparis@redhat.com
Subject: Re: [PATCH 1/6] user namespace: make signal.c respect user
 namespaces (v4)
Message-ID: <20111109141853.GB4010@sergelap>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
 <1320445482-8459-2-git-send-email-serge@hallyn.com>
 <20111108162216.1ffb3e9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108162216.1ffb3e9a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Fri,  4 Nov 2011 22:24:37 +0000
> Serge Hallyn <serge@hallyn.com> wrote:
> 
> > +static inline void fixup_uid(struct siginfo *info, struct task_struct *t)
> > +{
> > +#ifdef CONFIG_USER_NS
> > +	if (current_user_ns() == task_cred_xxx(t, user_ns))
> > +#endif
> > +		return;
> > +
> > +	if (SI_FROMKERNEL(info))
> > +		return;
> > +
> > +	info->si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
> > +					current_cred(), info->si_uid);
> > +}
> 
> err, this function is a no-op if CONFIG_USER_NS=n.  If that was
> intentional then why on earth do this in such a weird fashion?  If

(I didn't write it, but)  I think the assumption was that the compiler
would optimize it all away if !CONFIG_USER_NS, and in this way the
call site didn't need to be obscured with the #ifdef.  Is there a way
that's better?  Would you prefer something like:

+#ifdef CONFIG_USER_NS
+static inline void fixup_uid(struct siginfo *info, struct task_struct *t)
+{
+	if (current_user_ns() == task_cred_xxx(t, user_ns))
+		return;
+
+	if (SI_FROMKERNEL(info))
+		return;
+
+	info->si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
+					current_cred(), info->si_uid);
+}
+#else
+static inline void fixup_uid(struct siginfo *info, struct task_struct *t)
+{
+		return;
+}
+#endif

?  It's less sneaky at least.

> unintentional then it makes me wonder how well tested all this was with
> CONFIG_USER_NS=n?
> 
> I vaguely remember that I've forgotten how all this stuff works.  Some
> additional review input would be nice (cough-oleg-cough).
> 
