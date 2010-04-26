Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0DZXP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:15:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774Ab0DZXPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:15:53 -0400
Date: Mon, 26 Apr 2010 16:14:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: Dan Carpenter <error27@gmail.com>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] gpio: potential null dereference
Message-Id: <20100426161446.d384c678.akpm@linux-foundation.org>
In-Reply-To: <20100426230515.GA1388@emlix.com>
References: <20100426192520.GU29093@bicker>
	<20100426230515.GA1388@emlix.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 01:05:15 +0200
Daniel Gl__ckner <dg@emlix.com> wrote:

> On Mon, Apr 26, 2010 at 09:25:20PM +0200, Dan Carpenter wrote:
> > Smatch found a potential null dereference in gpio_setup_irq().  The 
> > "pdesc" variable is allocated with idr_find() that can return NULL.  If
> > gpio_setup_irq() is called with 0 as gpio_flags and "pdesc" is null, it
> > would OOPs here.
> 
> idr_find() doesn't allocate, idr_get_new_above() does.
> Assuming idr_find() never fails for an id if idr_get_new_above()
> successfully allocated that id, I don't think we can reach that
> line with pdesc being NULL:
> 
> - There are two gotos leading to free_sd
> - #2 is after a block that allocates pdesc
> - #1 is in an if (!gpio_flags) block
> - We exit early if ((desc->flags & GPIO_TRIGGER_MASK) == gpio_flags)
> - Therefore (desc->flags & GPIO_TRIGGER_MASK) must be != 0 to reach #1
> - Trigger flags are added to desc->flags only after we have
>   successfully allocated pdesc (i.e. right before return 0)
> - We start off with no trigger flags set
> 

heh, thanks.  I figured that something like that might be going on but
couldn't be bothered picking through it all.

That being said, the above sequence of steps is awfully (and unusually)
intricate and is hence hard to preserve and could get broken at some
future time.

