Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0DTUwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:52:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab0DTUwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:52:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=LYza2YBLdqFuK9MiyLSaZURub1m8IDmxsYBi3yVjUjYqCoI9XkRiWwx1i9dLIw9xZ
	KDlQ7eX79JbZByhISZIMA==
MIME-Version: 1.0
In-Reply-To: <g2ida824cf31004141843p41f7b21fz25927e3c6faeeed7@mail.gmail.com>
References: <g2ida824cf31004141843p41f7b21fz25927e3c6faeeed7@mail.gmail.com>
Date: Tue, 20 Apr 2010 13:52:21 -0700
Message-ID: <l2jda824cf31004201352y5fcdfa40g2ecb5dbb1706bf88@mail.gmail.com>
Subject: Re: [PATCH] 2.6.34-rc3 v2 Disable R_OK (Early ACK) on SII 3726 PMP
From: Grant Grundler <grundler@google.com>
To: Linux IDE mailing list <linux-ide@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping? Can this patch please be applied?

I was assuming this will show up here:
   http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=shortlog;h=refs/heads/upstream-linus

thanks,
grant

On Wed, Apr 14, 2010 at 6:43 PM, Grant Grundler <grundler@google.com> wrote:
> In 2009, While running "cache read" performance test of drives behind
> SII PMP we encountered a "all 5 drives" timeout on more than 30% of the
> machines under test.  This patch reduces the rate by a factor of about 70.
> Low enough that we didn't care to further investigate the issue.
>
> Performance impact with any sort of "normal" use was ~2%+ CPU and less
> than 1% throughput degradation.  Worst case impact (cached read) was
> 6% IOPS reduction. This is with NCQ off (q=1) but I believe FIS based
> switching enabled in the SATA driver.
>
> The patch disables "Early ACK" in the 3726 port multiplier.
> "Early ACK" is issued when device sends a FIS to the host (via PMP)
> and the PMP sends an ACK immediately back to the device - well before
> the host gets the response. Under worst case IOPs load (cached read
> test) and more than 2 PMPs connected to a 4-port SATA controller,
> I suspect the time to service all of the PMPs is exceeding the PMPs
> ability to keep track of outstanding FIS it owes the Host. Reducing
> the number of PMPs to 2 (or 1) reduces the frequency by several orders
> of magnitude. Kudos to Gwendal for initial debugging of this issue.
> [Any errors in the description are mine, not his.]
>
> Patch is currently in production on Google servers.
>
> Signed-off-by: Grant Grundler <grundler@google.com>
> Signed-off-by: Gwendal Grignou <gwendal@google.com>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> ---
>
> v2: dropped references to 4726 since I didn't test 4726,
>    moved register definition directly into libata-pmp.c, and
>    expanded the comment in the code to summarize the above description.
>
> Code below is white space mangled. Please use attached file.
>
> diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
> index 00305f4..487227a 100644
> --- a/drivers/ata/libata-pmp.c
> +++ b/drivers/ata/libata-pmp.c
> @@ -231,10 +231,14 @@ static const char *sata_pmp_spec_rev_str(const u32 *gscr)
>        return "<unknown>";
>  }
>
> +#define PMP_GSCR_SII_POL 129
> +
>  static int sata_pmp_configure(struct ata_device *dev, int print_info)
>  {
>        struct ata_port *ap = dev->link->ap;
>        u32 *gscr = dev->gscr;
> +       u16 vendor = sata_pmp_gscr_vendor(gscr);
> +       u16 devid = sata_pmp_gscr_devid(gscr);
>        unsigned int err_mask = 0;
>        const char *reason;
>        int nr_ports, rc;
> @@ -260,12 +264,34 @@ static int sata_pmp_configure(struct ata_device
> *dev, int print_info)
>                goto fail;
>        }
>
> +       /* Disable sending Early R_OK.
> +        * With "cached read" HDD testing and multiple ports busy on a SATA
> +        * host controller, 3726 PMP will very rarely drop a deferred
> +        * R_OK that was intended for the host. Symptom will be all
> +        * 5 drives under test will timeout, get reset, and recover.
> +        */
> +       if (vendor == 0x1095 && devid == 0x3726) {
> +               u32 reg;
> +
> +               err_mask = sata_pmp_read(&ap->link, PMP_GSCR_SII_POL, &reg);
> +               if (err_mask) {
> +                       rc = -EIO;
> +                       reason = "failed to read Sil3726 Private Register";
> +                       goto fail;
> +               }
> +               reg &= ~0x1;
> +               err_mask = sata_pmp_write(&ap->link, PMP_GSCR_SII_POL, reg);
> +               if (err_mask) {
> +                       rc = -EIO;
> +                       reason = "failed to write Sil3726 Private Register";
> +                       goto fail;
> +               }
> +       }
> +
>        if (print_info) {
>                ata_dev_printk(dev, KERN_INFO, "Port Multiplier %s, "
>                               "0x%04x:0x%04x r%d, %d ports, feat 0x%x/0x%x\n",
> -                              sata_pmp_spec_rev_str(gscr),
> -                              sata_pmp_gscr_vendor(gscr),
> -                              sata_pmp_gscr_devid(gscr),
> +                              sata_pmp_spec_rev_str(gscr), vendor, devid,
>                               sata_pmp_gscr_rev(gscr),
>                               nr_ports, gscr[SATA_PMP_GSCR_FEAT_EN],
>                               gscr[SATA_PMP_GSCR_FEAT]);
>
