Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab2CBQoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 11:44:03 -0500
Received: from mga10.intel.com ([192.55.52.92]:15246 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020Ab2CBQoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:44:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dan.j.williams@intel.com designates 10.182.118.34 as permitted sender) smtp.mail=dan.j.williams@intel.com
MIME-Version: 1.0
In-Reply-To: <20120302162159.GB31683@wavehammer.waldi.eu.org>
References: <CAJ75kXZ-2vWZpG7Uz3firg6ew4y_DdorXotkAkUGSK0GWLMUQQ@mail.gmail.com>
	<20120127144737.GA27750@andromeda.dapyr.net>
	<20120219223125.GA820@burratino>
	<20120220181618.GD17566@burratino>
	<4F4891B8.9050008@goirand.fr>
	<20120302055715.GA692@burratino>
	<CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
	<20120302162159.GB31683@wavehammer.waldi.eu.org>
Date: Fri, 2 Mar 2012 08:44:00 -0800
Message-ID: <CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 8:21 AM, Bastian Blank <waldi@debian.org> wrote:
> On Thu, Mar 01, 2012 at 10:42:44PM -0800, Dan Williams wrote:
>> WARN_ON may work, but then kernel may be subject random hangs from missed
>> i/o completions.

...actually descriptors completing too early.

>
> Why is that? Currently it just dies if was triggered via interrupt and
> for some reason no active descriptor was found.

No, it's not the case that "no active descriptor was found".

The channel is walking through the submitted descriptor chain to catch
up with what was last posted to '
phys_complete'.  It expects to stop when seeing phys_complete, but if
it never finds it the driver ends up completing the entire pending
ring.  The BUG_ON is there because the driver has just completed every
descriptor in the chain, and if the kernel was depending on proper
descriptor ordering it may have just violated it.

So I take it back, we can't go to WARN_ON, because the state of the
system is compromised and we need to bring it to a halt.

That said the code is likely failing in the self test, so the system
is probably fine, but if this happened in the network or raid layer it
is potentially fatal.

>>                   Is xen32 using vt-d?
>
> Yes. Xen can use VT-D.
>
>>                                         Just wondering if writes from ioat
>> device are getting misdirected.
>
> How do VT-D and ioat interact?
>

Same as any other pci bus mastering device, via dma_map to get a
io-virtual  address.
