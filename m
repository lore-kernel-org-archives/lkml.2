Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab2EAQRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:17:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38324 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694Ab2EAQRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:17:05 -0400
Message-ID: <1335889006.13683.162.camel@twins>
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, paulmck <paulmck@linux.vnet.ibm.com>
Date: Tue, 01 May 2012 18:16:46 +0200
In-Reply-To: <4FA002F4.8000508@redhat.com>
References: <20120427161727.27082.43096.stgit@abhimanyu>
	    <20120427162401.27082.59387.stgit@abhimanyu>
	  <4F9D32B4.8040002@redhat.com>  <1335865176.13683.120.camel@twins>
	  <4F9FBF38.2060903@redhat.com> <1335869827.13683.133.camel@twins>
	  <4F9FD337.5010908@redhat.com> <1335885292.13683.150.camel@twins>
	 <4FA002F4.8000508@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 18:36 +0300, Avi Kivity wrote:

> > > What bounds the amount of memory waiting to be freed during an rcu grace
> > > period?
> >
> > Most RCU implementations don't have limits, so that could be quite a
> > lot. I think preemptible RCU has a batch limit at which point it tries
> > rather hard to force a grace period, but I'm not sure if even that
> > provides a hard limit.
> >
> > Practically though, I haven't had reports of PPC/Sparc going funny
> > because of this.
> 
> It could be considered a DoS if a user is able to free page tables
> faster than rcu is able to recycle them, possibly triggering the oom
> killer (should that force a grace period before firing from the hip?)

One would think that would be a good thing, yes. However I cannot seem
to find anything like that in the current OOM killer. David, Paul, I
seem to have vague recollections of a discussion about RCU vs OOM, what
was the resolution (if anything) and would something like the below make
sense?

---
 mm/oom_kill.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 46bf2ed5..244a371 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -607,6 +607,9 @@ int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
 	struct zone *zone;
 	int ret = 1;
 
+	synchronize_sched();
+	synchronize_rcu();
+
 	spin_lock(&zone_scan_lock);
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
 		if (zone_is_oom_locked(zone)) {

