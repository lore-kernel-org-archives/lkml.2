Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2ALUy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:54:57 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48477 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2ALUyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:54:55 -0500
Date: Thu, 12 Jan 2012 12:54:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: leonid.moiseichuk@nokia.com
cc: gregkh@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cesarb@cesarb.net, kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net,
        penberg@kernel.org, aarcange@redhat.com, riel@redhat.com,
        mel@csn.ul.ie, dima@android.com, rebecca@android.com, san@google.com,
        akpm@linux-foundation.org, vesa.jaaskelainen@nokia.com
Subject: RE: [PATCH 3.2.0-rc1 3/3] Used Memory Meter pseudo-device module
In-Reply-To: <84FF21A720B0874AA94B46D76DB9826904556CB7@008-AM1MPN1-003.mgdnok.nokia.com>
Message-ID: <alpine.DEB.2.00.1201121247480.17287@chino.kir.corp.google.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com> <ed78895aa673d2e5886e95c3e3eae38cc6661eda.1325696593.git.leonid.moiseichuk@nokia.com> <20120104195521.GA19181@suse.de> <84FF21A720B0874AA94B46D76DB9826904554AFD@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201090203470.8480@chino.kir.corp.google.com> <84FF21A720B0874AA94B46D76DB9826904554B81@008-AM1MPN1-003.mgdnok.nokia.com> <alpine.DEB.2.00.1201091251300.10232@chino.kir.corp.google.com> <84FF21A720B0874AA94B46D76DB98269045568A1@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201111338320.21755@chino.kir.corp.google.com> <84FF21A720B0874AA94B46D76DB9826904556CB7@008-AM1MPN1-003.mgdnok.nokia.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012, leonid.moiseichuk@nokia.com wrote:

> As I wrote the proposed change is not safety belt but looking ahead 
> radar.
> If it detects that we are close to wall it starts to alarm and alarm 
> volume is proportional to distance.
> 

Then it's fundamentally flawed since there's no guarantee that coming with 
100MB of the min watermark, for example, means that an oom is imminent and 
will just result in unnecessary notification to userspace that will cause 
some action to be taken that may not be necessary.  If the setting of 
these thresholds depends on some pattern that is guaranteed to be along 
the path to oom for a certain workload, then that will also change 
depending on VM implementation changes, kernel versions, other 
applications, etc., and simply is unmaintainable.

> In close-to-OOM situations device becomes very slow, which is not good 
> for user. The performance difference depends on code size and storage 
> performance to trash code pages but even 20% is noticeable. Practically 
> 2x-5x times slowdown was observed.
> 

It would be much better to address the slowdown when running out of memory 
rather than requiring userspace to react and unnecessarily send signals to 
threads that may or may not have the ability to respond because they may 
already be oom themselves.  You can do crazy things to reduce latency in 
lowmem memory allocations like changing gfp_allowed_mask to be GFP_ATOMIC 
so that direct reclaim is never called, for example, and then use the 
proposed oom killer delay to handle the situation at the time of oom.

Regardless, you should be addressing the slowness in lowmem situations 
rather than implementing notifiers to userspace to handle the events 
itself, so nack on this proposal.
