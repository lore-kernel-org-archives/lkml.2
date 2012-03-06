Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab2CFK10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:27:26 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41575 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab2CFK1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:27:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of vegard.nossum@gmail.com designates 10.180.80.104 as permitted sender) smtp.mail=vegard.nossum@gmail.com; dkim=pass header.i=vegard.nossum@gmail.com
MIME-Version: 1.0
In-Reply-To: <1331028583.15778.3.camel@ThinkPad-T61>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	<1329735648.2293.307.camel@twins>
	<1329788560.3448.45.camel@ThinkPad-T61>
	<1329819437.2293.382.camel@twins>
	<1329990828.19165.36.camel@ThinkPad-T61>
	<1330340324.11248.60.camel@twins>
	<1330941917.24353.63.camel@ThinkPad-T61>
	<1330969747.11248.250.camel@twins>
	<20120305214545.GH3083@redhat.com>
	<1331028583.15778.3.camel@ThinkPad-T61>
Date: Tue, 6 Mar 2012 11:27:21 +0100
Message-ID: <CAOMGZ=ECe+p10H4RMjcJnfa254_JGPg+BzmVuLvpZb1-Tzn4Xg@mail.gmail.com>
Subject: Re: [PATCH v3 x86 1/2] fix page faults by nmiaction in nmi if
 kmemcheck is enabled
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, paulus@samba.org,
        mingo@elte.hu, acme@ghostprotocols.net, tony.luck@intel.com,
        bp@amd64.org, robert.richter@amd.com, lenb@kernel.org, minyard@acm.org,
        wim@iguana.be, linux-edac@vger.kernel.org, oprofile-list@lists.sf.net,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        linux-watchdog@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2012 11:09, Li Zhong <zhong@linux.vnet.ibm.com> wrote:
> This patch tries to fix the problem of page fault exception caused by
> accessing nmiaction structure in nmi if kmemcheck is enabled.
>
> If kmemcheck is enabled, the memory allocated through slab are in pages
> that are marked non-present, so that some checks could be done in the
> page fault handling code ( e.g. whether the memory is read before
> written to ).
> As nmiaction is allocated in this way, so it resides in a non-present
> page. Then there is a page fault while the nmi code accessing the
> nmiaction structure, which would then cause a warning by
> WARN_ON_ONCE(in_nmi()) in kmemcheck_fault(), called by do_page_fault().
>
> v2: as Peter suggested, changed the nmiaction to use static storage.
>
> v3: as Peter suggested, use macro to shorten the codes. Also keep the
> original usage of register_nmi_handler, so users of this call doesn't
> need change.
>
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Looks like you've solved this now. Thanks.

For the record, another way to prevent the page fault from happening
in the first place is to set up a new slab cache with the flag
SLAB_NOTRACK. This is different from the GFP_NOTRACK flag which, as
you noted, doesn't prevent page faults, just inhibits
checking/warnings for those memory areas.

It's a bit of a hassle, I admit. Maybe we could create an additional,
separate set of slab caches (using SLAB_NOTRACK) and a new GFP flag
which selects this set of caches instead. This would allow anything
that takes a gfp_t to allocate memory that is guaranteed not to page
fault when using kmemcheck. Pekka, any thoughts?


Vegard
