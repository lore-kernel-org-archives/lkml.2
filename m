Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab1CHAS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 19:18:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:44355 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab1CHAS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 19:18:26 -0500
Subject: Re: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
From: James Bottomley <James.Bottomley@suse.de>
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: Mariusz Kozlowski <mk@lab.zgora.pl>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
In-Reply-To: <1299542075.5232.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
	 <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
	 <20110307201610.GA9032@mako-laptop>
	 <1299542075.5232.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 18:18:17 -0600
Message-ID: <1299543497.15955.108.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 15:54 -0800, Bhanu Gollapudi wrote:
> On Mon, 2011-03-07 at 12:16 -0800, Mariusz Kozlowski wrote: 
> > On Wed, Mar 02, 2011 at 11:10:03PM +0100, Mariusz Kozlowski wrote:
> > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencing pointer to incomplete type
> > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: ‘MODULE_STATE_LIVE’ undeclared (first use in this function)
> > 
> > Hm. Still there in next-20110307. Is this patch wrong or..?
> > 
> 
> James,
> 
> Here is my ack for this patch.

OK, so the patch is actually wrong because adding #ifdefs on modules in
files really impedes readability.  The bug is using a direct deref on
module state instead of one of the APIs which work in the non-modular
case, namely try_module_get(). That means the other two need to come out
and be reworked (plus all the others in fcoe).

Reworked looks like it might be a bigger item than bnx2fc.  If any of
those tests is ever relevant, it means we have a race in the
fcoe_transport because it shouldn't be calling function pointers on a
dying module (unless it wants to trigger an oops).

So, why are you trying to do this in the first place?

James


