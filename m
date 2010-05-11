Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab0EKSX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:23:56 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46877 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab0EKSXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:23:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iXuUE5mfAxpitWpLRFjBQyqugsnevAi1QIsKhdPnc2JPiXoS8RFcnhQZAhw3oMM/zY
         PM7Qmr3jt+BgTGmPkHxqbrfSkhiZU+u7fRTGWQuLJJ2p9aROcB8xjQxbhsKtmqxvc/nn
         OFMOfJhjQ2URUwqn9byu26SRvzD0fgKkEKfMg=
Date: Tue, 11 May 2010 22:23:47 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] pda_power: add support for writeable properties
Message-ID: <20100511182347.GA31831@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <20100511174708.GA26777@oksana.dev.rtsoft.ru>
 <20100511175812.GH30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100511175812.GH30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 07:58:12PM +0200, Daniel Mack wrote:
[...]
> Hmm, no. The code defaults to (S_IRUSR | S_IRGRP | S_IROTH) which is
> 0444, just like it was before. So there shouldn't be any regression. The
> mode is only changed if the psy defines a property_is_writeable()
> callback which returns 1. Or do I miss your point?

Yes, power_supply_attrs is a global array, and you shouldn't change
it between power_supply_register() calls.

If you don't see why it's a bad idea in general, think about it
other way, a race:

...someone registers psy0 with attr X marked as read-only...
...code flow stops before device_create_file(psy0, global->mode)..
[preempt]
...someone registers psy1 with attr X marked as writable...
...you set up global->mode to 0644...
[preempt again]
...we end up calling device_create_file(psy0, 0644)...

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
