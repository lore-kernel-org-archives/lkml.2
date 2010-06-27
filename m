Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0F0E6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 00:58:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40019 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0F0E6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 00:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SSZqPOHbAQTaYYJbRRTiZo8xJUXNoM7lcrcwf0IUvp2IdDuQ3zBNt/f7PrI6lZkSBH
         oHewMrFpE4VBuQWJuwuDpQJxI/dYLhOg8j7ghy7rT07c1xAczR3tVePQbtUEK+P4eVj9
         GVIEh9tKzHxvwj8iCwbA3XPmlk/BlxPAGZoXo=
MIME-Version: 1.0
In-Reply-To: <20100627130717M.fujita.tomonori@lab.ntt.co.jp>
References: <AANLkTinG-5iKW5cigIQHPHRZuAMtG_xY-74XLL6vE5kb@mail.gmail.com>
	<20100622145805R.fujita.tomonori@lab.ntt.co.jp>
	<AANLkTimTOTM8Tt5A7eBVbxcYaGQVn_Q6-9hL8B1B4bjY@mail.gmail.com>
	<20100627130717M.fujita.tomonori@lab.ntt.co.jp>
Date: Sun, 27 Jun 2010 00:58:07 -0400
Message-ID: <AANLkTim0JbmNLY1yG5MIWhcjM34h4HHVjS58jEobmPO0@mail.gmail.com>
Subject: Re: Problems with alpha/pci + radeon/ttm
From: Matt Turner <mattst88@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, mcree@orcon.net.nz, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
       airlied@gmail.com, alexdeucher@gmail.com, jglisse@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 12:20 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Thu, 24 Jun 2010 10:53:52 -0400
> Matt Turner <mattst88@gmail.com> wrote:
>
>> > Seems that the IOMMU can't find 128 pages. It's likely due to:
>> >
>> > - out of the IOMMU space (possibly someone doesn't free the IOMMU
>> >  space).
>> >
>> > or
>> >
>> > - the mapping parameters (such as align) aren't appropriate so the
>> >  IOMMU can't find space.
>> >
>> >
>> >> Is this the cause of the bug we're seeing in the report [1]?
>> >>
>> >> Anyone know what's going wrong here?
>> >
>> >
>> > I've attached a patch to print the debug info about the mapping
>> > parameters.
>> >
>> >
>> > diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
>> > index d1dbd9a..17cf0d8 100644
>> > --- a/arch/alpha/kernel/pci_iommu.c
>> > +++ b/arch/alpha/kernel/pci_iommu.c
>> > @@ -187,6 +187,10 @@ iommu_arena_alloc(struct device *dev, struct pci_iommu_arena *arena, long n,
>> >        /* Search for N empty ptes */
>> >        ptes = arena->ptes;
>> >        mask = max(align, arena->align_entry) - 1;
>> > +
>> > +       printk("%s: %p, %p, %d, %ld, %lx, %u\n", __func__, dev, arena, arena->size,
>> > +              n, mask, align);
>> > +
>> >        p = iommu_arena_find_pages(dev, arena, n, mask);
>> >        if (p < 0) {
>> >                spin_unlock_irqrestore(&arena->lock, flags);
>>
>> Using this patch, I log the attached output.
>
> Your system has 1GB iommu address space. I guess that it's enough for
> KSM?

I would definitely think so. The video card I'm using here is a 64MB
Radeon 9100 PCI, with a 128MB BAR.

> The parameters in the log looks good. But you got this log before you
> started X?

Yes, that's right.

I'll see if I can isolate where the first -ENOMEM is coming from.

Thanks Fujita for helping with this!

Matt
