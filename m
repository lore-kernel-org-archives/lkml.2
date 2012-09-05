Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2IEMK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:10:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57028 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2IEMK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:10:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 15/17] mfd: dbx540-prcmu creation
Date: Wed, 5 Sep 2012 12:10:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        "STEricsson_nomadik_linux" <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "LT ST-Ericsson" <st-ericsson@lists.linaro.org>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com> <1346839153-6465-16-git-send-email-loic.pallardy-ext@stericsson.com>
In-Reply-To: <1346839153-6465-16-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209051210.04880.arnd@arndb.de>
X-Provags-ID: V02:K0:ihfYfD8UiKa4V7u3KPj5X2Q3EV0lcaN2F62MBFk/vN6
 K0ZiikGBzUplLSRseeDjRn3RgYR2i1d7mu8iXH1n6gpqfa7sZG
 WPPHgQDVr2y9Zx4pCVbEksSrpSkj5WkrwQydSa9jiOFmWMf6vB
 zRxV8DqCY7kOdWMa5aYKCtG2md97fJ0woUi98Eg6PVJ0ww5Z7t
 +y1/DMNzYL9L2AKP4r3DBEEozmrzHDmbGu24Fkrjlg0hBvK2pg
 u3mCmsFT8IW2UrRmQVn90RQt5zIriTAUXTZ86QRzHax+rW8A2e
 XvPXy9FzINYpYbSyGqin5Rp+ZSRxHib3kfurTTwcUnbALDltUa
 vgxAFaiiR8JPUbkK17uE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2012, Loic Pallardy wrote:
 
> This driver offers support for ST-Ericsson DB9540 and
> DB8540 PRCMU.
> - add new communication interface named UniqPAP
> - add support for x540 HW
> 
> Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

This makes me doubt the quality of Linus' Ack on other patches...

> diff --git a/drivers/mfd/dbx540-prcmu-regs.h b/drivers/mfd/dbx540-prcmu-regs.h
> new file mode 100644
> index 0000000..a15810d
> --- /dev/null
> +++ b/drivers/mfd/dbx540-prcmu-regs.h

This header file looks like it really should only be included in a
single .c file, so better put all the definitions in there.

> +#define PRCM_PLLDSITV_FREQ         (_PRCMU_BASE + 0x500)
> +#define PRCM_PLLDSITV_ENABLE       (_PRCMU_BASE + 0x504)
> +#define PRCM_PLLDSITV_LOCKP        (_PRCMU_BASE + 0x508)
> +#define PRCM_PLLDSILCD_FREQ        (_PRCMU_BASE + 0x290)
> +#define PRCM_PLLDSILCD_ENABLE      (_PRCMU_BASE + 0x294)
> +#define PRCM_PLLDSILCD_LOCKP       (_PRCMU_BASE + 0x298)

Please get rid of the global _PRCMU_BASE variable, at least for new
code. Instead, please use ioremap() of the resources passed in the
device tree, like we do for all other drivers.

> +#include <mach/hardware.h>
> +#include <mach/irqs.h>
> +#include <mach/db8500-regs.h>
> +#include <mach/hardware.h>

None of these should be needed in this driver, especially not twice.

> +/* mailbox definition */
> +static struct mb0_transfer mb0;
> +static struct mb2_transfer mb2;
> +static struct mb3_transfer mb3;
> +static struct mb4_transfer mb4;
> +static struct mb5_transfer mb5;

The entire mailbox system seems to be complicated by having a different
structure for each one, and no shared code between them. 

> +static void (*upap_read_services[UPAP_SERVICES_NB])(struct upap_req *req,
> +		struct upap_ack *ack);
> +
> +static int cpu1_unplug_ongoing;
> +static int prcmu_driver_initialised;
> +
> +static struct {
> +	bool valid;
> +	struct prcmu_fw_version version;
> +} fw_info;
> +
> +static unsigned long latest_armss_rate;
>
> +static atomic_t ac_wake_req_state = ATOMIC_INIT(0);
> +
> +/* Spinlocks */
> +static DEFINE_SPINLOCK(prcmu_lock);
> +static DEFINE_SPINLOCK(clkout_lock);
> +static DEFINE_SPINLOCK(spare_out_lock);
> +
> +/*
> + * Copies of the startup values of the reset status register and the SW reset
> + * code.
> + */
> +static u32 reset_status_copy;
> +static u16 reset_code_copy;
> +
> +static DEFINE_SPINLOCK(clk_mgt_lock);
> +

You have *way* too many static variables in this driver.

> +static int set_arm_freq(u32 freq);
> +static int get_arm_freq(void);

You should also just remove all forward declarations by reordering the
functions in the order they are called in.

> +#define CLK_MGT_ENTRY(_name, _branch, _clk38div)[PRCMU_##_name] = \
> +	{ (PRCM_##_name##_MGT), 0 , _branch, _clk38div}
> +static struct clk_mgt clk_mgt[PRCMU_NUM_REG_CLOCKS] = {
> +	CLK_MGT_ENTRY(SGACLK, PLL_DIV, false),
> +	CLK_MGT_ENTRY(UARTCLK, PLL_FIX, true),

Never use string concatenation in macros to generate identifier names
like this. It makes it impossible to grep for where the symbols are used.
Better avoid those macros entirely and just open-code the array.

Another option would be to put the table into the device tree so you
can abstract the differences between the two prmu versions more easily.

> +
> +/*
> +* Used by MCDE to setup all necessary PRCMU registers
> +*/
> +#define PRCMU_RESET_DSIPLLTV		0x00004000
> +#define PRCMU_RESET_DSIPLLLCD		0x00008000
> +#define PRCMU_UNCLAMP_DSIPLL		0x00400800
> +
> +#define PRCMU_CLK_PLL_DIV_SHIFT		0
> +#define PRCMU_CLK_PLL_SW_SHIFT		5
> +#define PRCMU_CLK_38			(1 << 9)
> +#define PRCMU_CLK_38_SRC		(1 << 10)
> +#define PRCMU_CLK_38_DIV		(1 << 11)
> +
> +/* PLLDIV=12, PLLSW=4 (PLLDDR) */
> +#define PRCMU_DSI_CLOCK_SETTING		0x0000008C
> +/* PLLDIV = 12, PLLSW=1 (PLLSOC0) */
> +#define U9540_PRCMU_DSI_CLOCK_SETTING	0x0000002C
> +
> +/* DPI 50000000 Hz */
> +#define PRCMU_DPI_CLOCK_SETTING		((1 << PRCMU_CLK_PLL_SW_SHIFT) | \
> +					  (16 << PRCMU_CLK_PLL_DIV_SHIFT))
> +#define PRCMU_DSI_LP_CLOCK_SETTING	0x00000E00
> +
> +/* D=101, N=1, R=4, SELDIV2=0 */
> +#define PRCMU_PLLDSI_FREQ_SETTING	0x00040165
> +
> +#define PRCMU_ENABLE_PLLDSI		0x00000001
> +#define PRCMU_DISABLE_PLLDSI		0x00000000
> +#define PRCMU_RELEASE_RESET_DSS		0x0000400C
> +#define PRCMU_TV_DSI_PLLOUT_SEL_SETTING	0x00000202
> +#define PRCMU_LCD_DSI_PLLOUT_SEL_SETTING	0x00000A0A
> +/* ESC clk, div0=1, div1=1, div2=3 */
> +#define PRCMU_ENABLE_ESCAPE_CLOCK_DIV	0x07030101
> +#define PRCMU_DISABLE_ESCAPE_CLOCK_DIV	0x00030101
> +#define PRCMU_DSI_RESET_SW		0x00000007
> +
> +#define PRCMU_PLLDSI_LOCKP_LOCKED	0x3

A lot of this looks identical to the db8500 version, so maybe it's better to
have it in the generic dbx500-prcmu.c file?

> +/**
> +/**
> + * unplug_cpu1 - Power gate OFF CPU1 for U9540
> + * * void:
> + * Returns:
> + */
> +static int unplug_cpu1(void)
> +{
> +	int r = 0;
> +#ifdef CONFIG_UX500_ROMCODE_SHARED_MUTEX
> +	struct upap_req req;
> +	struct upap_ack ack;
> +
> +	/* Set flag start Hotplug sequence */
> +	cpu1_unplug_ongoing = 1;

> +
> +/**
> + * replug_cpu1 - Power gate ON CPU1 for U9540
> + * * void
> + * * Returns:
> + */
> +static int replug_cpu1(void)
> +{
> +	int r = 0;
> +#ifdef CONFIG_UX500_ROMCODE_SHARED_MUTEX
> +	struct upap_req req;
> +	struct upap_ack ack;
> +

Can you move these to a separate cpu-hotplug file?

> +/**
> + * config_clkout - Configure one of the programmable clock outputs.
> + * @clkout:	The CLKOUT number (0 or 1).
> + * @source:	The clock to be used (one of the PRCMU_CLKSRC_*).
> + * @div:	The divider to be applied.
> + *
> + * Configures one of the programmable clock outputs (CLKOUTs).
> + * @div should be in the range [1,63] to request a configuration, or 0 to
> + * inform that the configuration is no longer requested.
> + */
> +static int config_clkout(u8 clkout, u8 source, u8 div)
> +{

This again looks identical to the db8500 version.

> +/*
> + * set_arm_freq - set the appropriate ARM frequency for U9540
> + * @freq: The new ARM frequency to which transition is to be made (kHz)
> + * Returns: 0 on success, non-zero on failure
> + */
> +static int set_arm_freq(u32 freq)
> +{
> +	struct upap_req req;
> +	struct upap_ack ack;
> +	int r = 0;
> +
> +	if (dvfs_context.arm_freq == freq)
> +		return 0;
> +
> +
> +/**
> + * get_arm_freq - get the current ARM freq
> + *
> + * Returns: the current ARM freq (kHz).
> + * Not supported by U8500
> + */
> +static int get_arm_freq(void)
> +{
> +	u32 val;
> +	/*
> +	 * U9540 is not able to read ARM OPP value from TCDM. Therefore
> +	 * determine if the ARM OPP has been set, or not.
> +	 */
> +	if (dvfs_context.arm_freq != 0)
> +		return dvfs_context.arm_freq;
> +

These look like they belong into the cpufreq driver.

> +static unsigned long dbx540_prcmu_clock_rate(u8 clock)
> +{
> +	if (clock < PRCMU_NUM_REG_CLOCKS)
> +		return clock_rate(clock);
> +	else if (clock == PRCMU_TIMCLK)
> +		return ROOT_CLOCK_RATE / 16;
> +	else if (clock == PRCMU_SYSCLK)
> +		return ROOT_CLOCK_RATE;
> +	else if (clock == PRCMU_PLLSOC0)
> +		return pll_rate(PRCM_PLLSOC0_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
> +	else if (clock == PRCMU_PLLSOC1)
> +		return pll_rate(PRCM_PLLSOC1_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
> +	else if (clock == PRCMU_PLLDDR)
> +		return pll_rate(PRCM_PLLDDR_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
> +	else if (clock == PRCMU_PLLDSI)
> +		return pll_rate(PRCM_PLLDSITV_FREQ, clock_rate(PRCMU_HDMICLK),
> +			PLL_RAW);
> +	else if (clock == PRCMU_ARMSS)
> +		return KHZ_TO_HZ(armss_rate());
> +	else if (clock == PRCMU_ARMCLK)
> +		return KHZ_TO_HZ(get_arm_freq());
> +	else if ((clock == PRCMU_DSI0CLK) || (clock == PRCMU_DSI1CLK))
> +		return dsiclk_rate(clock - PRCMU_DSI0CLK, false);
> +	else if ((PRCMU_DSI0ESCCLK <= clock) && (clock <= PRCMU_DSI2ESCCLK))
> +		return dsiescclk_rate(clock - PRCMU_DSI0ESCCLK);
> +	else if (clock == PRCMU_PLLDSI_LCD)
> +		return pll_rate(PRCM_PLLDSILCD_FREQ,
> +					clock_rate(PRCMU_SPARE1CLK), PLL_RAW);
> +	else if ((clock == PRCMU_DSI0CLK_LCD) || (clock == PRCMU_DSI1CLK_LCD))
> +		return dsiclk_rate(clock - PRCMU_DSI0CLK_LCD, true);
> +	else
> +		return 0;
> +}

Please use the common clock code for managing these.
No more private clock implementations.

> +void prcmu_reset_hva(void)
> +{
> +	writel(PRCM_C2C_RESETN_HVA_MEM | PRCM_C2C_RESETN_HVA_LOGIC,
> +			PRCM_C2C_RESETN_CLR);
> +	writel(PRCM_C2C_RESETN_HVA_MEM | PRCM_C2C_RESETN_HVA_LOGIC,
> +			PRCM_C2C_RESETN_SET);
> +}
> +EXPORT_SYMBOL(prcmu_reset_hva);
> +
> +void prcmu_reset_hx170(void)
> +{
> +	writel(PRCM_C2C_RESETN_G1_MEM | PRCM_C2C_RESETN_G1_LOGIC,
> +			PRCM_C2C_RESETN_CLR);
> +	writel(PRCM_C2C_RESETN_G1_MEM | PRCM_C2C_RESETN_G1_LOGIC,
> +			PRCM_C2C_RESETN_SET);
> +}
> +EXPORT_SYMBOL(prcmu_reset_hx170);

Why is the dbx540 driver exporting symbols for non-GPL drivers?
Shouldn't this be handled through the common dbx500 code, if at all?

> +/**
> + * get_reset_status - Retrieve reset status
> + *
> + * Retrieves the value of the reset status register as read at startup.
> + */
> +u32 get_reset_status(void)
> +{
> +	return reset_status_copy;
> +}
> +
> +/**
> + * prcmu_reset_modem - ask the PRCMU to reset modem
> + */
> +void modem_reset(void)
> +{
> +	prcmu_modem_reset_db9540();
> +}

Moreover, why do you have any global functions in this driver that
are not in a well-defined namespace?

> +static struct prcmu_early_data early_fops = {
> +	/*  system reset  */
> +	.system_reset = db8500_prcmu_system_reset,
> +
> +	/*  clock service */
> +	.config_clkout = config_clkout,
> +	.request_clock = dbx540_prcmu_request_clock,
> +
> +	/*  direct register access */
> +	.read = db8500_prcmu_read,
> +	.write =  db8500_prcmu_write,
> +	.write_masked = db8500_prcmu_write_masked,
> +	/* others */
> +	.round_clock_rate = dbx540_prcmu_round_clock_rate,
> +	.set_clock_rate = dbx540_prcmu_set_clock_rate,
> +	.clock_rate = dbx540_prcmu_clock_rate,
> +	.get_fw_version = get_fw_version,
> +	.has_arm_maxopp = has_arm_maxopp,
> +};

What does the "f" in fops stand for?

Why are these all early?

Why do you have an abstract interface for functions that are the same
between db8500 and dbx540, rather than just the different ones?

> +struct prcmu_probe_data probe_fops = {
> +	/* sysfs soc inf */
> +	.get_reset_code = get_reset_code,
> +
> +	/* pm/suspend.c/cpu freq */
> +	.config_esram0_deep_sleep = config_esram0_deep_sleep,
> +	.set_power_state = db8500_prcmu_set_power_state,
> +	.get_power_state_result = db8500_prcmu_get_power_state_result,
> +	.enable_wakeups = db8500_prcmu_enable_wakeups,
> +	.is_ac_wake_requested = is_ac_wake_requested,
> +
> +	/* modem */
> +	.modem_reset = modem_reset,
> +
> +	/* no used at all */
> +	.config_abb_event_readout = db8500_prcmu_config_abb_event_readout,
> +	.get_abb_event_buffer = db8500_prcmu_get_abb_event_buffer,
> +
> +	/* abb access */
> +	.abb_read = db8500_prcmu_abb_read,
> +	.abb_write = db8500_prcmu_abb_write,
> +	.get_reset_status = get_reset_status,
> +	/*  other u8500 specific */
> +	.request_ape_opp_100_voltage = request_ape_opp_100_voltage,
> +	.configure_auto_pm = db8500_prcmu_configure_auto_pm,
> +	.set_epod = db8500_prcmu_set_epod,
> +
> +	/* abb specific access */
> +	.abb_write_masked = db8500_prcmu_abb_write_masked,
> +
> +	/* watchdog */
> +	.config_a9wdog = db8500_prcmu_config_a9wdog,
> +	.enable_a9wdog = db8500_prcmu_enable_a9wdog,
> +	.disable_a9wdog = db8500_prcmu_disable_a9wdog,
> +	.kick_a9wdog = db8500_prcmu_kick_a9wdog,
> +	.load_a9wdog = db8500_prcmu_load_a9wdog,
> +};

Same comment about these

> +struct prcmu_probe_cpuhp_data probe_cpuhp_fops = {
> +
> +	.stay_in_wfi_check = stay_in_wfi_check,
> +	.replug_cpu1 = replug_cpu1,
> +	.unplug_cpu1 = unplug_cpu1,
> +};
> +
> +static struct prcmu_fops_register probe_tab[] = {
> +	{
> +		.fops = PRCMU_PROBE,
> +		.data.pprobe = &probe_fops,
> +	},
> +	{
> +		.fops = PRCMU_PROBE_CPU_HP,
> +		.data.pprobe_cpuhp =&probe_cpuhp_fops,
> +	},
> +};
> +
> +struct prcmu_fops_register_data probe_data = {
> +	.size = ARRAY_SIZE(probe_tab),
> +	.tab = probe_tab,
> +};

I'm lost in the number of abstraction layers here.

> +struct prcmu_fops_register_data *__init
> +			dbx540_prcmu_early_init(struct prcmu_tcdm_map *map)
> +{
> +	void *tcpm_base = ioremap_nocache(U8500_PRCMU_TCPM_BASE, SZ_4K);

Please use the resources rather than hardcoding a physical address.

> +	db8500_prcmu_init_mb0(&mb0);
> +	/*  mailbox 1 used by UniqPAP */
> +	db8500_prcmu_init_mb2(&mb2);
> +	db8500_prcmu_init_mb3(&mb3);
> +	db8500_prcmu_init_mb4(&mb4);
> +	db8500_prcmu_init_mb5(&mb5);

I think it would be good to split out all the mailbox handling into a
separate file, and provide a proper abstraction for it, based on a
data structure that can hold pointers to the init/read/write/... functions
as well as the common data for all mailboxes, such as

struct prcmu_mailbox {
	struct mutex lock;
	struct completion complete;
	bool (*read)(struct prcmu_mailbox *);
	void (*init)(struct prcmu_mailbox *):
}

> +	/* initialize UniqPAP */
> +	upap_init();
> +	/* register UniqPAP services */
> +	upap_register_ack_service(U9540_PRCM_UPAP_SERVICE_DVFS,
> +			upap_read_service_dvfs);
> +	upap_register_ack_service(U9540_PRCM_UPAP_SERVICE_USB,
> +			upap_read_service_usb);
> +	upap_register_ack_service(U9540_PRCM_UPAP_SERVICE_CLOCK,
> +			upap_read_service_clock);
> +	upap_register_ack_service(U9540_PRCM_UPAP_SERVICE_MODEM,
> +			upap_read_service_modem);
> +	upap_register_ack_service(U9540_PRCM_UPAP_SERVICE_CPUHOTPLUG,
> +			upap_read_service_cpuhotplug);
> +	upap_register_ack_service(U9540_PRCM_UPAP_SERVICE_THSENSOR,
> +			upap_read_service_thsensor);
> +	upap_register_ack_service(U9540_PRCM_UPAP_SERVICE_DDR,
> +			upap_read_service_ddr);

And then a separate file for the new upap stuff, with a similar
structure.

> +
> +static struct regulator_init_data dbx540_regulators[DB8500_NUM_REGULATORS] = {
> +	[DB8500_REGULATOR_VAPE] = {
> +		.constraints = {
> +			.name = "db8500-vape",
> +			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
> +		},
> +		.consumer_supplies = db8500_vape_consumers,
> +		.num_consumer_supplies = ARRAY_SIZE(db8500_vape_consumers),
> +	},


The array again looks a lot like the db8500 one. Please find a way to share more
of the code.

> +/**
> + * prcmu_fw_init - core init call for the Linux PRCMU fw init logic
> + *
> + */
> +static int __init dbx540_prcmu_probe(struct platform_device *pdev)
> +{
> +	int irq = 0, err = 0;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	init_prcm_registers();
> +
> +	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);
> +

Please move the common parts of this function into dbx500-prcmu.c

> +	if(np) {
> +		if (of_property_read_u32_array(np,
> +				"stericsson,db8500-frequency-tab ",
> +				(u32 *)freq_table, 7) < 0)
> +                         dev_err(&pdev->dev, "frequency tab\n");
> +	} else
> +		freq_table =
> +			(struct cpufreq_frequency_table *)dev_get_platdata(&pdev->dev);

I haven't seen a binding for this property yet. Please make sure you post the
binding along with the patch.

> +#ifdef CONFIG_C2C
> +void prcmu_c2c_request_notif_up(void);
> +void prcmu_c2c_request_reset(void);
> +#endif

No need to enclose declarations in #ifdef, unless you provide an empty
stub in the #else path.


	Arnd
