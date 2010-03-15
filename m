Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805Ab0COT2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:28:05 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:33031 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965760Ab0COT2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:28:00 -0400
Date: Mon, 15 Mar 2010 21:27:54 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Jordan Crouse <jcrouse@codeaurora.org>
Cc: dri-devel@lists.sourceforge.net, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Allow platform devices to register as DRM devices
Message-ID: <20100315192754.GE4536@sci.fi>
Mail-Followup-To: Jordan Crouse <jcrouse@codeaurora.org>,
	dri-devel@lists.sourceforge.net, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <4B8BE42C.1090401@codeaurora.org>
 <4B8BE489.7020402@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B8BE489.7020402@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 09:00:09AM -0700, Jordan Crouse wrote:
> 
> Allow platform devices without PCI resources to be DRM devices.

I really dislike the fact that drm has bus specific junk all over the
generic code. Some ideas how to clean that up:

Add 'struct device *dev' into drm_device so you don't have to go through
the pdev/platformdev to get it every time. Also use dev_name() instead
of pci_name() and whatever you used for the platform device case.

Add 'int irq' into struct drm_device instead of adding more bus specific
hoops to get at the irq. Not sure I like the generic code mucking about
with the irq directly though but baby steps are easier to handle.

Get rid of the drm_resource_start/len wrappers. AFAICS they're all called
from the low level driver code anyway and the driver knows the bus type
so there's no need for the wrappers.

It would be nice to get the struct pci_driver out of the the drm_driver
structure. Since you now have a new pci specific drm_get_dev() thing
could you also pass the pci_driver as a function parameter instead
of having it live inside the drm_driver?

Also all cases where there's some PCI specific stuff (the busid stuff
mostly) you could just check the drm_device.pdev pointer instead of
having to add another driver flags to identify non-PCI devices. Although
I don't really like having the pdev/platformdev pointers in there at all.

That's sort of my secret drm TODO list but so far didn't have the time
to actually do the coding part.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
