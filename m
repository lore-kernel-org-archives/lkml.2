Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0C2Hrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:47:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:52776 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab0C2Hru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:47:50 -0400
Date: Mon, 29 Mar 2010 18:47:40 +1100
From: Neil Brown <neilb@suse.de>
To: Neil Brown <neilb@suse.de>
Cc: ebiederm@xmission.com (Eric W. Biederman),
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs: simplify handling for s_active refcount
Message-ID: <20100329184740.5d99edef@notabene.brown>
In-Reply-To: <20100329154325.2bb42a9c@notabene.brown>
References: <20100324031829.2136.66489.stgit@notabene.brown>
	<20100324032008.2136.52640.stgit@notabene.brown>
	<m139znogl0.fsf@fess.ebiederm.org>
	<20100326163236.1ffb2c2b@notabene.brown>
	<m1bpebfrhv.fsf@fess.ebiederm.org>
	<20100329154325.2bb42a9c@notabene.brown>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 15:43:25 +1100
Neil Brown <neilb@suse.de> wrote:

> However if we do consider memory ordering guarantees we can describe a clear
> limit to the possibly delay between SYSFS_FLAG_REMOVED being set, and being
> seen.  The atomic_inc_not_zero serves as a memory barrier in exactly the same
> way that the current code requires atomic_dec_return.  So while
> 
> 	if (likely(sd)
> 	    && (sd->s_flags & SYSFS_FLAG_REMOVED) == 0
> 	    && atomic_inc_not_zero(&sd->s_active)) {
> 
> could possibly gain a reference even 'after' SYS_FLAG_REMOVED as been set,
> a second call to this on the same processor will see SYSFS_FLAG_REMOVED.
> So at the absolute most, we could see NCPUS active references gained and
> dropped after SYSFS_FLAG_REMOVED was set - a clear limit which is all we need.

It just occurred to me that this 'proof' isn't quite complete in itself.  I
need to also show that there is a suitable memory barrier after
SYSFS_FLAG_REMOVED is set.  There is as it is always set under sysfs_mutex,
so the mutex_unlock provides a barrier.
So after sysfs_mutex is unlocked, it is conceivable that each CPU could grant
one active reference against the sysfs_dirent before SYSFS_FLAG_REMOVED was
globally visible.

> I'm still not sure we even need to argue in terms of memory barriers to be
> sure the code is correct, but it seems they are sufficient to give a simple
> proof.

NeilBrown
