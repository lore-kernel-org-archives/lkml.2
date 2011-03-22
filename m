Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab1CVU0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:26:12 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:40878 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754936Ab1CVU0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:26:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Yli5CPnnLk84r6NIQXgbznZSilLdTSR85TmCfQD5Y6LMvo35bZa+hFuxISA2FBI2NA0YmpQBmE1JKTFHqzp1PujN1dDSFYzefk5FrrXS/0d8jjb4subdumn2eNYBUlxw;
Date: Tue, 22 Mar 2011 13:25:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        linux-kernel@vger.kernel.org
Subject: Re: intel_ips produces constant load of 1
Message-ID: <20110322132555.715dc096@jbarnes-desktop>
In-Reply-To: <20110321110404.6a71a404@jbarnes-desktop>
References: <im2ik4$3dd$1@ID-44327.news.uni-berlin.de>
	<20110321110404.6a71a404@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011 11:04:04 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> > ps aux | grep ips
> > root       593  0.0  0.0      0     0 ?        S    17:20   0:00
> > [ips-adjust]
> > root       594  0.0  0.0      0     0 ?        D    17:20   0:00
> > [ips-monitor]
> > 
> > If the module isn't loaded, the load of the machine in idle mode is 0 as
> > expected.  
> 
> This is a reporting problem, and probably due to the schedule() call
> and associated task state in the ips-monitor thread.  I thought setting
> the task state to interruptible would prevent this, but it seems like
> it's not enough for the deferrable on-stack timers?
> 
> At any rate, it's not actually causing increased CPU usage, so you can
> safely ignore it until we have a fix.

Oops, one task uses interruptible correctly, but the monitor thread
doesn't.

Does this patch fix your load average?

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
 
