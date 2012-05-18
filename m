Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2EROeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:34:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48840 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2EROen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:34:43 -0400
Message-ID: <1337351677.573.44.camel@twins>
Subject: Re: [PATCH 2/2] block: Convert BDI proportion calculations to
 flexible proportions
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Date: Fri, 18 May 2012 16:34:37 +0200
In-Reply-To: <20120518142443.GA6875@quack.suse.cz>
References: <1337096583-6049-1-git-send-email-jack@suse.cz>
	 <1337096583-6049-3-git-send-email-jack@suse.cz>
	 <1337292273.4281.101.camel@twins> <20120518142443.GA6875@quack.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 16:24 +0200, Jan Kara wrote:
>   Yeah, that should be easy enough so I'll try it that way since I presume
> it's nicer to power usage to use deferred timers if it's reasonably
> possible. 

Btw, your current scheme also drifts. Since you do jiffes + 3*HZ you
period might actually be longer if the timer got delayed.

If you keep an external jiffies count like:

unsigned long period_jiffies = jiffies;

void my_timer_func()
{
	unsigned long delta = jiffies - period_jiffies;
	unsigned long periods = delta / 3*HZ;

	age(periods);

	period_jiffies += 3*HZ * periods;
	mod_timer(&my_timer, period_jiffies);
}


it all works without drift (+- bugs of course).
