Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab1ERLHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:07:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51416 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab1ERLHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oCUktNyxbEAKSCv5Yjedx3wB77+2+Q/4iourbof1Tk/EXmjaIs0p97tiFzsmne23VC
         VzB/+jKw/NQKnf1Nr7TTJRdVcoCo39TWAl37vRghq7tg3K4Qc/mp5KvXWJAVH4aq7ZhK
         /kO9PmpDnhpz94/h/mgJr2NT9WouTYHNY450U=
Date: Wed, 18 May 2011 13:07:32 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Borislav Petkov <bp@alien8.de>, Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/3 v2.6.39-rc7] block: make disk_block_events()
 properly wait for work cancellation
Message-ID: <20110518110732.GW20624@htj.dyndns.org>
References: <20110517102824.GK20624@htj.dyndns.org>
 <20110517102853.GL20624@htj.dyndns.org>
 <BANLkTimj2guK6kw7QSijYZyvoRY+JKgbTg@mail.gmail.com>
 <20110517151107.GQ20624@htj.dyndns.org>
 <BANLkTikpwk-hJs+TF7TJB38JsvOvHk2UMQ@mail.gmail.com>
 <20110517152742.GR20624@htj.dyndns.org>
 <BANLkTi=-Ak5vhCFxgc2rt2rft0PE9XJiTA@mail.gmail.com>
 <20110518050729.GA16870@mtj.dyndns.org>
 <BANLkTi=0_bv7s6=i2v-iP0vQmHHT3=tm8w@mail.gmail.com>
 <20110518100451.GV20624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518100451.GV20624@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 12:04:51PM +0200, Tejun Heo wrote:
> Yeap, the problem was unblock/check being allowed to be called without
> sleeping context, which isn't used anymore and was broken due to
> cancellation race.  We can just enclose the whole thing inside per-ev
> mutex and everything should be simple and fine.  I'll post patches
> soon.

Oops, spoke too soon.  Converting to mutex creates a circular
dependency.  disk_block_events() acquires ev->lock and waits for
ev->dwork to finish, but ev->dwork also needs to acquire ev->lock to
update event states.  So, no matter how we twist this, we need two
locks or a lock and a completion.  The mutex approach seems simple
enough, so I suggest leaving it like that.

Thanks.

-- 
tejun
