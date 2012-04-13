Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2DMRm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:42:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45798 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2DMRmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:42:25 -0400
Date: Fri, 13 Apr 2012 10:42:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anthony Foiani <tkil@scrye.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shengzhou Liu <Shengzhou.Liu@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [ 011/108] powerpc/usb: fix bug of kernel hang when initializing
 usb
Message-ID: <20120413174219.GA4078@kroah.com>
References: <20120330195723.719813895@linuxfoundation.org>
 <gpqbc8avn.fsf@dworkin.scrye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gpqbc8avn.fsf@dworkin.scrye.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 11:21:48PM -0600, Anthony Foiani wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Shengzhou Liu <Shengzhou.Liu@freescale.com>
> >
> > commit 28c56ea1431421dec51b7b229369e991481453df upstream.
> >
> > If USB UTMI PHY is not enable, writing to portsc register will lead to
> > kernel hang during boot up.
> 
> I apologize for the late response, but I was encountering this same
> hang (on an 8315) and applied this patch.  (For what it's worth, I'm
> only seeing it after many warm boots; a cold boot / hard power cycle
> solves the issue, but since this is eventually going to be locked up
> in a box without a console...)
> 
> I encountered the hang again this evening, so this fix (plus the snoop
> fix) is not sufficientl
> 
> Reading through the original thread, it seems that an additional delay
> might be required:
> 
>    http://article.gmane.org/gmane.linux.usb.general/58795
> 
>    > First, the SDK kernel had a delay after setting that bit, I added
>    > that back in. This is not what fixed it but it looks like the
>    > right thing to do, though please, use msleep rather than udelay
>    > here if possible (not in atomic context).
> 
> However, I never saw a patch to that effect.  I'm assuming (hoping!)
> it's something as simple as:
> 
> ------------------------------------------------------------------------
> diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
> index 09fd214..d58c1c6 100644
> --- a/drivers/usb/host/ehci-fsl.c
> +++ b/drivers/usb/host/ehci-fsl.c
> @@ -236,6 +236,7 @@ static void ehci_fsl_setup_phy(struct ehci_hcd *ehci,
> 	case FSL_USB2_PHY_UTMI:
> 		/* enable UTMI PHY */
> 		setbits32(non_ehci + FSL_SOC_USB_CTRL, CTRL_UTMI_PHY_EN);
> +		msleep(5);
> 		portsc |= PORT_PTS_UTMI;
> 		break;
> 	case FSL_USB2_PHY_NONE:
> ------------------------------------------------------------------------
> 
> But confirmation would be nice.  Also, which SDK kernel was this
> compared against?  I just downloaded the 8315ERDB BSP, and the kernel
> there doesn't seem to have any of this in it.
> 
> There was also the follow-on patch that enabled snooping (to deal with
> cache coherency?):
> 
>    http://article.gmane.org/gmane.linux.usb.general/58798
> 
> (If there was a formal patch there, it looks like it got scrambled on
> gmane, and I can't find another list archive.)
> 
> Is that also needed for consistent results here?  (Or are we wandering
> astray from "-stable" material?)

Yes you are, any patch for the stable tree needs to be in Linus's tree
already.  Please work with the original developers of this patch to
resolve the issue, get the patch merged, and then I can take it for a
stable release.

thanks,

greg k-h
