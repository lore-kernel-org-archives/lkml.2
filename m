Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab2EDGHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:07:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:20506 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab2EDGHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:07:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="136886911"
Message-ID: <4FA37237.5000501@intel.com>
Date: Fri, 04 May 2012 14:07:51 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] perf: Generic pci uncore device support
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>  <1335924440-11242-7-git-send-email-zheng.z.yan@intel.com> <1336081595.6509.31.camel@twins>
In-Reply-To: <1336081595.6509.31.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 05:46 AM, Peter Zijlstra wrote:
> On Wed, 2012-05-02 at 10:07 +0800, Yan, Zheng wrote:
>> +static void __devexit uncore_pci_remove(struct pci_dev *pdev)
>> +{
>> +       struct intel_uncore_box *box = pci_get_drvdata(pdev);
>> +       int phyid = pcibus_to_phyid[pdev->bus->number];
>> +
>> +       if (WARN_ON_ONCE(phyid != box->phy_id))
>> +               return;
>> +
>> +       box->pci_dev = NULL;
>> +       if (--box->refcnt == 0) {
> 
> This appears completely unserialized (as is all the refcnt stuff in
> patch 4 it seems), now I figure the only way to actually have this pci
> device go away is by hotplug, which is serialized. Still looks very odd.
> 
yes, box->refcnt should always be 1 here. will remove the 'if (--box->refcnt == 0)'

>> +               spin_lock(&uncore_pci_lock);
>> +               hlist_del_rcu(&box->hlist);
>> +               spin_unlock(&uncore_pci_lock);
>> +               kfree_rcu(box, rcu_head);
>> +       }
>> +} 

