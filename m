Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab0EMK5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:57:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758622Ab0EMK5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:57:05 -0400
Message-ID: <4BEBDAF5.3020004@redhat.com>
Date: Thu, 13 May 2010 13:56:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: greg@kroah.com, jbarnes@virtuousgeek.org, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, ddutile@redhat.com, alex.williamson@redhat.com
Subject: Re: [PATCH 2/2] pci: allow sysfs file owner to read device dependent
 config space
References: <20100513012857.GA28034@sequoia.sous-sol.org> <20100513012957.GB28034@sequoia.sous-sol.org>
In-Reply-To: <20100513012957.GB28034@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 04:29 AM, Chris Wright wrote:
> The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
> check to verify privileges before allowing a user to read device
> dependent config space.  This is meant to protect from an unprivileged
> user potentially locking up the box.
>
> When assigning a PCI device directly to a guest with libvirt and KVM,
> the sysfs config space file is chown'd to the unprivileged user that
> the KVM guest will run as.  The guest needs to have full access to the
> device's config space since it's responsible for driving the device.
> However, despite being the owner of the sysfs file, the CAP_SYS_ADMIN
> check will not allow read access beyond the config header.
>
> With this patch the sysfs file owner is also considered privileged enough
> to read all of the config space.
>
>    

Related questions:

- does sysfs support selinux labels?
- what about iommu?

So we give a user privileges to access a device.  But if we don't 
enforce iommu protection, you're giving the user access to the entire 
system.

With kvm, qemu wraps the device with an iommu, but this is less secure 
than it might be.  Better to have a privileged process open the device, 
irrevocably wrap it with an iommu, and pass the wrapped fd to qemu.

This is probably best done with uio, but it means all device access 
needs to be available through the uio fd, including pci config space access.

-- 
error compiling committee.c: too many arguments to function

