Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab1CCOLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:11:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33723 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758344Ab1CCOLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:11:50 -0500
Date: Thu, 3 Mar 2011 14:11:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Simon Glass <sjg@chromium.org>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Alexander Shishkin <virtuoso@slind.org>,
        Mikael Pettersson <mikpe@it.uu.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joe Perches <joe@perches.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: Use generic BUG() handler
Message-ID: <20110303141113.GF25891@n2100.arm.linux.org.uk>
References: <1298939263-16421-1-git-send-email-sjg@chromium.org> <20110301084949.GA16733@n2100.arm.linux.org.uk> <20110301085911.GB16733@n2100.arm.linux.org.uk> <19820.47240.801312.507393@pilspetsen.it.uu.se> <20110301100306.GA18007@n2100.arm.linux.org.uk> <AANLkTinMnZAupxn7oYFhqkN1Y0OD-eyN=UeRpw96no9r@mail.gmail.com> <20110302105930.GA2363@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302105930.GA2363@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 10:59:50AM +0000, Dave Martin wrote:
> +	asm volatile("1:\t" __bug_instr "\n"		q	\
> +		     ".pushsection .rodata.str, \"a\"\n"	\
> +		     "2:\t.asciz \"" #__file "\"\n"		\
> +		     ".popsection\n"				\ 

Doesn't this mean we end up with multiple file names?

> +		     ".pushsection __bug_table,\"a\"\n"		\
> +		     "3:\t.word 1b, 2b\n"			\
> +		     "\t.hword " #__line ", 0\n"		\
> +		     ".popsection"				\
> +	unreachable();						\
> +} while (0)

Second problem is that the above produces this:

        1:      .word 0xec000000
.pushsection .rodata.str, "a"
2:      .asciz "__FILE__"
.popsection
.pushsection __bug_table,"a"
3:      .word 1b, 2b
        .hword __LINE__, 0
.popsection

which is clearly not what we want.  Adding another level of indirection
starts to get closer to what we desire:

        1:      .word 0xec000000
.pushsection .rodata.str, "a"
2:      .asciz ""t.c""
.popsection
.pushsection __bug_table,"a"
3:      .word 1b, 2b
        .hword 19, 0
.popsection

but we're still ending up with multiple strings containing the filename,
which is going to excessively bloat the kernel no end.
