Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0DZXdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:33:41 -0400
Received: from mx1.emlix.com ([193.175.82.87]:38480 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0DZXdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:33:40 -0400
X-Greylist: delayed 1688 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2010 19:33:40 EDT
Date: Tue, 27 Apr 2010 01:05:15 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
To: Dan Carpenter <error27@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] gpio: potential null dereference
Message-ID: <20100426230515.GA1388@emlix.com>
References: <20100426192520.GU29093@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100426192520.GU29093@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 09:25:20PM +0200, Dan Carpenter wrote:
> Smatch found a potential null dereference in gpio_setup_irq().  The 
> "pdesc" variable is allocated with idr_find() that can return NULL.  If
> gpio_setup_irq() is called with 0 as gpio_flags and "pdesc" is null, it
> would OOPs here.

idr_find() doesn't allocate, idr_get_new_above() does.
Assuming idr_find() never fails for an id if idr_get_new_above()
successfully allocated that id, I don't think we can reach that
line with pdesc being NULL:

- There are two gotos leading to free_sd
- #2 is after a block that allocates pdesc
- #1 is in an if (!gpio_flags) block
- We exit early if ((desc->flags & GPIO_TRIGGER_MASK) == gpio_flags)
- Therefore (desc->flags & GPIO_TRIGGER_MASK) must be != 0 to reach #1
- Trigger flags are added to desc->flags only after we have
  successfully allocated pdesc (i.e. right before return 0)
- We start off with no trigger flags set

  Daniel


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführung: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - your embedded linux partner
