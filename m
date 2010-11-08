Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab0KHSF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:05:29 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33963 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab0KHSF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OIfuPxBBLltShuYt0b4vVYTB21ZFolQdgIXdlrffkUTUi6560k1XpPZgQaitcs4C4Q
         ujPpOOXAMA83MaNO6IB4LwzV5S13BKb06GTbt2LPyuI5leFE0lFG+hncV1nGqMwpt/CP
         dNP/RHRiC+7r/FshnC24ej3BRXWSYJ+OTlfho=
Date: Mon, 8 Nov 2010 19:05:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        sergey.senozhatsky@gmail.com
Subject: Re: [PATCH v2] watchdog:  touch_nmi_watchdog should only touch
	local cpu not every one
Message-ID: <20101108180518.GA5375@nowhere>
References: <1289234675-2400-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289234675-2400-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 11:44:35AM -0500, Don Zickus wrote:
> I ran into a scenario where while one cpu was stuck and should have panic'd
> because of the NMI watchdog, it didn't.  The reason was another cpu was spewing
> stack dumps on to the console.  Upon investigation, I noticed that when writing
> to the console and also when dumping the stack, the watchdog is touched.
> 
> This causes all the cpus to reset their NMI watchdog flags and the 'stuck' cpu
> just spins forever.
> 
> This change causes the semantics of touch_nmi_watchdog to be changed slightly.
> Previously, I accidentally changed the semantics and we noticed there was a
> codepath in which touch_nmi_watchdog could be touched from a preemtible area.
> That caused a BUG() to happen when CONFIG_DEBUG_PREEMPT was enabled.  I believe
> it was the acpi code.
> 
> My attempt here re-introduces the change to have the touch_nmi_watchdog() code
> only touch the local cpu instead of all of the cpus.  But instead of using
> __get_cpu_var(), I use the __raw_get_cpu_var() version.
> 
> This avoids the preemption problem.  However my reasoning wasn't because I was
> trying to be lazy.  Instead I rationalized it as, well if preemption is enabled
> then interrupts should be enabled to and the NMI watchdog will have no reason
> to trigger.  So it won't matter if the wrong cpu is touched because the percpu
> interrupt counters the NMI watchdog uses should still be incrementing.
> 
> V2:  remove touch_all_nmi_watchdog code


Are you sure you did? :)


> +void touch_all_nmi_watchdogs(void)
> +{
>  	if (watchdog_enabled) {
>  		unsigned cpu;
>  
> @@ -151,7 +166,7 @@ void touch_nmi_watchdog(void)
>  	}
>  	touch_softlockup_watchdog();
>  }
> -EXPORT_SYMBOL(touch_nmi_watchdog);
> +EXPORT_SYMBOL(touch_all_nmi_watchdogs);
>  
>  #endif
>  
> -- 
> 1.7.2.3
> 

