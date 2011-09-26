Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab1IZWWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:22:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57411 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1IZWWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:22:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai.lu@oracle.com>
Subject: Re: S4 resume broken since 2.6.39 (3.1, too)
Date: Tue, 27 Sep 2011 00:24:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, oneukum@suse.de, x86@kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <s5hmxdzyyzx.wl%tiwai@suse.de> <201109212048.23074.rjw@sisk.pl> <CAE9FiQVy4D0NhaN=PvPK_+L4Jv=+7huLy9U--LYW49GFZ9TyaQ@mail.gmail.com>
In-Reply-To: <CAE9FiQVy4D0NhaN=PvPK_+L4Jv=+7huLy9U--LYW49GFZ9TyaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109270024.55418.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 22, 2011, Yinghai Lu wrote:
> On Wed, Sep 21, 2011 at 11:48 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > It looks like init_memory_mapping() is sometimes called with "end"
> > beyond the last mapped PFN and it explodes when we try to write stuff to
> > that address during image restoration.
> >
> > IOW, the Yinghai's assumption that init_memory_mapping() would always be
> > called with a "good end" on x86_64 was overomptimistic.
> 
> for 64bit x86, kernel_physical_mapping_init() will use
> map_low_page()/call early_memmap() to access ram for page_table that is above
> rather last mapped PFN.
> 
> the point is:
> on system with 64g, usable ram will be [0,2048m), [4g, 64g)
> init_memory_mapping will be called two times for them.
> before putting page_table high,
> page table will be two parts: one is just below 512M, and one below 2048m.
> after putting page_table high,
> page table will be two parts: one is just below 2048M, and one below 64G.
> 
> one of the purposes is finding biggest continuous big range under
> 1024m for kdump.

This is all fine so long as we can ensure that the "end" value we're
passing to init_memory_mapping() will always be a valid address, which
evidently is not the case sometimes.

So, in my opinion we should simply apply the Takashi's patch at this
point and revisit the kdump issue later, when we actually know how to do
the right thing.

Thanks,
Rafael
