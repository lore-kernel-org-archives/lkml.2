Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab0CZEus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 00:50:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38319 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab0CZEuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 00:50:46 -0400
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kref: create karef and use for sysfs_dirent->s_active
References: <20100324031829.2136.66489.stgit@notabene.brown>
	<20100324032008.2136.61287.stgit@notabene.brown>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 25 Mar 2010 21:50:42 -0700
In-Reply-To: <20100324032008.2136.61287.stgit@notabene.brown> (NeilBrown's message of "Wed\, 24 Mar 2010 14\:20\:08 +1100")
Message-ID: <m17hozlm8t.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: neilb@suse.de, linux-kernel@vger.kernel.org, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> ->s_active is almost a kref, but needs atomic_inc_not_zero which
> is not generally appropriate for a kref, as you can only access a
> kreffed object if you hold a reference, and in that case the counter
> cannot possibly be zero.
>
> So introduce 'karef' - a counter of active references.  An active
> reference is separate from an existential reference and normally
> implies one.
> For a karef, get_not_zero have be appropriate providing a separate
> existential reference is held.
>
> Then change sysfs_dirent->s_active to be the first (and so-far only)
> karef. super_block->s_active is another candidate to be a karef.

If this actually captured the semantics of active references I would find
this interesting.  But you currently miss the inconvenient but crucial
part of preventing new references after deletion, and you miss the
lockdep bits.

Given that with the completion we act enough like a lock we can cause
deadlocks I would expect a generic version for dummies (aka a kref flavor)
to include lockdep annotations from the start.

Lock ordering issues combined with ref counts are rare but they really
suck, are hard to find (without lockdep) and hard to reason about.

The logical semantics are:

read_trylock() sysfs_get_active
read_unlock() sysfs_put_active
write_lock() sysfs_deactivate

Maybe your karef stuff is good for something but it models the sysfs
usage poorly.

Eric
