Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab1FWNsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:48:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57303 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399Ab1FWNsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=RXgrSE8vBKhq1M4b5EUhsSs7GqCLUB3B84u9Ld6xwpBJYSvOlVymtJGSExd+p1neUb
         FN4RPe1RcZPMm6FcLM1N3w5j6p464uKb71CeRrAumMTiIXe/pQEe2JN6Mkq9KLmygef5
         2evK2rFkoEuAp6C2c0tZlBrTbXRZrPD6LxFKk=
Date: Thu, 23 Jun 2011 15:48:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Menage <menage@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 4/4] cgroups: Add an rlimit subsystem
Message-ID: <20110623134759.GC8058@somewhere.redhat.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
 <1308527474-20704-5-git-send-email-fweisbec@gmail.com>
 <BANLkTin_MA+Yc7=q=cK5s2CbCfu_xmqTAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin_MA+Yc7=q=cK5s2CbCfu_xmqTAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:37:03AM -0700, Paul Menage wrote:
> On Sun, Jun 19, 2011 at 4:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > +static void rlim_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
> > +                     struct cgroup *old_cgrp, struct task_struct *task)
> > +{
> > +       rlim_remove_proc(old_cgrp);
> > +}
> 
> Since this is used for both the exit callback and the attach callback,
> it should have a more generic name.

Right.
 
> > +static int rlim_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
> > +{
> > +       struct rlim *rlim = cgroup_rlim(cgrp);
> > +       struct res_counter *limit_fail_at;
> > +
> > +       return res_counter_charge(&rlim->proc_counter, 1, &limit_fail_at);
> > +}
> 
> Can't this fail spuriously in the presence of hierarchies?
> 
> E.g. if cgroup A has children, and A is at its limit, then moving
> tasks around between A and its children, or between different children
> of A, seems like it would fail due to the temporary double counting.

Good point. Probably I should first uncharge the old cgroup and its parents.
