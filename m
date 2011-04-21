Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1DUNpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:45:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40827 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1DUNpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eHMGybbJwMV4pyuLKIkAtBb5c9GJxPWezjFyLJC6NCsQ3Rk+KigMHslvt/cKH0Qiy4
         4c6XuPwM+WPiZqX0zl71tLe0TxldiUmykVE740dO/Dk1JONusl/suWR5+3o7dLV0nMp0
         gjnAIRjG0A1XLre7bz4zdh3aAZbSBAyDPoW7Q=
Date: Thu, 21 Apr 2011 15:40:54 +0200
From: Tejun Heo <htejun@gmail.com>
To: Jian Peng <jipeng2005@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] libata: ahci_start_engine compliant to AHCI spec
Message-ID: <20110421134054.GE31724@htj.dyndns.org>
References: <1303249499-11557-1-git-send-email-jipeng2005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303249499-11557-1-git-send-email-jipeng2005@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 02:44:59PM -0700, Jian Peng wrote:
> At the end of section 10.1 of AHCI spec (rev 1.3), it states
> 
> Software shall not set PxCMD.ST to 1 until it is determined that a
> functoinal device is present on the port as determined by
> PxTFD.STS.BSY=0, PxTFD.STS.DRQ=0 and PxSSTS.DET=3h
> 
> Even though most AHCI host controller works without this additional
> check, specific controller will fail without this.
> 
> Signed-off-by: Jian Peng <jipeng2005@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

But some nitpicks below.

> +	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;

It usually isn't customary to initialize variable with a statement
which has side effect, especially hardware access.  Please make the
readl a separate statement.

> +	if (status & (ATA_BUSY | ATA_DRQ) ||
> +	    ahci_scr_read(&ap->link, SCR_STATUS, &tmp) ||

Also, ahci_scr_read() is known not to fail on host port in ahci and
it's customary to skip error return in such cases in low level
drivers.

> +	    (tmp & 0x0f) != 0x03)
> +		return;

And please add comment explaining what condition is being checked.
It's much easier to read comment than digging through changelog and
find out what the code is trying to achieve.

Thanks.

-- 
tejun
