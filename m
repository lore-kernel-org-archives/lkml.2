Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1I1NYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:24:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab1I1NYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:24:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: S4 resume broken since 2.6.39 (3.1, too)
Date: Wed, 28 Sep 2011 15:26:19 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Yinghai Lu <yinghai.lu@oracle.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, oneukum@suse.de, x86@kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
References: <s5hmxdzyyzx.wl%tiwai@suse.de> <201109271856.44300.rjw@sisk.pl> <s5hbou5c70w.wl%tiwai@suse.de>
In-Reply-To: <s5hbou5c70w.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281526.20088.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 28, 2011, Takashi Iwai wrote:
> At Tue, 27 Sep 2011 18:56:44 +0200,
> Rafael J. Wysocki wrote:
> > 
> > On Tuesday, September 27, 2011, Takashi Iwai wrote:
> > > At Mon, 26 Sep 2011 19:26:44 -0700,
> > > Yinghai Lu wrote:
> > > > 
> > > > On 09/22/2011 11:11 AM, Takashi Iwai wrote:
> > > > 
> > > > > At Thu, 22 Sep 2011 07:33:17 -0700,
> > > > > Yinghai Lu wrote:
> > > > >>
> > > > >> On Wed, Sep 21, 2011 at 11:48 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > >>> It looks like init_memory_mapping() is sometimes called with "end"
> > > > >>> beyond the last mapped PFN and it explodes when we try to write stuff to
> > > > >>> that address during image restoration.
> > > > >>>
> > > > >>> IOW, the Yinghai's assumption that init_memory_mapping() would always be
> > > > >>> called with a "good end" on x86_64 was overomptimistic.
> > > > >>
> > > > >> for 64bit x86, kernel_physical_mapping_init() will use
> > > > >> map_low_page()/call early_memmap() to access ram for page_table that is above
> > > > >> rather last mapped PFN.
> > > > >>
> > > > >> the point is:
> > > > >> on system with 64g, usable ram will be [0,2048m), [4g, 64g)
> > > > >> init_memory_mapping will be called two times for them.
> > > > >> before putting page_table high,
> > > > >> page table will be two parts: one is just below 512M, and one below 2048m.
> > > > >> after putting page_table high,
> > > > >> page table will be two parts: one is just below 2048M, and one below 64G.
> > > > > 
> > > > > So, how can this change break S4 resume?
> > > > 
> > > > 
> > > > not sure.
> > > > 
> > > > seems resume has it's own page table during transition...
> > > > 
> > > > 
> > > > > Any hint for further debugging?
> > > > 
> > > > 
> > > > you may try to insert dead loop in arch/x86/power/hibernate_asm_64.S::restore_image or core_restore_code
> > > > 
> > > > to see which part cause reset.
> > > 
> > > That's the answer I was afraid of :)
> > 
> > I wonder.  Does hibernation work on the machine in question with
> > acpi_sleep=nonvs and if so, is the problem reproducible with this
> > setting?
> 
> It still shows the same problem.  Reboots after a few S4 cycles.
> I'll test kernel S4.

This most likely means that NVS is not involved.

Have you tried to revert commit d1ee433 (x86, trampoline: Use the unified
trampoline setup for ACPI wakeup)?

Rafael
