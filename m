Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2APSmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:42:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54813 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2APSmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:42:38 -0500
MIME-Version: 1.0
In-Reply-To: <20120116181135.GA2680@suse.de>
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
 <4F10BDF7.8030306@linux.vnet.ibm.com> <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
 <4F10EB5B.5060804@linux.vnet.ibm.com> <CA+55aFxK5XCh6NCbo9AMvsarS9_A+s0QqV6=vC2O4dgg3vg=Aw@mail.gmail.com>
 <20120114144938.GA32033@suse.de> <20120116181135.GA2680@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 16 Jan 2012 19:42:14 +0100
Message-ID: <CAPXgP12uw9MKhsHPK6GHLER7E0UDGJ6FHPHGLtRGefkMYAk+Fw@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 19:11, Greg KH <gregkh@suse.de> wrote:

>> It has to do with the fact that this is a "static" device that is being
>> reused.  Normally it would be cleaned up properly in the release
>> function, but as there isn't one, some fields are being left in a bad
>> state.
>
> Kay, I looked at this this morning, and it comes down to the line:
>
> DEFINE_PER_CPU(struct device, mce_device);
>
> Where we are creating static struct device variables.  I'm guessing this
> is just done for "convenience" as we really don't care about where in
> memory these structures are, we just want to make sure we have enough of
> them around (this is the way all the other mce per-cpu structures are
> handled.)

It's a pretty common pattern across the CPU handling code. I don't
know the details, but I doubt many of them are needed or really useful
in the context which they are used. So, it's either convenience or
just 'hoping stuff could be made without managing memory'. :)

Having the 'machinecheck' devices pre-allocated per CPU might not make
too much sense, because the driver core operations will still need to
allocate stuff dynamically at register() time anyway. Attaching
devices to interfaces and drivers of a subsystem will require the same
thing, even the simplest kobject allocates the name dynamically.

I guess, the driver core part ofmachinecheckcould just be fully
dynamic, instead of statically pre-allocated.

Kay
