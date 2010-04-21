Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab0DUUp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:45:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38029 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0DUUpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dapEwdZ7wxHHiWWHXhClGHC2qjQuJv73VUPS1QXoDRCf0Ya7XmXz5oRf24YpqZUChB
         MAv136cbM8bieEdAAX4jv0/eFrsSVrSCXDV7Ym/lCbxzgT0fnKK9yOrzQRm2sXKnpA1S
         QH/tNTd+eyIWr/c4zZM1dEJ0NZMtE0ckAzgPg=
Date: Wed, 21 Apr 2010 22:46:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/6] [watchdog] convert touch_softlockup_watchdog to
	touch_watchdog
Message-ID: <20100421204559.GB8677@nowhere>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com> <1271777043-3807-3-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271777043-3807-3-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 11:23:59AM -0400, Don Zickus wrote:
> Just a scripted conversion to remove touch_softlockup_watchdog.
> 
> Also converts the once case of touch_all_softlockup_watchdogs to
> touch_all_watchdogs.
> 
> This is done as part of the removal of the old softlockup code and
> transition to the new softlockup code.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>


In fact I worry a bit about this unification of watchdog touching.
When we touch the softlockup watchdog, do we also want to touch
the nmi watchdog?

Most of the time, I think we don't want to. We usually touch the
softlockup detector because we know we are abnormally delaying
the softlockup kthread from being scheduled, and if we are in such
situation, it means we are doing something in a sensitive context:
typically the kind of context favorable to create hardlockups...

But the opposite is right: if we touch the nmi watchdog: it means we
are abnormally delaying irqs, which means we also are abnormally
delaying the softlockup kthread from being scheduled, so if we
touch the nmi watchdog, we also want to touch the softlockup
detector.

Hence I guess we want to keep the current state:

- touch_nmi_watchdog() = touch softlockup and nmi watchdogs
- touch_softlockup_watchdog() = only touch softlockup watchdog

