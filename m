Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1HVORK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:17:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48719 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1HVORI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:17:08 -0400
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Date: Mon, 22 Aug 2011 16:16:20 +0200
In-Reply-To: <1313786266-9585-3-git-send-email-dzickus@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
	 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314022580.24275.33.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 16:37 -0400, Don Zickus wrote:
> +static struct nmiaction *__free_nmi(unsigned int type, const char *name)
> +{
> +       struct nmi_desc *desc = nmi_to_desc(type);
> +       struct nmiaction *n, **np = &(desc->head);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&desc->lock, flags);
> +
...
> +
> +       spin_unlock_irqrestore(&desc->lock, flags);
> +       synchronize_rcu();
> +       return *np;
> +}

> +void unregister_nmi_handler(unsigned int type, const char *name)
> +{
> +       kfree(__free_nmi(type, name));
> +}

This code is weird.. why not have the kfree() in __free_nmi(), also why
use sync_rcu() and not use kfree_rcu()?

> +EXPORT_SYMBOL_GPL(unregister_nmi_handler); 

*g*, so binary modules can register an NMI handler, but can't unregister
it..?
