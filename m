Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2HMTI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 15:08:58 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:34779 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2HMTI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 15:08:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, kernel-janitors@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, <linux-arch@vger.kernel.org>
References: <20120812145023.GA17077@localhost> <87k3x3z3de.fsf@xmission.com>
	<20120813133910.GA30532@localhost>
	<63f9e712-3cd1-4020-9df6-8fb8d9c3f1ec@email.android.com>
	<20120813175516.GA32757@localhost> <20120813181343.GA2055@localhost>
Date: Mon, 13 Aug 2012 12:08:47 -0700
In-Reply-To: <20120813181343.GA2055@localhost> (Fengguang Wu's message of
	"Tue, 14 Aug 2012 02:13:43 +0800")
Message-ID: <877gt2y5hc.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19sPv/ZiTWvG1FeXFQw5uqZfbog4RHve8w=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Fengguang Wu <fengguang.wu@intel.com>
X-Spam-Relay-Country: 
Subject: Architectures missing atomic64_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> On Tue, Aug 14, 2012 at 01:55:16AM +0800, Fengguang Wu wrote:
>> > >I'd suggest to fix it in m68k and make atomic64_t generally available.
>> > 
>> > Fengguang in your testing on any architechtures is atomic64_t missing on anything except some m68k subarchtechtures?
>> 
>> Eric, it only complaints for m68k, among the architechtures the build
>> tests covered (alpha arm avr32 blackfin cris frv h8300 i386 ia64 m32r
>> m68k mips mn10300 openrisc parisc powerpc s390 sh sparc sparc64 tile
>> um x86_64 xtensa).
>
> Sorry, I must missed something (in my system, build errors are only
> recorded on first sight)..
>
> wfg /c/linux% for arch in arch/*/; do grep -ir -q atomic64 $arch || echo $arch; done
> arch/c6x/
> arch/h8300/
> arch/mn10300/
> arch/score/
> arch/unicore32/
>
> So the above archs are likely still missing atomic64_t support.
> However it should be trivial to add support to them, by adding
> "select GENERIC_ATOMIC64" lines to them.

So I just looked a little deeper and it appears architectures that do
not support atomic64_t are broken.

The generic atomic64 support came in 2009 to support the perf subsystem
with the expectation that all architectures would implement atomic64
support.

Furthermore upon inspection of the kernel atomic64_t is used in a fair
number of places beyond the performance counters:
block/blk-cgroup.c
drivers/acpi/apei/
drivers/block/rbd.c
drivers/crypto/nx/nx.h
drivers/gpu/drm/radeon/radeon.h
drivers/infiniband/hw/ipath/
drivers/infiniband/hw/qib/
drivers/staging/octeon/
fs/xfs/
include/linux/perf_event.h
include/net/netfilter/nf_conntrack_acct.h
kernel/events/
kernel/trace/
net/mac80211/key.h
net/rds/

The block control group, infiniband, xfs, crypto, 802.11, netfilter.
Nothing quite so fundamental as fs/namespace.c but definitely in
multiplatform-code that should work, and is already broken on those
architecutres.

Looking at the implementation of atomic64_add_return in lib/atomic64.c
the code looks as efficient as these kinds of things get.

Which leads me to the conclusion that we need atomic64 support on all
architectures.

Arch folks can you please take care of your achitectures and ensure
that atomic64_t is supported?

Eric

commit 09d4e0edd4614e787393acc582ac701c6ec3565b
Author: Paul Mackerras <paulus@samba.org>
Date:   Fri Jun 12 21:10:05 2009 +0000

    lib: Provide generic atomic64_t implementation
    
    Many processor architectures have no 64-bit atomic instructions, but
    we need atomic64_t in order to support the perf_counter subsystem.
    
    This adds an implementation of 64-bit atomic operations using hashed
    spinlocks to provide atomicity.  For each atomic operation, the address
    of the atomic64_t variable is hashed to an index into an array of 16
    spinlocks.  That spinlock is taken (with interrupts disabled) around the
    operation, which can then be coded non-atomically within the lock.
    
    On UP, all the spinlock manipulation goes away and we simply disable
    interrupts around each operation.  In fact gcc eliminates the whole
    atomic64_lock variable as well.
    
    Signed-off-by: Paul Mackerras <paulus@samba.org>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>


