Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1JTKM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:12:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36079 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1JTKM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:12:57 -0400
MIME-Version: 1.0
In-Reply-To: <1317382585-12172-2-git-send-email-wpk@culm.net>
References: <1317382585-12172-1-git-send-email-wpk@culm.net> <1317382585-12172-2-git-send-email-wpk@culm.net>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 20 Oct 2011 03:12:37 -0700
X-Google-Sender-Auth: YvTTR45h5aStfV4C7nQ1-OjhIOo
Message-ID: <CALdu-PDeW4PfGPePv6gUNihq1J0kKKWEm=6jm5OphcQY9+Jnvg@mail.gmail.com>
Subject: Re: [PATCH 1/6] cgroup: add cgroup.isolation_root flag entry to the
 cgroup filesystem
To: Witold Krecicki <wpk@culm.net>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 4:36 AM, Witold Krecicki <wpk@culm.net> wrote:
> + */
> +static struct cgroup *cgroup_get_isolation_root(struct cgroup *cgrp)
> +{
> +       for (;;) {
> +               if (!cgrp)
> +                       return NULL;
> +               if (isolation_root(cgrp))
> +                       return cgrp;
> +               cgrp = cgrp->parent;
> +       }
> +       return NULL;
> +}

What are the locking requirements for cgroup_get_isolation_root?

> +
> +static int cgroup_isolation_root_write(struct cgroup *cgrp,
> +                                    struct cftype *cft,
> +                                    u64 val)
> +{
> +       if (cgrp->parent == NULL)
> +               return -EBUSY;

EPERM or EINVAL would be more appropriate here, I think.

> +       if (atomic_read(&cgrp->count))
> +               return -EBUSY;

Also need to check for child cgroups, and return -EBUSY?

> +       if (val)
> +               set_bit(CGRP_ISOLATION_ROOT, &cgrp->flags);
> +       else
> +               clear_bit(CGRP_ISOLATION_ROOT, &cgrp->flags);
> +       return 0;
> +}

Arguably we need  to take a lock in these two functions, both to guard
against racing with a creation of a child cgroup or moving in a task
while trying to set its isolation root flag, and to synchronize
readers and writers of the flag. But to be honest I think we can say
that this is one of those cases where we can say that the sysadmin is
dumb enough to have races between his container setup code and his
container population code the result is undefined, as long as we don't
actually crash or leak :-)

Paul
