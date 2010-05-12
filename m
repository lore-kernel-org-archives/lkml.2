Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0ELTR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:17:27 -0400
Received: from kroah.org ([198.145.64.141]:56227 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab0ELTR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:17:26 -0400
Date: Wed, 12 May 2010 12:13:36 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: jbarnes@virtuousgeek.org, matthew@wil.cx, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ddutile@redhat.com,
       alex.williamson@redhat.com
Subject: Re: [RFC PATCH] sysfs: bin_attr permission checking
Message-ID: <20100512191336.GA30678@kroah.com>
References: <20100512184713.GV28034@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512184713.GV28034@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:47:13AM -0700, Chris Wright wrote:
> The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
> check to verify privileges before allowing a user to read device
> dependent config space.  This is meant to protect from an unprivileged
> user potentially locking up the box.
> 
> When assigning a PCI device directly to a guest with libvirt and KVM, the 
> sysfs config space file is chown'd to the user that the KVM guest will
> run as.  The guest needs to have full access to the device's config
> space since it's responsible for driving the device.  However, despite
> being the owner of the sysfs file, the CAP_SYS_ADMIN check will not
> allow read access beyond the config header.
> 
> This patch adds a new bin_attr->read_file() callback which adds a struct
> file to the normal argument list.  This allows an implementation such as
> PCI config space bin_attr read_file handler to check both inode
> permission as well as privileges to determine whether to allow
> privileged actions through the handler.

Ick, this is all because we like showing different information if the
user is "privileged or not" :(

Turns out, that this probably isn't the best user api to implement,
remind me never to do that again...

> This is just RFC, although I've tested that it does allow the chown +
> read to work as expected.  Any other ideas of how to handle this are
> welcome.

Can we just pass in the 'file' for all users of the bin files instead of
the dentry?  You can always get the dentry from the file (as your patch
showes), and there isn't that many users of this interface.  I'd really
rather not have two different types of callbacks here.

thanks,

greg k-h
