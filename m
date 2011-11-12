Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab1KLAyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:54:54 -0500
Received: from sous-sol.org ([216.99.217.87]:47579 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755227Ab1KLAyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:54:53 -0500
Date: Fri, 11 Nov 2011 16:17:05 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        chrisw@sous-sol.org, ddutile@redhat.com
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains
 unattached to iommus
Message-ID: <20111112001705.GM14486@sequoia.sous-sol.org>
References: <20111111224849.9756.13368.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111111224849.9756.13368.stgit@bling.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> domain_update_iommu_coherency() currently default to setting domains
> as coherent when the domain is not attached to any iommus.  This
> allows for a window in domain_context_mapping_one() where such a
> domain can update context entries non-coherenty, and only after
> update the domain capability to clear iommu_coherency.
> 
> This can be seen using KVM device assignment on VT-d systems that
> do not support coherency in the ecap register.  When a device is
> added to a guest, a domain is created (iommu_coherency = 0), the
> device is attached, and ranges are mapped.  If we then hot unplug
> the device, the coherency is updated and set to the default (1)
> since no iommus are attached to the domain.  A subsequenct attach
> of a device makes use of the same dmar domain (now marked coherent)
> updates context entries with cohrency enabled, and only disables
> coherency as the last step in the process.

Specifically, in domain_context_mapping_one():

  context_set_translation_type(context, translation);
  context_set_fault_enable(context);
  context_set_present(context);
  domain_flush_cache(domain, context, sizeof(*context));  <-- noop

This does not update context entry, leaving IOMMU w/ a non-present
context entry, and therefore subsequent DMA generates DMAR faults:

DMAR:[DMA Read] Request device [08:10.0] fault addr 37298000
DMAR:[fault reason 02] Present bit in context entry is clear
 
> To fix this, switch domain_update_iommu_coherency() to use the
> safer, non-coherent default for domains not attached to iommus.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Tested-by: Donald Dutile <ddutile@redhat.com>
> Acked-by: Donald Dutile <ddutile@redhat.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>

thanks,
-chris
