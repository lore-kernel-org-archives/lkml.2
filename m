Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2KSS3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:29:04 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:42095 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753975Ab2KSS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:29:03 -0500
Message-ID: <1353349733.2630.9.camel@thor>
Subject: Re: [PATCH v3] mfd: lpc_ich: Fix resource request for [mem
 0x00000000]
From: Peter Hurley <peter@hurleysoftware.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Aaron Sierra <asierra@xes-inc.com>
Date: Mon, 19 Nov 2012 13:28:53 -0500
In-Reply-To: <20121119174615.GG18738@sortiz-mobl>
References: <efe3e3f7-eb7f-460b-86d7-293dba8651d8@zimbra>
	 <1352462129.8352.2.camel@thor> <20121119174615.GG18738@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-19 at 18:46 +0100, Samuel Ortiz wrote:
> Hi Peter,
> 
> On Fri, Nov 09, 2012 at 06:55:29AM -0500, Peter Hurley wrote:
> > The older southbridges supported by the lpc_ich driver do not
> > provide memory-mapped space of the root complex. The driver
> > correctly avoids computing the iomem address in this case, yet
> > submits a zeroed resource request anyway (via mfd_add_devices()).
> > 
> > Remove the iomem resource from the resource array submitted to the
> > mfd core for the older southbridges.
> > 
> > Acked-by: Aaron Sierra <asierra@xes-inc.com>
> > Cc: Peter Tyser <ptyser@xes-inc.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > ---
> > 
> > v2: post-decrement to match existing style
> >     retitle patch subject
> > v3: respin as standalone patch
> > 
> >  drivers/mfd/lpc_ich.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
> > index a22544f..f507c09 100644
> > --- a/drivers/mfd/lpc_ich.c
> > +++ b/drivers/mfd/lpc_ich.c
> > @@ -842,6 +842,9 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
> >  		res = wdt_mem_res(ICH_RES_MEM_GCS);
> >  		res->start = base_addr + ACPIBASE_GCS_OFF;
> >  		res->end = base_addr + ACPIBASE_GCS_END;
> > +	} else {
> So I suppose there is no v3 for the iTCO ? If we're expecting all versions
> after 1 to have a memory mapped region, we should have something like:
> 
> --- a/drivers/mfd/lpc_ich.c
> +++ b/drivers/mfd/lpc_ich.c
> @@ -830,7 +830,10 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev
> *dev,
>          * we have to read RCBA from PCI Config space 0xf0 and use
>          * it as base. GCS = RCBA + ICH6_GCS(0x3410).
>          */
> -       if (lpc_chipset_info[id->driver_data].iTCO_version == 2) {
> +       if (lpc_chipset_info[id->driver_data].iTCO_version == 1) {
> +               /* Don't register iomem for TCO ver 1 */
> +               lpc_ich_cells[LPC_WDT].num_resources--;
> +       } else {
>                 pci_read_config_dword(dev, RCBABASE, &base_addr_cfg);
>                 base_addr = base_addr_cfg & 0xffffc000;
>                 if (!(base_addr_cfg & 1)) {

Hi Samuel,

I have no objection to your version.

FWIW, the iTCO_version field is exclusively a driver construct used to
differentiate southbridges that support memory-mapped I/O to the TCO
registers from those that only support port-based I/O. IOW, there's no
intrinsic meaning to the values and could be represented with a bool
type instead.

Regards,
Peter Hurley

