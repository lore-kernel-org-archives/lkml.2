Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0IMPJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:09:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56258 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0IMPJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:09:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XbYFfrJ9cFRLmqyoSHCHVjEbQrEE9THh8dgV8COCepcMMYiCp0XZImbpnC+eTcPYSO
         I4NvPUm2SFrCADVO2KTcsEohunW+iIyOtKSMid5ahJQnFg0utmDKbzwFAYSEndpoYV6+
         xJpo+DodelxKTi3jK/71qIB+TJ3LA8cjy3grc=
Date: Mon, 13 Sep 2010 17:09:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, markus.t.metzger@intel.com
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
Message-ID: <20100913150914.GA6155@nowhere>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 04:55:01PM +0200, Stephane Eranian wrote:
> The DS, BTS, and PEBS memory regions were allocated using kzalloc(), i.e.,
> requesting contiguous physical memory. There is no such restriction on
> DS, PEBS and BTS buffers. Using kzalloc() could lead to error in case
> no contiguous physical memory is available. BTS is requesting 64KB,
> thus it can cause issues. PEBS is currently only requesting one page.
> Both PEBS and BTS are static buffers allocated for each CPU at the
> first user. When the last user exists, the buffers are released.
> 
> All buffers are only accessed on the CPU they are attached to.
> kzalloc() does not take into account NUMA, thus all allocations
> are taking place on the NUMA node where the perf_event_open() is
> made.
> 
> This patch switches allocation to vmalloc_node() to use non-contiguous
> physical memory and to allocate on the NUMA node corresponding to each
> CPU. We switched DS and PEBS although they do not cause problems today,
> to, at least, make the allocation on the correct NUMA node. In the future,
> the PEBS buffer size may increase. DS may also grow bigger than a page.
> This patch eliminates the memory allocation imbalance.
> 
> vmalloc_node() returns page-aligned addresses which do conform with the
> restriction on PEBS buffer as documented by Intel in Vol3a section 16.9.4.2.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> --


For now I think you can not do this. vmalloc'ed memory can't be safely
accessed from NMIs in x86 because that might fault. And faults from NMIs
are not supported. They cause very bad things: return from fault calls
iret which reenables NMI, so NMI can nest but in the meantime there is
only one NMI stack, so that gets quickly messed up.

