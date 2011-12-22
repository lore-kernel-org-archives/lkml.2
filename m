Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1LVT4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:56:36 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:37528 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1LVT4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:56:33 -0500
Date: Thu, 22 Dec 2011 14:56:29 -0500 (EST)
Message-Id: <20111222.145629.505018474228371646.davem@davemloft.net>
To: bhelgaas@google.com
Cc: James.Bottomley@hansenpartnership.com, linux-pci@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org
Subject: Re: [PATCH v2 00/29] Create PCI root buses with correct resources
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111222.141537.1513319029738355747.davem@davemloft.net>
References: <CAErSpo7yoWOg8P1NAi70HJX=OMyO6XUwnUBxVq3P0YK87eP5tw@mail.gmail.com>
	<20111222.135911.584309149966835644.davem@davemloft.net>
	<20111222.141537.1513319029738355747.davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 22 Dec 2011 11:56:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 22 Dec 2011 14:15:37 -0500 (EST)

> It looks like populate_msi_sysfs() is where these kobjects are
> supposed to be initialized.

Ok, it looks like we violate the invariant the free_msi_irqs() should
only be invoked after populate_msi_sysfs() has successfully been run.

For example, in msix_capability_init(), if arch_setup_msi_irqs() fails
we will branch to "error" and do free_msi_irqs().

free_msi_irqs() unconditionally does puts on the MSI entry kobjects,
but we haven't initialized them in populate_msi_sysfs() and thus we
get the warnings.

Even if we did execute populate_msi_sysfs(), if that function
encountered an error part way through the MSI entry list, we'll still
hit this kobject_put() warning for the MSI entrys we did not process
and init.

In my case arch_setup_msi_irqs() is failing simply because MSI has
not been enabled on these PCI host bridges.  It should, and I'm
trying to figure out if this is some strange interaction with the
new resource code.

But this is independent of the above bugs that can result in erroneous
kobject puts.
