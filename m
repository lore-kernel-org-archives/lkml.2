Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab0D1FTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 01:19:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683Ab0D1FTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 01:19:01 -0400
Date: Tue, 27 Apr 2010 22:17:05 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Yusuke Goda <yusuke.goda.sx@renesas.com>
Cc: ben@decadent.org.uk, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] MMC:Add support MMCIF for SuperH
Message-Id: <20100427221705.1628375b.akpm@linux-foundation.org>
In-Reply-To: <4BD7C240.5050800@renesas.com>
References: <4BD7C240.5050800@renesas.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 14:06:08 +0900 Yusuke Goda <yusuke.goda.sx@renesas.com> wrote:

> +	time = wait_event_interruptible_timeout(host->intr_wait,
> +			host->wait_int == 1 ||
> +			host->sd_error == 1, host->timeout);
> +	if (host->wait_int != 1 && (time == 0 || host->sd_error != 0))
> +		return sh_mmcif_error_manage(host);

wait_event_interruptible_timeout() will return early with -ERESTARTSYS
if the calling process gets signalled (eg, ^C was hit).

The driver uses wait_event_interruptible_timeout() rather a lot and the
two sites I looked at seem to handle the signal_pending() case
correctly.

But incorrectly handling signals with interruptible waits is a
frequently-occurring error in drivers.  Did you deliberately cater for
this case, and have you runtime tested it?

