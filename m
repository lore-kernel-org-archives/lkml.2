Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2E3Q2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:28:11 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62553 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527Ab2E3Q2I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:28:08 -0400
MIME-Version: 1.0
In-Reply-To: <4FC5CEF1.6000509@snewbury.org.uk>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
 <CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
 <20120525043651.GA1391@google.com> <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
 <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
 <20120525193716.GA8817@google.com> <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
 <CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
 <CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com>
 <CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
 <CAE9FiQWUrkKEpLmEn9kzkKOtEtX7-R8shdVSKGgSyHezKpzJCw@mail.gmail.com>
 <4FC50E09.4000204@zytor.com> <CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com>
 <CAErSpo4ywho4UmPVAjT7yZNROc9e1zCx+UoaS5un+v4aN=akJA@mail.gmail.com>
 <CAE9FiQWORRjxEQwr+933ReNAAKAEoJ5B6AWte4gr33_BO+4heQ@mail.gmail.com>
 <CAErSpo44TViNFcZivjr5hAu8w8kpEpUjxNAWtazhAqwwsorZbw@mail.gmail.com> <4FC5CEF1.6000509@snewbury.org.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 30 May 2012 10:27:45 -0600
Message-ID: <CAErSpo6zU898KBv+vFFkymMjpDrPokj0dJq9MMX0z6WZOALbmQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
To: Steven Newbury <steve@snewbury.org.uk>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 1:40 AM, Steven Newbury <steve@snewbury.org.uk> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 30/05/12 00:27, Bjorn Helgaas wrote:
>> On Tue, May 29, 2012 at 2:40 PM, Yinghai Lu <yinghai@kernel.org>
>> wrote:
>>> On Tue, May 29, 2012 at 12:23 PM, Bjorn Helgaas
>>> <bhelgaas@google.com> wrote:
>>>> On Tue, May 29, 2012 at 12:17 PM, Yinghai Lu
>>>> <yinghai@kernel.org> wrote:
>>>>> On Tue, May 29, 2012 at 10:57 AM, H. Peter Anvin
>>>>> <hpa@zytor.com> wrote:
>>>>>> On 05/29/2012 10:55 AM, Yinghai Lu wrote:
>
> *SNIP*
>
>>>
>>>
>>> ok, please check the version, that put back PCI_MAX_RESOURCE_32
>>> for io ports.
>>>
>>> also RFC to limit for 16 bit ioport handling.  only help other
>>> arches that does support 32bit ioports but have bridges only
>>> support 16bit io ports.
>>
>> I don't understand this one at all.  It looks like you mashed
>> together at least two changes: (1) prefer I/O space above 64K if
>> available, and (2) mark secondary bus resources with
>> IORESOURCE_IO_32 when the P2P bridge I/O window address decode type
>> is PCI_IO_RANGE_TYPE_32 and use that to limit allocations.
>>
>> I don't see the justification for (1).  What problem does this
>> solve?
>>
> I can potentially see this helping with hotplug, where a new device
> has only 16 bit io ports, but if there's no space remaining under 64k
> allocation would fail.  Preferring above 64k means preserving that
> limited resource.  This is exactly equivalent to my original
> motivation for preferring 64 bit PCI mem in order to preserve 32 bit
> address space for hotplug devices without 64 bit BARs.

You're right, the spec does allow the upper 16 bits of I/O BARs to be
hardwired to zero (PCI spec rev 3.0, p. 226), so this part does make
some sense.  I don't think it applies to x86, since I don't think
there's a way to generate an I/O access to anything above 64K, but it
could help other arches.

I'm inclined to be conservative and wait until we find a problem where
a patch like this would help.
