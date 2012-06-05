Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357Ab2FEChK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 22:37:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43710 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699Ab2FEChH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 22:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo67h_mdZtoEn-W_OOXZ8m7gs3g6Q25kte285ZX=2FKf+A@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
	<CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
	<20120525043651.GA1391@google.com>
	<CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
	<CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
	<20120525193716.GA8817@google.com>
	<CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
	<CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
	<CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com>
	<CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
	<CAE9FiQWUrkKEpLmEn9kzkKOtEtX7-R8shdVSKGgSyHezKpzJCw@mail.gmail.com>
	<4FC50E09.4000204@zytor.com>
	<CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com>
	<4FC51D79.6010804@zytor.com>
	<CAE9FiQUWMAdU5jtKfq1_=1E-574gW-Afo8Pby49mUFQYFrs9Pw@mail.gmail.com>
	<4FC536A5.6020600@zytor.com>
	<CAE9FiQXi23-mY6p2Dr1EJmukhTSPxvBGtjvQ8wyJYPDS+6o5ZA@mail.gmail.com>
	<CAErSpo67h_mdZtoEn-W_OOXZ8m7gs3g6Q25kte285ZX=2FKf+A@mail.gmail.com>
Date: Mon, 4 Jun 2012 19:37:06 -0700
X-Google-Sender-Auth: 1H0KzPvIVEufduu0yncw6kjb6jQ
Message-ID: <CAE9FiQV7jpBWkcXy2vgixnxx2fhid28Wj0iHAhGkVVdQn6epNQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 6:05 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Jun 1, 2012 at 4:30 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Tue, May 29, 2012 at 1:50 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> The bus-side address space should not be more than 32 bits no matter
>>> what.  As Bjorn indicates, you seem to be mixing up bus and cpu
>>> addresses all over the place.
>>
>> please check update patches that is using converted pci bus address
>> for boundary checking.
>
> What problem does this fix?  There's significant risk that this
> allocation change  will make us trip over something, so it must fix
> something to make it worth considering.

If we do not enable that, we would not find the problem.

On one my test setup that _CRS does state 64bit resource range,
but when I clear some device resource manually and let kernel allocate
high, just then find out those devices does not work with drivers.
It turns out _CRS have more big range than what the chipset setting states.
with fixing in BIOS, allocate high is working now on that platform.

>
> Steve's problem doesn't count because that's a "pci=nocrs" case that
> will always require special handling.

but pci=nocrs is still supported, even some systems does not work with
pci=use_crs

> A general solution is not
> possible without a BIOS change (to describe >4GB apertures) or a
> native host bridge driver (to discover >4GB apertures from the
> hardware).  These patches only make Steve's machine work by accident
> -- they make us put the video device above 4GB, and we're just lucky
> that the host bridge claims that region.

Some bios looks enabling the non-stated range default to legacy chain.
Some bios does not do that. only stated range count.
So with pci=nocrs we still have some chance to get allocate high working.

>
> One possibility is some sort of boot-time option to force a PCI device
> to a specified address.  That would be useful for debugging as well as
> for Steve's machine.

yeah, how about

pci=alloc_high

and default to disabled ?

Thanks

Yinghai
