Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2LCJWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:22:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab2LCJWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:22:31 -0500
Date: Mon, 3 Dec 2012 10:21:34 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Andrew Morton <akpm@linux-foundation.org>
cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        axboe@kernel.dk, jmoyer@redhat.com, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2 v3] wait: add wait_event_lock_irq() interface
In-Reply-To: <20121130121308.54d66bfe.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1212031020180.6336@localhost>
References: <1354272161-9173-1-git-send-email-lczerner@redhat.com> <20121130024842.5326d998.akpm@linux-foundation.org> <alpine.LFD.2.00.1211301233320.8688@dhcp-1-104.brq.redhat.com> <20121130121308.54d66bfe.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-613886922-1354526505=:6336"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-613886922-1354526505=:6336
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 30 Nov 2012, Andrew Morton wrote:

> Date: Fri, 30 Nov 2012 12:13:08 -0800
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
>     jmoyer@redhat.com, Neil Brown <neilb@suse.de>
> Subject: Re: [PATCH 1/2 v3] wait: add wait_event_lock_irq() interface
> 
> On Fri, 30 Nov 2012 12:36:35 +0100 (CET)
> Lukáš Czerner <lczerner@redhat.com> wrote:
> 
> > On Fri, 30 Nov 2012, Andrew Morton wrote:
> > 
> > > Date: Fri, 30 Nov 2012 02:48:42 -0800
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > To: Lukas Czerner <lczerner@redhat.com>
> > > Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
> > >     jmoyer@redhat.com, Neil Brown <neilb@suse.de>,
> > >     David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
> > >     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Subject: Re: [PATCH 1/2 v3] wait: add wait_event_lock_irq() interface
> > > 
> > > On Fri, 30 Nov 2012 11:42:40 +0100 Lukas Czerner <lczerner@redhat.com> wrote:
> > > 
> > > > New wait_event{_interruptible}_lock_irq{_cmd} macros added. This commit
> > > > moves the private wait_event_lock_irq() macro from MD to regular wait
> > > > includes, introduces new macro wait_event_lock_irq_cmd() instead of using
> > > > the old method with omitting cmd parameter which is ugly and makes a use
> > > > of new macros in the MD. It also introduces the _interruptible_ variant.
> > > > 
> > > > The use of new interface is when one have a special lock to protect data
> > > > structures used in the condition, or one also needs to invoke "cmd"
> > > > before putting it to sleep.
> > > > 
> > > > All new macros are expected to be called with the lock taken. The lock
> > > > is released before sleep and is reacquired afterwards. We will leave the
> > > > macro with the lock held.
> > > > 
> > > > Note to DM: IMO this should also fix theoretical race on waitqueue while
> > > > using simultaneously wait_event_lock_irq() and wait_event() because of
> > > > lack of locking around current state setting and wait queue removal.
> > > 
> > > Does this fix the sparse warning which Fengguang just sent us?
> > 
> > Which report from Fengguang do you have in mind ? I do not see any
> > on linux-kernel today.
> > 
> > /me going to see what spare reports
> > 
> 
> On Fri, 30 Nov 2012 16:30:24 +0800
> kbuild test robot <fengguang.wu@intel.com> wrote:
> 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
> > head:   cfb65dadcd079ad4547407a1584bc6b96bd48bb3
> > commit: 2b29cdb6f98c86a1da4ec5335d6247392b7c6551 [35/476] wait: add wait_event_lock_irq() interface
> > 
> > 
> > sparse warnings:
> > 
> > + drivers/block/drbd/drbd_int.h:2339:9: sparse: preprocessor token __wait_event_lock_irq redefined
> > include/linux/wait.h:554:9: this was the original definition
> > + drivers/block/drbd/drbd_int.h:2358:9: sparse: preprocessor token wait_event_lock_irq redefined
> > include/linux/wait.h:621:9: this was the original definition
> > drivers/block/drbd/drbd_interval.h:12:63: sparse: dubious one-bit signed bitfield
> > drivers/block/drbd/drbd_interval.h:13:22: sparse: dubious one-bit signed bitfield
> > drivers/block/drbd/drbd_int.h:903:39: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1123:69: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1124:70: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1125:59: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1126:63: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1127:60: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1128:71: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1129:65: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1130:66: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1335:74: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1336:50: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1338:51: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1339:58: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1340:54: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1341:62: sparse: attribute 'require_context': unknown attribute
> > drivers/block/drbd/drbd_int.h:1435:92: sparse: attribute 'require_context': unknown attribute
> 

I believe that Lars send patch for that already. So no,

'[PATCH 1/2 v3] wait: add wait_event_lock_irq() interface'

does not fix the issue, but another patch should.

http://www.spinics.net/lists/linux-next/msg23042.html

Thanks!
-Lukas
--8323328-613886922-1354526505=:6336--
