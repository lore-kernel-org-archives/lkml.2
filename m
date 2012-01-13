Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422Ab2AMXCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:02:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56876 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759389Ab2AMXCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:02:23 -0500
MIME-Version: 1.0
In-Reply-To: <4F10929E.8070007@linux.vnet.ibm.com>
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 15:02:01 -0800
X-Google-Sender-Auth: iLZw-bBHaRehgwKWJ48TJ_sIlRI
Message-ID: <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
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
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 12:22 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
>
> Fundamentally, this warning is triggered during CPU Offline, which is done
> during poweroff, suspend, hibernate etc. IOW, even a simple
> # echo 0 > /sys/devices/system/cpu/cpuX/online will trigger it.

There is definitely something wrong with CPU hotplug and MCE.

I seem to be able to trigger not only warnings, but some oopses, by doing:

 - enable list debugging, slab debugging, and kobject debugging in the
kernel (I've got some other things enabled too, but I think those are
the main ones)

 - do

     echo 0 > /sys/devices/system/cpu/cpuX/online

   this gets a few warnings

 - then do

     echo 1 > /sys/devices/system/cpu/cpuX/online

where bringing it up again will crash the machine entirely.

The oops scrolled off the screen an ddidn't get caught anywhere, but
the call trace seems to be (warning: hand-entered, so some of this may
be bogus):

Oops in:
  kobject_get+0x10/0x40

Code:
  55 48 89 f8 48 89 e5 48 83 ec 10 48 85 ff 74 0b <8b> 57 38 85 d2 74 06 f0 ff

Call trace:
  get_device
  klist_device_get
  klist_add_tail
  bus_add_device
  device_add
  device_register
  mce_device_create
  notifier_call_chain
  __raw_notifier_call_chain
  __cpu_notify
  _cpu_up
  store_online
  dev_attr_change
  sysfs_write_file

so it's definitely something bad in MCE device handling, and probably
something to do with reusing a 'struct device' after freeign it, or
after not having completely cleaned it up.

I didn't see if I could spot the problem, but I think this is entirely
reproducible, so hopefully somebody who knows the MCE code can
trivially see this and fix it.

                   Linus
