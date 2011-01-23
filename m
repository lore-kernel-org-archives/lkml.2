Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab1AWBM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 20:12:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34436 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1AWBM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 20:12:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I4br3cHFX7JLQmt9a7zAfqIQUxzlVGKoSZbw4GM7+prDbPRRpUWN0PpjzyjUvsBI0w
         83dshvo0wGgGy8n6PgsT9axFzDV+pxMrM2+zR86vm1w+GsFoa7+dXisEZLYXG16DVKLJ
         B5OKgmpyw2ZGzOg1JD/hkdhzeYZ0qJBJVHXoM=
Date: Sun, 23 Jan 2011 02:12:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
Message-ID: <20110123011221.GB1805@nowhere>
References: <20110120232410.GA19405@nowhere>
 <1295607537-877-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295607537-877-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 10:58:57AM +0000, Chris Wilson wrote:
> We can only utilize the stolen portion of the GTT if we are in sole
> charge of the hardware. This is only true if using GEM and KMS,
> otherwise VESA continues to access stolen memory.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---


Applied on top of -rc2, it crashes the kernel early on
boot with an unhandle page request.
I don't have a serial line and it's too early for netconsole,
so I wrote the stacktrace I saw with printk delayed.

i830_write_entry
intel_gtt_clar_range
intel_fake_agp_insert_entries
agp_bind_memory
?agp_generic_alloc_pages
?intelfb_pci_register
?raw_spin_unlock_irqrestore
?local_pci_probe
?pci_device_probe
?driver_probe_device
?__driver_attach
?bus_for_each_dev
?driver_attach
?__driver_attach
?bus_add_driver
?pci_device_remove
?driver_register
?raw_spin_lock_init
?pci_register_driver
?intelfb_init
?do_one_initcall
?radix_tree_lookup
?irq_to_desc
?intelfb_init
?kernel_init

Given the ip (c12ccf12) it must be:

c12ccef0 <i830_write_entry>:
c12ccef0:       55                      push   %ebp
c12ccef1:       81 f9 01 00 01 00       cmp    $0x10001,%ecx
c12ccef7:       89 e5                   mov    %esp,%ebp
c12ccef9:       b9 01 00 00 00          mov    $0x1,%ecx
c12ccefe:       53                      push   %ebx
c12cceff:       bb 07 00 00 00          mov    $0x7,%ebx
c12ccf04:       0f 45 d9                cmovne %ecx,%ebx
c12ccf07:       09 c3                   or     %eax,%ebx
c12ccf09:       c1 e2 02                shl    $0x2,%edx
c12ccf0c:       03 15 8c 5e d5 c1       add    0xc1d55e8c,%edx
c12ccf12:       89 1a                   mov    %ebx,(%edx)  <--- here
c12ccf14:       5b                      pop    %ebx
c12ccf15:       5d                      pop    %ebp
c12ccf16:       c3                      ret    
c12ccf17:       89 f6                   mov    %esi,%esi
c12ccf19:       8d bc 27 00 00 00 00    lea    0x0(%edi,%eiz,1),%edi

So, it seems to be the actual writel() that faults.
