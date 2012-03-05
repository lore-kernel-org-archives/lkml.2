Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab2CER4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:56:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58562 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab2CER4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:56:06 -0500
Message-ID: <1330970118.11248.256.camel@twins>
Subject: Re: [PATCH v2 x86 1/2]  fix page faults by nmiaction in nmi if
 kmemcheck is enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Don Zickus <dzickus@redhat.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        paulus@samba.org, mingo@elte.hu, acme@ghostprotocols.net,
        Vegard Nossum <vegardno@ifi.uio.no>, tony.luck@intel.com, bp@amd64.org,
        robert.richter@amd.com, lenb@kernel.org, minyard@acm.org,
        wim@iguana.be, linux-edac@vger.kernel.org, oprofile-list@lists.sf.net,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        linux-watchdog@vger.kernel.org
Date: Mon, 05 Mar 2012 18:55:18 +0100
In-Reply-To: <20120305155434.GT3083@redhat.com>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	 <1329735648.2293.307.camel@twins> <1329788560.3448.45.camel@ThinkPad-T61>
	 <1329819437.2293.382.camel@twins> <1329990828.19165.36.camel@ThinkPad-T61>
	 <1330340324.11248.60.camel@twins> <1330941917.24353.63.camel@ThinkPad-T61>
	 <20120305155434.GT3083@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 10:54 -0500, Don Zickus wrote:
> This is one way of doing this.  I was trying to avoid this when I rewrote the
> nmi handlers, because everyone kept screwing up the structs.  I thought it
> would be safer to have callers pass in data based on an api instead.

Apparently kmemcheck marks pages as non-present and does magic in the
fault handler. Having the action thing allocated meant kmemcheck also
marks that thing as non-present in the page-tables, the list iteration
from NMI context would then fault and things would go funny.

There's two ways out, help kmemcheck with a new annotation (which of
course starts with checking if there isn't already such a thing).

Or this one, avoid the action things from being allocated, this
side-steps kmemcheck and avoids the problem thusly.

Sadly this patch doesn't at all mention the first possibility and why
that isn't a feasible approach. A well...
