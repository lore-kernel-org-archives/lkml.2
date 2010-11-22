Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0KVHcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:32:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43907 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab0KVHcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:32:31 -0500
Date: Mon, 22 Nov 2010 08:32:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com
Subject: Re: [RFC] persistent store
Message-ID: <20101122073227.GA17928@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@gmail.com>, "Luck, Tony" <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
	akpm@linux-foundation.org, ying.huang@intel.com
References: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
 <20101121090707.GA5016@liondog.tnic>
 <AANLkTincT5w82v0964Pfaw+yudmDC2D1uGkC9p6_N23_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTincT5w82v0964Pfaw+yudmDC2D1uGkC9p6_N23_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 01:47:22PM -0800, Tony Luck wrote:
> >> 1) "Why do you only allow one platform driver to register?"
> >>   I only have one such driver.  Adding more is easy from the "read" side
> >>   (just collect all the records from all devices and remember where they
> >>   came from so you can call the correct "eraser" function).  But the "write"
> >>   side opens up questions that I don't have good answers for:
> >>   - Which device(s) should error records be written to?
> >>     All of them? Start with one and move on when it is
> >>     full?  Write some types of records to one device?
> >
> > Maybe based on the error type? We definitely need one device which
> > should contain all the records, something like main pstore device.
> 
> But who decides which records go where? And which device gets to be
> the "main" one?  I don't think that we can usefully do this in the
> registration mechanism (how does a driver know that other drivers even
> exist?).  I continue to want to defer this until someone with two or more
> devices on one machine steps forward.

Yeah, let's wait and see.

[..]

> > /sys/firmware might not be all that sensible if someone comes up with
> > persistent storage type which is the network but we'll change that then.
> 
> I'd like to get the right place first time - change means having to update
> any applications that coded in the pathname.

True, true.

> >> +int
> >> +pstore_register(struct pstore_info *psi)
> >> +{
> >> +     struct  pstore_entry    *new_pstore;
> >> +     int     rc = 0, type;
> >> +     unsigned long size;
> >> +     u64     id;
> >> +     unsigned long ps_maxsize;
> >
> > Alignment here? Maybe something like this:
> >
> >        struct pstore_entry     *new_pstore;
> >        unsigned long           ps_maxsize;
> >        int                     rc = 0, type;
> 
> Are you talking about textual alignment of the declarations? Yours
> does look prettier.

Yep, textual alignment.

[..]

> >> +     list_del(&search_pstore->list);
> >> +
> >> +     spin_unlock(&pstore_lock);
> >> +
> >> +     sysfs_remove_bin_file(&pstore_kset->kobj, &search_pstore->attr);
> >
> > AFAICT, you might want to remove the sysfs file _before_ you remove it
> > from the pstore list/erase its contents, otherwise concurrent accesses
> > to it from userspace readers might make us go boom.
> 
> I'll think about the ordering.  I have three things to do here:
> 1) Remove from the pstore_list
> 2) Call platform driver to erase from store
> 3) Call sysfs to remove the binfile.
> 
> Potentially the erase could fail ... and I should probably notice
> that and do something.

Right, and I was also wondering what might happen if userspace accesses
the bin attribute before you've removed it from the sysfs hierarchy but
after erasing its backing storage in the firmware?

AFAICT, it could be that those ps->data and ps->size members which are
accessed in pstore_show() (which is called when the bin attribute is
read from /sysfs) after the block of data is erased by platform driver,
might contain crap data and memory_read_from_buffer() could do some
illegal accesses to some kernel memory if not cleared properly by the
->erase() routine.

OTOH, you might want to do the clearing here and leave the platform
driver as dumb as possible by having a lower level __pstore_erase()
wrapper or similar.

Do you see my point? (I could very well be completely offcourse too :))

Thanks.

-- 
Regards/Gruss,
    Boris.
