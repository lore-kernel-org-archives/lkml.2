Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab0EMPGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:06:19 -0400
Received: from sous-sol.org ([216.99.217.87]:36217 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754179Ab0EMPGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:06:16 -0400
Date: Thu, 13 May 2010 08:05:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Wright <chrisw@sous-sol.org>, greg@kroah.com,
       jbarnes@virtuousgeek.org, matthew@wil.cx, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ddutile@redhat.com,
       alex.williamson@redhat.com
Subject: Re: [PATCH 2/2] pci: allow sysfs file owner to read device dependent
 config space
Message-ID: <20100513150554.GC28034@sequoia.sous-sol.org>
References: <20100513012857.GA28034@sequoia.sous-sol.org>
 <20100513012957.GB28034@sequoia.sous-sol.org>
 <20100513105911.6469c434@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513105911.6469c434@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> On Wed, 12 May 2010 18:29:57 -0700
> Chris Wright <chrisw@sous-sol.org> wrote:
> 
> > The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
> > check to verify privileges before allowing a user to read device
> > dependent config space.  This is meant to protect from an unprivileged
> > user potentially locking up the box.
> 
> Or hacking it.

With read access?  You mean from read side-effect on a device register?

>  You could argue the correct requirement is to change it to
> require CAP_SYS_RAWIO in fact !

It's also pervasive through sysfs.  I found 22 CAP_SYS_ADMIN checks via
sysfs bin_attrs, most are firmware, config space, and similar; most of
which have could be abused to hack box in one way or another.

> > With this patch the sysfs file owner is also considered privileged enough
> > to read all of the config space.
> 
> Which breaks the main reason the check was there in the first place. To
> stop accidents of the form
> 
> 	find / -exec grep {} "wibble"
> 
> blowing up in people's faces.

Right, this won't change w/out sysadmin intervention.

Currently, any random user doing that won't trigger an ill-behaving
device dependent config space read.  It requires an admin to chown the
file to the user, at which point you've given the device to the user.
This is typically only done in the privileged context of libvirt launching
a KVM guest that has a host PCI device directly assigned to it, and the
chown is typically to a non-shell user.

> I agree with the problem - but IMHO the fix is to require opening the file
> checks CAP_SYS_something instead:

We can't require CAP_SYS_something on open as that will break basic tools
like lspci.  We could note the privileges when opened and check them
later.

>  not to hack the read method and make it
> even weirder and more un-Linux than it is now.


