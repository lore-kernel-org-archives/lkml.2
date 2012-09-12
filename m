Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2ILFQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:16:37 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55614 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2ILFQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:16:35 -0400
Subject: Re: iwl3945: order 5 allocation during ifconfig up; vm problem?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Marc MERLIN <marc@merlins.org>
Cc: Pavel Machek <pavel@ucw.cz>, David Rientjes <rientjes@google.com>,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        johannes.berg@intel.com, wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        Andrew Morton <akpm@osdl.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20120911162536.bd5171a1.akpm@linux-foundation.org>
References: <20120909213228.GA5538@elf.ucw.cz>
	 <alpine.DEB.2.00.1209091539530.16930@chino.kir.corp.google.com>
	 <20120910111113.GA25159@elf.ucw.cz>
	 <20120911162536.bd5171a1.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Sep 2012 07:16:28 +0200
Message-ID: <1347426988.13103.684.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 16:25 -0700, Andrew Morton wrote:

> Asking for a 256k allocation is pretty crazy - this is an operating
> system kernel, not a userspace application.
> 
> I'm wondering if this is due to a recent change, but I'm having trouble
> working out where the allocation call site is.
> --

(Adding Marc Merlin to CC, since he reported same problem)

Thats the firmware loading in iwlwifi driver. Not sure if it can use SG.

drivers/net/wireless/iwlwifi/iwl-drv.c

iwl_alloc_ucode() -> iwl_alloc_fw_desc() -> dma_alloc_coherent()

It seems some sections of /lib/firmware/iwlwifi*.ucode files are above
128 Kbytes, so dma_alloc_coherent() try order-5 allocations


# ls -l /lib/firmware/iwlwifi*.ucode
-rw-r--r-- 1 root root 335056 2012-01-23 18:20 /lib/firmware/iwlwifi-1000-3.ucode
-rw-r--r-- 1 root root 337520 2012-01-23 18:20 /lib/firmware/iwlwifi-1000-5.ucode
-rw-r--r-- 1 root root 689680 2012-01-24 19:18 /lib/firmware/iwlwifi-105-6.ucode
-rw-r--r-- 1 root root 701228 2012-01-24 19:18 /lib/firmware/iwlwifi-135-6.ucode
-rw-r--r-- 1 root root 695876 2012-01-24 19:19 /lib/firmware/iwlwifi-2000-6.ucode
-rw-r--r-- 1 root root 707392 2012-01-24 19:19 /lib/firmware/iwlwifi-2030-6.ucode
-rw-r--r-- 1 root root 150100 2012-01-23 18:20 /lib/firmware/iwlwifi-3945-2.ucode
-rw-r--r-- 1 root root 187972 2012-01-23 18:20 /lib/firmware/iwlwifi-4965-2.ucode
-rw-r--r-- 1 root root 345008 2012-01-23 18:20 /lib/firmware/iwlwifi-5000-1.ucode
-rw-r--r-- 1 root root 353240 2012-01-23 18:20 /lib/firmware/iwlwifi-5000-2.ucode
-rw-r--r-- 1 root root 340696 2012-01-23 18:21 /lib/firmware/iwlwifi-5000-5.ucode
-rw-r--r-- 1 root root 337400 2012-01-23 18:20 /lib/firmware/iwlwifi-5150-2.ucode
-rw-r--r-- 1 root root 462280 2012-01-24 19:20 /lib/firmware/iwlwifi-6000-4.ucode
-rw-r--r-- 1 root root 444128 2012-01-24 19:20 /lib/firmware/iwlwifi-6000g2a-5.ucode
-rw-r--r-- 1 root root 460912 2012-01-24 19:20 /lib/firmware/iwlwifi-6000g2b-5.ucode
-rw-r--r-- 1 root root 679436 2012-01-24 19:19 /lib/firmware/iwlwifi-6000g2b-6.ucode
-rw-r--r-- 1 root root 463692 2012-01-23 18:20 /lib/firmware/iwlwifi-6050-4.ucode
-rw-r--r-- 1 root root 469780 2012-01-23 18:20 /lib/firmware/iwlwifi-6050-5.ucode


