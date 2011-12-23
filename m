Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab1LWNQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:16:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047Ab1LWNQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:16:11 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] Add driver auto probing for x86 features v2
Date: Fri, 23 Dec 2011 14:16:09 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, davej@redhat.com,
        kay.sievers@vrfy.org, axboe@kernel.dk, herbert@gondor.hengli.com.au,
        ying.huang@intel.com, lenb@kernel.org, gregkh@suse.de
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org> <1324338394-4670-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1324338394-4670-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201112231416.09954.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

for info:

On Tuesday, December 20, 2011 12:46:27 AM Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Old patchkit, resurrect due to popular demand.
...
> +	n = snprintf(buf, size, "x86cpu:vendor:%04x:family:%04x:model:%04x:feature:",
this must be uppercase hex values (%04X)
...
> +		if (boot_cpu_has(i)) {
> +			n = snprintf(buf, size, ",%04x", i);
same here.
Looks like a string compare is happening and in
scripts/mod/file2alias.c
sizeof(field) == 2 ? "%04X"
is used and the modalias added to the driver and showing up
in /lib/modules/*/modales.alias is uppercase.

...
> +	}
> +	*buf++ = ',';
> +	*buf++ = '\n';
this must be:
 +	*buf++ = '\0';
otherwise one can hit:
   WARNING: at lib/kobject_uevent.c:362 add_uevent_var+0xf2/0x100()
   add_uevent_var: buffer size too small
Hm, then /sys/devices/system/cpu/modalias has not a newline.
Using kzalloc in arch_cpu_uevent() should be the nicest way
to address this.

Now things work much better, hope that's all.
I just send out a new patchset (with cpuid vs cpu kobject broken out
in a separate patch for better backporting).

   Thomas
