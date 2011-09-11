Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab1IKByk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 21:54:40 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59529 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1IKByi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 21:54:38 -0400
Date: Sun, 11 Sep 2011 10:54:31 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, matthltc@us.ibm.com,
        paul@paulmenage.org, containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] freezer: fix wait_event_freezable/__thaw_task races
Message-ID: <20110911015431.GK29319@htj.dyndns.org>
References: <20110905023315.GB9807@htj.dyndns.org>
 <20110905162012.GA4445@redhat.com>
 <20110906032846.GA18425@mtj.dyndns.org>
 <20110906151836.GA15568@redhat.com>
 <20110906152539.GA16899@redhat.com>
 <20110906155332.GF18425@mtj.dyndns.org>
 <20110907182156.GA13909@redhat.com>
 <20110907182217.GB13909@redhat.com>
 <20110908010530.GD3987@mtj.dyndns.org>
 <20110908175926.GA26986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908175926.GA26986@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 08, 2011 at 07:59:26PM +0200, Oleg Nesterov wrote:
> > Indeed, nice catch.  This one actually is pretty dangerous.  We
> > probably want to make a separate fix for this and backport it to
> > -stable?
> 
> And I forgot to mention that wait_event_freezable_timeout() doesn't
> handle -ERESTARTSYS at all.
> 
> But I don't think -stable needs this fix. According to grep, nobody
> check the returned value, and none of the callers plays with signals.

Ah, no user, okay.

> > Yeap, with freezable_with_signal gone, this looks correct & simpler to
> > me
> 
> I don't really understand this... set_freezable_with_signal() has a
> lot of problems, yes... But even if it wasn't removed this fix makes
> sense anyway, afaics.
> 
> If freezable_with_signal caller does wait_event_freezable_timeout(),
> __retval becomes -ERESTARTSYS after freeze_task(). The next iteration
> will return 0 with the KERN_ERR message from schedule_timeout().

Hmmm... but with the change, if a kthread gets TIF_SIGPENDING from
freezer and then thawed, it would not enter try_to_freeze() and thus
won't clear TIF_SIGPENDING.  The original code was racy too but the
window would be much larger afterwards.  Anyways, this doesn't matter
anymore.

> > but it would be nice if you can sprinkle some documentation while
> > at it. :)
> 
> But they already have the comment ;) What can I add?

Proper /** - */ comment w/ return value documentation? :P

Thanks.

-- 
tejun
