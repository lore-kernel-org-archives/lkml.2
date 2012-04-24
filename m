Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab2DXXUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:20:50 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:47807 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2DXXUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:20:48 -0400
Date: Tue, 24 Apr 2012 16:20:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH v5 1/3] USB: Add driver for NXP ISP1301 USB transceiver
Message-ID: <20120424232044.GA2657@kroah.com>
References: <1335002264-22225-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335002264-22225-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 11:57:42AM +0200, Roland Stigge wrote:
> This very-lowlevel driver registers the NXP ISP1301 chip via the I2C subsystem.
> The chip is the USB transceiver shared by ohci-nxp, lpc32xx_udc (gadget) and
> isp1301_omap.
> 
> Following patches let the respective USB host and gadget drivers use this
> driver, instead of duplicating ISP1301 handling.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> ---
> 
> Applies to v3.4-rc3
> 
> Changes since v4:
> * Documentation adjustment of device tree "compatible" string:
>   "nxp,lpc32xx-udc" -> "nxp,lpc3220-udc"
> 
>  Documentation/devicetree/bindings/usb/isp1301.txt |   25 ++++++
>  drivers/usb/Kconfig                               |    2 
>  drivers/usb/Makefile                              |    1 
>  drivers/usb/phy/Kconfig                           |   17 ++++
>  drivers/usb/phy/Makefile                          |    7 +
>  drivers/usb/phy/isp1301.c                         |   79 ++++++++++++++++++++

Nice, but:

>  include/linux/usb/isp1301.h                       |   84 ++++++++++++++++++++++

Why this file?  You have a lot of register stuff in here that should be
in the .c file, right?  Only put what other files need in this .h file,
which shouldn't be much at all from what I can tell.

> +#define DRV_VERSION		"0.1.0"

Is that really needed?

> +struct i2c_client *isp1301_get_client(struct device_node *node)
> +{
> +	if (node) { /* reference of ISP1301 I2C node via DT */
> +		struct device *dev = bus_find_device(&i2c_bus_type, NULL,
> +						     node, match);
> +		if (!dev)
> +			return NULL;
> +		return to_i2c_client(dev);
> +	} else { /* non-DT: only one ISP1301 chip supported */
> +		return isp1301_i2c_client;
> +	}
> +}
> +EXPORT_SYMBOL(isp1301_get_client);

EXPORT_SYMBOL_GPL()?

> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

Are you really willing to keep track of where the FSF keeps it's office
for the next 40 years?  Just delete this paragraph please, it's not
needed at all.

thanks,

greg k-h
