Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab1IMRAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:00:24 -0400
Received: from claw.goop.org ([74.207.240.146]:35122 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab1IMRAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:00:22 -0400
Message-ID: <4E6F8C24.3090207@goop.org>
Date: Tue, 13 Sep 2011 10:00:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org>
In-Reply-To: <m2bouo37by.fsf@bob.laptop.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 06:22 AM, Chris Ball wrote:
> Hi Jeremy,
>
> On Mon, Sep 12 2011, Jeremy Fitzhardinge wrote:
>> Since 2.6.39, the SD card slot in my Lenovo X220 has stopped working.  
>> When I insert a card with current linux.git kernel (3.1-rc6), I get:
>>
>> [ 3891.745549] mmc0: new SDHC card at address b368
>> [ 3891.790704] mmcblk0: mmc0:b368 PNY   7.51 GiB 
>> [ 3891.795568] mmc0: Got data interrupt 0x00200000 even though no data
>> operation was in progress.
> Please could you try reverting a3c7778f8153b9 "mmc: sdhci: R1B command
> handling + MMC_CAP_ERASE"?  We've had one other similar report that
> bisected to this patch.
>

The revert was not entirely trivial (below), but I'm fairly sure I got
it right, and it didn't help.

On card insert, it now says:

[56549.455385] mmc0: new SDHC card at address b368
[56549.456872] mmcblk0: mmc0:b368 PNY   7.51 GiB 
[56549.467279] mmc0: starting CMD18 arg 00000000 flags 000000b5
[56549.467288] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[56549.467294] mmc0:     CMD12 arg 00000000 flags 0000049d
[56549.467340] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[56549.467369] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[56549.467376] mmc0:     0 bytes transferred: 0
[56549.467382] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[56549.467404] mmc0: starting CMD13 arg b3680000 flags 00000195
[56549.467440] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[56549.467455] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[56549.467458] mmcblk0: error -110 sending status command, retrying
[56549.467461] mmc0: starting CMD13 arg b3680000 flags 00000195
[56549.467477] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[56549.467484] mmc0: req done (CMD13): 0: 00800900 00000000 00000000 00000000
[56549.467488] mmcblk0: timed out sending r/w cmd command, card status 0x800900
[56549.467492] mmc0: starting CMD18 arg 00000000 flags 000000b5
[56549.467494] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[56549.467496] mmc0:     CMD12 arg 00000000 flags 0000049d
[56549.467518] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[56549.467973] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00608000
[56549.468019] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00408003
[56549.468035] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
[56549.468037] mmc0:     0 bytes transferred: -84
[56549.468038] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
[56549.468045] mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb00
[56549.468047] mmcblk0: retrying using single block read
[56549.468051] mmc0: starting CMD17 arg 00000000 flags 000000b5
[56549.468053] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
[56549.468076] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[56549.468411] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00608002
[56549.468438] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
[56549.468444] mmc0:     0 bytes transferred: -84
[56549.468459] mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0x0
[56549.468471] end_request: I/O error, dev mmcblk0, sector 0
[56549.468481] mmc0: starting CMD17 arg 00000001 flags 000000b5
[56549.468488] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
[56549.468525] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[56549.468855] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00408002
[56549.468881] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
[56549.468887] mmc0:     0 bytes transferred: -84
[56549.468902] mmcblk0: error -84 transferring data, sector 1, nr 7, cmd response 0x900, card status 0x0
[56549.468928] end_request: I/O error, dev mmcblk0, sector 1
[56549.468931] mmc0: starting CMD17 arg 00000002 flags 000000b5
[56549.468934] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
[56549.468958] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[56549.469295] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
[56549.469311] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
[56549.469318] mmc0:     512 bytes transferred: 0
[56549.469340] mmc0: starting CMD17 arg 00000003 flags 000000b5
[56549.469347] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
[56549.469382] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[56549.469714] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
[...]

Thanks,
	J


Revert patch:
index 0e02cc1..7d85245 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -42,6 +42,7 @@
 
 static unsigned int debug_quirks = 0;
 
+static void sdhci_prepare_data(struct sdhci_host *, struct mmc_data *);
 static void sdhci_finish_data(struct sdhci_host *);
 
 static void sdhci_send_command(struct sdhci_host *, struct mmc_command *);
@@ -606,10 +607,9 @@ static void sdhci_adma_table_post(struct sdhci_host *host,
 		data->sg_len, direction);
 }
 
-static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
+static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_data *data)
 {
 	u8 count;
-	struct mmc_data *data = cmd->data;
 	unsigned target_timeout, current_timeout;
 
 	/*
@@ -621,18 +621,12 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 	if (host->quirks & SDHCI_QUIRK_BROKEN_TIMEOUT_VAL)
 		return 0xE;
 
-	/* Unspecified timeout, assume max */
-	if (!data && !cmd->cmd_timeout_ms)
-		return 0xE;
-
 	/* timeout in us */
-	if (!data)
-		target_timeout = cmd->cmd_timeout_ms * 1000;
-	else {
-		target_timeout = data->timeout_ns / 1000;
-		if (host->clock)
-			target_timeout += data->timeout_clks / host->clock;
-	}
+	target_timeout = data->timeout_ns / 1000 +
+		data->timeout_clks / host->clock;
+
+	if (host->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)
+		host->timeout_clk = host->clock / 1000;
 
 	/*
 	 * Figure out needed cycles.
@@ -654,8 +648,8 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 	}
 
 	if (count >= 0xF) {
-		printk(KERN_WARNING "%s: Too large timeout requested for CMD%d!\n",
-		       mmc_hostname(host->mmc), cmd->opcode);
+		printk(KERN_WARNING "%s: Too large timeout requested!\n",
+			mmc_hostname(host->mmc));
 		count = 0xE;
 	}
 
@@ -673,21 +667,15 @@ static void sdhci_set_transfer_irqs(struct sdhci_host *host)
 		sdhci_clear_set_irqs(host, dma_irqs, pio_irqs);
 }
 
-static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
+static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 {
 	u8 count;
 	u8 ctrl;
-	struct mmc_data *data = cmd->data;
 	int ret;
 
 	WARN_ON(host->data);
 
-	if (data || (cmd->flags & MMC_RSP_BUSY)) {
-		count = sdhci_calc_timeout(host, cmd);
-		sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
-	}
-
-	if (!data)
+	if (data == NULL)
 		return;
 
 	/* Sanity checks */
@@ -699,6 +687,9 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
 	host->data_early = 0;
 	host->data->bytes_xfered = 0;
 
+	count = sdhci_calc_timeout(host, data);
+	sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
+
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA))
 		host->flags |= SDHCI_REQ_USE_DMA;
 
@@ -964,7 +955,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 
 	host->cmd = cmd;
 
-	sdhci_prepare_data(host, cmd);
+	sdhci_prepare_data(host, cmd->data);
 
 	sdhci_writel(host, cmd->arg, SDHCI_ARGUMENT);
 
@@ -2504,12 +2495,9 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (caps[0] & SDHCI_TIMEOUT_CLK_UNIT)
 		host->timeout_clk *= 1000;
 
-	if (host->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)
-		host->timeout_clk = mmc->f_max / 1000;
-
 	mmc->max_discard_to = (1 << 27) / host->timeout_clk;
 
-	mmc->caps |= MMC_CAP_SDIO_IRQ | MMC_CAP_ERASE | MMC_CAP_CMD23;
+	mmc->caps |= MMC_CAP_SDIO_IRQ | MMC_CAP_CMD23;
 
 	if (host->quirks & SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12)
 		host->flags |= SDHCI_AUTO_CMD12;


