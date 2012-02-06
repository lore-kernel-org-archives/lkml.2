Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab2BFROu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:14:50 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33575 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2BFROr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:14:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVG9YbZW=Usv0drxuyQ=ZTERK5KZK3TF6aX-iWuAS8L6Q@mail.gmail.com>
References: <1328136242-17725-1-git-send-email-yinghai@kernel.org>
 <1328136242-17725-3-git-send-email-yinghai@kernel.org> <CAErSpo44bef-Vj4LPB0QJ8HRjWxqRFK_=kpMq8hYEe=4t58zGQ@mail.gmail.com>
 <1328312292.30631.5.camel@pasglop> <CAE9FiQVG9YbZW=Usv0drxuyQ=ZTERK5KZK3TF6aX-iWuAS8L6Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 6 Feb 2012 09:14:26 -0800
Message-ID: <CAErSpo46ZTbqu1+KMomHrD9KQxTT3j+Dc8F_byKfvTJ=EDw+ow@mail.gmail.com>
Subject: Re: [PATCH 02/15] PCI: Add iobusn_resource
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 6:30 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Feb 3, 2012 at 3:38 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> On Fri, 2012-02-03 at 08:36 -0800, Bjorn Helgaas wrote:
>>> On Wed, Feb 1, 2012 at 2:43 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> > also add busn_res into struct pci_bus.
>>> >
>>> > will use them to have bus number resource tree.

>> To be honest that whole business with bus numbers in struct resource
>> seems like gratuituous bloat & over engineering to me ...
>
> ah, i thought it is simple enough, and should be done before already.
>
>> Does it actually solve a specific problem or serve a purpose ?
>
> very beginning is for one IBM x3950...
>
> https://bugzilla.novell.com/show_bug.cgi?id=735909
>
> ++max searching valid bus number range is out of boundary of peer root
> bus range.
>
> later, found the code could help: pcie hotplug, pci bus rescan and
> even remove some hacks for/from cardbus field.
>
> now with this patchset (+ one patch that is not sent out yet), I could
> even use setpci/pci rescan to move pci bus around.

The current bus number allocation in pci_scan_bridge() is very simple
-- we just add one to the highest-numbered bridge we've seen.  That
works in many cases, but it means any holes in the range of used bus
numbers are just wasted.

Here's a case I tripped over where the current scheme fails.  The
machine boots with bridge 00:03.0 to [bus 05-19].  Now we hot-add a
hierarchy that is currently configured like this:

      05:00.0 bridge to [bus 06-1e]
      06:05.0 bridge to [bus 1c]
      06:06.0 bridge to [bus 1d]
      1c:00.0 NIC0
      1d:00.0 NIC1

[bus 1a-1e] is inaccessible because the 00:03.0 aperture only includes
[bus 05-19].  There's plenty of space to reconfigure the hierarchy,
e.g., to make 05:00.0 lead to [bus 06-19], 06:05.0 lead to [bus 18],
and 06:06.0 lead to [bus 19].  But we aren't smart enough to do that.

So I think it's important to improve bus number allocation to make hot
plug more robust, but I don't think the current series is
understandable or maintainable yet.

 Bjorn
