Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1ISHgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 03:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab1ISHgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 03:36:37 -0400
Date: Mon, 19 Sep 2011 15:37:22 +0800
From: Han Pingtian <phan@redhat.com>
To: Borislav Petkov <bp@amd64.org>
Cc: mchehab@redhat.com, linux-kernel@vger.kernel.org,
        edac-devel <linux-edac@vger.kernel.org>
Subject: Re: [PATCH v2] Fix EDAC sdram_scrub_rate read/write failure
Message-ID: <20110919073722.GE2822@hpt.nay.redhat.com>
Mail-Followup-To: Borislav Petkov <bp@amd64.org>, mchehab@redhat.com,
	linux-kernel@vger.kernel.org,
	edac-devel <linux-edac@vger.kernel.org>
References: <20110916105856.GA13253@hpt.nay.redhat.com>
 <20110916125326.GA1957@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110916125326.GA1957@gere.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Sep 16, 2011 at 02:53:27PM +0200, Borislav Petkov wrote:
> On Fri, Sep 16, 2011 at 06:58:56PM +0800, Han Pingtian wrote:
> > If sdram scrubbing rate ins't implemented on current system, read it
> > will cause an error:
> > 
> > cat: /sys/devices/system/edac/mc//mc0/sdram_scrub_rate: Invalid argument
> > 
> > The eba042a81edd6baaff44831b2d719b14a6d21e58 let it returning -EINVAL,
> 
> Can you please add the patch author to CC next time, out of courtesy?
Will do next time. Thanks.
> Thanks.
> 
> > but according to the document, it should show -1:
> > 
> > dram memory scrubbing rate:
> > 
> >         'sdram_scrub_rate'
> > 
> >         Read/Write attribute file that controls memory scrubbing. The scrubbing
> >         rate is set by writing a minimum bandwidth in bytes/sec to the attribute
> >         file. The rate will be translated to an internal value that gives at
> >         least the specified rate.
> > 
> >         Reading the file will return the actual scrubbing rate employed.
> > 
> >         If configuration fails or memory scrubbing is not implemented, the value
> >         of the attribute file will be -1.
> > 
> > Signed-off-by: Han Pingtian <phan@redhat.com>
> > ---
> >  drivers/edac/edac_mc_sysfs.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> > index 29ffa35..602fdcf 100644
> > --- a/drivers/edac/edac_mc_sysfs.c
> > +++ b/drivers/edac/edac_mc_sysfs.c
> > @@ -475,7 +475,7 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
> >  	int bandwidth = 0;
> >  
> >  	if (!mci->get_sdram_scrub_rate)
> > -		return -EINVAL;
> > +		return sprintf(date, "%d\n", -1);
> 
> Have you even build-tested your patch:
> 
> drivers/edac/edac_mc_sysfs.c: In function ‘mci_sdram_scrub_rate_show’:
> drivers/edac/edac_mc_sysfs.c:478: error: ‘date’ undeclared (first use in this function)
> drivers/edac/edac_mc_sysfs.c:478: error: (Each undeclared identifier is reported only once
> drivers/edac/edac_mc_sysfs.c:478: error: for each function it appears in.)
> make[2]: *** [drivers/edac/edac_mc_sysfs.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [drivers/edac] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2
> make: *** Waiting for unfinished jobs....
> 
> >  
> >  	bandwidth = mci->get_sdram_scrub_rate(mci);
> >  	if (bandwidth < 0) {
> 
> Anyway, the EDAC document says that sdram_scrub_rate is
> read/write and when writing you have to write -1 too. Care to fix
Cannot figure out how to write -1 here. Since the document just says the
value will be -1 when configuration fails or memory scrubbing is not
implemented, I think we can do nothing when setting the vaule if
scrubbing not implemented and just make sure showing will return -1.
> mci_sdram_scrub_rate_store too, test your patch properly and resend?

Thanks your review. I have tested the new patch attached. Please have a
look. 

Thanks.
-- 
Han Pingtian
Quality Engineer
hpt @ #kernel-qe
Red Hat, Inc
Freedom ... courage ... Commitment ... ACCOUNTABILITY

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Fix-EDAC-sdram_scrub_rate-read-write-failure.patch"

>From a77c8db0797f8c6b3e1ac30f8da0b7f2d9c10dbe Mon Sep 17 00:00:00 2001
From: Han Pingtian <phan@redhat.com>
Date: Fri, 16 Sep 2011 18:43:20 +0800
Subject: [PATCH] Fix EDAC sdram_scrub_rate read/write failure

If sdram scrubbing rate isn't implemented on current system, read/write it
will cause an error:

]# cat /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
cat: /sys/devices/system/edac/mc/mc0/sdram_scrub_rate: Invalid argument

]# echo 1 > /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
-bash: echo: write error: Invalid argument

The eba042a81edd6baaff44831b2d719b14a6d21e58 let it returning -EINVAL,
but according to the document, the value should be -1, so there
shouldn't be a failure.

Sdram memory scrubbing rate:

        'sdram_scrub_rate'

        Read/Write attribute file that controls memory scrubbing. The scrubbing
        rate is set by writing a minimum bandwidth in bytes/sec to the attribute
        file. The rate will be translated to an internal value that gives at
        least the specified rate.

        Reading the file will return the actual scrubbing rate employed.

        If configuration fails or memory scrubbing is not implemented, the value
        of the attribute file will be -1.

Signed-off-by: Han Pingtian <phan@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 29ffa35..dae14cf 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -451,8 +451,11 @@ static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
 	unsigned long bandwidth = 0;
 	int new_bw = 0;
 
-	if (!mci->set_sdram_scrub_rate)
-		return -EINVAL;
+	if (!mci->set_sdram_scrub_rate) {
+		edac_printk(KERN_WARNING, EDAC_MC,
+			"Memory scrub rate writing is not implemented\n");
+		return count;
+	}
 
 	if (strict_strtoul(data, 10, &bandwidth) < 0)
 		return -EINVAL;
@@ -474,8 +477,11 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 {
 	int bandwidth = 0;
 
-	if (!mci->get_sdram_scrub_rate)
-		return -EINVAL;
+	if (!mci->get_sdram_scrub_rate) {
+		edac_printk(KERN_WARNING, EDAC_MC,
+			"Memory scrub rate reading not implemented\n");
+		return sprintf(data, "%d\n", -1);
+	}
 
 	bandwidth = mci->get_sdram_scrub_rate(mci);
 	if (bandwidth < 0) {
-- 
1.7.1


--d6Gm4EdcadzBjdND--
