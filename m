Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2DITlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:41:31 -0400
Received: from mga05.intel.com ([192.55.52.89]:46454 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752324Ab2DITl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120409194857.8004.86352.stgit@dwillia2-linux.jf.intel.com>
References: <20120409194514.8004.53204.stgit@dwillia2-linux.jf.intel.com>
	<20120409194857.8004.86352.stgit@dwillia2-linux.jf.intel.com>
Date: Mon, 9 Apr 2012 12:41:25 -0700
Message-ID: <CABE8wwvjJt8-io9gsnTATW59D+O81rmcyYHn8dss284bOj7v7w@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] tegra, serial8250: add ->handle_break() uart_port op
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: gregkh@linuxfoundation.org
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, Grant Likely <grant.likely@secretlab.ca>,
        linux-serial@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Nhan H Mai <nhan.h.mai@intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding Arnd ]

On Mon, Apr 9, 2012 at 12:48 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> The "KT" serial port has another use case for a "received break" quirk,
> so before adding another special case to the 8250 core take this
> opportunity to push such quirks out of the core and into a uart_port op.
>
> Stephen says:
> "If the callback function is to no longer live in 8250.c itself,
>  arch/arm/mach-tegra/devices.c isn't logically a good place to put it,
>  and that file will be going away once we get rid of all the board files
>  and move solely to device tree."
>
> ...so since 8250_pci.c houses all the quirks for pci serial devices this
> quirk is similarly housed in of_serial.c.  Once the open firmware
> conversion completes the infrastructure details (CONFIG_TEGRA_SERIAL,
> include/linux/of_serial.h, and the export) can all be removed to make
> this self contained to of_serial.c.
>
> Cc: Nhan H Mai <nhan.h.mai@intel.com>
> Cc: Colin Cross <ccross@android.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Arnd Bergmann arnd@arndb.de

Sorry, messed up Arnd's address, checkpatch would have caught this for me...

> Acked-by: Sudhakar Mamillapalli <sudhakar@fb.com>
> Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Acked-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/arm/configs/tegra_defconfig      |    1 +
>  arch/arm/mach-tegra/board-harmony.c   |    4 ++++
>  arch/arm/mach-tegra/board-paz00.c     |    5 +++++
>  arch/arm/mach-tegra/board-seaboard.c  |    4 ++++
>  arch/arm/mach-tegra/board-trimslice.c |    4 ++++
>  arch/arm/mach-tegra/devices.h         |    1 -
>  drivers/tty/serial/8250/8250.c        |   34 +++------------------------------
>  drivers/tty/serial/Kconfig            |    8 ++++++++
>  drivers/tty/serial/of_serial.c        |   25 ++++++++++++++++++++++++
>  include/linux/of_serial.h             |   17 +++++++++++++++++
>  include/linux/serial_8250.h           |    1 +
>  include/linux/serial_core.h           |    5 +++++
>  12 files changed, 77 insertions(+), 32 deletions(-)
>  create mode 100644 include/linux/of_serial.h
>
> diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
> index 351d670..de7288a 100644
> --- a/arch/arm/configs/tegra_defconfig
> +++ b/arch/arm/configs/tegra_defconfig
> @@ -97,6 +97,7 @@ CONFIG_INPUT_EVDEV=y
>  CONFIG_SERIAL_8250=y
>  CONFIG_SERIAL_8250_CONSOLE=y
>  CONFIG_SERIAL_OF_PLATFORM=y
> +CONFIG_SERIAL_TEGRA=y
>  # CONFIG_HW_RANDOM is not set
>  CONFIG_I2C=y
>  # CONFIG_I2C_COMPAT is not set
> diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
> index c00aadb..b8ceac3 100644
> --- a/arch/arm/mach-tegra/board-harmony.c
> +++ b/arch/arm/mach-tegra/board-harmony.c
> @@ -19,6 +19,7 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/serial_8250.h>
> +#include <linux/of_serial.h>
>  #include <linux/clk.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/pda_power.h>
> @@ -52,6 +53,7 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
>                .irq            = INT_UARTD,
>                .flags          = UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
>                .type           = PORT_TEGRA,
> +               .handle_break   = tegra_serial_handle_break,
>                .iotype         = UPIO_MEM,
>                .regshift       = 2,
>                .uartclk        = 216000000,
> @@ -115,7 +117,9 @@ static void __init harmony_i2c_init(void)
>  }
>
>  static struct platform_device *harmony_devices[] __initdata = {
> +#if IS_ENABLED(CONFIG_SERIAL_TEGRA)
>        &debug_uart,
> +#endif
>        &tegra_sdhci_device1,
>        &tegra_sdhci_device2,
>        &tegra_sdhci_device4,
> diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
> index 330afdf..1113dab 100644
> --- a/arch/arm/mach-tegra/board-paz00.c
> +++ b/arch/arm/mach-tegra/board-paz00.c
> @@ -21,6 +21,7 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/serial_8250.h>
> +#include <linux/of_serial.h>
>  #include <linux/clk.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/gpio_keys.h>
> @@ -55,6 +56,7 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
>                .irq            = INT_UARTA,
>                .flags          = UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
>                .type           = PORT_TEGRA,
> +               .handle_break   = tegra_serial_handle_break,
>                .iotype         = UPIO_MEM,
>                .regshift       = 2,
>                .uartclk        = 216000000,
> @@ -65,6 +67,7 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
>                .irq            = INT_UARTC,
>                .flags          = UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
>                .type           = PORT_TEGRA,
> +               .handle_break   = tegra_serial_handle_break,
>                .iotype         = UPIO_MEM,
>                .regshift       = 2,
>                .uartclk        = 216000000,
> @@ -142,7 +145,9 @@ static struct platform_device gpio_keys_device = {
>  };
>
>  static struct platform_device *paz00_devices[] __initdata = {
> +#if IS_ENABLED(CONFIG_SERIAL_TEGRA)
>        &debug_uart,
> +#endif
>        &tegra_sdhci_device4,
>        &tegra_sdhci_device1,
>        &wifi_rfkill_device,
> diff --git a/arch/arm/mach-tegra/board-seaboard.c b/arch/arm/mach-tegra/board-seaboard.c
> index d669847..59a30ab 100644
> --- a/arch/arm/mach-tegra/board-seaboard.c
> +++ b/arch/arm/mach-tegra/board-seaboard.c
> @@ -18,6 +18,7 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/serial_8250.h>
> +#include <linux/of_serial.h>
>  #include <linux/i2c.h>
>  #include <linux/delay.h>
>  #include <linux/input.h>
> @@ -47,6 +48,7 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
>                /* Memory and IRQ filled in before registration */
>                .flags          = UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
>                .type           = PORT_TEGRA,
> +               .handle_break   = tegra_serial_handle_break,
>                .iotype         = UPIO_MEM,
>                .regshift       = 2,
>                .uartclk        = 216000000,
> @@ -145,7 +147,9 @@ static struct platform_device seaboard_audio_device = {
>  };
>
>  static struct platform_device *seaboard_devices[] __initdata = {
> +#if IS_ENABLED(CONFIG_SERIAL_TEGRA)
>        &debug_uart,
> +#endif
>        &tegra_pmu_device,
>        &tegra_sdhci_device4,
>        &tegra_sdhci_device3,
> diff --git a/arch/arm/mach-tegra/board-trimslice.c b/arch/arm/mach-tegra/board-trimslice.c
> index cd52820..b156f55 100644
> --- a/arch/arm/mach-tegra/board-trimslice.c
> +++ b/arch/arm/mach-tegra/board-trimslice.c
> @@ -22,6 +22,7 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/serial_8250.h>
> +#include <linux/of_serial.h>
>  #include <linux/io.h>
>  #include <linux/i2c.h>
>  #include <linux/gpio.h>
> @@ -48,6 +49,7 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
>                .irq            = INT_UARTA,
>                .flags          = UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
>                .type           = PORT_TEGRA,
> +               .handle_break   = tegra_serial_handle_break,
>                .iotype         = UPIO_MEM,
>                .regshift       = 2,
>                .uartclk        = 216000000,
> @@ -81,7 +83,9 @@ static struct platform_device trimslice_audio_device = {
>  };
>
>  static struct platform_device *trimslice_devices[] __initdata = {
> +#if IS_ENABLED(CONFIG_SERIAL_TEGRA)
>        &debug_uart,
> +#endif
>        &tegra_sdhci_device1,
>        &tegra_sdhci_device4,
>        &tegra_i2s_device1,
> diff --git a/arch/arm/mach-tegra/devices.h b/arch/arm/mach-tegra/devices.h
> index ec45567..6e5f852 100644
> --- a/arch/arm/mach-tegra/devices.h
> +++ b/arch/arm/mach-tegra/devices.h
> @@ -53,5 +53,4 @@ extern struct platform_device tegra_i2s_device1;
>  extern struct platform_device tegra_i2s_device2;
>  extern struct platform_device tegra_das_device;
>  extern struct platform_device tegra_pcm_device;
> -
>  #endif
> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> index 5c27f7e..cbd94c3 100644
> --- a/drivers/tty/serial/8250/8250.c
> +++ b/drivers/tty/serial/8250/8250.c
> @@ -1332,27 +1332,6 @@ static void serial8250_enable_ms(struct uart_port *port)
>  }
>
>  /*
> - * Clear the Tegra rx fifo after a break
> - *
> - * FIXME: This needs to become a port specific callback once we have a
> - * framework for this
> - */
> -static void clear_rx_fifo(struct uart_8250_port *up)
> -{
> -       unsigned int status, tmout = 10000;
> -       do {
> -               status = serial_in(up, UART_LSR);
> -               if (status & (UART_LSR_FIFOE | UART_LSR_BRK_ERROR_BITS))
> -                       status = serial_in(up, UART_RX);
> -               else
> -                       break;
> -               if (--tmout == 0)
> -                       break;
> -               udelay(1);
> -       } while (1);
> -}
> -
> -/*
>  * serial8250_rx_chars: processes according to the passed in LSR
>  * value, and returns the remaining LSR bits not handled
>  * by this Rx routine.
> @@ -1386,20 +1365,10 @@ serial8250_rx_chars(struct uart_8250_port *up, unsigned char lsr)
>                up->lsr_saved_flags = 0;
>
>                if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
> -                       /*
> -                        * For statistics only
> -                        */
>                        if (lsr & UART_LSR_BI) {
>                                lsr &= ~(UART_LSR_FE | UART_LSR_PE);
>                                port->icount.brk++;
>                                /*
> -                                * If tegra port then clear the rx fifo to
> -                                * accept another break/character.
> -                                */
> -                               if (port->type == PORT_TEGRA)
> -                                       clear_rx_fifo(up);
> -
> -                               /*
>                                 * We do the SysRQ and SAK checking
>                                 * here because otherwise the break
>                                 * may get masked by ignore_status_mask
> @@ -3037,6 +3006,7 @@ static int __devinit serial8250_probe(struct platform_device *dev)
>                port.serial_in          = p->serial_in;
>                port.serial_out         = p->serial_out;
>                port.handle_irq         = p->handle_irq;
> +               port.handle_break       = p->handle_break;
>                port.set_termios        = p->set_termios;
>                port.pm                 = p->pm;
>                port.dev                = &dev->dev;
> @@ -3209,6 +3179,8 @@ int serial8250_register_port(struct uart_port *port)
>                        uart->port.set_termios = port->set_termios;
>                if (port->pm)
>                        uart->port.pm = port->pm;
> +               if (port->handle_break)
> +                       uart->port.handle_break = port->handle_break;
>
>                if (serial8250_isa_config != NULL)
>                        serial8250_isa_config(0, &uart->port,
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 665beb6..33fa6ec 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -380,6 +380,14 @@ config SERIAL_PXA_CONSOLE
>          your boot loader (lilo or loadlin) about how to pass options to the
>          kernel at boot time.)
>
> +# FIXME remove this option when Tegra completes conversion to open firmware
> +config SERIAL_TEGRA
> +       bool "Tegra serial port support"
> +       depends on SERIAL_OF_PLATFORM=y
> +       help
> +         If you have a machine based on NVIDIA Tegra you can enable its
> +         onboard serial ports by enabling this option.
> +
>  config SERIAL_SA1100
>        bool "SA1100 serial port support"
>        depends on ARM && ARCH_SA1100
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index e8c9cee..b692528 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -12,8 +12,10 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> +#include <linux/delay.h>
>  #include <linux/serial_core.h>
>  #include <linux/serial_8250.h>
> +#include <linux/serial_reg.h>
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
> @@ -24,6 +26,26 @@ struct of_serial_info {
>        int line;
>  };
>
> +#if IS_ENABLED(CONFIG_SERIAL_TEGRA)
> +void tegra_serial_handle_break(struct uart_port *p)
> +{
> +       unsigned int status, tmout = 10000;
> +
> +       do {
> +               status = p->serial_in(p, UART_LSR);
> +               if (status & (UART_LSR_FIFOE | UART_LSR_BRK_ERROR_BITS))
> +                       status = p->serial_in(p, UART_RX);
> +               else
> +                       break;
> +               if (--tmout == 0)
> +                       break;
> +               udelay(1);
> +       } while (1);
> +}
> +/* FIXME remove this export when tegra finishes conversion to open firmware */
> +EXPORT_SYMBOL_GPL(tegra_serial_handle_break);
> +#endif
> +
>  /*
>  * Fill a struct uart_port for a given device node
>  */
> @@ -84,6 +106,9 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
>                | UPF_FIXED_PORT | UPF_FIXED_TYPE;
>        port->dev = &ofdev->dev;
>
> +       if (type == PORT_TEGRA)
> +               port->handle_break = tegra_serial_handle_break;
> +
>        return 0;
>  }
>
> diff --git a/include/linux/of_serial.h b/include/linux/of_serial.h
> new file mode 100644
> index 0000000..2035d96
> --- /dev/null
> +++ b/include/linux/of_serial.h
> @@ -0,0 +1,17 @@
> +#ifndef __LINUX_OF_SERIAL_H
> +#define __LINUX_OF_SERIAL_H
> +
> +/*
> + * FIXME remove this file when tegra finishes conversion to open firmware,
> + * expectation is that all quirks will then be self-contained in
> + * drivers/tty/serial/of_serial.c.
> + */
> +#if IS_ENABLED(CONFIG_SERIAL_TEGRA)
> +extern void tegra_serial_handle_break(struct uart_port *port);
> +#else
> +static inline void tegra_serial_handle_break(struct uart_port *port)
> +{
> +}
> +#endif
> +
> +#endif /* __LINUX_OF_SERIAL */
> diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
> index 8f012f8..a522fd9 100644
> --- a/include/linux/serial_8250.h
> +++ b/include/linux/serial_8250.h
> @@ -38,6 +38,7 @@ struct plat_serial8250_port {
>        int             (*handle_irq)(struct uart_port *);
>        void            (*pm)(struct uart_port *, unsigned int state,
>                              unsigned old);
> +       void            (*handle_break)(struct uart_port *);
>  };
>
>  /*
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index 2db407a..65db992 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -310,6 +310,7 @@ struct uart_port {
>        int                     (*handle_irq)(struct uart_port *);
>        void                    (*pm)(struct uart_port *, unsigned int state,
>                                      unsigned int old);
> +       void                    (*handle_break)(struct uart_port *);
>        unsigned int            irq;                    /* irq number */
>        unsigned long           irqflags;               /* irq flags  */
>        unsigned int            uartclk;                /* base uart clock */
> @@ -533,6 +534,10 @@ uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
>  static inline int uart_handle_break(struct uart_port *port)
>  {
>        struct uart_state *state = port->state;
> +
> +       if (port->handle_break)
> +               port->handle_break(port);
> +
>  #ifdef SUPPORT_SYSRQ
>        if (port->cons && port->cons->index == port->line) {
>                if (!port->sysrq) {
>
