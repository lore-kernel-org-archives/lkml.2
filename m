Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1JLMvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab1JLMvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:51:54 -0400
Date: Wed, 12 Oct 2011 08:51:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, seiji.aguchi@hds.com,
        vgoyal@redhat.com, mjg@redhat.com, tony.luck@intel.com,
        gong.chen@intel.com, satoru.moriya@hds.com, avi@redhat.com
Subject: Re: [PATCH 1/3] x86, reboot:  Use NMI instead of REBOOT_VECTOR to
 stop cpus
Message-ID: <20111012125132.GI5795@redhat.com>
References: <1318346686-12349-1-git-send-email-dzickus@redhat.com>
 <1318346686-12349-2-git-send-email-dzickus@redhat.com>
 <4E94FCFE.4090300@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E94FCFE.4090300@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 10:35:42AM +0800, Chen Gong wrote:
> 于 2011/10/11 23:24, Don Zickus 写道:
> >+
> >+		/* sync above data before sending NMI */
> >+		wmb();
> >+
> >+		apic->send_IPI_allbutself(NMI_VECTOR);
> >+
> >+		/*
> >+		 * Don't wait longer than a second if the caller
> >+		 * didn't ask us to wait.
> >+		 */
> >+		timeout = USEC_PER_SEC;
> >+		while (num_online_cpus()>  1&&  (wait || timeout--))
> >+			udelay(1);
> 
> In this patch and next patch, how about using the same logic in commit 74d91e3c6

I guess I don't understand why I would do that.  That commit doesn't seem
to have a way to break out of the while loop and it does not take into account
the 'wait' variable the virt folks needed.  The only thing that could be
usable seems to be the 'touch_nmi_watchdog', but in that case if the other
cpus haven't hit the NMI yet, I would be happy for other NMI sources to
trigger to, to help move things along. :-)

The above code snippet is what is currently there and that seems to work
well, so I didn't want to change to much when moving from the IRQ path to
the NMI path.

Perhaps I am missing something?

Cheers,
Don
