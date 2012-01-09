Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab2AIRRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:17:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab2AIRRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:17:02 -0500
Date: Mon, 9 Jan 2012 09:16:52 -0800
From: Greg KH <gregkh@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgorman@suse.de, hch@infradead.org, akpm@linux-foundation.org
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120109171652.GA3904@suse.de>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
 <CA+55aFy-XiMR6XCudvjbPV8Q0cyDxy+iB_BnDxYOJTnskCkw9A@mail.gmail.com>
 <877h10957n.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877h10957n.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 06:05:32PM +0100, Miklos Szeredi wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Mon, Jan 9, 2012 at 2:58 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>
> >> This patch adds a new dentry flag that is set when the dentry is removed
> >> from the lru and put on the list being processed by
> >> shrink_dentry_list().  The flag is cleared in dentry_lru_del() which is
> >> called if the dentry gets a new reference just before it's pruned.
> >>
> >> Thoughts?
> >
> > Looks reasonable. Were you actually able to reproduce the hang, or how
> > did you notice?
> 
> We got a bug report from a partner about hang during reboot.  It's
> actually quite easily reproducible with:
> 
> while true; do
>         echo -bond0 > /sys/class/net/bonding_masters
>         echo +bond0 > /sys/class/net/bonding_masters
>         echo -bond1 > /sys/class/net/bonding_masters
>         echo +bond1 > /sys/class/net/bonding_masters
> done
> 
> That reliably triggers the soft lookup detector for several machines
> that we tested.  It's rather timing sensitive though, because turning on
> DEBUG_SPINLOCK makes it go away.
> 
> I had to add printks to see what's going on, because it wasn't obvious
> from the stack traces and crash dumps.

You also usually need to add a udev rule that looks at the pci id of the
device as well, without checking for what type it is (which is what a
"correct" udev rule should be doing, which is why we only started seeing
this on some systems, with "incorrect" rules.)

Having a file in /lib/udev/rules.d/ with only this one rule:
ATTR{vendor}=="0x8086", ATTR{device}=="0x10ca", ENV{PCI_SLOT_NAME}="%k", ENV{MATCHADDR}="$attr{address}", RUN+="/bin/true"

Seems to do the trick.  udev calls stat() on the vendor sysfs file,
while it is going away, and then this dentry race shows up.

thanks,

greg k-h
