Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2KDVXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 16:23:14 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50375 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2KDVXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 16:23:10 -0500
MIME-Version: 1.0
In-Reply-To: <1352080784-30839-2-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
	<1352080784-30839-2-git-send-email-luming.yu@gmail.com>
Date: Sun, 4 Nov 2012 22:23:09 +0100
X-Google-Sender-Auth: f2zGTB4DJWOXOtEBphNUo8LlftQ
Message-ID: <CAONaPpEfbkkE_zd4m8AHo4zfg9-UL_ojS2aQLQquyKDQRYyc6Q@mail.gmail.com>
Subject: Re: [PATCH 01/13] HW-latency: hardware latency test 0.10
From: John Kacur <jkacur@redhat.com>
To: Luming Yu <luming.yu@gmail.com>, Jon Masters <jonathan@jonmasters.org>,
        Jon Masters <jcm@redhat.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Luming Yu <luming.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 2:59 AM, Luming Yu <luming.yu@gmail.com> wrote:
>
> This patch is the first step to test some basic hardware functions like
> TSC to help people understand if there is any hardware latency as well
> as throughput problem exposed on bare metal or left behind by BIOS or
> interfered by SMI. Currently the patch tests TSC, CPU Frequency and
> RDRAND which is a new CPU instruction to get random number introduced in
> new CPU like Intel Ivy Bridge in stop_machine context,which is choosen to
> make sure testers fully control their system under test to rule out some
> level of unwanted noise.
>
> Signed-off-by: Luming Yu <luming.yu@intel.com>
> ---
>  drivers/misc/Kconfig           |   7 +
>  drivers/misc/Makefile          |   1 +
>  drivers/misc/hw_latency_test.c | 833 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 841 insertions(+)
>  create mode 100644 drivers/misc/hw_latency_test.c
>
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b151b7c..5ed440b 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -114,6 +114,13 @@ config IBM_ASM
>           for information on the specific driver level and support statement
>           for your IBM server.
>
> +config HW_LATENCY_TEST
> +       tristate "Testing module to detect hardware lattency and throughput"
> +       depends on DEBUG_FS
> +       depends on RING_BUFFER
> +       depends on X86
> +       default m
> +
>  config PHANTOM
>         tristate "Sensable PHANToM (PCI)"
>         depends on PCI
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 2129377..c195cce 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -49,3 +49,4 @@ obj-y                         += carma/
>  obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
>  obj-$(CONFIG_ALTERA_STAPL)     +=altera-stapl/
>  obj-$(CONFIG_INTEL_MEI)                += mei/
> +obj-$(CONFIG_HW_LATENCY_TEST)  += hw_latency_test.o
> diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
> new file mode 100644
> index 0000000..2aa3a74
> --- /dev/null
> +++ b/drivers/misc/hw_latency_test.c
> @@ -0,0 +1,833 @@
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/ring_buffer.h>
> +#include <linux/stop_machine.h>
> +#include <linux/time.h>
> +#include <linux/hrtimer.h>
> +#include <linux/kthread.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/uaccess.h>
> +#include <linux/version.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/random.h>
> +#include <asm/tlbflush.h>
> +
> +#define BUF_SIZE_DEFAULT       262144UL
> +#define BUF_FLAGS      (RB_FL_OVERWRITE)
> +#define        U64STR_SIZE     22
> +#define DEBUGFS_BUF_SIZE       1024
> +#define DEBUGFS_NAME_SIZE      32
> +
> +#define        VERSION         "0.1.0"
> +#define BANNER         "hardware latency test"
> +#define DRVNAME                "hw_latency_test"
> +
> +#define DEFAULT_SAMPLE_WINDOW  1000000
> +#define        DEFAULT_SAMPLE_WIDTH    500000
> +#define        DEFAULT_LAT_THRESHOLD   10
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Luming Yu <luming.yu@gmail.com>");
> +MODULE_DESCRIPTION("A simple hardware latency test");
> +MODULE_VERSION(VERSION);


-------->o SNIP

Ok, hopefully this is just an unintentional oversight - but I don't
see where you are acknowledging that the original author of most of
this code is Jon Masters. It's fine for you to work on it, but you
have to somewhere acknowledge where it comes from.

Thanks

John
