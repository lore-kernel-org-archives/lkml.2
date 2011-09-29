Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1I2APt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 20:15:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64636 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1I2APr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 20:15:47 -0400
MIME-Version: 1.0
In-Reply-To: <4E83243A.7060408@windriver.com>
References: <20110928184150.0fcf097b7f9128f8639059f3@canb.auug.org.au>
	<4E83243A.7060408@windriver.com>
Date: Wed, 28 Sep 2011 20:15:45 -0400
X-Google-Sender-Auth: n0jgSeVHuyTAunqRafMJUVT1FXc
Message-ID: <CAP=VYLrHGYXpXaHn0GbE5ysRXkNhnqVimC01K3inwXq_KPBtYA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the moduleh tree
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 9:42 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On 11-09-28 04:41 AM, Stephen Rothwell wrote:
>> Hi Paul,
>>
>> After merging the moduleh tree, today's linux-next build (x86_64
>> allmodconfig) went on producing more failures (beyond those reported
>> earlier).  I have used the version of the moduleh tree from next-20110927
>> for today and will see if I have more stamina tomorrow.
>
> I will grab a copy of today's next and pick up where you left off, plowing
> into the new additions in next that are implicitly using module.h

Hi Stephen,

I figured, given the footprint of the module.h stuff, that it is entirely
unfair for you to have to carry all those changes that aren't in the
merge-base of the module.h branch.  So I've created a post merge
commit series that I'll maintain -- which will have the commits that
can't be in the module.h split branch, but will be required, once all
the linux-next content has been merged.

If you clone:

   git://openlinux.windriver.com/people/paulg/modsplit-post-merge

you will get a repository of commits, and a series file (just like that used
for longterm/stable queues) that you can deploy onto linux-next to get
the changes you'd been carrying, plus new ones I found by testing on
linux-next myself.  It replaces the following from your tree generation:

Applying: dm: use export.h instead of module.h where possible
Applying: block: bsg-lib.c needs export.h not module.h
Applying: PM: EXPORT_SYMBOL needs export.h
Applying: bcma: driver_chipcommon_pmu.c needs linux/export.h
Applying: powerpc/powernv: include export.h in hvc_opal.h for THIS_MODULE
Applying: PM QoS: include export.h in qos.c for EXPORT_SYMBOL
Applying: x86, amd: include linux/elf.h since we use stuff from asm/elf.h
Applying: block/mtip32xx: include module.h for its utilities
Applying: NFC: use of module facilities requires the inclusion of module.h
Applying: mmc: using mopdule_param requires the inclusion of moduleparam.h
Applying: rtlwifi: use of module_param requires the inclusion of moduleparam.h
Applying: wireless/ath6kl: use of module_param requires the inclusion
of moduleparam.h

I'm hoping that you can plug pulls of this post-merge queue into your
infrastructure in a way that moves the burden off you and onto me.

[I didn't have exact copies of what you were using for the top three, but
it wasn't hard to recreate them based on the oneline shortlog]

I took the most recent linux-next, reverted the merge of the "old" module
split content, merged the "new" split content, and then played the series
file to get a tree that will pass x86_64 allmodconfig with the linux-next
content all present.  I'll be doing additional build coverage over all the
other arch on that same tree overnight.

I also weeded out as many conflicts as I could by trivial relocations of
include files.  However, the following remain, and can't be easily killed
because some files only have one or two includes, and don't lend
themselves to relocations.   Here is the conflicts that remain:

    Conflicts:
        arch/arm/mach-bcmring/mm.c
        drivers/media/dvb/frontends/dibx000_common.c
        drivers/misc/altera-stapl/altera.c
        drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
        drivers/scsi/libfc/fc_lport.c
        drivers/staging/iio/accel/adis16220_core.c
        include/linux/dmaengine.h
        sound/soc/soc-io.c

Some of these you will already have in your rr-cache for sure.
They are all trivial conflicts in header lists.

Hopefully this makes things easier for you.  If you have any
other suggestions/tweaks that you'd like to see in order to
make your life easier, please do let me know.

Thanks again for putting up with the large footprint of this,
Paul.
