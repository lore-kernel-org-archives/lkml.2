Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2HRSzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 14:55:33 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:36197 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2HRSza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 14:55:30 -0400
Date: Sat, 18 Aug 2012 20:55:28 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jim Cromie <jim.cromie@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [bisected] Driver core fixes for 3.6-rc3 regression
Message-ID: <20120818185528.GA250@x4>
References: <20120817171354.GA14046@kroah.com>
 <20120818060934.GA255@x4>
 <20120818163401.GA2013@kroah.com>
 <1345315025.10014.15.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345315025.10014.15.camel@joe2Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.08.18 at 11:37 -0700, Joe Perches wrote:
> On Sat, 2012-08-18 at 09:34 -0700, Greg KH wrote:
> > On Sat, Aug 18, 2012 at 08:09:34AM +0200, Markus Trippelsdorf wrote:
> > > On 2012.08.17 at 10:13 -0700, Greg KH wrote:
> > > > ----------------------------------------------------------------
> > > > Driver core fixes for 3.6-rc3
> > > > 
> > > > Here are two tiny patches, one fixing a dynamic debug problem that the printk
> > > > rework turned up, and the other one fixing an extcon problem that people
> > > > reported.
> > > > 
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > 
> > > > ----------------------------------------------------------------
> > > > Axel Lin (1):
> > > >       extcon: extcon_gpio: Replace gpio_request_one by devm_gpio_request_one
> > > > 
> > > > Jim Cromie (1):
> > > >       drivers-core: make structured logging play nice with dynamic-debug
> > > 
> > > The commit af7f2158f above causes hundreds of "Failed to force enable
> > > HPET" messages to appear during boot on my system.
> > > Please also note the strange "^A0" character sequence that is also
> > > introduced by the same commit.
> > 
> > Ugh, I see the same thing here, debugging must be accidentally enabled
> > with this patch, and the ^A0 stuff is just a mess.  Sorry, I didn't
> > notice this in my testing, my fault.
> 
> It's a combination interaction because of the patch with
> a conversion of KERN_<LEVEL> from "<.>" to concatenated
> SOH "."
> 
> commit: 04d2c8c83d0e3ac5f78aeede51babb3236200112

IOW:

diff --git a/drivers/base/core.c b/drivers/base/core.c
index cdd01c5..5e6e00b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1912,8 +1912,8 @@ int __dev_printk(const char *level, const struct device *dev,
 				    "DEVICE=+%s:%s", subsys, dev_name(dev));
 	}
 skip:
-	if (level[3])
-		level_extra = &level[3]; /* skip past "<L>" */
+	if (level[2])
+		level_extra = &level[2]; /* skip past KERN_SOH "L" */
 
 	return printk_emit(0, level[1] - '0',
 			   dictlen ? dict : NULL, dictlen,

-- 
Markus
