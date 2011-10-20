Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1JTNUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:20:55 -0400
Received: from mx.kernel.net.pl ([217.73.31.3]:39438 "EHLO an2.kernel.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751740Ab1JTNUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:20:54 -0400
From: Witold Krecicki <wpk@culm.net>
To: Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/6] cgroup: add cgroup.isolation_root flag entry to the cgroup filesystem
Date: Thu, 20 Oct 2011 15:20:44 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.6.2; x86_64; ; )
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <1317382585-12172-1-git-send-email-wpk@culm.net> <1317382585-12172-2-git-send-email-wpk@culm.net> <CALdu-PDeW4PfGPePv6gUNihq1J0kKKWEm=6jm5OphcQY9+Jnvg@mail.gmail.com>
In-Reply-To: <CALdu-PDeW4PfGPePv6gUNihq1J0kKKWEm=6jm5OphcQY9+Jnvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110201520.45234.wpk@culm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia czwartek, 20 października 2011 o 12:12:37 Paul Menage napisał(a):
> On Fri, Sep 30, 2011 at 4:36 AM, Witold Krecicki <wpk@culm.net> wrote:
> > + */
> > +static struct cgroup *cgroup_get_isolation_root(struct cgroup *cgrp)
> > +{
> > +       for (;;) {
> > +               if (!cgrp)
> > +                       return NULL;
> > +               if (isolation_root(cgrp))
> > +                       return cgrp;
> > +               cgrp = cgrp->parent;
> > +       }
> > +       return NULL;
> > +}
> 
> What are the locking requirements for cgroup_get_isolation_root?

IMHO none - this function is performed only if there is a task in a cgroup, so 
cgroup cannot be removed (and a task cannot leave cgroup) - also, you cannot 
change isolation_root flag if the isolation_root is busy. 


In here we really need locking, after fixes:
static int cgroup_isolation_root_write(struct cgroup *cgrp,
                                     struct cftype *cft, 
                                     u64 val)
{
        if (cgrp->parent == NULL)
                return -EPERM; 
        cgroup_lock();
        if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
                cgroup_unlock();
                return -EBUSY;
        }
        if (val)
                set_bit(CGRP_ISOLATION_ROOT, &cgrp->flags);
        else
                clear_bit(CGRP_ISOLATION_ROOT, &cgrp->flags);
        cgroup_unlock();
        return 0;
}
> Arguably we need  to take a lock in these two functions, both to guard
> against racing with a creation of a child cgroup or moving in a task
> while trying to set its isolation root flag, and to synchronize
> readers and writers of the flag. But to be honest I think we can say
> that this is one of those cases where we can say that the sysadmin is
> dumb enough to have races between his container setup code and his
> container population code the result is undefined, as long as we don't
> actually crash or leak :-)
I guess that fixes that problem?
-- 
WK

