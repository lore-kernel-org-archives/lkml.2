Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2ANCx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 21:53:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64279 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2ANCx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 21:53:26 -0500
MIME-Version: 1.0
In-Reply-To: <4F10EB5B.5060804@linux.vnet.ibm.com>
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
 <4F10BDF7.8030306@linux.vnet.ibm.com> <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
 <4F10EB5B.5060804@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 18:53:04 -0800
X-Google-Sender-Auth: liMbDIyoLjO_bs2VT3d0JVpsLuY
Message-ID: <CA+55aFxK5XCh6NCbo9AMvsarS9_A+s0QqV6=vC2O4dgg3vg=Aw@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 6:41 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
>
> YES!! Finally I have a fix for this whole MCE thing! :-)

Goodie.

> The patch below works perfectly for me - I tested multiple CPU hotplug
> operations as well as multiple pm_test runs at core level. Please let me
> know if this solves the suspend issue as well..

Ok, I'll try, and I bet it does.

HOWEVER.

I'd be a whole lot happier knowing exactly which field in "struct
device" that needed to be NULL before it gets registered.

I don't like how

  device_register() + device_create_file(dev)..

is not sufficiently undone by

 .. device_remove_file(dev) +  device_unregister()

so that it can't be repeated. Exactly *what* state is stale and
re-used incorrectly if you do that device_register() a second time.

It smells like a misfeature of the device core handling.

But that does obviously explain why this started happening with a
fairly straightforward conversion from sysdev to struct device. It
just makes me worry about any *other* such conversions.

Of course, normal users will allocate and free the memory, so never
see this "re-use the same piece of memory" issue. But still..

                 Linus
