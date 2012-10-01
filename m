Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab2JARjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:39:13 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:35750 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab2JARjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:39:12 -0400
Date: Mon, 1 Oct 2012 11:39:08 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Peter.Huewe@infineon.com, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] TPM: Issue TPM_STARTUP at driver load if
 the TPM has not been started
Message-ID: <20121001173908.GA22342@obsidianresearch.com>
References: <20120930233012.GH30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121001161536.GC31620@obsidianresearch.com>
 <20121001171003.GA1117@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001171003.GA1117@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 12:10:03PM -0500, Kent Yoder wrote:

> > I'm not familiar enough with how the power management flow works with
> > the TPM to do this. I don't think that can be the general case
> > because:
> > 
> > 3. If stType = TPM_ST_STATE
> >   a. If the TPM has no state to restore, the TPM MUST set the internal
> >      state such that it returns TPM_FAILEDSELFTEST to all subsequent
> >      commands.
> > 
> > So you need to know a save state exists in the TPM before attempting
> > the command?
> 
>  Presumably we'd have called TPM_SaveState on suspend. It might be
> possible to set a flag based on whether we needed to call startup at
> init time that tells the driver to call save/restore state during
> suspend/resume.

Curiously the current code does call TPM_SaveState on suspend, but
relies on the BIOS to do TPM_Startup(ST_STATE) on resume, why the
asymmetry?

Anyhow, I think the thing would be something like this. I have no
means to test TPM suspend, so I'll just post this as a note here. It
will apply over v2 of my patch.

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index b13ad77..7a8136a 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1336,10 +1336,23 @@ EXPORT_SYMBOL_GPL(tpm_pm_suspend);
 int tpm_pm_resume(struct device *dev)
 {
        struct tpm_chip *chip = dev_get_drvdata(dev);
+       struct tpm_cmd_t tpm_cmd;
 
        if (chip == NULL)
                return -ENODEV;
 
+       tpm_cmd.header.in = tpm_getcap_header;
+       tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
+       tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
+       tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
+       rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0);
+       if (rc == TPM_ERR_INVALID_POSTINIT) {
+               /* The BIOS did not restart the TPM, execute a startup
+                  command. */
+               dev_info(chip->dev, "Issuing TPM_STARTUP");
+               tpm_startup(chip, TPM_ST_STATE);
+       }
+
        return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_resume);

Jason
