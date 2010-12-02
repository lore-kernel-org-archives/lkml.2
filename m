Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab0LBUeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 15:34:18 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:29647 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755378Ab0LBUeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 15:34:17 -0500
Message-ID: <4CF80316.4090104@bluewatersys.com>
Date: Fri, 03 Dec 2010 09:35:34 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Charles Manning <cdhmanning@gmail.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] Add yaffs2 file system: VFS glue code, hook into
 kernel tree building
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <1291154254-22533-9-git-send-email-cdhmanning@gmail.com>
In-Reply-To: <1291154254-22533-9-git-send-email-cdhmanning@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2010 10:57 AM, Charles Manning wrote:
> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> ---

<snip>

> +#
> +# YAFFS file system configurations
> +#

There are still too many config options...

> +config YAFFS_FS
> +	tristate "YAFFS2 file system support"
> +	default n
> +	depends on MTD_BLOCK
> +	select YAFFS_YAFFS1
> +	select YAFFS_YAFFS2
> +	help
> +	  YAFFS2, or Yet Another Flash Filing System, is a filing system
> +	  optimised for NAND Flash chips.
> +
> +	  To compile the YAFFS2 file system support as a module, choose M
> +	  here: the module will be called yaffs2.
> +
> +	  If unsure, say N.
> +
> +	  Further information on YAFFS2 is available at
> +	  <http://www.aleph1.co.uk/yaffs/>.
> +
> +config YAFFS_YAFFS1
> +	bool "512 byte / page devices"
> +	depends on YAFFS_FS
> +	default y
> +	help
> +	  Enable YAFFS1 support -- yaffs for 512 byte / page devices
> +
> +	  Not needed for 2K-page devices.
> +
> +	  If unsure, say Y.
> +
> +config YAFFS_9BYTE_TAGS
> +	bool "Use older-style on-NAND data format with pageStatus byte"
> +	depends on YAFFS_YAFFS1
> +	default n
> +	help
> +
> +	  Older-style on-NAND data format has a "pageStatus" byte to record
> +	  chunk/page state.  This byte is zero when the page is discarded.
> +	  Choose this option if you have existing on-NAND data using this
> +	  format that you need to continue to support.  New data written
> +	  also uses the older-style format.  Note: Use of this option
> +	  generally requires that MTD's oob layout be adjusted to use the
> +	  older-style format.  See notes on tags formats and MTD versions
> +	  in yaffs_mtdif1.c.
> +
> +	  If unsure, say N.
> +
> +config YAFFS_DOES_ECC
> +	bool "Lets Yaffs do its own ECC"
> +	depends on YAFFS_FS && YAFFS_YAFFS1 && !YAFFS_9BYTE_TAGS
> +	default n
> +	help
> +	  This enables Yaffs to use its own ECC functions instead of using
> +	  the ones from the generic MTD-NAND driver.
> +
> +	  If unsure, say N.
> +
> +config YAFFS_ECC_WRONG_ORDER
> +	bool "Use the same ecc byte order as Steven Hill's nand_ecc.c"
> +	depends on YAFFS_FS && YAFFS_DOES_ECC && !YAFFS_9BYTE_TAGS
> +	default n
> +	help
> +	  This makes yaffs_ecc.c use the same ecc byte order as Steven
> +	  Hill's nand_ecc.c. If not set, then you get the same ecc byte
> +	  order as SmartMedia.
> +
> +	  If unsure, say N.
> +
> +config YAFFS_YAFFS2
> +	bool "2048 byte (or larger) / page devices"
> +	depends on YAFFS_FS
> +	default y
> +	help
> +	  Enable YAFFS2 support -- yaffs for >= 2K bytes per page devices
> +
> +	  If unsure, say Y.

How much additional code do the YAFFS1 and YAFFS2 options add? If the
added size is minimal maybe its better to remove these options and just
always support both yaffs and yaffs2?

> +config YAFFS_AUTO_YAFFS2
> +	bool "Autoselect yaffs2 format"
> +	depends on YAFFS_YAFFS2
> +	default y
> +	help
> +	  Without this, you need to explicitely use yaffs2 as the file
> +	  system type. With this, you can say "yaffs" and yaffs or yaffs2
> +	  will be used depending on the device page size (yaffs on
> +	  512-byte page devices, yaffs2 on 2K page devices).

Could this option be removed and have the default behaviour auto-detect
when specifying "yaffs", and have "yaffs1" and "yaffs2" specify the
filesystem explicitly?

> +
> +	  If unsure, say Y.
> +
> +config YAFFS_DISABLE_TAGS_ECC
> +	bool "Disable YAFFS from doing ECC on tags by default"
> +	depends on YAFFS_FS && YAFFS_YAFFS2
> +	default n
> +	help
> +	  This defaults Yaffs to using its own ECC calculations on tags instead of
> +	  just relying on the MTD.
> +	  This behavior can also be overridden with tags_ecc_on and
> +	  tags_ecc_off mount options.
> +
> +	  If unsure, say N.
> +
> +config YAFFS_ALWAYS_CHECK_CHUNK_ERASED
> +	bool "Force chunk erase check"
> +	depends on YAFFS_FS
> +	default n
> +	help
> +          Normally YAFFS only checks chunks before writing until an erased
> +	  chunk is found. This helps to detect any partially written
> +	  chunks that might have happened due to power loss.
> +
> +	  Enabling this forces on the test that chunks are erased in flash
> +	  before writing to them. This takes more time but is potentially
> +	  a bit more secure.
> +
> +	  Suggest setting Y during development and ironing out driver
> +	  issues etc. Suggest setting to N if you want faster writing.
> +
> +	  If unsure, say Y.
> +
> +config YAFFS_EMPTY_LOST_AND_FOUND
> +	bool "Empty lost and found on boot"
> +	depends on YAFFS_FS
> +	default n
> +	help
> +	  If this is enabled then the contents of lost and found is
> +	  automatically dumped at mount.
> +
> +	  If unsure, say N.
> +
> +config YAFFS_DISABLE_BLOCK_REFRESHING
> +	bool "Disable yaffs2 block refreshing"
> +	depends on YAFFS_FS
> +	default n
> +	help
> +	 If this is set, then block refreshing is disabled.
> +	 Block refreshing infrequently refreshes the oldest block in
> +	 a yaffs2 file system. This mechanism helps to refresh flash to
> +	 mitigate against data loss. This is particularly useful for MLC.
> +
> +	  If unsure, say N.

Some of the Kconfig options are enabling features and some are disabling
features which is a bit confusing.

This option, and some of the others, looks like it could be replaced by
a sysfs tuneable to set the refresh_period. This would give much greater
control over this option.

> +config YAFFS_DISABLE_BACKGROUND
> +	bool "Disable yaffs2 background processing"
> +	depends on YAFFS_FS
> +	default n
> +	help
> +	 If this is set, then background processing is disabled.
> +	 Background processing makes many foreground activities faster.
> +
> +	 If unsure, say N.

Why would you enable this config option?

> +config YAFFS_XATTR
> +	bool "Enable yaffs2 xattr support"
> +	depends on YAFFS_FS
> +	default y
> +	help
> +	 If this is set then yaffs2 will provide xattr support.
> +	 If unsure, say Y.

Why would you disable this config option?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
