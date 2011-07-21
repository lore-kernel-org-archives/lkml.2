Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1GURNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:13:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34925 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1GURNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:13:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110721084917.GE3455@htj.dyndns.org>
References: <CAN8TOE9CCSiS2koyx=UsZj=9KwaWZW5yDjUUqgJf2=qZU70k1w@mail.gmail.com>
	<20110713131407.GN2872@htj.dyndns.org>
	<CAN8TOE9Rjujf9aLQGONDULNasFiQmVkiUPWUDX=Vf0Nx2pka7w@mail.gmail.com>
	<20110721084917.GE3455@htj.dyndns.org>
Date: Thu, 21 Jul 2011 10:13:16 -0700
Message-ID: <CAN8TOE_dCg6Wi_trE97hXjBPnZi4jpLyoeUEVrbMpgDH-BwKWA@mail.gmail.com>
Subject: Re: ahci_start_engine compliance with AHCI spec
From: Brian Norris <computersforpeace@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>,
        linux-kernel@vger.kernel.org, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 1:49 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Jul 18, 2011 at 11:40:17AM -0700, Brian Norris wrote:
>> On Wed, Jul 13, 2011 at 6:14 AM, Tejun Heo <tj@kernel.org> wrote:
>> > Hmmm... what happens if you don't comment out ahci_start_engine() call
>> > from ahci_start_port()?
>>
>> I wasn't commenting out the ahci_start_engine() from
>> ahci_start_port(). Can you clarify what you mean?
>
> Oh, I meant "what if you comment out..."  I wrote that sentence in
> negative and then switched but forgot removing "don't".

OK, well I tried simply commenting out that ahci_start_engine() on
both my special controller and on the Dell E6410 laptop and it worked
just fine (solved my issues and didn't cause any issues on the Dell).
Is this safe? It seems like we end up calling ahci_start_engine() at
the end of the error handling process anyway, so maybe this call is
not really necessary in the first place?

Anyway, I also tried my own fix for this: adding a small delay to wait
for some link recognition at the end of ahci_power_up(). I'm not sure
if this is the greatest, but it also works for both systems I'm
testing. I included the test patch here (based on linux-2.6). BTW, I'm
not sure my mail will be formatted perfectly here. I can resend with
my other mailer if needed.

>> > Is this the same IP block that Jian Peng was using?
>>
>> Yes, it is. I'm taking over some of his work.
>
> Is there any way to detect that particular IP block.  It's the only
> one with this problem so maybe we just should treat it specially.

I'm not sure how easy it would be to detect this particular version.
Besides, that is not our first choice solution, as our special-case
fix would not be very well tested for logic bugs.

Brian

---
 drivers/ata/libahci.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 41223c7..0c0c444 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -657,6 +657,19 @@ static void ahci_power_up(struct ata_port *ap)

        /* wake up link */
        writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
+
+       /*
+        * Wait for PxSSTS.DET == 1h or 3h, step 5 of 10.1.1 in
+        * AHCI 1.3 spec. See 10.10.2 for spin-up procedure.
+        */
+       if (ata_wait_register(ap, port_mmio + ahci_scr_offset(ap, SCR_STATUS),
+                               0x01, 0x00, 1, 10)) {
+               /* also wait for DRQ to be cleared */
+               ata_wait_register(ap, port_mmio + PORT_TFDATA, ATA_DRQ,
+                               ATA_DRQ, 1, 10);
+
+               /* proceed with step 6, 7 of 10.1.1 in AHCI 1.3 spec? */
+       }
 }

 static int ahci_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
