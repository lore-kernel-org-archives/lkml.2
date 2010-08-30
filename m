Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0H3Utd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 16:49:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59590 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0H3Utb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 16:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EZMk46iO7oH4ISyZ3gCzV7KM0uw4E76akoyPD3mSI/jcl4mMgfpY2MPZNRVw4hJqmk
         yPxsubvVD40bOchAdrGZ7bEW1nqeVY/P93Z/TvvE50CyA2GIxUVd3j0SY172xyujAKA7
         eoI3YqGfFqDTaHDRXfCqyqGAEAMKi2jQld0bg=
MIME-Version: 1.0
In-Reply-To: <1282936206-17288-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1282936206-17288-1-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Mon, 30 Aug 2010 13:49:29 -0700
Message-ID: <AANLkTin69t9Z4vunB4t4X6p77=QSR9m+JueCcKSm8jEL@mail.gmail.com>
Subject: Re: [PATCH] e1000e: Intel 82571EB: Don't wait for MNG cycle on
 unmanaged chips
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, Kyle Moffett <kyle@moffetthome.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 12:10 PM, Kyle Moffett
<Kyle.D.Moffett@boeing.com> wrote:
> The Intel 82571EB chipset can be used in an unmanaged configuration as a
> fast dual-port Gig-E controller.  Unfortunately a board constructed that
> way would fail to correctly come up because the driver polls for the
> completion of a management cycle that will never occur.
>
> To resolve this problem, we disable the poll and error return on chips
> whose EEPROMs indicate no management.  As a protection against
> misconfigured chipsets, we still delay for the entire management poll
> timeout.
>
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>

Hi Kyle, thanks for submitting this patch.  Are you fixing this
problem for a device that is a LOM?  The reason I ask is that most if
not all of our current eeprom images require some firmware interaction
to correctly initialize the PHY when the part is reset, even for the
no_mng (no managability) case.

Your code below will avoid reading of and waiting for the cfg_done
bit, which means that the firmware could end up racing with the
driver, with them both trying to configure the part.

Was there a specific bug you were trying to fix, and can you reply (if
you want to me in private) with your ethtool -e ethX output?

The concern here is that you may simply have an out of date eeprom
image, which might fix the original issue and get the driver to work
correctly, as the behavior you are describing is not how it should
work according to our design.

At the very least we would like to reproduce your issue here so we can
investigate further.

Jesse
