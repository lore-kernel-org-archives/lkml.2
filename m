Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab1HOTnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:43:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59871 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1HOTnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:43:45 -0400
Date: Mon, 15 Aug 2011 20:37:24 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Kenneth Heitke <kheitke@codeaurora.org>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        rdunlap@xenotime.net, john.stultz@linaro.org, arnd@arndb.de,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110815193724.GB2465@flint.arm.linux.org.uk>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 05:31:28PM -0600, Kenneth Heitke wrote:
> From: Sagar Dharia <sdharia@codeaurora.org>
> 
> SLIMbus (Serial Low Power Interchip Media Bus) is a specification
> developed by MIPI (Mobile Industry Processor Interface) alliance.
> SLIMbus is a 2-wire implementation, which is used to communicate with
> peripheral components like audio. Commonly used digital audio
> interfaces such as I2S, PCM are intended for point-to-point connection
> between application processor and single audio device and support one
> or two channels. Adding more channels or functions is difficult
> without increasing number of bus structures and hence pin count.
> In parallel to audio channels, control buses such as I2C are typically
> used for low-bandwidth control tasks.
> SLIMbus replaces many digital audio buses and control buses by
> providing flexible and dynamic bus-bandwidth between data-functions
> and control-functions.
> 
> The framework supports message APIs, channel scheduling for SLIMbus.
> Message APIs are used for status/control type of communication with a
> device. Data Channel APIs are used for setting data channels between
> SLIMbus devices.
> 
> Framework supports multiple busses (1 controller per bus) and multiple
> clients/slave devices per controller.

This looks like another bus doing the same thing as SPI and I2C.

We seem to be having a growing number of bus_types which:

1. Supply some kind of boardinfo array containing device names against
   a device.
struct i2c_board_info {
        char            type[I2C_NAME_SIZE];
        unsigned short  flags;
        unsigned short  addr;
        void            *platform_data;
        struct dev_archdata     *archdata;
        struct device_node *of_node;
        int             irq;
};
struct spi_board_info {
        char            modalias[SPI_NAME_SIZE];
        const void      *platform_data;
        void            *controller_data;
        int             irq;
        u32             max_speed_hz;
        u16             bus_num;
        u16             chip_select;
        u8              mode;
};

2. match drivers to this against (i2c) type (spi) modalias.

3. drivers contain essentially the same ID structure:
#define I2C_NAME_SIZE   20
#define I2C_MODULE_PREFIX "i2c:"
struct i2c_device_id {
        char name[I2C_NAME_SIZE];
        kernel_ulong_t driver_data      /* Data private to the driver */
                        __attribute__((aligned(sizeof(kernel_ulong_t))));
};
#define SPI_NAME_SIZE   32
#define SPI_MODULE_PREFIX "spi:"
struct spi_device_id {
        char name[SPI_NAME_SIZE];
        kernel_ulong_t driver_data      /* Data private to the driver */
                        __attribute__((aligned(sizeof(kernel_ulong_t))));
};
+#define SLIMBUS_NAME_SIZE      32
+#define SLIMBUS_MODULE_PREFIX "slim:"
+struct slim_device_id {
+       char name[SLIMBUS_NAME_SIZE];
+       kernel_ulong_t driver_data      /* Data private to the driver */
+                       __attribute__((aligned(sizeof(kernel_ulong_t))));
+};

I heard of another bus type at the recent Linaro conference which sounds
like it's going to do yet again a similar thing.  So it sounds like we're
heading for about four of these things.

Is there any way to consolidate this before we end up with four ways of
solving the same problem?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
