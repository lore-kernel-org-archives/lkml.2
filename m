Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab1A1R7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:59:23 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:40556
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373Ab1A1R7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:59:20 -0500
X-SpamScore: -16
X-BigFish: VPS-16(z6c9Mz1432N98dNzz1202hzzz32i637h668h34h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LFQVAL-02-90T-02
X-M-MSG: 
Date: Fri, 28 Jan 2011 18:59:10 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Manoj Iyer <manoj.iyer@canonical.com>,
        "James C. Georgas" <james.georgas@yahoo.ca>
CC: Borislav Petkov <bp@amd64.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110128175910.GB4599@alberich.amd.com>
References: <20110113185807.GA24720@srcf.ucam.org>
 <20110113190700.GB30866@kryptos.osrc.amd.com>
 <alpine.LFD.2.00.1101132012140.2678@localhost6.localdomain6>
 <20110113192825.GC30866@kryptos.osrc.amd.com>
 <alpine.LFD.2.00.1101132032350.2678@localhost6.localdomain6>
 <20110113210950.GA4081@aftab>
 <alpine.LFD.2.00.1101132210351.2678@localhost6.localdomain6>
 <20110113214841.GC4081@aftab>
 <alpine.LFD.2.00.1101132353210.2678@localhost6.localdomain6>
 <AANLkTik7DgsmFv1KN6r92jai-Git5G9+kQLF9J0u=6e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <AANLkTik7DgsmFv1KN6r92jai-Git5G9+kQLF9J0u=6e0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l76fUT7nc3MelDdI
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 14, 2011 at 02:55:30PM -0500, Manoj Iyer wrote:
> Borislav,
>=20
> Any more thoughts on this one ?

Seems that we've identified the root cause.

I wondered why systems with the problem have configured IOAPIC pin
with polarity=3D1 (low active).  That was different to what the working
systems used.

Switching the configuration to the usual polarity=3D0 (high active)
fixed the issue.

The explanation is that when hpet interrupt is triggerd, signal goes
from low to high. (AFAIK HPET spec even mentions that HPET interrupts
are all active high.)

Now if IO-APIC pin is configured as low active it just ignores this
signal change. It just triggers later when for next interrupt signal
will go from high to low and high again. (That happens the first time
after resume when the HPET counter wrapped around.)=20

Setting the correct polarity fixes the detection of the first hpet
interrupt after resume.

To confirm that your systems behave similar you should boot with
"apic=3Ddebug" kernel parameter. The output for IO APIC should show
polarity=3D1 for IO APIC pin 2, e.g.

  [    0.158179] IO APIC #2......
   ...
  [    0.158205]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
  [    0.158210]  00 000 1    0    0   0   0    0    0    00
  [    0.158217]  01 003 0    0    0   0   0    1    1    31
  [    0.158224]  02 003 0    0    0   1   0    1    1    30

Furthermore you can check with attached test patch whether changing
the polarity fixes the problem on your system. IO APIC debug output
with this patch should change to

  [    0.156170] IO APIC #2......
   ...
  [    0.156197]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
  [    0.156202]  00 000 1    0    0   0   0    0    0    00
  [    0.156209]  01 003 0    0    0   0   0    1    1    31
  [    0.156216]  02 003 0    0    0   0   0    1    1    30


I'll come up with an SB800 quirk asap. (Of course we'll also try to
fix the respective BIOSes but too often BIOS updates are only
available for a limited time period.)


Regards,

Andreas

--=20
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. M=FCnchen, Germany
 Research | Gesch=E4ftsf=FChrer: Alberto Bozzo, Andrew Bowd
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis M=FCnchen
  (OSRC)  | Registergericht M=FCnchen, HRB Nr. 43632

--l76fUT7nc3MelDdI
Content-Type: text/plain; charset="us-ascii"; name="polarity-fix.diff"
Content-Disposition: attachment; filename="polarity-fix.diff"
Content-Description: polarity-fix.diff

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 697dc34..9bf2b87 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1365,6 +1365,10 @@ static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
 		    apic_id, mp_ioapics[apic_id].apicid, pin, cfg->vector,
 		    irq, trigger, polarity);
 
+	if (pin == 2) {
+		polarity = 0;
+		trigger = 0;
+	}
 
 	if (setup_ioapic_entry(mp_ioapics[apic_id].apicid, irq, &entry,
 			       dest, trigger, polarity, cfg->vector, pin)) {

--l76fUT7nc3MelDdI--
