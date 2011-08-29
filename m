Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1H2H2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:28:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57609 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1H2H2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:28:08 -0400
Date: Mon, 29 Aug 2011 09:28:00 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 12/16] freezer: clean up freeze_processes() failure path
Message-ID: <20110829072800.GC16431@mtj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-13-git-send-email-tj@kernel.org>
 <20110828180901.GD27032@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110828180901.GD27032@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Aug 28, 2011 at 08:09:01PM +0200, Oleg Nesterov wrote:
> This was copied from cancel_, yes. but what this
> recalc_sigpending_and_wake() can or should do?
>
> It looks simply pointless. It can't clear TIF_SIGPENDING,
> it can only do the unneeded/spurious wake_up(INTERRUPTIBLE).

Yeah, I just copied it over.  It seems it got confused between
recalc_sigpending() and recalc_sigpending_and_wake() where the latter
can't clear TIF_SIGPENDING.  The signallable freezable kthread seems
quite fragile.  Once TIF_SIGPENDING is set, the only way for it to be
cleared for a kthread is going through refrigerator and if freezing
gets canceled before that happens, the kthread will have stuck
TIF_SIGPENDING failing interruptible sleeps.  We'll probably should
move recalc_sigpending() to the top of refrigerator.

But that said, I don't see any in-kernel user of
set_freezable_with_signal().  Rafael, is there scheduled to be some
new user of this API?  It would be awesome if we can drop it.

Thanks.

-- 
tejun
