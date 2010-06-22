Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab0FVBO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 21:14:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49177 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab0FVBO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 21:14:56 -0400
Date: Mon, 21 Jun 2010 18:14:52 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] security: Yama LSM
Message-ID: <20100622011452.GN24749@outflux.net>
References: <20100621213424.GG24749@outflux.net>
 <201006220028.o5M0Sbx7062650@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006220028.o5M0Sbx7062650@www262.sakura.ne.jp>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tetsuo,

On Tue, Jun 22, 2010 at 09:28:37AM +0900, Tetsuo Handa wrote:
> Kees Cook wrote:
> > +       /* require ptrace target be a child of ptracer on attach */
> > +       if (mode == PTRACE_MODE_ATTACH && ptrace_scope &&
> > +           !capable(CAP_SYS_PTRACE)) {
> > +               struct task_struct *walker = child;
> > +
> > +               read_lock(&tasklist_lock);
> 
> Holding tasklist_lock does not imply rcu protection.
> Don't you need rcu_read_lock() like setpriority() and getppid()?

You're totally right, thanks for the catch!  Looks like setpriority() does
a similar kind of thing, so I've wrapped the whole thing in rcu_ now:

...
+               rcu_read_lock();
                read_lock(&tasklist_lock);
                while (walker->pid > 0) {
...
                        rc = -EPERM;
                read_unlock(&tasklist_lock);
+               rcu_read_unlock();
...


-Kees

-- 
Kees Cook
Ubuntu Security Team
