Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab1IHBN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 21:13:26 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:34750 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab1IHBNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 21:13:25 -0400
Date: Thu, 8 Sep 2011 10:05:30 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, matthltc@us.ibm.com,
        paul@paulmenage.org, containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] freezer: fix wait_event_freezable/__thaw_task races
Message-ID: <20110908010530.GD3987@mtj.dyndns.org>
References: <1314988070-12244-7-git-send-email-tj@kernel.org>
 <20110904184626.GA30101@redhat.com>
 <20110905023315.GB9807@htj.dyndns.org>
 <20110905162012.GA4445@redhat.com>
 <20110906032846.GA18425@mtj.dyndns.org>
 <20110906151836.GA15568@redhat.com>
 <20110906152539.GA16899@redhat.com>
 <20110906155332.GF18425@mtj.dyndns.org>
 <20110907182156.GA13909@redhat.com>
 <20110907182217.GB13909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907182217.GB13909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 07, 2011 at 08:22:17PM +0200, Oleg Nesterov wrote:
> wait_event_freezable() and wait_event_freezable_timeout() stop
> the waiting if try_to_freeze() fails. This is not right, we can
> race with __thaw_task() and in this case
> 
> 	- wait_event_freezable() returns the wrong ERESTARTSYS
> 
> 	- wait_event_freezable_timeout() can return the positive
> 	  value while condition == F

Indeed, nice catch.  This one actually is pretty dangerous.  We
probably want to make a separate fix for this and backport it to
-stable?

> Change the code to always check __retval/condition before return.
> 
> Note: with or without this patch the timeout logic looks strange,
> probably we should recalc timeout if try_to_freeze() returns T.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Yeap, with freezable_with_signal gone, this looks correct & simpler to
me but it would be nice if you can sprinkle some documentation while
at it. :)

Thanks.

-- 
tejun
