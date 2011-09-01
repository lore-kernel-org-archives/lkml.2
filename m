Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab1IAWE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:04:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42812 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab1IAWEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:04:52 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>, Jonathan Cameron <jic23@cam.ac.uk>,
        Andrew Chew <achew@nvidia.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 2/5] spi: Add irq_gpio field to struct spi_device, spi_board_info.
Date: Thu,  1 Sep 2011 16:04:28 -0600
Message-Id: <1314914676-28397-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314914676-28397-1-git-send-email-swarren@nvidia.com>
References: <1314914676-28397-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices use a single pin as both an IRQ and a GPIO. In that case,
irq_gpio is the GPIO ID for that pin. Not all drivers use this feature.
Where they do, and the use of this feature is optional, and the system
wishes to disable this feature, this field must be explicitly set to a
defined invalid GPIO ID, such as -1.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v3: New patch for v3; apply the same change to spi as for i2c per Mark
    Brown.

 drivers/spi/spi.c       |    1 +
 include/linux/spi/spi.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 77eae99..9932572 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -433,6 +433,7 @@ struct spi_device *spi_new_device(struct spi_master *master,
 	proxy->max_speed_hz = chip->max_speed_hz;
 	proxy->mode = chip->mode;
 	proxy->irq = chip->irq;
+	proxy->irq_gpio = chip->irq_gpio;
 	strlcpy(proxy->modalias, chip->modalias, sizeof(proxy->modalias));
 	proxy->dev.platform_data = (void *) chip->platform_data;
 	proxy->controller_data = chip->controller_data;
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index bb4f5fb..086b591 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -50,6 +50,12 @@ extern struct bus_type spi_bus_type;
  *	The spi_transfer.bits_per_word can override this for each transfer.
  * @irq: Negative, or the number passed to request_irq() to receive
  *	interrupts from this device.
+ * @irq_gpio: some devices use a single pin as both an IRQ and a GPIO. In
+ *	that case, irq_gpio is the GPIO ID for that pin. Not all drivers
+ *	use this feature. Where they do, and the use of this feature is
+ *	optional, and the system wishes to disable this feature, this
+ *	field must be explicitly set to a defined invalid GPIO ID, such
+ *	as -1.
  * @controller_state: Controller's runtime state
  * @controller_data: Board-specific definitions for controller, such as
  *	FIFO initialization parameters; from board_info.controller_data
@@ -86,6 +92,7 @@ struct spi_device {
 #define	SPI_READY	0x80			/* slave pulls low to pause */
 	u8			bits_per_word;
 	int			irq;
+	int			irq_gpio;
 	void			*controller_state;
 	void			*controller_data;
 	char			modalias[SPI_NAME_SIZE];
@@ -692,6 +699,8 @@ static inline ssize_t spi_w8r16(struct spi_device *spi, u8 cmd)
  * @controller_data: Initializes spi_device.controller_data; some
  *	controllers need hints about hardware setup, e.g. for DMA.
  * @irq: Initializes spi_device.irq; depends on how the board is wired.
+ * @irq_gpio: Initializes spi_device.irq_gpio; depends on how the board
+ *	is wired.
  * @max_speed_hz: Initializes spi_device.max_speed_hz; based on limits
  *	from the chip datasheet and board-specific signal quality issues.
  * @bus_num: Identifies which spi_master parents the spi_device; unused
@@ -727,6 +736,7 @@ struct spi_board_info {
 	const void	*platform_data;
 	void		*controller_data;
 	int		irq;
+	int		irq_gpio;
 
 	/* slower signaling on noisy or low voltage boards */
 	u32		max_speed_hz;
-- 
1.7.0.4

