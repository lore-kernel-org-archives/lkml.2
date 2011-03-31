Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1CaU65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:58:57 -0400
Received: from mail.aknet.ru ([78.158.192.28]:36102 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab1CaU64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:58:56 -0400
Message-ID: <4D94EAEE.2010505@aknet.ru>
Date: Fri, 01 Apr 2011 00:58:22 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D94BE19.7050001@aknet.ru> <20110331181816.GA17101@redhat.com>
In-Reply-To: <20110331181816.GA17101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

31.03.2011 22:18, Oleg Nesterov wrote:
> >  +			if (me->real_parent == init_pid_ns.child_reaper)
>  Also, the task can be the child of /sbin/init's sub-thread.
Hmm, how to check then? Should I add the "exact_parent" just
for that? Or traverse the sibling list? How bad. :(


> There are. zap_other_threads() for example. More importantly, we
> can have more of them. exit_state != 0 means: this task has passed
> exit_notify(), we shouldn't break this.
OK.

> Ah, I _seem_ to recall... Yes, it seems strange that only group leader
> can do PR_DETACH. If we implement this, I think any thread should be
> allowed to call prctl(DETACH). But why do we need to change the leader?
OK, I didn't know it is safe to leave it unchanged.

 > I didn't look at the patch above, but probably it makes more sense.
 > At least for the start.
IIRC strace didn't like the fact that wait() fails, and that's
why I started to add the complexity.

> I didn't mean it is very hard to understand the intent. What is
> really hard (at least to me) to see if it is correct or not.
OK, I'll try to break it into a small chunks then.
But the fact that such a seemingly simple functionality
requires so many changes, is IMHO bad by itself. And it
is also non-trivial to implement mostly because of the
ptrace hooks that are everywhere. Some cleanups are
certainly needed in that area. :)

> So, just in case, I have to admit: yes, personally I dislike this
> new feature ;)
Do you dislike a feature by itself, or by its implementation?
The feature by itself does nothing but to allow the daemon()
to work with threads, which can't be bad IMO, and, in some
cases, the inability to do so is difficult to work around. Of course,
these cases have nothing to do with the good design, but rather
with the vendor-provided poorly-coded drivers and libs. In all
the better cases you have the trivial workarounds, but why to
search for the workarounds at all, in the first place? Why not
to have the daemon() to "just work" with threads? :)

> >  As for convincing LKML... Well, when the code is right, maybe. :))
> Maybe ;)
>
> But, otoh. It is quite possible you will get the quick nack...
Well, with such a rate of additions into a thread_struct, I'll
probably nack it myself soon, but again, I am surprised that
such a simple task requires so many untrivial changes.
