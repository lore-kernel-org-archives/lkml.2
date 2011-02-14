Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981Ab1BNFij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 00:38:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56188 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1BNFih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 00:38:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WCQy3RAptCKid6n6upkEdFP8EamRpPCwtS3sgYk4jN5jVp8BAAb1gMpBVpgGee1otz
         e1s8M51zEmCVaQsGGMgvhUg+BLMWbv1iFRp3u30VylryqQC3OV6SUYDRCz2O+UST/wdt
         ZFh0jWKrjewQjX/zIJAi+KFxKqnCWtLBSLqx8=
Date: Mon, 14 Feb 2011 13:38:27 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        James Morris <jmorris@namei.org>
Subject: Re: Regression - Xorg start failed
Message-ID: <20110214053826.GA2557@darkstar.dhcp.inet.fi>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
 <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
 <AANLkTimxCMgdfht7rrg8QiCppb=D7fvR92eeiewdqCpH@mail.gmail.com>
 <20110214003531.GH9869@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214003531.GH9869@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 04:35:31PM -0800, Chris Wright wrote:
> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > On Sat, Feb 12, 2011 at 11:53 PM, Dave Airlie <airlied@gmail.com> wrote:
> > > Probably should revert first, then work out what is crapping out libpciaccess.
> > 
> > Yeah, I'll revert. The patch is one of those "obviously a good idea,
> > but in practice it's not something we can change now".
> 
> Turns out I'm just a bona fide idiot.
> 
> I was not testing the right kernel _and_ didn't get the logic right.
> 
> sorry for the screw up,
> -chris
> ---
> 
> Subject: [PATCH] pci: use security_capable correctly during config space read
> 
> Commit 47970b1 ("pci: use security_capable() when checking capablities
> during config space read") is just plain broken.  The normal capable()
> interface returns true on success, but the LSM interface returns 0 on
> success.

Chris, linus has reverted the original commit, so this does not apply.

Anyway I have tested this one, it works well. Feel free add my Tested-by line.

> 
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
> 
> I've tested this quickly (lspci behaviour is as expected).
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index f7771f3..ea25e5b 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -369,7 +369,7 @@ pci_read_config(struct file *filp, struct kobject *kobj,
>  	u8 *data = (u8*) buf;
>  
>  	/* Several chips lock up trying to read undefined config space */
> -	if (security_capable(filp->f_cred, CAP_SYS_ADMIN)) {
> +	if (security_capable(filp->f_cred, CAP_SYS_ADMIN) == 0) {
>  		size = dev->cfg_size;
>  	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
>  		size = 128;
> 
> 
