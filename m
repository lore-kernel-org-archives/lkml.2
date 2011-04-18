Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1DRThx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:37:53 -0400
Received: from smtp.outflux.net ([198.145.64.163]:32937 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab1DRThv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:37:51 -0400
Date: Mon, 18 Apr 2011 12:37:15 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>
Cc: linux-kernel@vger.kernel.org, taviso@cmpxchg8b.com, security@kernel.org
Subject: Re: Kernel panic (NULL ptr deref?) in find_ge_pid()/next_pidmap()
 (via sys_getdents or sys_readdir)
Message-ID: <20110418193715.GH4800@outflux.net>
References: <BANLkTik8nOXJb3J9=m4-2Ugw4P7AFzCQoA@mail.gmail.com>
 <BANLkTim8=Tf62gfTePczL11K_tYm71NXwg@mail.gmail.com>
 <BANLkTi=5k1r-hxNerVKAsXeKksvLSaSU8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=5k1r-hxNerVKAsXeKksvLSaSU8A@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Mon, Apr 18, 2011 at 02:57:55PM +0200, Robert Święcki wrote:
> and a repro - should be quite obvious for FS folks, I guess
> filp->f_pos needs better checking in proc's readdir (or in llseek).

Yup:

int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
{
        unsigned int nr = filp->f_pos - FIRST_PROCESS_ENTRY;
...
        for (; nr < ARRAY_SIZE(proc_base_stuff); filp->f_pos++, nr++) {
...
        }

        ns = filp->f_dentry->d_sb->s_fs_info;
        iter.task = NULL;
        iter.tgid = filp->f_pos - TGID_OFFSET;
...

There's no test to validate f_pos. If it's out of bounds, the "for"
just doesn't run.

-Kees

-- 
Kees Cook
Ubuntu Security Team
