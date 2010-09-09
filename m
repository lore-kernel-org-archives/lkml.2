Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0IIC42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 22:56:28 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43277 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0IIC4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 22:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=skR5UqlfP7iaTh/FRIv9x2jgU5Wnbf7PgFb6kmaRABS8Ndf/gdc1no5XNo/1VfI1wZ
         mI0S25F2oLQ/f/mlnfNmnjAg/QPFEhZt71FIROJH0Hwg8jcH1yn8S1SDGimkFM9k3V77
         Bqq3NR9YsYfl1OJK32EzU86fZJgXXEDAw7ttQ=
Date: Wed, 8 Sep 2010 19:56:19 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, Dan Carpenter <error27@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] pm_qos_params: cleanup: terminate a string
Message-ID: <20100909025619.GA5049@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100903124105.GJ5437@bicker>
 <20100907062227.GB25651@gvim.org>
 <20100907133805.GA20050@gvim.org>
 <201009090014.00158.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009090014.00158.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 12:13:59AM +0200, Rafael J. Wysocki wrote:
> On Tuesday, September 07, 2010, mark gross wrote:
> > On Mon, Sep 06, 2010 at 11:22:27PM -0700, mark gross wrote:
> > > On Fri, Sep 03, 2010 at 02:41:06PM +0200, Dan Carpenter wrote:
> ...
> > 
> > updated patch 
> > 
> > Signed-off-by: mark gross <markgross@thegnar.org>
> > 
> > --mgross 
> > 
> > Subject: [PATCH] correct some pr_debug misuse and add a stronger parrameter check to
> >  pm_qos_write for the ascii hex value case.  Thanks to Dan Carpenter for
> >  pointing out the problem!
> > 
> > ---
> >  kernel/pm_qos_params.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> > index f42d3f7..aae58d2 100644
> > --- a/kernel/pm_qos_params.c
> > +++ b/kernel/pm_qos_params.c
> > @@ -155,7 +155,7 @@ static void update_target(int pm_qos_class)
> >  		call_notifier = 1;
> >  		atomic_set(&pm_qos_array[pm_qos_class]->target_value,
> >  				extreme_value);
> > -		pr_debug(KERN_ERR "new target for qos %d is %d\n", pm_qos_class,
> > +		pr_debug("new target for qos %d is %d\n", pm_qos_class,
> >  			atomic_read(&pm_qos_array[pm_qos_class]->target_value));
> >  	}
> >  	spin_unlock_irqrestore(&pm_qos_lock, flags);
> 
> The above doesn't apply to the Linus' tree any more.  Care to fix?
> 
> Rafael

no problem.  (I screwed up on my fetch and forgot to merge the linus
remote....) This bit doesn't apply post 2.6.35.
--mgross

Signed-off-by: mark gross <markgross@thegnar.org)


>From 64753f68e2baaef21783192566469abc54aca90d Mon Sep 17 00:00:00 2001
From: mgross <mgross@mgross-laptop.(none)>
Date: Wed, 8 Sep 2010 19:52:39 -0700
Subject: [PATCH] make it harder to misuse the pm_qos user mode api.

---
 kernel/pm_qos_params.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index b7e4c36..645e541 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -389,10 +389,12 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 	} else if (count == 11) { /* len('0x12345678/0') */
 		if (copy_from_user(ascii_value, buf, 11))
 			return -EFAULT;
+		if (strlen(ascii_value) != 10)
+			return -EINVAL;
 		x = sscanf(ascii_value, "%x", &value);
 		if (x != 1)
 			return -EINVAL;
-		pr_debug(KERN_ERR "%s, %d, 0x%x\n", ascii_value, x, value);
+		pr_debug("%s, %d, 0x%x\n", ascii_value, x, value);
 	} else
 		return -EINVAL;
 
-- 
1.7.0.4

