Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1CWSUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:20:13 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:57964 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754796Ab1CWSUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:20:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AL/2Hp4mpTISowlt1JxbgJ5TB8J8ZYyg/Zxfz90SElyQ1OPY8rnaZ1RCJabQHgvw9PEdUGTJ1kSe27KbciXMYG868qnvrGWFPGO20IjlEJOA5ftcyNrZdelUi83ks94y;
Date: Wed, 23 Mar 2011 11:20:06 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: intel_ips produces constant load of 1
Message-ID: <20110323112006.6a2d975b@jbarnes-desktop>
In-Reply-To: <4D8A38DD.80207@dualc.maya.org>
References: <im2ik4$3dd$1@ID-44327.news.uni-berlin.de>
	<20110321110404.6a71a404@jbarnes-desktop>
	<20110322132555.715dc096@jbarnes-desktop>
	<4D8A38DD.80207@dualc.maya.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011 19:15:57 +0100
Andreas Hartmann <andihartmann@freenet.de> wrote:

> Jesse Barnes wrote:
> > On Mon, 21 Mar 2011 11:04:04 -0700
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> >>> ps aux | grep ips
> >>> root       593  0.0  0.0      0     0 ?        S    17:20   0:00
> >>> [ips-adjust]
> >>> root       594  0.0  0.0      0     0 ?        D    17:20   0:00
> >>> [ips-monitor]
> >>>
> >>> If the module isn't loaded, the load of the machine in idle mode is 0 as
> >>> expected.  
> >>
> >> This is a reporting problem, and probably due to the schedule() call
> >> and associated task state in the ips-monitor thread.  I thought setting
> >> the task state to interruptible would prevent this, but it seems like
> >> it's not enough for the deferrable on-stack timers?
> >>
> >> At any rate, it's not actually causing increased CPU usage, so you can
> >> safely ignore it until we have a fix.
> > 
> > Oops, one task uses interruptible correctly, but the monitor thread
> > doesn't.
> > 
> > Does this patch fix your load average?
> 
> Which patch? I can't see any patch :-).
> 

Did I forget to paste it?  See below.

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 1294a39..85c8ad4 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -1111,7 +1111,7 @@ static int ips_monitor(void *data)
                last_msecs = jiffies_to_msecs(jiffies);
                expire = jiffies + msecs_to_jiffies(IPS_SAMPLE_PERIOD);
 
-               __set_current_state(TASK_UNINTERRUPTIBLE);
+               __set_current_state(TASK_INTERRUPTIBLE);
                mod_timer(&timer, expire);
                schedule();
 
