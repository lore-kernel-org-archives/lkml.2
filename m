Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab1ITRXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:23:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab1ITRXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:23:43 -0400
Message-ID: <4E78CBF7.4060004@redhat.com>
Date: Tue, 20 Sep 2011 20:23:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        jeremy@goop.org
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple events
 and unknown NMIs
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com> <1316529792-6560-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1316529792-6560-5-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 05:43 PM, Don Zickus wrote:
> Previous patches allow the NMI subsystem to process multipe NMI events
> in one NMI.  As previously discussed this can cause issues when an event
> triggered another NMI but is processed in the current NMI.  This causes the
> next NMI to go unprocessed and become an 'unknown' NMI.
>
> To handle this, we first have to flag whether or not the NMI handler handled
> more than one event or not.  If it did, then there exists a chance that
> the next NMI might be already processed.  Once the NMI is flagged as a
> candidate to be swallowed, we next look for a back-to-back NMI condition.
>
> This is determined by looking at the %rip from pt_regs.  If it is the same
> as the previous NMI, it is assumed the cpu did not have a chance to jump
> back into a non-NMI context and execute code and instead handled another NMI.
>
> If both of those conditions are true then we will swallow any unknown NMI.
>
> There still exists a chance that we accidentally swallow a real unknown NMI,
> but for now things seem better.
>
> An optimization has also been added to the nmi notifier rountine.  Because x86
> can latch up to one NMI while currently processing an NMI, we don't have to
> worry about executing _all_ the handlers in a standalone NMI.  The idea is
> if multiple NMIs come in, the second NMI will represent them.  For those
> back-to-back NMI cases, we have the potentail to drop NMIs.  Therefore only
> execute all the handlers in the second half of a detected back-to-back NMI.
>
> V2:
>    - forgot to add the 'read' code for swallow_nmi (went into next patch)
>
> V3:
>    - redesigned the algorithm to utilize Avi's idea of detecting a back-to-back
>      NMI with %rip.
> V4:
>    - clean up fixes, like adding 'static', rename save_rip to last_nmi_rip
>
>

Missing a zeroing of last_nmi_rip in the idle path.  Otherwise, as Andi 
points out, and idle machine will always see NMIs coming in from the 
hlt/mwait address and detect them as back-to-back NMIs.

-- 
error compiling committee.c: too many arguments to function

