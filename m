Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2HVHop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:44:45 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55403 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab2HVHon convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 22 Aug 2012 03:44:43 -0400
Message-Id: <50349BF6020000780008A4C6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 22 Aug 2012 08:44:38 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <alex.shi@intel.com>
Cc: <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: apparent regressions from TLB range flushing page set
References: <503261F00200007800096710@nat28.tlf.novell.com>
 <5034516E.60908@intel.com>
In-Reply-To: <5034516E.60908@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Alex Shi <alex.shi@intel.com> 08/22/12 5:27 AM >>>
>> Second, the UV code doesn't flush the full range at all, it simply
>> ignores its 'end' parameter (and hence also the "all" indicator).
> 
>Sure. the following rfc patch try to fix it. untested since no hardware.

Sure - this needs to be looked at by a person knowing UV (and I would
have thought a change like the one we're discussing here would also
have required an ack from such a person), but ...

>--- a/arch/x86/platform/uv/tlb_uv.c
>+++ b/arch/x86/platform/uv/tlb_uv.c
>@@ -280,12 +280,12 @@ static void bau_process_message(struct msg_desc *mdp, struct bau_control *bcp,
>    /*
>     * This must be a normal message, or retry of a normal message
>     */
>-    if (msg->address == TLB_FLUSH_ALL) {
>+    if (msg->end == 0) {

How would "end" end up being 0 here? Don't you rather mean "start and
end on the same page"? And even if you do, aren't you then losing the
intended optimization?

>+        __flush_tlb_one(msg->start);
>+        stat->d_onetlb++;
>+    } else {
 >        local_flush_tlb();
>        stat->d_alltlb++;
>-    } else {
>-        __flush_tlb_one(msg->address);
>-        stat->d_onetlb++;
>    }
>    stat->d_requestee++;
 >
>@@ -1113,7 +1114,8 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 >
>    record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 >
>-    bau_desc->payload.address = start;
>+    bau_desc->payload.start = start;
>+    bau_desc->payload.end    = end;
>    bau_desc->payload.sending_cpu = cpu;
>    /*
>     * uv_flush_send_and_wait returns 0 if all cpu's were messaged,

Jan

