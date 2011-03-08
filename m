Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab1CHU3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:29:23 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3548 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab1CHU3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:29:22 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: RE: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
From: "Bhanu Gollapudi" <bprakash@broadcom.com>
To: "Zou, Yi" <yi.zou@intel.com>
cc: "Love, Robert W" <robert.w.love@intel.com>,
        "James Bottomley" <James.Bottomley@suse.de>,
        "Mariusz Kozlowski" <mk@lab.zgora.pl>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
In-Reply-To: <7C88852EF6F99F4EB538472FCFEBE222014F6FE66D@orsmsx509.amr.corp.intel.com>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
 <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
 <20110307201610.GA9032@mako-laptop>
 <1299542075.5232.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
 <1299543497.15955.108.camel@mulgrave.site>
 <1299546546.1689.40.camel@fritz>
 <7C88852EF6F99F4EB538472FCFEBE222014F6FE66D@orsmsx509.amr.corp.intel.com>
Date: Tue, 8 Mar 2011 12:29:06 -0800
Message-ID: <1299616146.1360.1.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 61684D9626W10496481-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 11:36 -0800, Zou, Yi wrote: 
> > On Mon, 2011-03-07 at 16:18 -0800, James Bottomley wrote:
> > > On Mon, 2011-03-07 at 15:54 -0800, Bhanu Gollapudi wrote:
> > > > On Mon, 2011-03-07 at 12:16 -0800, Mariusz Kozlowski wrote:
> > > > > On Wed, Mar 02, 2011 at 11:10:03PM +0100, Mariusz Kozlowski wrote:
> > > > > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencing
> > pointer to incomplete type
> > > > > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error:
> > ‘MODULE_STATE_LIVE’ undeclared (first use in this function)
> > > > >
> > > > > Hm. Still there in next-20110307. Is this patch wrong or..?
> > > > >
> > > >
> > > > James,
> > > >
> > > > Here is my ack for this patch.
> > >
> > > OK, so the patch is actually wrong because adding #ifdefs on modules in
> > > files really impedes readability.  The bug is using a direct deref on
> > > module state instead of one of the APIs which work in the non-modular
> > > case, namely try_module_get(). That means the other two need to come
> > out
> > > and be reworked (plus all the others in fcoe).
> > >
> > > Reworked looks like it might be a bigger item than bnx2fc.  If any of
> > > those tests is ever relevant, it means we have a race in the
> > > fcoe_transport because it shouldn't be calling function pointers on a
> > > dying module (unless it wants to trigger an oops).
> > >
> > > So, why are you trying to do this in the first place?
> > >
> > First, fcoe.c started with these checks. Here is a comment in fcoe.c at
> > the point of one of the checks.
> > 
> > /*
> >  * Make sure the module has been initialized, and is not about to be
> >  * removed.  Module paramter sysfs files are writable before the
> >  * module_init function is called and after module_exit.
> >  */
> > 
> > I don't know the correct way to fix that race is, but we may be past the
> > need to fix it in the LLDs.
> > 
> > Next, the fcoe transport was added. Since it (libfcoe.ko) is now calling
> > what used to be the fcoe.ko sysfs entry points I don't think the problem
> > exists in fcoe.c or in bnx2fc_fcoe.c, the problem should be in the fcoe
> > transport code, as James suggested.
> > 
> > The fcoe transport code already has these checks to protect against
> > sysfs files being writable before module initialization is complete. It
> > uses the ft_mutex to protect the list of transports(LLDs) so when
> > 'create' is called it knows that the transport is still there to call
> > down to. It holds the ft_mutex until the LLD's 'create' routine returns.
> > The transports(LLDs) should be detaching themselves from the fcoe
> > transport layer before they exit. fcoe_transport_detach will try to
> > acquire the ft_mutex and block until the 'create' call returns and
> > releases the ft_mutex. I think this ensures that the transport(LLD) will
> > be fine when the fcoe transport calls it.
> > 
> > My feeling is that these checks are still needed in the fcoe transport,
> > but not in the LLDs. If someone can suggest a better way to protect
> > against writable sysfs files when the module hasn't finished
> > initializing, we should do that instead of the ifdefs.
> > 
> > Hope this helps,
> > 
> > //Rob
> > 
> > FYI: mnc asked about this code and the trylock code in fcoe and libfcoe.
> > I have patches in our internal validation to remove the trylock usage,
> > but I don't have patches to fix the module state checking.
> > 
> Yeah, this logic was from original fixing race condition in fcoe.ko, note
> that we do need check the MODULE_STATE_LIVE, try_module_get() is not what
> we wanted, plus module_is_live () checks if it is !GOING. Anyway, I don't
> think this is needed any more for individual fcoe transport driver, e.g.,
> fcoe.ko or bnx2fc, as the race is now for sysfs of libfcoe.
> 
> I will send out a patch to clean up the fcoe.c for this.

I agree. I'll follow it up with bnx2fc patch.

Thanks,
Bhanu 
> 
> Thanks,
> yi
> 
> 
> 
> 
> 
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



