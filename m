Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1HEQkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:40:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab1HEQkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:40:07 -0400
Date: Fri, 5 Aug 2011 12:39:49 -0400
From: Dave Jones <davej@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
Message-ID: <20110805163948.GA11113@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jaxboe@fusionio.com>
References: <20110805010038.GA18148@redhat.com>
 <20110805084614.GA1588@x4.trippels.de>
 <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
 <alpine.DEB.2.00.1108051131440.28580@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1108051131440.28580@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 11:32:09AM -0500, Christoph Lameter wrote:
 > On Fri, 5 Aug 2011, Pekka Enberg wrote:
 > 
 > > On Fri, Aug 5, 2011 at 11:46 AM, Markus Trippelsdorf
 > > <markus@trippelsdorf.de> wrote:
 > > > On 2011.08.04 at 21:00 -0400, Dave Jones wrote:
 > > >> Sometime in the last week, something was merged which causes my laptop
 > > >> to lock up occasionally.  I can trigger it most of the time just by
 > > >> doing a kernel build. When it gets to the final linking stage, it locks up hard.
 > > >>
 > > >> I finally managed to coax something out of usb console to get the traces below,
 > > >> which seem to implicate something in the block layer ?
 > > >>
 > > >> my root device is an lvm volume on an dmcrypt'd block dev, which might be relevant,
 > > >> as I don't see this happening on other machines with simpler setups.
 > > >>
 > > >> I'm going to try bisecting, but it might take me a few days, because it's
 > > >> such a pain in the ass to reproduce this reliably.
 > > >>
 > > >> [ 5913.233035] ------------[ cut here ]------------
 > > >> [ 5913.233097] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
 > > >> [ 5913.233101] Hardware name: Adamo 13
 > > >> [ 5913.233105] list_del corruption. prev->next should be ffffea000434fd20, but was ffffea0004199520
 > > >
 > > > See also: http://lkml.org/lkml/2011/8/3/37
 > >
 > > That's in networking so SLUB lockless patches are almost certainly the
 > > issue here. Is this with SLUB debugging enabled or not? Christoph, it
 > > like the partial lists are getting corrupted somehow.
 > 
 > This is occurring in __slab_free when we are freeing the last
 > object from a slab page that is on the partial list. It is not frozen so
 > it is not in use by a processor and thus deactivate_slab cannot be run
 > on it.
 > 
 > The logical race would be with acquire_slab() but both take the node lock
 > before doing anything with the lists.
 > 
 > Do you have CONFIG_DEBUG_VM on? If not please do so. This will check if
 > the frozen state is managed correctly.

Not sure if you were addressing my original report (quoted above), or the networking
related report in this part of the thread. But anyway, I had it turned on (as well as just about
every other debugging option).  I didn't see anything output from it though,
just the LIST_DEBUG warnings.

	Dave

