Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab0CZEYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 00:24:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54917 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0CZEYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 00:24:49 -0400
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs: simplify handling for s_active refcount
References: <20100324031829.2136.66489.stgit@notabene.brown>
	<20100324032008.2136.52640.stgit@notabene.brown>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 25 Mar 2010 21:24:43 -0700
In-Reply-To: <20100324032008.2136.52640.stgit@notabene.brown> (NeilBrown's message of "Wed\, 24 Mar 2010 14\:20\:08 +1100")
Message-ID: <m139znogl0.fsf@fess.ebiederm.org>
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

> s_active counts the number of active references to a 'sysfs_direct'.
> When we wish to deactivate a sysfs_direct, we subtract a large
> number for the refcount so it will always appear negative.  When
> it is negative, new references will not be taken.
> After that subtraction, we wait for all the active references to
> drain away.
>
> The subtraction of the large number contains exactly the same
> information as the setting of the flag SYSFS_FLAG_REMOVED.
> (We know this as we already assert that SYSFS_FLAG_REMOVED is set
> before adding the large-negative-bias).
> So doing both is pointless.
>
> By starting s_active with a value of 1, not 0 (as is typical of
> reference counts) and using atomic_inc_not_zero, we can significantly
> simplify the code while keeping exactly the same functionality.

Overall your logic appears correct but in detail this patch scares me.

sd->s_flags is protected by the sysfs_mutex, and you aren't
taking it when you read it.  So in general I don't see the new check
if (sd->s_flags & SYSFS_FLAG_REMOVED) == 0 providing any guarantee of
progress whatsoever with user space applications repeated reading from
a sysfs file when that sysfs file is being removed.  They could easily
have the sd->s_flags value cached and never see the new value, given a
crazy enough cache architecture.

So as attractive as this patch is I don't think it is correct.

Eric 
