Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab0DVUWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:22:54 -0400
Received: from kroah.org ([198.145.64.141]:59684 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757771Ab0DVUAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:20 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:10 2010
Message-Id: <20100422195410.292391759@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
Subject: [054/139] x86, hpet: Erratum workaround for read after write of HPET comparator
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>

commit 8da854cb02156c90028233ae1e85ce46a1d3f82c upstream.

On Wed, Feb 24, 2010 at 03:37:04PM -0800, Justin Piszcz wrote:
> Hello,
>
> Again, on the Intel DP55KG board:
>
> # uname -a
> Linux host 2.6.33 #1 SMP Wed Feb 24 18:31:00 EST 2010 x86_64 GNU/Linux
>
> [    1.237600] ------------[ cut here ]------------
> [    1.237890] WARNING: at arch/x86/kernel/hpet.c:404 hpet_next_event+0x70/0x80()
> [    1.238221] Hardware name:
> [    1.238504] hpet: compare register read back failed.
> [    1.238793] Modules linked in:
> [    1.239315] Pid: 0, comm: swapper Not tainted 2.6.33 #1
> [    1.239605] Call Trace:
> [    1.239886]  <IRQ>  [<ffffffff81056c13>] ? warn_slowpath_common+0x73/0xb0
> [    1.240409]  [<ffffffff81079608>] ? tick_dev_program_event+0x38/0xc0
> [    1.240699]  [<ffffffff81056cb0>] ? warn_slowpath_fmt+0x40/0x50
> [    1.240992]  [<ffffffff81079608>] ? tick_dev_program_event+0x38/0xc0
> [    1.241281]  [<ffffffff81041ad0>] ? hpet_next_event+0x70/0x80
> [    1.241573]  [<ffffffff81079608>] ? tick_dev_program_event+0x38/0xc0
> [    1.241859]  [<ffffffff81078e32>] ? tick_handle_oneshot_broadcast+0xe2/0x100
> [    1.246533]  [<ffffffff8102a67a>] ? timer_interrupt+0x1a/0x30
> [    1.246826]  [<ffffffff81085499>] ? handle_IRQ_event+0x39/0xd0
> [    1.247118]  [<ffffffff81087368>] ? handle_edge_irq+0xb8/0x160
> [    1.247407]  [<ffffffff81029f55>] ? handle_irq+0x15/0x20
> [    1.247689]  [<ffffffff810294a2>] ? do_IRQ+0x62/0xe0
> [    1.247976]  [<ffffffff8146be53>] ? ret_from_intr+0x0/0xa
> [    1.248262]  <EOI>  [<ffffffff8102f277>] ? mwait_idle+0x57/0x80
> [    1.248796]  [<ffffffff8102645c>] ? cpu_idle+0x5c/0xb0
> [    1.249080] ---[ end trace db7f668fb6fef4e1 ]---
>
> Is this something Intel has to fix or is it a bug in the kernel?

This is a chipset erratum.

Thomas: You mentioned we can retain this check only for known-buggy and
hpet debug kind of options. But here is the simple workaround patch for
this particular erratum.

Some chipsets have a erratum due to which read immediately following a
write of HPET comparator returns old comparator value instead of most
recently written value.

Erratum 15 in
"Intel I/O Controller Hub 9 (ICH9) Family Specification Update"
(http://www.intel.com/assets/pdf/specupdate/316973.pdf)

Workaround for the errata is to read the comparator twice if the first
one fails.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <20100225185348.GA9674@linux-os.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -399,9 +399,15 @@ static int hpet_next_event(unsigned long
 	 * then we might have a real hardware problem. We can not do
 	 * much about it here, but at least alert the user/admin with
 	 * a prominent warning.
+	 * An erratum on some chipsets (ICH9,..), results in comparator read
+	 * immediately following a write returning old value. Workaround
+	 * for this is to read this value second time, when first
+	 * read returns old value.
 	 */
-	WARN_ONCE(hpet_readl(HPET_Tn_CMP(timer)) != cnt,
+	if (unlikely((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt)) {
+		WARN_ONCE(hpet_readl(HPET_Tn_CMP(timer)) != cnt,
 		  KERN_WARNING "hpet: compare register read back failed.\n");
+	}
 
 	return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }


