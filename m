Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0DDUqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 16:46:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4702 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0DDUqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 16:46:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=rbhu79hya40TPxgzXiLafxGGEo8/HtvgZeY3nKt2zHy3T6GuwReKEOrE2Zt/D+NTX
	8vvYzT9mjNs8OBI5HWseA==
Date: Sun, 4 Apr 2010 13:45:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch v2] slab: add memory hotplug support
In-Reply-To: <alpine.DEB.2.00.1003301141190.24717@router.home>
Message-ID: <alpine.DEB.2.00.1004041336450.4184@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>  <20100226155755.GE16335@basil.fritz.box>  <alpine.DEB.2.00.1002261123520.7719@router.home>  <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com>  <20100305062002.GV8653@laptop>  <alpine.DEB.2.00.1003081502400.30456@chino.kir.corp.google.com>  <20100309134633.GM8653@laptop>  <alpine.DEB.2.00.1003271849260.7249@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1003271940190.8399@chino.kir.corp.google.com> <84144f021003300201x563c72vb41cc9de359cc7d0@mail.gmail.com> <alpine.DEB.2.00.1003301141190.24717@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, Christoph Lameter wrote:

> > Nick, Christoph, lets make a a deal: you ACK, I merge. How does that
> > sound to you?
> 
> I looked through the patch before and slabwise this seems to beok but I am
> still not very sure how this interacts with the node and cpu bootstrap.
> You can have the ack with this caveat.
> 
> Acked-by: Christoph Lameter <cl@linux-foundation.org>
> 

Thanks.

I tested this for node hotplug by setting ACPI_SRAT_MEM_HOT_PLUGGABLE 
regions and then setting up a new memory section with 
/sys/devices/system/memory/probe.  I onlined the new memory section, which 
mapped to an offline node, and verified that the nwe nodelists were 
initialized correctly.  This is done before the MEM_ONLINE notifier and 
the bit being set in node_states[N_HIGH_MEMORY].  So, for node hot-add, it 
works.

MEM_GOING_OFFLINE is more interesting, but there's nothing harmful about 
draining the freelist and reporting whether there are existing full or 
partial slabs back to the memory hotplug layer to preempt a hot-remove 
since those slabs cannot be freed.  I don't consider that to be a risky 
change.

As far as the interactions between memory and cpu hotplug, they are really 
different things with many of the same implications for the slab layer.  
Both have the possibility of bringing new nodes online or offline and they 
must be dealt with accordingly.  We lack support for offlining an entire 
node at a time since we must hotplug first by adding a new memory section, 
so these notifiers won't be called simultaneously.  Even if they were, 
draining the freelist and checking if a nodelist needs to be initialized 
is not going to be harmful since both notifiers have the same checks for 
existing nodelists (which is not only necessary if we _did_ have 
simultaneous cpu and memory hot-add, but also if a node transitioned from 
online to offline and back to online).

I hope this patch is merged because it obviously fixed a problem on my box 
where a memory section could be added, a node onlined, and then no slab 
metadata being initialized for that memory.
