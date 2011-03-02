Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab1CBWN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:13:57 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41704 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab1CBWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:13:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77649864"
From: adharmap@codeaurora.org
To: davidb@codeaurora.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Qualcomm PM8921 MFD 6/6] msm: board-8960: Add support for pm8921
Date: Wed,  2 Mar 2011 14:13:21 -0800
Message-Id: <1299104001-5240-7-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

Add device structure declarations to the msm8960 board file
for PMIC 8921 chip and its subdevices.

Change-Id: I93a2c929a98e93a3b7a4e6e6e05381b519516d1f
Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Signed-off-by: David Collins <collinsd@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8960.c          |   47 ++++++++++++++++++++++------
 arch/arm/mach-msm/include/mach/irqs-8960.h |    9 ++---
 2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index bf1a24b..8433938 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -8,19 +8,15 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- *
  */
+
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/clkdev.h>
 #include <linux/msm_ssbi.h>
+#include <linux/mfd/pm8921.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -28,9 +24,18 @@
 
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
+#include <mach/irqs.h>
 
 #include "devices.h"
 
+/* Macros assume PMIC GPIOs and MPPs start at 1 */
+#define PM8921_GPIO_BASE		NR_GPIO_IRQS
+#define PM8921_GPIO_PM_TO_SYS(pm_gpio)	(pm_gpio - 1 + PM8921_GPIO_BASE)
+#define PM8921_MPP_BASE			(PM8921_GPIO_BASE + NR_PM8921_GPIOS)
+#define PM8921_MPP_PM_TO_SYS(pm_gpio)	(pm_gpio - 1 + PM8921_MPP_BASE)
+#define PM8921_IRQ_BASE			(NR_MSM_IRQS + NR_GPIO_IRQS)
+#define PM8921_MPP_IRQ_BASE		(PM8921_IRQ_BASE + NR_GPIO_IRQS)
+
 static void __init msm8960_map_io(void)
 {
 	msm_map_msm8960_io();
@@ -65,12 +70,34 @@ static struct platform_device *sim_devices[] __initdata = {
 
 static struct platform_device *rumi3_devices[] __initdata = {
 	&msm8960_device_uart_gsbi5,
+	&msm8960_device_ssbi_pm8921,
+};
+
+static struct pm8xxx_irq_platform_data pm8xxx_irq_pdata __devinitdata = {
+	.irq_base		= PM8921_IRQ_BASE,
+	.devirq			= MSM_GPIO_TO_INT(104),
+	.irq_trigger_flag	= IRQF_TRIGGER_LOW,
+};
+
+static struct pm8xxx_gpio_platform_data pm8xxx_gpio_pdata __devinitdata = {
+	.gpio_base	= PM8921_GPIO_PM_TO_SYS(1),
+};
+
+static struct pm8xxx_mpp_platform_data pm8xxx_mpp_pdata __devinitdata = {
+	.mpp_base	= PM8921_MPP_PM_TO_SYS(1),
+};
+
+static struct pm8921_platform_data pm8921_platform_data __devinitdata = {
+	.irq_pdata		= &pm8xxx_irq_pdata,
+	.gpio_pdata		= &pm8xxx_gpio_pdata,
+	.mpp_pdata		= &pm8xxx_mpp_pdata,
 };
 
-static struct msm_ssbi_platform_data msm8960_ssbi_pm8921_pdata = {
-	.controller_type = MSM_SBI_CTRL_PMIC_ARBITER,
-	.slave	= {
-		.name		= "pm8921-core",
+static struct msm_ssbi_platform_data msm8960_ssbi_pm8921_pdata __initdata = {
+	.controller_type	= MSM_SBI_CTRL_PMIC_ARBITER,
+	.slave			= {
+		.name			= "pm8921-core",
+		.platform_data		= &pm8921_platform_data,
 	},
 };
 
diff --git a/arch/arm/mach-msm/include/mach/irqs-8960.h b/arch/arm/mach-msm/include/mach/irqs-8960.h
index 81ab2a6..1bd0ee8 100644
--- a/arch/arm/mach-msm/include/mach/irqs-8960.h
+++ b/arch/arm/mach-msm/include/mach/irqs-8960.h
@@ -267,11 +267,10 @@
 #define PM8921_SEC_IRQ_104			(GIC_SPI_START + 225)
 #define PM8018_SEC_IRQ_107			(GIC_SPI_START + 226)
 
-/* For now, use the maximum number of interrupts until a pending GIC issue
- * is sorted out */
-#define NR_MSM_IRQS 1020
-#define NR_BOARD_IRQS 0
-#define NR_GPIO_IRQS 0
+#define NR_MSM_IRQS 256
+#define NR_GPIO_IRQS 151
+#define NR_PM8921_IRQS 256
+#define NR_BOARD_IRQS (NR_PM8921_IRQS)
 
 #endif
 
-- 
1.7.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
