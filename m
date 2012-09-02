Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab2IBQar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 12:30:47 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50610 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2IBQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 12:30:45 -0400
Date: Sun, 2 Sep 2012 09:30:30 -0700
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] tpm: fix tpm_acpi sparse warning on different address
 spaces
Message-ID: <20120902163030.GB1840@mwanda>
References: <20120830143839.GA9589@linux.vnet.ibm.com>
 <20120830174556.GD20741@mwanda>
 <20120830192155.GA25524@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830192155.GA25524@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:21:55PM -0500, Kent Yoder wrote:
> On Thu, Aug 30, 2012 at 10:45:56AM -0700, Dan Carpenter wrote:
> > On Thu, Aug 30, 2012 at 09:38:41AM -0500, Kent Yoder wrote:
> > > acpi_os_map_memory expects its return value to be in the __iomem address
> > > space. Cast it back later when used in a memcpy to avoid the same sparse
> > > warning there.
> > > 
> > > Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> > 
> > I can't download linux-next right now but I don't think this is the
> > correct fix.  I don't think you can memcpy() directly from __iomem.
> > The static checker is warning about a valid bug which should be
> > addressed instead of just casted away and silenced.
> 
>   I took a look at other uses of the return from acpi_os_map_memory(),
> such as acpi_tb_parse_fadt(), which passes the returned pointer to
> acpi_tb_create_local_fadt(), which uses ACPI_MEMCPY on it, which is just
> memcpy.  This code lives in drivers/acpi.
> 

Sparse finds that bug as well.  ;)

drivers/acpi/acpica/tbfadt.c:247:15: warning: incorrect type in assignment (different address spaces)
drivers/acpi/acpica/tbfadt.c:247:15:    expected struct acpi_table_header *table
drivers/acpi/acpica/tbfadt.c:247:15:    got void [noderef] <asn:2>*
drivers/acpi/acpica/tbfadt.c:266:30: warning: incorrect type in argument 1 (different address spaces)
drivers/acpi/acpica/tbfadt.c:266:30:    expected void [noderef] <asn:2>*logical_address
drivers/acpi/acpica/tbfadt.c:266:30:    got struct acpi_table_header *table

It should be memcpy_fromio() probably.

regards,
dan carpenter

