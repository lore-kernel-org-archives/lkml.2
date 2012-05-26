Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2EZPCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 11:02:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47295 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab2EZPCM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 11:02:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
 <1337754877-19759-3-git-send-email-yinghai@kernel.org> <CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
 <CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
 <CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
 <20120525043651.GA1391@google.com> <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
 <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
 <20120525193716.GA8817@google.com> <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
 <CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
 <CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com> <CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 26 May 2012 09:01:47 -0600
Message-ID: <CAErSpo5iQr9Q3=94DBkUPNKTWS3F0SNKyBgrpCATWgtLeJ-98g@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 6:12 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, May 25, 2012 at 5:10 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Fri, May 25, 2012 at 2:55 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> I think we should fix this with a separate patch that removes
>>> PCIBIOS_MAX_MEM_32 altogether, replacing this use with an explicit
>>> 0xffffffff (or some other "max 32-bit value" symbol).  I don't think
>>> there's anything arch-specific about this.
>>>
>>> So I'd like to see two patches here:
>>>  1) Avoid allocating 64-bit regions for 32-bit BARs
>>>  2) Try to allocate regions above 4GB for 64-bit BARs
>>
>> Sure. please check updated two patches.
>
> I think the first one looks good.
>
> I'm curious about the second.  Why did you add the IORESOURCE_MEM
> test?  That's doesn't affect the "start =" piece because
> IORESOURCE_MEM is always set if IORESOURCE_MEM_64 is set.
>
> But it does affect the "end =" part.  Previously we limited all I/O
> and 32-bit mem BARs to the low 4GB.  This patch makes it so we limit
> 32-bit mem BARs to the low 4GB, but we don't limit I/O BARs.  But I/O
> BARs can only have 32 bits of address, so it seems like we should
> limit them the same way as 32-bit mem BARs.  So I expected something
> like this:
>
>    if (res->flags & IORESOURCE_MEM_64) {
>        start = (resource_size_t) (1ULL << 32);
>        end = PCI_MAX_RESOURCE;
>    } else {
>        start = 0;
>        end = PCI_MAX_RESOURCE_32;
>    }

Another bug here: we're trying to restrict the *bus* addresses we
allocate, but we're applying the limits to *CPU* addresses.
Therefore, this only works as intended when CPU addresses are the same
as bus addresses, i.e., when the host bridge applies no address
translation.  That happens to be the case for x86, but is not the case
in general.

I think we need a third patch to fix this problem.
