Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2H2Nux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 09:50:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52698 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2H2Nuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 09:50:51 -0400
MIME-Version: 1.0
In-Reply-To: <1346213517.2522.2.camel@edumazet-glaptop>
References: <1345653510-22000-1-git-send-email-nzimmer@sgi.com>
	<1345660110.5158.1969.camel@edumazet-glaptop>
	<1345671778.5158.2369.camel@edumazet-glaptop>
	<20120828203826.GA5868@p183.telecom.by>
	<1346213517.2522.2.camel@edumazet-glaptop>
Date: Wed, 29 Aug 2012 16:50:50 +0300
Message-ID: <CACVxJT_ZRvznb3M=jq_du_aJvRmjcAb3=LSXFGYFWe5W2xo93A@mail.gmail.com>
Subject: Re: [PATCH] fs/proc: Move kfree outside pde_unload_lock
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 7:11 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> I'll polish this patch once LKS/LPC is over...

It should oops in the following way (excuse Gmail please):
PDEO is removed from lists
->pde_users is 0
PDE won't be in purge queue -- no ->release while module is alive

Current code removes PDEO and checks if PDE scheduled for removal atomically.

proc_reg_release                                        remove_proc_entry

                                                        de->proc_fops = NULL;
release = pde_opener_del(inode, file);
rcu_read_lock();
                                                        synchronize_rcu();
fops = rcu_dereference(pde->proc_fops);
if (!fops) {
        rcu_read_unlock();
                         ----------------------------------
                                                        /* NOP */
                                                        while
(atomic_read(&de->pde_users))
                                                                ...
                                                        /* NOP */

pde_openers_purge(de, &purge_queue);
                                                        /* NOP */
                                                        while
(!list_empty(&purge_queue))
                                                                ...
                                                        rmmod

        if (release)
                release(inode, file) /* OOPS */
