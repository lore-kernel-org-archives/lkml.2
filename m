Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2GXVlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:41:16 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44931 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402Ab2GXVlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:41:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120720203857.GD13835@redhat.com>
References: <1342727183-4520-1-git-send-email-jim.cromie@gmail.com> <20120720203857.GD13835@redhat.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 24 Jul 2012 15:40:43 -0600
Message-ID: <CAJfuBxzV-hct4wE+wPxrSabd_2oJ9DaH31Oxd-LVhuh1hFyoSw@mail.gmail.com>
Subject: Re: [PATCH 0/3] dyndbg: dev_dbg bugfix + 2 trivials
To: Jason Baron <jbaron@redhat.com>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, joe@perches.com,
        greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Jason

( Kay, I previously mis-addressed you at vrfy.com, so you havent received the
thread directly until now. sorry about that)

On Fri, Jul 20, 2012 at 2:38 PM, Jason Baron <jbaron@redhat.com> wrote:
> On Thu, Jul 19, 2012 at 01:46:19PM -0600, Jim Cromie wrote:
>> 3 patches here, 1st is bugfix, others are trivial.
>>
>> 1- fix __dev_printk, which broke dev_dbg() prefix under CONFIG_DYNAMIC_DEBUG.
>>
>
> Patch looks good, and would be really nice to get into 3.5. Kay, are you
> ok with this patch?
>
>> 2- change dyndbg prefix interfield separator from ':' to '.'
>>
>> for example (output from test-code, not submitted):
>> r8169 0000:02:00.0: r8169.rtl_init_one: set-drvdata pdev:ffff880223041000 dev:ffff880220d6a000
>> hwmon hwmon1: k10temp.k10temp_probe.180: set-drvdata pdev:ffff88022303d000 dev:ffff8801dfd2a000
>>
>> This improves usability of cut -d: <logfile> for pr_debug() messages,
>> as field position is less volatile with various uses of dyndbg flags.
>> Its not perfect:
>> - dev_dbg on net-devices adds several more colons,
>>   but this doesnt vary with dyndbg flags.
>> - dyndbg=+pfmlt still adds a field vs dyndbg==p (ie no prefix)
>> - pr_fmt() commonly adds another colon (unchanged with this patch)
>
> As you suggest in the patch, changing the delimiter to a non-colon
> character such as ',' would resolve these cases?

yes mostly - depending upon what "these" are.

Changing the prefix delimiter (I chose dot since its used in nested
names everywhere)
definitely improves the situation, with this patch the field-count variation is
0 or 1 for dyndbg==p or dyndbg==p[fmlt]+ respectively

It obviously doesnt address colons which may be added elsewhere;
pr_fmt() KBUILD_MODNAME ":" __func__  adds another,
and dev_printk adds several, depending on the device type

Its reasonable to change all the pr_fmt() delimiters to dot also,
but thats a lot of touches to a lot of modules (ie churn), and
probably isnt worth doing
unless its done fully, which would need a solid consensus that its
worth the trouble.

changing delimiters inside dev_printk() / dev_driver_string() is harder;
it means changing values in low level fields
                        (dev->bus ? dev->bus->name :
                        (dev->class ? dev->class->name : ""));

which are also exposed to user-space, forex by lspci etc

]$ lspci | cut -c 1-20
00:00.0 Host bridge:
00:07.0 PCI bridge:
00:11.0 SATA control
00:12.0 USB Controll
00:14.0 SMBus: ATI T
00:14.1 IDE interfac
00:14.2 Audio device
00:14.3 ISA bridge:
00:14.4 PCI bridge:

That looks like a can of worms best left closed.


So this patch only addresses dyndbg prefix, and is 95% resolved.
the remaining 0-1 variation isnt really important - almost all dyndbg users
will want some prefix - at least module, so the missing field in dyndbg==p
is pretty inconsequential, and its typically provided by pr_fmt() anyway.


In any case, I think ths patch does what is practical now, and no more.
If you agree, the patch needs your Ackd-by before Greg will take it.


Going forward, the proper priorities for dyndbg are IMO (CMIIW)

- get jumplabels working

  Ive coded this, and it looks ok, but Im stuck on the circular
include problem seen
  when I add #include <linux/jumplabel.h> needed for the ddebug.key field.
  Ive tried a few permutations, but I dont think thats gonna
illuminate a working fix.
  I think I'll post a minimal RF-Help patch to demonstrate the problem ..

- propose a pr_debug_flags("flagchars", "fmt", ...)

  "flagchars" would be uppercase chars defined for each module
  DBG_DEFINE_FLAG( mod_debug_str, "A", "alpha flag controls .. blah blah..");

  I think this could be made to work for both dyndbg and non-dyndbg:
  $ echo A > /sys/module/modname/parameters/dbg_str
  $ echo module modname +pA > /dbg/dynamic_debug/control

This needs more thought, and perhaps simplification,
but it seems appropriate to see if dyndbg and non-dyndbg can be made
to fit together cogently from a user perspective.
