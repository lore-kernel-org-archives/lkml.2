Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1IZX32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 19:29:28 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:56574 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1IZX31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 19:29:27 -0400
Date: Mon, 26 Sep 2011 19:29:06 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110926232906.GB13175@flamenco.cs.columbia.edu>
References: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
 <1317029238-13357-3-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317029238-13357-3-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 11:27:16 +0200, Manohar Vanga wrote:
(snip)
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 76e08f3..9cb6938 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1317,6 +1317,7 @@ static int vme_add_bus(struct vme_bridge *bridge)
>  		if ((vme_bus_numbers & (1 << i)) == 0) {
>  			vme_bus_numbers |= (1 << i);
>  			bridge->num = i;
> +			INIT_LIST_HEAD(&bridge->devices);
>  			list_add_tail(&bridge->bus_list, &vme_bus_list);

Just realised that vme_buses_lock also protects vme_bus_list; appending
to this list here should be protected by the mutex, otherwise
vme_add_bus (ie this function) could race with __vme_register_driver,
which might access a corrupt copy of the list.

Note that vme_remove_bus does the right thing though; it acquires
the lock before unpinning the bridge from vme_bus_list.

		Emilio

