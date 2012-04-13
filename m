Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2DMFbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 01:31:07 -0400
Received: from scrye.com ([75.148.32.185]:36037 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2DMFbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 01:31:04 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2012 01:31:04 EDT
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shengzhou Liu <Shengzhou.Liu@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [ 011/108] powerpc/usb: fix bug of kernel hang when initializing usb
From: Anthony Foiani <tkil@scrye.com>
Reply-To: Anthony Foiani <tkil@scrye.com>
X-Attribution: Tony
References: <20120330195723.719813895@linuxfoundation.org>
Date: Thu, 12 Apr 2012 23:21:48 -0600
In-Reply-To: <20120330195723.719813895@linuxfoundation.org> (Greg KH's message of "Fri, 30 Mar 2012 12:57:33 -0700")
Message-ID: <gpqbc8avn.fsf@dworkin.scrye.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b31 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> 3.0-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Shengzhou Liu <Shengzhou.Liu@freescale.com>
>
> commit 28c56ea1431421dec51b7b229369e991481453df upstream.
>
> If USB UTMI PHY is not enable, writing to portsc register will lead to
> kernel hang during boot up.

I apologize for the late response, but I was encountering this same
hang (on an 8315) and applied this patch.  (For what it's worth, I'm
only seeing it after many warm boots; a cold boot / hard power cycle
solves the issue, but since this is eventually going to be locked up
in a box without a console...)

I encountered the hang again this evening, so this fix (plus the snoop
fix) is not sufficientl

Reading through the original thread, it seems that an additional delay
might be required:

   http://article.gmane.org/gmane.linux.usb.general/58795

   > First, the SDK kernel had a delay after setting that bit, I added
   > that back in. This is not what fixed it but it looks like the
   > right thing to do, though please, use msleep rather than udelay
   > here if possible (not in atomic context).

However, I never saw a patch to that effect.  I'm assuming (hoping!)
it's something as simple as:

------------------------------------------------------------------------
diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index 09fd214..d58c1c6 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -236,6 +236,7 @@ static void ehci_fsl_setup_phy(struct ehci_hcd *ehci,
	case FSL_USB2_PHY_UTMI:
		/* enable UTMI PHY */
		setbits32(non_ehci + FSL_SOC_USB_CTRL, CTRL_UTMI_PHY_EN);
+		msleep(5);
		portsc |= PORT_PTS_UTMI;
		break;
	case FSL_USB2_PHY_NONE:
------------------------------------------------------------------------

But confirmation would be nice.  Also, which SDK kernel was this
compared against?  I just downloaded the 8315ERDB BSP, and the kernel
there doesn't seem to have any of this in it.

There was also the follow-on patch that enabled snooping (to deal with
cache coherency?):

   http://article.gmane.org/gmane.linux.usb.general/58798

(If there was a formal patch there, it looks like it got scrambled on
gmane, and I can't find another list archive.)

Is that also needed for consistent results here?  (Or are we wandering
astray from "-stable" material?)

Thanks,
Tony.
