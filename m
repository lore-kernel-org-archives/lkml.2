Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab1ERKE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:04:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36992 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab1ERKE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vDH4KiKCh/9X/Jb/HOrMHC3B5n0rYnOHOBr9Ct8iUk35a3Do2oN8Nwbl9EznSACh45
         09TKgzbpiP9ZFCXmKzXRIgGwh5r3+B5FipX3G1LTGd9kmL5gMiDWtn0pFvxU5NnAKLbN
         XrkdVNnGOa6wUHLzNmvcMzjBw/IvIIyhnqs5I=
Date: Wed, 18 May 2011 12:04:51 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Borislav Petkov <bp@alien8.de>, Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/3 v2.6.39-rc7] block: make disk_block_events()
 properly wait for work cancellation
Message-ID: <20110518100451.GV20624@htj.dyndns.org>
References: <20110517102713.GJ20624@htj.dyndns.org>
 <20110517102824.GK20624@htj.dyndns.org>
 <20110517102853.GL20624@htj.dyndns.org>
 <BANLkTimj2guK6kw7QSijYZyvoRY+JKgbTg@mail.gmail.com>
 <20110517151107.GQ20624@htj.dyndns.org>
 <BANLkTikpwk-hJs+TF7TJB38JsvOvHk2UMQ@mail.gmail.com>
 <20110517152742.GR20624@htj.dyndns.org>
 <BANLkTi=-Ak5vhCFxgc2rt2rft0PE9XJiTA@mail.gmail.com>
 <20110518050729.GA16870@mtj.dyndns.org>
 <BANLkTi=0_bv7s6=i2v-iP0vQmHHT3=tm8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=0_bv7s6=i2v-iP0vQmHHT3=tm8w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 18, 2011 at 02:46:30AM -0700, Linus Torvalds wrote:
> Quite frankly. right now I think I need to just release 2.6.39, and
> then for 2.6.40 merge the trivial
> 
>   mutex_lock(&ev->mutex);
>   if (!ev->block++)
>     cancel_delayed_work_sync(&ev->dwork);
>   mutex_unlock(&ev->mutex);
> 
> with a cc: stable for backporting.

This isn't super-critical and releasing without the fix but later
backporting via -stable definitely is an option.

> So we can't be in some atomic context inside some other spinlock
> anyway, afaik. And there can be no lock order issues, since this
> would always be a new inner lock.

Yeap, the problem was unblock/check being allowed to be called without
sleeping context, which isn't used anymore and was broken due to
cancellation race.  We can just enclose the whole thing inside per-ev
mutex and everything should be simple and fine.  I'll post patches
soon.

Thanks.

-- 
tejun
