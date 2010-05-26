Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904Ab0EZInn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:43:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab0EZInj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:43:39 -0400
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: Peter Zijlstra <peterz@infradead.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu, James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <AANLkTimL5rU5lALezEZVCwdcZL85tVahhsTibdpq9s-Y@mail.gmail.com>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
	 <201005252344.37639.rjw@sisk.pl>
	 <AANLkTimL5rU5lALezEZVCwdcZL85tVahhsTibdpq9s-Y@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 10:42:22 +0200
Message-ID: <1274863342.5882.4850.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 15:33 -0700, Arve Hjønnevåg wrote:
> The biggest problem here is not that it is hard to change our
> user-space, but that the proposed change is inferior to what we have
> now. It forces us to poll until all drivers stop aborting suspend. On
> one hand we have people telling us that all code that polls is broken
> and must be fixed (instead of suspending to limit the damage), and on
> the other hand we have people suggesting we implement opportunistic
> suspend by polling from user-space until suspend succeeds. 

No it does _not_. You're really not getting that Dmitry is proposing.


So your proposal is that when we wake userspace, it
opens /dev/suspend_blocker _before_ it consumes whatever event, consumes
the event, deals with the event, then closes the suspend_blocker. Then
the kernel, upon reaching a 0 suspend_blocker count, will try to suspend
again.


What Dmitry proposes is that, the app _before_ it consumes the event,
pokes at this suspend manager, it increases a blocker count, then
consumes the event (the kernel will _not_ auto-suspend), handles it and
then again pokes the suspend manager, this time decreasing the blocker
count.

The suspend manager will, upon reaching a 0 block count, suspend the
machine. If that fails, it means there's something to do, an app will
inc, work, dec its count, and it will try again once it reaches 0 again.

There is no polling what-so-ever in this model.

The only thing is that the kernel will not try to auto-suspend and there
is no user-space suspend blocker API.
