Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2JJOS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:18:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33059 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab2JJOS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:18:26 -0400
Date: Wed, 10 Oct 2012 10:06:36 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        "Tang, Feng" <feng.tang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] ACPI: Add early console framework for DBGP/DBG2.
Message-ID: <20121010140635.GE4005@phenom.dumpdata.com>
References: <cover.1347453194.git.zetalog@gmail.com>
 <6a6a79654294bf4a3a9df1cf81880a44aeea4b44.1349749925.git.lv.zheng@intel.com>
 <20121009170220.GE25276@phenom.dumpdata.com>
 <1AE640813FDE7649BE1B193DEA596E88B9C9BE@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88B9C9BE@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 01:31:54AM +0000, Zheng, Lv wrote:
> > > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > > Reviewed-by: Len Brown <len.brown@intel.com>
> > > Reviewed-by: Rui Zhang <rui.zhang@intel.com>
> > > Reviewed-by: Ying Huang <ying.huang@intel.com>
> > > Reviewed-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
> > Please don't include that unless I (or other folks looking at your code) say
> > explicitly 'Acked' or 'Reviewed-by'
> 
> ACK.
> I'll remove these names and resend.  Thanks.
> 
> > > +#define DEBUG
> > That should not be the default case.
> 
> RFC.

The title of the patch does not have RFC anymore.. Please put it back
then.

> If we do not add ignore_loglevel to the command line, the acpi earlycon will be mute just as what you want.
> Do you really want this to be:
> #undef DEBUG
> If we do this, all pr_debug invocations in this file will be empty in compilation stage and are there any other means for us to view the output of ACPI earlycon without recompiling?

Correct. By the time you remove the 'RFC' part this should be the
default.
> 
> > > +DECLARE_BITMAP(acpi_early_flags, MAX_ACPI_DBG_PORTS);
> > static?
> 
> ACK.
> I'll do the modification.
> 
> > > +int acpi_early_enabled;
> > __read_mostly and you could also make it a bool.
> 
> NAK.
> I think this variable will be read only once and written up to 16 times so __read_mostly is not required.
> I'll check and add __init and __initdata for this patch.
> 
> > > +	set_bit(port, acpi_early_flags);
> > > +	if (keep)
> > > +		set_bit(port+MAX_ACPI_DBG_PORTS, acpi_early_flags);
> > Huh? The bitmap is up to MAX_ACPI_DB_PORTS, but here you offset it past
> > that? Why?
> 
> ACK.
> It's my mistake.  The size of the bitmap should be "MAX_ACPI_DBG_PORTS<<1 or MAX_ACPI_DBG_PORTS*2".
> The reason is:
> I think MAX_ACPI_DBG_PORTS=4 is enough in this case.
> Since the systems running Linux are 32/64 bit architectures, using 2 bitmaps will be waste.
> As the systems are at least 32 bit, the MAX_ACPI_DB_PORTS is defined as 16 to make full use of the bitmap.

> 
> > > +	if (!acpi_early_console_enabled(info->port_index))
> > > +		return 0;
> > Not -ENODEV?
> 
> NAK.
> This is to support "MULTIPLE DBG2 debug ports".
> 
> ** MULTIPLE DBGP table versions and MULTIPLE DBG2 debug ports support **
> The whole patch takes ENODEV as the semantics of "table not exist or table version not supported" in PROBE/START stage so that we can obtain the ability of probing Microsoft's future tables in the order from DBGn, ..., DBG2, DBGP.
> We should not return here as users may pass the following command line:
> earlyprintk=acpi2,keep
> to let the first 2 debug ports mute, but take the 3rd as a Linux earlycon.

OK? How will this function get called three times then? I thought it
would just get called once?

> 
> > > +	while (((unsigned long)entry) + sizeof(struct acpi_dbg2_device) <
> > > +	       tbl_end) {
> > Just make it one line. Ignore the 80 characters limit here.
> 
> ACK.
> I'll try to implement this within 80 characters.

Well, you don't have to - not for this.
> 
> > > +		if (!max_entries || count++ < max_entries) {
> > How about you just make this 'count'
> > > +			pr_debug("early: DBG2 PROBE - console %d(%04x:%04x).\n",
> > > +				 count-1,
> > > +				 entry->port_type, entry->port_subtype);
> > > +			devinfo.port_index = (u8)count-1;
> > Then you don't this 'count -1'
> > and then do
> > 		count++ here?
> 
> ACK.
> It's my mistake, the previous version uses port_index=1 as the first debug port, but this version takes 0 as the first port.
> 
> > > +			acpi_early_console_start(&devinfo);
> > no check of the return value to see whether you should return immediately?
> 
> NAK.
> See " MULTIPLE DBGP tables and MULTIPLE DBG2 debug ports support" above.
> 
> > > +	acpi_early_console_start(&devinfo);
> > how about 'return acpi_early_console_start(..)'
> 
> NAK.
> See " MULTIPLE DBGP tables and MULTIPLE DBG2 debug ports support" above.
> 
> > > +	if (acpi_table_parse(ACPI_SIG_DBG2, acpi_parse_dbg2) != 0)
> > > +		acpi_table_parse(ACPI_SIG_DBGP, acpi_parse_dbgp);
> 
> RFC.
> This is to support "MULTIPLE DBGP table versions".
> 
> 
