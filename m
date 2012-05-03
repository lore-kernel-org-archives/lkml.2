Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab2ECVqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:46:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60122 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2ECVqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:46:51 -0400
Message-ID: <1336081595.6509.31.camel@twins>
Subject: Re: [PATCH 6/9] perf: Generic pci uncore device support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 23:46:35 +0200
In-Reply-To: <1335924440-11242-7-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	 <1335924440-11242-7-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 10:07 +0800, Yan, Zheng wrote:
> +static void __devexit uncore_pci_remove(struct pci_dev *pdev)
> +{
> +       struct intel_uncore_box *box = pci_get_drvdata(pdev);
> +       int phyid = pcibus_to_phyid[pdev->bus->number];
> +
> +       if (WARN_ON_ONCE(phyid != box->phy_id))
> +               return;
> +
> +       box->pci_dev = NULL;
> +       if (--box->refcnt == 0) {

This appears completely unserialized (as is all the refcnt stuff in
patch 4 it seems), now I figure the only way to actually have this pci
device go away is by hotplug, which is serialized. Still looks very odd.

> +               spin_lock(&uncore_pci_lock);
> +               hlist_del_rcu(&box->hlist);
> +               spin_unlock(&uncore_pci_lock);
> +               kfree_rcu(box, rcu_head);
> +       }
> +} 
