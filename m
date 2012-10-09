Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2JIPlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:41:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53066 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab2JIPlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:41:03 -0400
Message-ID: <50744586.6010806@arm.com>
Date: Tue, 09 Oct 2012 16:40:54 +0100
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 4/9] ARM: export default read_current_timer
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <1349796183-30648-5-git-send-email-arnd@arndb.de>
In-Reply-To: <1349796183-30648-5-git-send-email-arnd@arndb.de>
X-OriginalArrivalTime: 09 Oct 2012 15:41:00.0493 (UTC) FILETIME=[7B8C87D0:01CDA634]
X-MC-Unique: 112100916410010601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 09/10/12 16:22, Arnd Bergmann wrote:

> read_current_timer is used by get_cycles since "ARM: 7538/1: delay:
> add registration mechanism for delay timer sources", and get_cycles
> can be used by device drivers in loadable modules, so it has to
> be exported.
> 
> Without this patch, building imote2_defconfig fails with
> 
> ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
[...]

>  arch/arm/lib/delay.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
> index 9d0a300..0dc5385 100644
> --- a/arch/arm/lib/delay.c
> +++ b/arch/arm/lib/delay.c
> @@ -45,6 +45,7 @@ int read_current_timer(unsigned long *timer_val)
>  	*timer_val = delay_timer->read_current_timer();
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(read_current_timer);


Perhaps this fits better in armksyms.c? That way it lives with
arm_delay_ops and friends.

I've got a patch doing it like that, which I can put in Russell's
patch-system, unless you prefer doing it in delay.c for any reason?

Jonny

(Here's the original patch sent to the kernel-janitors list and Will Deacon)
-------8<---------
On ARM, get_cycles() is implemented in terms of read_current_timer(), but
the latter is not exported to modules, resulting in failure to link:

  ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!

This patch exports the symbol as required.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
---
 arch/arm/kernel/armksyms.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 60d3b73..6a37f8d 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -50,6 +50,7 @@ extern void fpundefinstr(void);
 
        /* platform dependent support */
 EXPORT_SYMBOL(arm_delay_ops);
+EXPORT_SYMBOL(read_current_timer);
 
        /* networking */
 EXPORT_SYMBOL(csum_partial);
-- 
1.7.1








