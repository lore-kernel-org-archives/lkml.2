Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1IUMdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:33:23 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50730 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab1IUMdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:33:22 -0400
Date: Wed, 21 Sep 2011 14:33:13 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Han Pingtian <phan@redhat.com>, "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        edac-devel <linux-edac@vger.kernel.org>,
        Mark Grondona <mgrondona@llnl.gov>, Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH v2] Fix EDAC sdram_scrub_rate read/write failure
Message-ID: <20110921123313.GA29970@aftab>
References: <20110916105856.GA13253@hpt.nay.redhat.com>
 <20110916125326.GA1957@gere.osrc.amd.com>
 <20110919073722.GE2822@hpt.nay.redhat.com>
 <20110919142055.GF7814@aftab>
 <987664A83D2D224EAE907B061CE93D5301EAB8A5C8@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EAB8A5C8@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some more EDAC people.

On Mon, Sep 19, 2011 at 04:23:35PM -0400, Luck, Tony wrote:
> > @Tony, do you think the above makes sense? Anything against changing
> > that part of the EDAC API to say:
> 
> > Sdram memory scrubbing rate:
> 
> >     If configuration fails or memory scrubbing is not implemented,
> >	the access to that attribute from userspace will fail.
> 
> Ideally we'd not have the file there at all if memory scrubbing isn't
> implemented.

Haa, it'll be great if we could do that. But it doesn't look simple
- the whole sysfs thing comes up along the edac_mc_alloc path and
the ->[gs]et_sdram_scrub_rate func ptrs get assigned after the sysfs
hierarchy is up.

Which means, in order to fix that, we have to change it to support
dynamic sysfs assignment and change a bunch of edac drivers (probably
all, at least the couple I looked at will have to). Which is not a
very big deal but testing them would be a much more formidable task
especially if one doesn't have the hardware to test it on.

> I like having the write fail if the driver cannot set the chosen
> scrub rate ... though there seems to be some wiggle room ... scrub
> rates aren't exact, the user can try to set one and then read back
> to find out what the rate was actually rounded to. If you have to
> read back anyway, then reading back to find out if you failed doesn't
> look quite so odd (still odd, but with some sort of logic).

Agreed, I still think "fail the write" is much more intuitive than what
we have now. And I think we should change it if we're not breaking a
bunch of userspace (which I seriously doubt). Originally I thought
edac-utils might use the scrub rate thing but grepping through v0.16
sources doesn't say anything about scrub rate.

So how about the following - people should scream now if they see
problem with it and if we're breaking their userspace stuff (they should
fix them anyway though :-)

If scrub rate setting is not implemented, we say "No such device." and
otherwise on error we say "Invalid argument" which should be clear,
IMHO.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 21 Sep 2011 14:10:43 +0200
Subject: [PATCH] EDAC: Correct scrub rate API

The original scrub rate API definition states that if scrub rate
accessors are not implemented, a negative value (-1) should be written
to the sysfs file (/sys/devices/system/edac/mc/mc<N>/sdram_scrub_rate,
where N is the memory controller number on the system). This is
counter-intuitive and awkward at the very least because, when setting
the scrub rate, userspace has to write to sysfs and then read it back to
check error status of the operation.

As Tony notes, best it would be to not have the sdram_scrub_rate in
sysfs if scrub rate support is not implemented. It is too late about
that and a bunch of drivers on a bunch of arches would need to be
changed and tested which is not a trivial task ATM.

Instead, settle for the next best thing of returning -ENODEV when
implementation is missing and -EINVAL when there was an error
encountered while setting the scrub rate.

Reported-by: Han Pingtian <phan@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20110916105856.GA13253@hpt.nay.redhat.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 Documentation/edac.txt       |    4 ++--
 drivers/edac/edac_mc_sysfs.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index 249822c..fdcc49f 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -334,8 +334,8 @@ Sdram memory scrubbing rate:
 
 	Reading the file will return the actual scrubbing rate employed.
 
-	If configuration fails or memory scrubbing is not implemented, the value
-	of the attribute file will be -1.
+	If configuration fails or memory scrubbing is not implemented, accessing
+	that attribute will fail.
 
 
 
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 29ffa35..deb91fd 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -452,7 +452,7 @@ static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
 	int new_bw = 0;
 
 	if (!mci->set_sdram_scrub_rate)
-		return -EINVAL;
+		return -ENODEV;
 
 	if (strict_strtoul(data, 10, &bandwidth) < 0)
 		return -EINVAL;
@@ -475,7 +475,7 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 	int bandwidth = 0;
 
 	if (!mci->get_sdram_scrub_rate)
-		return -EINVAL;
+		return -ENODEV;
 
 	bandwidth = mci->get_sdram_scrub_rate(mci);
 	if (bandwidth < 0) {
-- 
1.7.4.rc2



-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
