Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0L2NRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 08:17:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0L2NR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 08:17:28 -0500
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] tg3: fix return value check in tg3_read_vpd()
Date: Wed, 29 Dec 2010 14:17:22 +0100
User-Agent: KMail/1.9.10
Cc: mcarlson@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Chan <mchan@broadcom.com>
References: <1293471094-28976-1-git-send-email-dsterba@suse.cz> <20101227201927.GA6365@bicker>
In-Reply-To: <20101227201927.GA6365@bicker>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201012291417.24424.dsterba@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 27 December 2010 21:19:27 Dan Carpenter wrote:
> Your fix is obviously correct, but could you describe the symptoms
> in your changelog instead of leaving it blank?  In the original code,
> negative error values are ignored so we never goto out_not_found.  Can
> pci_read_vpd() return any errors we care about besides -ENODEV?  What I
> mean is, did you find this through analysing the code or did it cause a
> bug at runtime?

Although pci_read_vpd returns ENODEV directly, there is a call to vpd->read
function which may return other error values and is eg. set to
pci_vpd_pci22_read() :

drivers/pci/access.c::pci_vpd_pci22_read()
  may return -EINVAL or -EINTR directly
  or -ETIMEDOUT or -EINTR via pci_vpd_pci22_wait()

Yes, other negative values besides ETIMEDOUT and EINTR are ignored and after
3 attempts the pos != TG3_NVM_VPD_LEN check goes outwards. The fixed version
allows to jump out immediately. So this does not manifest itself as a 
misbehaviour at runtime. It was found by code analysis.

I'll post updated patch.

dave
