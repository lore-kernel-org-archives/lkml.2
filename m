Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1INNAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:00:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345Ab1INNAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:00:49 -0400
Date: Wed, 14 Sep 2011 09:00:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        jeremy@goop.org
Subject: Re: [V4][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110914130027.GU5795@redhat.com>
References: <1315947509-6429-1-git-send-email-dzickus@redhat.com>
 <1315947509-6429-5-git-send-email-dzickus@redhat.com>
 <4E7052DD.8080305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7052DD.8080305@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 10:08:13AM +0300, Avi Kivity wrote:
> On 09/13/2011 11:58 PM, Don Zickus wrote:
> >Previous patches allow the NMI subsystem to process multipe NMI events
> >in one NMI.  As previously discussed this can cause issues when an event
> >triggered another NMI but is processed in the current NMI.  This causes the
> >next NMI to go unprocessed and become an 'unknown' NMI.
> >
> >To handle this, we first have to flag whether or not the NMI handler handled
> >more than one event or not.  If it did, then there exists a chance that
> >the next NMI might be already processed.  Once the NMI is flagged as a
> >candidate to be swallowed, we next look for a back-to-back NMI condition.
> >
> >This is determined by looking at the %rip from pt_regs.  If it is the same
> >as the previous NMI, it is assumed the cpu did not have a chance to jump
> >back into a non-NMI context and execute code and instead handled another NMI.
> >
> >If both of those conditions are true then we will swallow any unknown NMI.
> >
> >There still exists a chance that we accidentally swallow a real unknown NMI,
> >but for now things seem better.
> 
> Patch looks good, but the changelog is outdated.

Perhaps, but I tried rewriting most of it to reflect the current changes.
Was there something obvious in there that I missed?  I re-read it a few
times and can't figure out what part might be outdated (not that I
disagree with you, I just want to update it).

> 
> >@@ -278,19 +294,49 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
> >  	pr_emerg("Dazed and confused, but trying to continue\n");
> >  }
> >
> >+DEFINE_PER_CPU(bool, swallow_nmi);
> >+DEFINE_PER_CPU(unsigned long, save_rip);
> 
> 'static'.  Also need a better name for save_rip (suggest last_nmi_rip).

Good suggestion. 

Thanks,
Don
