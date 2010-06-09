Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab0FIQHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:07:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0FIQHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:07:34 -0400
Subject: Re: [PATCH v4] pm_qos: make update_request non blocking
From: James Bottomley <James.Bottomley@suse.de>
To: Florian Mickler <florian@mickler.org>
Cc: pm list <linux-pm@lists.linux-foundation.org>, markgross@thegnar.org,
       mgross@linux.intel.com, linville@tuxdriver.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100609180033.39d5b499@schatten.dmk.lab>
References: <1276097381-3982-1-git-send-email-florian@mickler.org>
	 <1276097832.4343.223.camel@mulgrave.site>
	 <20100609180033.39d5b499@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 12:07:25 -0400
Message-ID: <1276099645.4343.257.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 18:00 +0200, Florian Mickler wrote:
> On Wed, 09 Jun 2010 11:37:12 -0400
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
> 
> > This still isn't resilient against two successive calls to update.  If
> > the second one gets to schedule_work() before the work of the first one
> > has finished, you'll corrupt the workqueue.
> 
> Sorry, I don't see it. Can you elaborate?
> 
> In "run_workqueue(" we do a list_del_init() which resets the
> list-pointers of the workitem and only after that reset the
> WORK_STRUCT_PENDING member of said structure. 
> 
> 
> schedule_work does a queue_work_on which does a test_and_set_bit on
> the WORK_STRUCT_PENDING member of the work and only queues the work
> via list_add_tail in insert_work afterwards.
> 
> Where is my think'o? Or was this fixed while you didn't look?
> 
> So what _can_ happen, is that we miss a new notfication while the old
> notification is still in the queue. But I don't think this is a problem.

OK, so the expression of the race is that the latest notification gets
lost.  If something is tracking values, you'd really like to lose the
previous one (which is now irrelevant) not the latest one.  The point is
there's still a race.

James


